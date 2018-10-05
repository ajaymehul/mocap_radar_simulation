function [M] = ReadKinectFinger(filename, time)

[M,strings, raw] = xlsread(filename);
M(:,3) = -M(:,3);
%finger lengths
thumblen.name = 'Thumblen';
thumblen.length = 0.02;
indexlen.name = 'indexlen';
indexlen.length = 0.02;
middlelen.name = 'middlelen';
middlelen.length = 0.02;
ringlen.name = 'ringlen';
ringlen.length = 0.02;
pinkylen.name = 'pinkylen';
pinkylen.length = 0.02;
palmlen.name = 'palmlen';
palmlen.length = 0.05;
%Getting segment lengths%


%headlen%
temp = [(M(3,3)-M(4,3)) (M(3,1)-M(4,1)) (M(3,2)-M(4,2))];
headlen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
headlen.name = 'Headlen';

%shoulderlen%
temp = [(M(5,3)-M(9,3)) (M(5,1)-M(9,1)) (M(5,2)-M(9,2))];
shoulderlen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
shoulderlen.name = 'Shoulderlen';
%torsolen%
temp = [(M(21,3)-M(1,3)) (M(21,1)-M(1,1)) (M(21,2)-M(1,2))];
torsolen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
torsolen.name = 'Torsolen';
%hiplen%
temp = [(M(13,3)-M(17,3)) (M(13,1)-M(17,1)) (M(13,2)-M(17,2))];
hiplen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
hiplen.name = 'Hiplen';
%upperleglen%
temp = [(M(13,3)-M(14,3)) (M(13,1)-M(14,1)) (M(13,2)-M(14,2))];
upperleglen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
upperleglen.name = 'Upperleglen';
%lowerleglen%
temp = [(M(14,3)-M(15,3)) (M(14,1)-M(15,1)) (M(14,2)-M(15,2))];
lowerleglen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
lowerleglen.name = 'Lowerleglen';
%footlen%
temp = [(M(15,3)-M(16,3)) (M(15,1)-M(16,1)) (M(15,2)-M(16,2))];
footlen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
footlen.name = 'Footlen';
%upperarmlen%
temp = [(M(5,3)-M(6,3)) (M(5,1)-M(6,1)) (M(5,2)-M(6,2))];
upperarmlen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
upperarmlen.name = 'Upperarmlen';
%lowerarmlen%
temp = [(M(6,3)-M(7,3)) (M(6,1)-M(7,1)) (M(6,2)-M(7,2))];
lowerarmlen.length = sqrt(temp(1).^2+temp(2).^2+temp(3).^2);
lowerarmlen.name = 'Lowerarmlen';

seglength = [headlen,shoulderlen,torsolen,hiplen,upperleglen,lowerleglen,footlen,upperarmlen,lowerarmlen,thumblen,indexlen,middlelen, ringlen, pinkylen, palmlen];
%End of Segment length code%

%Start of Segment Position Data code%
count = size(M,1)/71;
p = 71;
%Base%
Base.name = 'Base';
Base.PositionData = [0;0;0];
Basei = [-M(1,3);-M(1,1);M(1,2)];
for i = 1:(count-1)
    temp = -Basei+ [-M(1+p*i,3);-M(1+p*i,1);M(1+p*i,2)] ;
    Base.PositionData = [Base.PositionData ,temp];
end

radarloc =  -Basei';


%Neck%
Neck.name = 'Neck';
Neck.PositionData = [-M(21,3);-M(21,1);M(21,2)];
for i = 1:(count-1)
    temp = -Basei+ [-M(21+p*i,3);-M(21+p*i,1);M(21+p*i,2)] ;
    Neck.PositionData = [Neck.PositionData ,temp];
end

%Head%
Head.name = 'Head';
Head.PositionData = [-M(4,3);-M(4,1);M(4,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(4+p*i,3);-M(4+p*i,1);M(4+p*i,2)]  ;
    Head.PositionData = [Head.PositionData ,temp];
end

%Left Shoulder%
lshoulder.name = 'lshoulder';
lshoulder.PositionData = [-M(5,3);-M(5,1);M(5,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(5+p*i,3);-M(5+p*i,1);M(5+p*i,2)] ;
    lshoulder.PositionData = [lshoulder.PositionData ,temp];
end

%Right Shoulder%
rshoulder.name = 'rshoulder';
rshoulder.PositionData = [-M(9,3);-M(9,1);M(9,2)];
for i = 1:(count-1)
    temp = -Basei+ [-M(9+p*i,3);-M(9+p*i,1);M(9+p*i,2)] ;
    rshoulder.PositionData = [rshoulder.PositionData ,temp];
end

%Left Elbow%
lelbow.name = 'lelbow';
lelbow.PositionData = [-M(6,3);-M(6,1);M(6,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(6+p*i,3);-M(6+p*i,1);M(6+p*i,2)] ;
    lelbow.PositionData = [lelbow.PositionData ,temp];
end

%Right Elbow%
relbow.name = 'relbow';
relbow.PositionData = [-M(10,3);-M(10,1);M(10,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(10+p*i,3);-M(10+p*i,1);M(10+p*i,2)] ;
    relbow.PositionData = [relbow.PositionData ,temp];
end

%Left Hand%
lhand.name = 'lhand';
lhand.PositionData = [-M(8,3);-M(8,1);M(8,2)];
for i = 1:(count-1)
    temp = -Basei+  [-M(8+p*i,3);-M(8+p*i,1);M(8+p*i,2)] ;
    lhand.PositionData = [lhand.PositionData ,temp];
end

%Right Hand%
rhand.name = 'rhand';
rhand.PositionData = [-M(12,3);-M(12,1);M(12,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(12+p*i,3);-M(12+p*i,1);M(12+p*i,2)] ;
    rhand.PositionData = [rhand.PositionData ,temp];
end

%Left Hand%
lwristk.name = 'lwristk';
lwristk.PositionData = [-M(7,3);-M(7,1);M(7,2)];
for i = 1:(count-1)
    temp =  -Basei+  [-M(7+p*i,3);-M(7+p*i,1);M(7+p*i,2)] ;
    lwristk.PositionData = [lwristk.PositionData ,temp];
end

%Right Wrist%
rwristk.name = 'rwristk';
rwristk.PositionData = [-M(11,3);-M(11,1);M(11,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(11+p*i,3);-M(11+p*i,1);M(11+p*i,2)] ;
    rwristk.PositionData = [rwristk.PositionData ,temp];
end

%Left Wrist%
lhip.name = 'lwrist';
lhip.PositionData = [-M(13,3);-M(13,1);M(13,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(13+p*i,3);-M(13+p*i,1);M(13+p*i,2)] ;
    lhip.PositionData = [lhip.PositionData ,temp];
end

%Right Hip%
rhip.name = 'rhip';
rhip.PositionData = [-M(17,3);-M(17,1);M(17,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(17+p*i,3);-M(17+p*i,1);M(17+p*i,2)] ;
    rhip.PositionData = [rhip.PositionData ,temp];
end

%Left Knee%
lknee.name = 'lknee';
lknee.PositionData = [-M(14,3);-M(14,1);M(14,2)];
for i = 1:(count-1)
    temp = -Basei+  [-M(14+p*i,3);-M(14+p*i,1);M(14+p*i,2)] ;
    lknee.PositionData = [lknee.PositionData ,temp];
end

%Right Knee%
rknee.name = 'rknee';
rknee.PositionData = [-M(18,3);-M(18,1);M(18,2)];
for i = 1:(count-1)
    temp =  -Basei+  [-M(18+p*i,3);-M(18+p*i,1);M(18+p*i,2)] ;
    rknee.PositionData = [rknee.PositionData ,temp];
end

%Left Ankle%
lankle.name = 'lankle';
lankle.PositionData = [-M(15,3);-M(15,1);M(15,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(15+p*i,3);-M(15+p*i,1);M(15+p*i,2)] ;
    lankle.PositionData = [lankle.PositionData ,temp];
end

%Right Ankle%
rankle.name = 'rankle';
rankle.PositionData = [-M(19,3);-M(19,1);M(19,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(19+p*i,1);-M(19+p*i,1);M(19+p*i,2)] ;
    rankle.PositionData = [rankle.PositionData ,temp];
end

%Left Toe%
ltoe.name = 'ltoe';
ltoe.PositionData = [-M(16,3);-M(16,1);M(16,2)];
for i = 1:(count-1)
    temp =  -Basei+ [-M(16+p*i,3);-M(16+p*i,1);M(16+p*i,2)] ;
    ltoe.PositionData = [ltoe.PositionData ,temp];
end

%Right Toe%
rtoe.name = 'rtoe';
rtoe.PositionData = [-M(20,3);-M(20,1);M(20,2)];
for i = 1:(count-1)
    temp = -Basei+ [-M(20+p*i,3);-M(20+p*i,1);M(20+p*i,2)] ;
    rtoe.PositionData = [rtoe.PositionData ,temp];
end

%Left Hand Fingers%

lthumb0.name = 'lthumb0';
lthumb0.PositionData = [M(26,3);-M(26,1);M(26,2)];
for i = 1:(count-1)
    temp = [M(26+p*i,3);-M(26+p*i,1);M(26+p*i,2)];
    lthumb0.PositionData = [lthumb0.PositionData, temp];
end

lthumb1.name = 'lthumb1';
lthumb1.PositionData = [M(28,3);-M(28,1);M(28,2)];
for i = 1:(count-1)
    temp = [M(28+p*i,3);-M(28+p*i,1);M(28+p*i,2)];
    lthumb1.PositionData = [lthumb1.PositionData, temp];
end

lthumb2.name = 'lthumb2';
lthumb2.PositionData = [M(30,3);-M(30,1);M(30,2)];
for i = 1:(count-1)
    temp = [M(30+p*i,3);-M(30+p*i,1);M(30+p*i,2)];
    lthumb2.PositionData = [lthumb2.PositionData, temp];
end

lthumb3.name = 'lthumb3';
lthumb3.PositionData = [M(32,3);-M(32,1);M(32,2)];
for i = 1:(count-1)
    temp = [M(32+p*i,3);-M(32+p*i,1);M(32+p*i,2)];
    lthumb3.PositionData = [lthumb3.PositionData, temp];
end

lindex0.name = 'lindex0';
lindex0.PositionData = [M(34,3);-M(34,1);M(34,2)];
for i = 1:(count-1)
    temp = [M(34+p*i,3);-M(34+p*i,1);M(34+p*i,2)];
    lindex0.PositionData = [lindex0.PositionData, temp];
end

lindex1.name = 'lindex1';
lindex1.PositionData = [M(36,3);-M(36,1);M(36,2)];
for i = 1:(count-1)
    temp = [M(36+p*i,3);-M(36+p*i,1);M(36+p*i,2)];
    lindex1.PositionData = [lindex1.PositionData, temp];
end

lindex2.name = 'lindex2';
lindex2.PositionData = [M(38,3);-M(38,1);M(38,2)];
for i = 1:(count-1)
    temp = [M(38+p*i,3);-M(38+p*i,1);M(38+p*i,2)];
    lindex2.PositionData = [lindex2.PositionData, temp];
end


lindex3.name = 'lindex3';
lindex3.PositionData = [M(40,3);-M(40,1);M(40,2)];
for i = 1:(count-1)
    temp = [M(40+p*i,3);-M(40+p*i,1);M(40+p*i,2)];
    lindex3.PositionData = [lindex3.PositionData, temp];
end

lmiddle0.name = 'lmiddle0';
lmiddle0.PositionData = [M(42,3);-M(42,1);M(42,2)];
for i = 1:(count-1)
    temp = [M(42+p*i,3);-M(42+p*i,1);M(42+p*i,2)];
    lmiddle0.PositionData = [lmiddle0.PositionData, temp];
end

lmiddle1.name = 'lmiddle1';
lmiddle1.PositionData = [M(44,3);-M(44,1);M(44,2)];
for i = 1:(count-1)
    temp = [M(44+p*i,3);-M(44+p*i,1);M(44+p*i,2)];
    lmiddle1.PositionData = [lmiddle1.PositionData, temp];
end

lmiddle2.name = 'lmiddle2';
lmiddle2.PositionData = [M(46,3);-M(46,1);M(46,2)];
for i = 1:(count-1)
    temp = [M(46+p*i,3);-M(46+p*i,1);M(46+p*i,2)];
    lmiddle2.PositionData = [lmiddle2.PositionData, temp];
end

lmiddle3.name = 'lmiddle3';
lmiddle3.PositionData = [M(48,3);-M(48,1);M(48,2)];
for i = 1:(count-1)
    temp = [M(48+p*i,3);-M(48+p*i,1);M(48+p*i,2)];
    lmiddle3.PositionData = [lmiddle3.PositionData, temp];
end

lring0.name = 'lring0';
lring0.PositionData = [M(50,3);-M(50,1);M(50,2)];
for i = 1:(count-1)
    temp = [M(50+p*i,3);-M(50+p*i,1);M(50+p*i,2)];
    lring0.PositionData = [lring0.PositionData, temp];
end

lring1.name = 'lring1';
lring1.PositionData = [M(52,3);-M(52,1);M(52,2)];
for i = 1:(count-1)
    temp = [M(52+p*i,3);-M(52+p*i,1);M(52+p*i,2)];
    lring1.PositionData = [lring1.PositionData, temp];
end

lring2.name = 'lring2';
lring2.PositionData = [M(54,3);-M(54,1);M(54,2)];
for i = 1:(count-1)
    temp = [M(54+p*i,3);-M(54+p*i,1);M(54+p*i,2)];
    lring2.PositionData = [lring2.PositionData, temp];
end

lring3.name = 'lring3';
lring3.PositionData = [M(56,3);-M(56,1);M(56,2)];
for i = 1:(count-1)
    temp = [M(56+p*i,3);-M(56+p*i,1);M(56+p*i,2)];
    lring3.PositionData = [lring3.PositionData, temp];
end

lpinky0.name = 'lpinky0';
lpinky0.PositionData = [M(58,3);-M(58,1);M(58,2)];
for i = 1:(count-1)
    temp = [M(58+p*i,3);-M(58+p*i,1);M(58+p*i,2)];
    lpinky0.PositionData = [lpinky0.PositionData, temp];
end

lpinky1.name = 'lpinky1';
lpinky1.PositionData = [M(60,3);-M(60,1);M(60,2)];
for i = 1:(count-1)
    temp = [M(60+p*i,3);-M(60+p*i,1);M(60+p*i,2)];
    lpinky1.PositionData = [lpinky1.PositionData, temp];
end

lpinky2.name = 'lpinky2';
lpinky2.PositionData = [M(62,3);-M(62,1);M(62,2)];
for i = 1:(count-1)
    temp = [M(62+p*i,3);-M(62+p*i,1);M(62+p*i,2)];
    lpinky2.PositionData = [lpinky2.PositionData, temp];
end

lpinky3.name = 'lpinky3';
lpinky3.PositionData = [M(64,3);-M(64,1);M(64,2)];
for i = 1:(count-1)
    temp = [M(64+p*i,3);-M(64+p*i,1);M(64+p*i,2)];
    lpinky3.PositionData = [lpinky3.PositionData, temp];
end

%End of left Hand finger%

%Right Hand fingers%

rthumb0.name = 'rthumb0';
rthumb0.PositionData = [M(27,3);-M(27,1);M(27,2)];
for i = 1:(count-1)
    temp = [M(27+p*i,3);-M(27+p*i,1);M(27+p*i,2)];
    rthumb0.PositionData = [rthumb0.PositionData, temp];
end

rthumb1.name = 'rthumb1';
rthumb1.PositionData = [M(29,3);-M(29,1);M(29,2)];
for i = 1:(count-1)
    temp = [M(29+p*i,3);-M(29+p*i,1);M(29+p*i,2)];
    rthumb1.PositionData = [rthumb1.PositionData, temp];
end

rthumb2.name = 'rthumb2';
rthumb2.PositionData = [M(31,3);-M(31,1);M(31,2)];
for i = 1:(count-1)
    temp = [M(31+p*i,3);-M(31+p*i,1);M(31+p*i,2)];
    rthumb2.PositionData = [rthumb2.PositionData, temp];
end

rthumb3.name = 'rthumb3';
rthumb3.PositionData = [M(33,3);-M(33,1);M(33,2)];
for i = 1:(count-1)
    temp = [M(33+p*i,3);-M(33+p*i,1);M(33+p*i,2)];
    rthumb3.PositionData = [rthumb3.PositionData, temp];
end

rindex0.name = 'rindex0';
rindex0.PositionData = [M(35,3);-M(35,1);M(35,2)];
for i = 1:(count-1)
    temp = [M(35+p*i,3);-M(35+p*i,1);M(35+p*i,2)];
    rindex0.PositionData = [rindex0.PositionData, temp];
end

rindex1.name = 'rindex1';
rindex1.PositionData = [M(37,3);-M(37,1);M(37,2)];
for i = 1:(count-1)
    temp = [M(37+p*i,3);-M(37+p*i,1);M(37+p*i,2)];
    rindex1.PositionData = [rindex1.PositionData, temp];
end

rindex2.name = 'rindex2';
rindex2.PositionData = [M(39,3);-M(39,1);M(39,2)];
for i = 1:(count-1)
    temp = [M(39+p*i,3);-M(39+p*i,1);M(39+p*i,2)];
    rindex2.PositionData = [rindex2.PositionData, temp];
end

rindex3.name = 'rindex3';
rindex3.PositionData = [M(41,3);-M(41,1);M(41,2)];
for i = 1:(count-1)
    temp = [M(41+p*i,3);-M(41+p*i,1);M(41+p*i,2)];
    rindex3.PositionData = [rindex3.PositionData, temp];
end

rmiddle0.name = 'rmiddle0';
rmiddle0.PositionData = [M(43,3);-M(43,1);M(43,2)];
for i = 1:(count-1)
    temp = [M(43+p*i,3);-M(43+p*i,1);M(43+p*i,2)];
    rmiddle0.PositionData = [rmiddle0.PositionData, temp];
end

rmiddle1.name = 'rmiddle1';
rmiddle1.PositionData = [M(45,3);-M(45,1);M(45,2)];
for i = 1:(count-1)
    temp = [M(45+p*i,3);-M(45+p*i,1);M(45+p*i,2)];
    rmiddle1.PositionData = [rmiddle1.PositionData, temp];
end

rmiddle2.name = 'rmiddle2';
rmiddle2.PositionData = [M(47,3);-M(47,1);M(47,2)];
for i = 1:(count-1)
    temp = [M(47+p*i,3);-M(47+p*i,1);M(47+p*i,2)];
    rmiddle2.PositionData = [rmiddle2.PositionData, temp];
end

rmiddle3.name = 'rmiddle3';
rmiddle3.PositionData = [M(49,3);-M(49,1);M(49,2)];
for i = 1:(count-1)
    temp = [M(49+p*i,3);-M(49+p*i,1);M(49+p*i,2)];
    rmiddle3.PositionData = [rmiddle3.PositionData, temp];
end

rring0.name = 'rring0';
rring0.PositionData = [M(51,3);-M(51,1);M(51,2)];
for i = 1:(count-1)
    temp = [M(51+p*i,3);-M(51+p*i,1);M(51+p*i,2)];
    rring0.PositionData = [rring0.PositionData, temp];
end

rring1.name = 'rring1';
rring1.PositionData = [M(53,3);-M(53,1);M(53,2)];
for i = 1:(count-1)
    temp = [M(53+p*i,3);-M(53+p*i,1);M(53+p*i,2)];
    rring1.PositionData = [rring1.PositionData, temp];
end

rring2.name = 'rring2';
rring2.PositionData = [M(55,3);-M(55,1);M(55,2)];
for i = 1:(count-1)
    temp = [M(55+p*i,3);-M(55+p*i,1);M(55+p*i,2)];
    rring2.PositionData = [rring2.PositionData, temp];
end

rring3.name = 'rring3';
rring3.PositionData = [M(57,3);-M(57,1);M(57,2)];
for i = 1:(count-1)
    temp = [M(57+p*i,3);-M(57+p*i,1);M(57+p*i,2)];
    rring3.PositionData = [rring3.PositionData, temp];
end

rpinky0.name = 'rpinky0';
rpinky0.PositionData = [M(59,3);-M(59,1);M(59,2)];
for i = 1:(count-1)
    temp = [M(59+p*i,3);-M(59+p*i,1);M(59+p*i,2)];
    rpinky0.PositionData = [rpinky0.PositionData, temp];
end

rpinky1.name = 'rpinky1';
rpinky1.PositionData = [M(61,3);-M(61,1);M(61,2)];
for i = 1:(count-1)
    temp = [M(61+p*i,3);-M(61+p*i,1);M(61+p*i,2)];
    rpinky1.PositionData = [rpinky1.PositionData, temp];
end

rpinky2.name = 'rpinky2';
rpinky2.PositionData = [M(63,3);-M(63,1);M(63,2)];
for i = 1:(count-1)
    temp = [M(63+p*i,3);-M(63+p*i,1);M(63+p*i,2)];
    rpinky2.PositionData = [rpinky2.PositionData, temp];
end

rpinky3.name = 'rpinky3';
rpinky3.PositionData = [M(65,3);-M(65,1);M(65,2)];
for i = 1:(count-1)
    temp = [M(65+p*i,3);-M(65+p*i,1);M(65+p*i,2)];
    rpinky3.PositionData = [rpinky3.PositionData, temp];
end
%End of right Hand fingers




%Leap Motion Arms%
lwrist.name = 'lwrist';
lwrist.PositionData = [M(66,3);-M(66,1);M(66,2)];
for i = 1:(count-1)
    temp = [M(66+p*i,3);-M(66+p*i,1);M(66+p*i,2)];
    lwrist.PositionData = [lwrist.PositionData, temp];
end

rwrist.name = 'rwrist';
rwrist.PositionData = [M(69,3);-M(69,1);M(69,2)];
for i = 1:(count-1)
    temp = [M(69+p*i,3);-M(69+p*i,1);M(69+p*i,2)];
    rwrist.PositionData = [rwrist.PositionData, temp];
end

lright.name = 'lright';
lright.PositionData = [M(67,3);-M(67,1);M(67,2)];
for i = 1:(count-1)
    temp = [M(67+p*i,3);-M(67+p*i,1);M(67+p*i,2)];
    lright.PositionData = [lright.PositionData, temp];
end

rright.name = 'rright';
rright.PositionData = [M(70,3);-M(70,1);M(70,2)];
for i = 1:(count-1)
    temp = [M(70+p*i,3);-M(70+p*i,1);M(70+p*i,2)];
    rright.PositionData = [rright.PositionData, temp];
end

lelb.name = 'lelb';
lelb.PositionData = [M(68,3);-M(68,1);M(68,2)];
for i = 1:(count-1)
    temp = [M(68+p*i,3);-M(68+p*i,1);M(68+p*i,2)];
    lelb.PositionData = [lelb.PositionData, temp];
end

relb.name = 'relb';
relb.PositionData = [M(71,3);-M(71,1);M(71,2)];
for i = 1:(count-1)
    temp = [M(71+p*i,3);-M(71+p*i,1);M(71+p*i,2)];
    relb.PositionData = [relb.PositionData, temp];
end


%end of Leap Motion Arms
lpalm.name = 'lpalm';
lpalm.PositionData = [];

rpalm.name ='rpalm';
rpalm.PositionData = [];


segment = [ Base, Neck, Head, lshoulder, rshoulder, lelbow, relbow, lhand, rhand, lhip, rhip, lknee, rknee, lankle, rankle, ltoe, rtoe,  lthumb0, lthumb1, lthumb2, lthumb3, lindex0, lindex1, lindex2, lindex3, lmiddle0, lmiddle1, lmiddle2, lmiddle3, lring0, lring1, lring2, lring3, lpinky0, lpinky1, lpinky2, lpinky3, lwrist, rthumb0, rthumb1, rthumb2, rthumb3, rindex0, rindex1, rindex2, rindex3, rmiddle0, rmiddle1, rmiddle2, rmiddle3, rring0, rring1, rring2, rring3, rpinky0, rpinky1, rpinky2, rpinky3, rwrist, lpalm, rpalm, lwristk, rwristk, lelb, relb];

segment = AlignJoint(segment,count);


[data, TF] = RadarReturnsBodyFinger(segment,seglength, time,radarloc);



end