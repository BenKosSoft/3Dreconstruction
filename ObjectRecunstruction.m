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

u1 = [385, 347, 349, 196, 171, 262, 352, 557;
      642, 692, 750, 785, 802, 586, 557, 825;
      1,   1,   1,   1,   1,   1,   1,   1];

u2 = [753, 722, 721, 582, 535, 659, 696, 644;
      667, 716, 774, 803, 819, 607, 579, 842;
      1,   1,   1,   1,   1,   1,   1,   1]; 
  
%intrinsic parameters are known (calibrated)
f=876;
u0 = 480;
v0 = 640;

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
for i=1:1:8
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
az = 90 * DEG_TO_RAD;
Rz = [cos(az) -sin(az) 0;
      sin(az) cos(az)  0;
      0          0     1];

Th1 = U*Rz*S*U';
T1 = [-Th1(2,3); Th1(1,3); -Th1(1,2)];
R1 = U*Rz'*V';


az = -90 * DEG_TO_RAD;
Rz = [cos(az) -sin(az) 0;
      sin(az) cos(az)  0;
      0          0     1];

Th2 = U*Rz*S*U';
T2 = [-Th2(2,3); Th2(1,3); -Th2(1,2)];
R2 = U*Rz'*V';
%% 3d reoons
%{
R = R1;
T = T1;
MU = zeros(45,16);

j = 1;

for i=1:1:8
    x1 = p1(:,i);
    x2 = p2(:,i);
    x2h = MakeSkewM(x2);%skew symmetric of x2
    MU(j:j+2,i) = x2h*R*x1;
    MU(j:j+2,end) = x2h*T;
    
    j = j + 3;
end

[U,S,V] = svd(MU'*MU);
Res = V(:,end);

lambdas = Res(1:15);


kGamma = Tc2c1(1) / T(1);
k = kGamma / Res(16);

lambdaM = [lambdas';lambdas';lambdas'];
p1Est = k * (p1 .* lambdaM);

% close all
figure;

plot3(p1Est(1,:),p1Est(2,:),p1Est(3,:),'d')
axis equal
grid on
axis vis3d
%}
%% Error in reconstruction
%{
%real deistance between farthest points on object
realDistance = norm(P_W(:,1) - P_W(:,end))

%estimated distance between farthest points on the reconstructed object
estimatedDistance = norm(p1Est(:,1) - p1Est(:,end))

%difference between them is the error
error = norm(P_W(:,1) - P_W(:,2)) - norm(p1Est(:,1) - p1Est(:,2))
%}
