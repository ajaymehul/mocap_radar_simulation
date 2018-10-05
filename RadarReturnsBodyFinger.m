function [data, TF] = RadarReturnsFromWalkingHuman(segment,seglength,T,radarloc )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Radar Returns From Walking Human
%
% Read walking human kinematics data.
%
% Based on “A Global Human Walking Model with Real-Time Kinematic
% Personification,” by R. Boulic, N. M. Thalmann, and D. Thalmann
% The Visual Computer, vol.6, 1990, pp. 344-358.
% This model is based on biomechanical experimental data.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input data
fprintf('%s\n',seglength(1).name);
headlen = seglength(1).length;
fprintf('%s\n',seglength(2).name);
shoulderlen = seglength(2).length;
fprintf('%s\n',seglength(3).name);
torsolen = seglength(3).length;
fprintf('%s\n',seglength(4).name);
hiplen = seglength(4).length;
fprintf('%s\n',seglength(5).name);
upperleglen = seglength(5).length;
fprintf('%s\n',seglength(6).name);
lowerleglen = seglength(6).length;
fprintf('%s\n',seglength(7).name);
footlen = seglength(7).length;
fprintf('%s\n',seglength(8).name);
upperarmlen = seglength(8).length;
fprintf('%s\n',seglength(9).name);
lowerarmlen = seglength(9).length;
fprintf('%s\n',segment(1).name);
base = segment(1).PositionData;
fprintf('%s\n',segment(2).name);
neck = segment(2).PositionData;
fprintf('%s\n',segment(3).name);
head = segment(3).PositionData;
fprintf('%s\n',segment(4).name);
lshoulder = segment(4).PositionData;
fprintf('%s\n',segment(5).name);
rshoulder = segment(5).PositionData;
fprintf('%s\n',segment(6).name);
lelbow = segment(6).PositionData;
fprintf('%s\n',segment(7).name);
relbow = segment(7).PositionData;
fprintf('%s\n',segment(8).name);
lhand = segment(8).PositionData;
fprintf('%s\n',segment(9).name);
rhand = segment(9).PositionData;
fprintf('%s\n',segment(10).name);
lhip = segment(10).PositionData;
fprintf('%s\n',segment(11).name);
rhip = segment(11).PositionData;
fprintf('%s\n',segment(12).name);
lknee = segment(12).PositionData;
fprintf('%s\n',segment(13).name);
rknee = segment(13).PositionData;
fprintf('%s\n',segment(14).name);
lankle = segment(14).PositionData;
fprintf('%s\n',segment(15).name);
rankle = segment(15).PositionData;
fprintf('%s\n',segment(16).name);
ltoe = segment(16).PositionData;
fprintf('%s\n',segment(17).name);
rtoe = segment(17).PositionData;




%finger joints
lthumb = [segment(18),segment(19),segment(20),segment(21)];
lindex = [segment(22),segment(23),segment(24),segment(25)];
lmiddle = [segment(26),segment(27),segment(28),segment(29)];
lring = [segment(30),segment(31),segment(32),segment(33)];
lpinky = [segment(34),segment(35),segment(36),segment(37)];
lwrist = segment(38).PositionData;


rthumb = [segment(39),segment(40),segment(41),segment(42)];
rindex = [segment(43),segment(44),segment(45),segment(46)];
rmiddle = [segment(47),segment(48),segment(49),segment(50)];
rring = [segment(51),segment(52),segment(53),segment(54)];
rpinky = [segment(55),segment(56),segment(57),segment(58)];
rwrist = segment(59).PositionData;

lpalm = segment(60).PositionData;
rpalm = segment(61).PositionData;
thumblen = seglength(10).length;
indexlen = seglength(11).length;
middlelen = seglength(12).length;
ringlen = seglength(13).length;
pinkylen = seglength(14).length;
palmlen = seglength(15).length;

%----------



j = sqrt(-1);
% radar parameters
lambda = 0.0125; % wave length
rangeres = 0.075; % range resolution
%radarloc = [10,0,2]; % radar location
nr = round(2*sqrt((radarloc(1))^2+(radarloc(2))^2+(radarloc(3))^2)/rangeres);
np = size(base,2);
data = zeros(nr,np);


disp (size(data))

% radar returns from the head
for k = 1:np
 % distance from radar to head
 r_dist(:,k) = abs(head(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);

 % aspect vector of the head
 aspct(:,k) = head(:,k)-neck(:,k);
 % calculate theta angle
 A = [radarloc(1)-head(1,k); radarloc(2)-head(2,k);...
 radarloc(3)-head(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-head(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.1; % ellipsoid parameter
 b = 0.1;
 c = headlen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
 
end
% radar returns from torso
for k = 1:np
 % distance from radar to torso
 torso(:,k) = (neck(:,k)+base(:,k))/2;
 r_dist(:,k) = abs(torso(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the torso
 aspct(:,k) = neck(:,k)-base(:,k);
 % calculate theta angle
 A = [radarloc(1)-torso(1,k); radarloc(2)-torso(2,k);...
 radarloc(3)-torso(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-torso(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.15;
 b = 0.15;
 c = torsolen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
% radar returns from left shoulder
for k = 1:np
 % distance from radar to left shoulder
 r_dist(:,k) = abs(lshoulder(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);

 % aspect vector of the left shoulder
 aspct(:,k) = lshoulder(:,k)-neck(:,k);
 % calculate theta angle
 A = [radarloc(1)-lshoulder(1,k); radarloc(2)-lshoulder(2,k);...
 radarloc(3)-lshoulder(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-lshoulder(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.06;
 b = 0.06;
 c = shoulderlen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

% radar returns from right shoulder
for k = 1:np
 % distance from radar to right shoulder
 r_dist(:,k) = abs(rshoulder(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the right shoulder
 aspct(:,k) = rshoulder(:,k)-neck(:,k);
 % calculate theta angle
 A = [radarloc(1)-rshoulder(1,k); radarloc(2)-rshoulder(2,k);...
 radarloc(3)-rshoulder(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-rshoulder(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.06;
 b = 0.06;
 c = shoulderlen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

% radar returns from left upper-arm
for k = 1:np
 % distance from radar to left upper-arm
 lupperarm(:,k) = (lshoulder(:,k)+lelbow(:,k))/2;
 r_dist(:,k) = abs(lupperarm(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);

 % aspect vector of the left upper-arm
 aspct(:,k) = lshoulder(:,k)-lelbow(:,k);
 % calculate theta angle
 A = [radarloc(1)-lupperarm(1,k); radarloc(2)-lupperarm(2,k);...
 radarloc(3)-lupperarm(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-lupperarm(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.06;
 b = 0.06;
 c = upperarmlen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));

 % aspect vector of the left lower-arm
 aspct(:,k) = lelbow(:,k)-lhand(:,k);
 % calculate theta angle
 A = [radarloc(1)-lhand(1,k); radarloc(2)-lhand(2,k);...
 radarloc(3)-lhand(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-lhand(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.05;
 b = 0.05;
 c = lowerarmlen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

% radar returns from right lower-arm
for k = 1:np
 % distance from radar to right lower-arm
 r_dist(:,k) = abs(rhand(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the right lower-arm
 aspct(:,k) = relbow(:,k)-rhand(:,k);
 % calculate theta angle
 A = [radarloc(1)-rhand(1,k); radarloc(2)-rhand(2,k);...
 radarloc(3)-rhand(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-rhand(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.05;
 b = 0.05;
 c = lowerarmlen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
%{
% radar returns from left hip
for k = 1:np
 % distance from radar to left hip
 r_dist(:,k) = abs(lhip(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);

 % aspect vector of the left hip
 aspct(:,k) = lhip(:,k)-base(:,k);
 % calculate theta angle
 A = [radarloc(1)-lhip(1,k); radarloc(2)-lhip(2,k);...
 radarloc(3)-lhip(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-lhip(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.07;
 b = 0.07;
 c = hiplen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

% radar returns from right hip
for k = 1:np
 % distance from radar to right hip
 r_dist(:,k) = abs(rhip(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the right hip
 aspct(:,k) = rhip(:,k)-base(:,k);
 % calculate theta angle
 A = [radarloc(1)-rhip(1,k); radarloc(2)-rhip(2,k);...
 radarloc(3)-rhip(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-rhip(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.07;
 b = 0.07;
 c = hiplen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
% radar returns from left upper-leg
for k = 1:np
 % distance from radar to left upper-leg
 lupperleg(:,k) = (lhip(:,k)+lknee(:,k))/2;
 r_dist(:,k) = abs(lupperleg(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);

 % aspect vector of the left upper-leg
 aspct(:,k) = lknee(:,k)-lhip(:,k);
 % calculate theta angle
 A = [radarloc(1)-lupperleg(1,k); radarloc(2)-lupperleg(2,k);...
 radarloc(3)-lupperleg(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-lupperleg(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.07;
 b = 0.07;
 c = upperleglen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
% radar returns from right upper-leg
for k = 1:np
 % distance from radar to right upper-leg
 rupperleg(:,k) = (rhip(:,k)+rknee(:,k))/2;
 r_dist(:,k) = abs(rupperleg(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the right upper-leg
 aspct(:,k) = rknee(:,k)-rhip(:,k);
 % calculate theta angle
 A = [radarloc(1)-rupperleg(1,k); radarloc(2)-rupperleg(2,k);...
 radarloc(3)-rupperleg(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-rupperleg(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.07;
 b = 0.07;
 c = upperleglen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
%radar returns from left lower-leg
for k = 1:np
 % distance from radar to left lower-leg
 llowerleg(:,k) = (lankle(:,k)+lknee(:,k))/2;
 r_dist(:,k) = abs(llowerleg(:,k)-radarloc(:));

 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the left lower-leg
 aspct(:,k) = lankle(:,k)-lknee(:,k);
 % calculate theta angle
 A = [radarloc(1)-llowerleg(1,k); radarloc(2)-llowerleg(2,k);...
 radarloc(3)-llowerleg(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-llowerleg(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.06;
 b = 0.06;
 c = lowerleglen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
% radar returns from right lower-leg
for k = 1:np
 % distance from radar to right lower-leg
 rlowerleg(:,k) = (rankle(:,k)+rknee(:,k))/2;
 r_dist(:,k) = abs(rlowerleg(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the right lower-leg
 aspct(:,k) = rankle(:,k)-rknee(:,k);
 % calculate theta angle
 A = [radarloc(1)-rlowerleg(1,k); radarloc(2)-rlowerleg(2,k);...
 radarloc(3)-rlowerleg(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-rlowerleg(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.06;
 b = 0.06;
 c = upperleglen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
% radar returns from left foot
for k = 1:np
 % distance from radar to left foot
 r_dist(:,k) = abs(ltoe(:,k)-radarloc(:));

 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the left foot
 aspct(:,k) = lankle(:,k)-ltoe(:,k);
 % calculate theta angle
 A = [radarloc(1)-ltoe(1,k); radarloc(2)-ltoe(2,k);...
 radarloc(3)-ltoe(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-ltoe(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.05;
 b = 0.05;
 c = footlen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
% radar returns from right foot
for k = 1:np
 % distance from radar to right foot
 r_dist(:,k) = abs(rtoe(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the right foot
 aspct(:,k) = rankle(:,k)-rtoe(:,k);
 % calculate theta angle
 A = [radarloc(1)-rtoe(1,k); radarloc(2)-rtoe(2,k);...
 radarloc(3)-rtoe(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-rtoe(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));
 a = 0.05;
 b = 0.05;
 c = footlen/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end



% radar returns from  Hand
% radar returns from Palm
for k = 1:np
 PHs = RadarReturns(radarloc, lpalm,lwrist,palmlen,lambda ,0.01 ,palmlen/2 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
% radar returns from Thumb 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, lthumb(2).PositionData,lthumb(1).PositionData, thumblen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
%radar returns from Thumb 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, lthumb(3).PositionData,lthumb(2).PositionData, thumblen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end
%radar returns from Thumb 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, lthumb(4).PositionData,lthumb(3).PositionData, thumblen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Index 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, lindex(2).PositionData,lindex(1).PositionData, indexlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Index 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, lindex(3).PositionData,lindex(2).PositionData, indexlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Index 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, lindex(4).PositionData,lindex(3).PositionData, indexlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Middle 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, lmiddle(2).PositionData,lmiddle(1).PositionData, middlelen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Middle 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, lmiddle(3).PositionData,lmiddle(2).PositionData, middlelen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Middle 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, lmiddle(4).PositionData,lmiddle(3).PositionData, middlelen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Ring 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, lring(2).PositionData,lring(1).PositionData, ringlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Ring 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, lring(3).PositionData,lring(2).PositionData, ringlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from Ring 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, lring(4).PositionData,lring(3).PositionData, ringlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from pinky 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, lpinky(2).PositionData,lpinky(1).PositionData, pinkylen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from pinky 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, lpinky(3).PositionData,lpinky(2).PositionData, pinkylen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from pinky 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, lpinky(4).PositionData,lpinky(3).PositionData, pinkylen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

% radar returns from Right Hand
% radar returns from Palm
for k = 1:np
 PHs = RadarReturns(radarloc, rpalm,rwrist,palmlen,lambda ,0.01 ,palmlen/2 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from thumb 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, rthumb(2).PositionData,rthumb(1).PositionData, thumblen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from thumb 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, rthumb(3).PositionData,rthumb(2).PositionData, thumblen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from thumb 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, rthumb(4).PositionData,rthumb(3).PositionData, thumblen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from index 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, rindex(2).PositionData,rindex(1).PositionData, indexlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from index 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, rindex(3).PositionData,rindex(2).PositionData, indexlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from index 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, rindex(4).PositionData,rindex(3).PositionData, indexlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from middle 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, rmiddle(2).PositionData,rmiddle(1).PositionData, middlelen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from middle 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, rmiddle(3).PositionData,rmiddle(2).PositionData, middlelen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from middle 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, rmiddle(4).PositionData,rmiddle(3).PositionData, middlelen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from ring 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, rring(2).PositionData,rring(1).PositionData, ringlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from ring 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, rring(3).PositionData,rring(2).PositionData, ringlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from ring 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, rring(4).PositionData,rring(3).PositionData, ringlen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from pinky 1-2
for k = 1:np
 PHs = RadarReturns(radarloc, rpinky(2).PositionData,rpinky(1).PositionData, pinkylen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from pinky 2-3
for k = 1:np
 PHs = RadarReturns(radarloc, rpinky(3).PositionData,rpinky(2).PositionData, pinkylen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%radar returns from pinky 3-4
for k = 1:np
 PHs = RadarReturns(radarloc, rpinky(4).PositionData,rpinky(3).PositionData, pinkylen,lambda ,0.01 ,0.01 ,k);
 data(floor(distances(k)/rangeres),k) = ...
 data(floor(distances(k)/rangeres),k) + PHs;
end

%}

% display range profiles
figure
colormap(jet(256))
imagesc([1,np],[0,nr*rangeres],20*log10(abs(data)+eps))
xlabel('Pulses')

ylabel('Range (m)')
title('Range Profiles')
axis xy
clim = get(gca,'CLim');
set(gca,'CLim',clim(2) + [-40 0]);
colorbar
drawnow

% micro-Doppler signature
x = sum(data); % average over range cells
dT = T/np;
F = 1/dT; % np/T;
wd = 512;
wdd2 = wd/2;
wdd8 = wd/8;
ns = np/wd;
% calculate time-frequency micro-Doppler signature
disp('Calculating segments of TF distribution ...')
TF2 = [];
for k = 1:ns
disp(strcat(' segment progress: ',num2str(k),'/',num2str(round(ns))))
sig(1:wd,1) = x(1,(k-1)*wd+1:(k-1)*wd+wd);
TMP = stft(sig,16);
TF2(:,(k-1)*wdd8+1:(k-1)*wdd8+wdd8) = TMP(:,1:8:wd);
end
TF = TF2;
disp('Calculating shifted segments of TF distribution ...')
TF1 = zeros(size(TF));
for k = 1:ns-1
disp(strcat(' shift progress: ',num2str(k),'/',num2str(round(ns-1))))
sig(1:wd,1) = x(1,(k-1)*wd+1+wdd2:(k-1)*wd+wd+wdd2);
TMP = stft(sig,16);
TF1(:,(k-1)*wdd8+1:(k-1)*wdd8+wdd8) = TMP(:,1:8:wd);
end
disp('Removing edge effects ...')
for k = 1:ns-1
 TF(:,k*wdd8-8:k*wdd8+8) = ...
 TF1(:,(k-1)*wdd8+wdd8/2-8:(k-1)*wdd8+wdd8/2+8);
end
% display final time-frequency signature
figure
colormap(jet(256))
imagesc([0,T],[-F/2,F/2],20*log10(fftshift(abs(TF),1)+eps))
xlabel('Time (s)')
ylabel('Doppler (Hz)')
title('Micro-Doppler Signature of Human Walk')
axis xy
clim = get(gca,'CLim');
set(gca,'CLim',clim(2) + [-45 0]);
colorbar
drawnow