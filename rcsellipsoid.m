function rcs = rcsellipsoid(a,b,c,phi,theta)
rcs = (pi*a^2*b^2*c^2)/(a^2*(sin(theta))^2*(cos(phi))^2+b^2*(sin(theta))^2*(sin(phi))^2+c^2*(cos(theta))^2)^2;