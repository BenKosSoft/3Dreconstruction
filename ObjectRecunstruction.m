clear all; close all;
%{
L = 300; %image size
I1 = zeros(L,L);

%intrinsic parameters are known (calibrated)
f=L;
u0 = L/2;
v0 = L/2;

K = [f 0 u0;
    0 f v0;
    0 0 1];

DEG_TO_RAD = pi/180;

P_W = [0 0 0 0 0 0 0 0 0 1 2 1 2 1 2 ;
       2 1 0 2 1 0 2 1 0 0 0 0 0 0 0 ;
       0 0 0 -1 -1 -1 -2 -2 -2 0 0 -1 -1 -2 -2 ;
       1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ];
   
figure;
plot3(P_W(1,:),P_W(2,:),P_W(3,:),'d');
axis equal;
grid on
axis vis3d;
   
NPTS = size(P_W,2);

ax = 120 * DEG_TO_RAD;
ay = 0 *DEG_TO_RAD;
az = 60 * DEG_TO_RAD;

Rx = [1 0 0;
      0 cos(ax) -sin(ax);
      0 sin(ax) cos(ax)];
Ry = [cos(ay)  0  sin(ay);
           0   1     0;
      -sin(ay) 0  cos(ay)];
Rz = [cos(az) -sin(az) 0;
      sin(az) cos(az)  0;
      0          0     1];
  
Rc1 = Rx*Ry*Rz; %rotation of camera 1
Tc1 = [0;0;5]; %translation of camera 1
M = [Rc1 Tc1];

p1 = K*(M * P_W);

u1(1,:) = p1(1,:) ./ p1(3,:);
u1(2,:) = p1(2,:) ./ p1(3,:);
u1(3,:) = p1(3,:) ./ p1(3,:);

for i=1:length(u1)
    x = round(u1(1,i)); y=round(u1(2,i));
    I1(y-2:y+2, x-2:x+2) = 255;
end
figure,subplot(1,2,1), imshow(I1, []), title('View 1');


ax = 0 * DEG_TO_RAD;
ay = 0 *DEG_TO_RAD;
az = 0 * DEG_TO_RAD;

Rx = [1 0 0;
      0 cos(ax) -sin(ax);
      0 sin(ax) cos(ax)];
Ry = [cos(ay)  0  sin(ay);
           0   1     0;
      -sin(ay) 0  cos(ay)];
Rz = [cos(az) -sin(az) 0;
      sin(az) cos(az)  0;
      0          0     1];

Rc2c1 = Rx*Ry*Rz;

Tc2c1 = [9;0;0];
Hc1 = [Rc1 Tc1; 0 0 0 1];
Hc2c1 = [Rc2c1 Tc2c1; 0 0 0 1];
Hc2 = Hc2c1*Hc1;

Rc2 = Hc2(1:3,1:3);
Tc2 = Hc2(1:3,4);

M = [Rc2 Tc2];

I2 = zeros(L,L);
p2 = K*(M*P_W);

% Rand = rand(3,15);
% Rand = Rand./100;
% Rand(3,:) = 0;
% 
% p2=p2+Rand;

u2(1,:) = p2(1,:) ./ p2(3,:);
u2(2,:) = p2(2,:) ./ p2(3,:);
u2(3,:) = p2(3,:) ./ p2(3,:);

for i=1:length(u2)
    x = round(u2(1,i)); y=round(u2(2,i));
    I2(y-2:y+2, x-2:x+2) = 255;
end

subplot(1,2,2), imshow(I2, []), title('View 2');

% disp('Points in image 1:');
% disp(u1);
% disp('Points in image 2:');
% disp(u2);

% imwrite(I1,'I1.tif');
% imwrite(I2,'I2.tif');

t = Tc2c1;
Etrue = [0 -t(3) t(2); t(3) 0 -t(1); -t(2) t(1) 0]*Rc2c1;
%}

%% points and intrinsic params
DEG_TO_RAD = pi/180;

u1 = [92,  94,  95,  97, 100, 100, 105, 128, 143, 168, 221, 271, 310, 387, 175, 173, 167, 168;
      438, 477, 519, 560, 603, 639, 448, 456, 465, 477, 470, 464, 453, 442, 527, 579, 664, 713;
      1,    1,    1,    1,   1,   1,   1,   1,  1,   1,   1,   1,   1,   1,   1,   1,   1,   1];
 
u2 = [226, 225, 223, 223, 221, 219, 249, 291, 318, 354, 398, 437, 465, 526, 355, 355, 343, 341;
      450, 487, 529, 571, 612, 650, 460, 470, 479, 487, 487, 482, 472, 464, 539, 594, 680, 730;
      1,   1,   1,   1,   1,   1,    1,    1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1]; 
  
%intrinsic parameters are known (calibrated)
f=876.85162;
u0 = 384.01067;
v0 = 371.84479;

K = [f 0 u0;
    0 f v0;
    0 0 1];

%% a
p1 = inv(K)*u1;
p2 = inv(K)*u2;

Xa = [];
% for i=1:1:8
% for i=4:1:12
% for i=3:1:15
% for i=1:1:10
for i=1:1:18
    a = [p1(1,i)*p2(1,i);
        p1(1,i)*p2(2,i);
        p1(1,i)*p2(3,i);
        p1(2,i)*p2(1,i);
        p1(2,i)*p2(2,i);
        p1(2,i)*p2(3,i);
        p1(3,i)*p2(1,i);
        p1(3,i)*p2(2,i);
        p1(3,i)*p2(3,i)];
    Xa = [Xa; a'];
end
XaTXa = (Xa')*Xa;
[U,S,V] = svd(XaTXa);
Es = V(:,end);
E = [Es(1:3) Es(4:6) Es(7:9)];
[U,S,V] = svd(E);
S(1,1) = 1;
S(2,2) = 1;
S(3,3) = 0;
E = U*S*V';
%% Epipoles
e1 = null(E,'r'); %right null space
e2 = null(E','r'); %left null space
%% Epipolar Lines
j=1;
x1 = p1(:,j);
x2 = p2(:,j);

l1 = (E')*x2;
l2 = E*x1;

%% estimate Rs Ts
% az = 90 * DEG_TO_RAD;
% Rz = [cos(az) -sin(az) 0;
%       sin(az) cos(az)  0;
%       0          0     1];
% 
% Th1 = U*Rz*S*U';
% T1 = [-Th1(2,3); Th1(1,3); -Th1(1,2)];
% R1 = U*Rz'*V';
% 
% 
% az = -90 * DEG_TO_RAD;
% Rz = [cos(az) -sin(az) 0;
%       sin(az) cos(az)  0;
%       0          0     1];
% 
% Th2 = U*Rz*S*U';
% T2 = [-Th2(2,3); Th2(1,3); -Th2(1,2)];
% R2 = U*Rz'*V';
%% 3d reoons

R = [-0.037113 -0.074803 0.101077;
    0.006917 0.050042 -0.033277;
    -0.058937 0.107928 0.069833];

T = [46.313922;4.812478;4.65071];

MU = zeros(54,19);

j = 1;

for i=1:1:18
    x1 = p1(:,i);
    x2 = p2(:,i);
    x2h = MakeSkewM(x2);%skew symmetric of x2
    MU(j:j+2,i) = x2h*R*x1;
    MU(j:j+2,end) = x2h*T;
    
    j = j + 3;
end

[U,S,V] = svd(MU'*MU);
Res = V(:,end);

lambdas = Res(1:18);


kGamma = 1;
k = kGamma / Res(19);

lambdaM = [lambdas';lambdas';lambdas'];
p1Est = k * (p1 .* lambdaM);

% close all
figure;

plot3(p1Est(1,:),p1Est(2,:),p1Est(3,:),'d')
axis equal
grid on
axis vis3d

%% Error in reconstruction
%{
%real deistance between farthest points on object
realDistance = norm(P_W(:,1) - P_W(:,end))

%estimated distance between farthest points on the reconstructed object
estimatedDistance = norm(p1Est(:,1) - p1Est(:,end))

%difference between them is the error
error = norm(P_W(:,1) - P_W(:,2)) - norm(p1Est(:,1) - p1Est(:,2))
%}
