function [PHs] = RadarReturns(radarloc, target, endjoint, len, lambda, a,b,k ) 

 % distance from radar to left palm
 r_dist(:,k) = abs(target(:,k)-radarloc(:));
 distances(k) = sqrt(r_dist(1,k).^2+r_dist(2,k).^2+r_dist(3,k).^2);
 % aspect vector of the right foot
 aspct(:,k) = endjoint(:,k)-target(:,k);
 % calculate theta angle
 A = [radarloc(1)-target(1,k); radarloc(2)-target(2,k);...
 radarloc(3)-target(3,k)];
 B = [aspct(1,k); aspct(2,k); aspct(3,k)];
 A_dot_B = dot(A,B,1);
 A_sum_sqrt = sqrt(sum(A.*A,1));
 B_sum_sqrt = sqrt(sum(B.*B,1));
 ThetaAngle(k) = acos(A_dot_B ./ (A_sum_sqrt .* B_sum_sqrt));
 PhiAngle(k) = asin((radarloc(2)-target(2,k))./...
 sqrt(r_dist(1,k).^2+r_dist(2,k).^2));

 c = len/2;
 rcs(k) = rcsellipsoid(a,b,c,PhiAngle(k),ThetaAngle(k));
 amp(k) = sqrt(rcs(k));
 PHs = amp(k)*(exp(-j*4*pi*distances(k)/lambda));
 
end