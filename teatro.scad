upright_dim=36;
crossbar=13*12;
teatro_width=8*12;
floor1=1*12;
floor2=9*12;
floor3=17*12;

module helios()
{
	color("red") rotate([0,0,0]) cylinder(r=6,h=15*12);
	color("green") rotate([0,12,0]) cylinder(r=6,h=15*12);
	color("blue") rotate([0,24,0]) cylinder(r=6,h=15*12);
}

module upright(len1,len2)
{
	translate([-3,-3,0]) cube([6,6,len1]);
	translate([upright_dim-3,-3,0]) cube([6,6,len2]);
	for(i=[1:(len2/36)])
	{
		translate([0,-3,35*i-6]) cube([upright_dim,6,6]);
	}
}

module ladder(len,width)
{
	translate([-1,-1,0]) cube([2,2,len]);
	translate([width-1,-1,0]) cube([2,2,len]);
	for(i=[1:(len/12)])
	{
		translate([0,-1,12*i-6]) cube([width,2,2]);
	}
}

module teatro()
{
translate([0,0*crossbar,0]) upright(21*12,21*12);
translate([12*8,0*crossbar,0]) rotate([0,0,180]) upright(21*12,21*12);

translate([0,1*crossbar,0]) upright(21*12,21*12);
translate([teatro_width,1*crossbar,0]) rotate([0,0,180]) upright(21*12,21*12);

translate([0,2*crossbar,0]) upright(21*12,21*12);
translate([teatro_width,2*crossbar,0]) rotate([0,0,180]) upright(21*12,21*12);

translate([0,0,floor1]) cube([teatro_width,2*crossbar,4]);
translate([0,0,floor2]) cube([teatro_width,2*crossbar,4]);
translate([0,0,floor3]) cube([teatro_width/2,2*crossbar,4]);
translate([teatro_width/2,48,floor3]) cube([teatro_width/2,2*crossbar-48,4]);
translate([teatro_width,0,floor3]) cube([6,2*crossbar,6]);

translate([0,0,21*12]) cube([6,2*crossbar,6]);
translate([teatro_width,0,21*12]) cube([6,2*crossbar,6]);

// rail up the backside of the top box
translate([teatro_width,0,floor2+24]) cube([6,2*crossbar,6]);
translate([teatro_width,0,floor2+48]) cube([6,2*crossbar,6]);
translate([teatro_width,0,floor2+72]) cube([6,2*crossbar,6]);

// ladder to the first level
translate([-teatro_width+40,0*crossbar,0])
rotate([0,0,90])
rotate([30,0,0])
ladder(10*12,24);

// ladder to the second level
translate([teatro_width-24-8,60,floor2])
rotate([30,0,0])
ladder(10*12,24);

translate([0,2*crossbar+12,(21-15)*12])
helios();

translate([teatro_width,2*crossbar+12,12+15*12])
rotate([0,180,0])
helios();
}


module sign()
{
translate([0,0*crossbar,0]) upright(17*12,14*12);
translate([0,1*crossbar,0]) upright(17*12,14*12);
translate([0,2*crossbar,0]) upright(17*12,14*12);
translate([0,3*crossbar,0]) upright(17*12,14*12);
translate([0,0,17*12-6]) cube([6,3*crossbar,6]);
translate([0,0,14*12-6]) cube([6,3*crossbar,6]);
translate([0,0,11*12-6]) cube([upright_dim,3*crossbar,6]);
}

rotate([0,0,180]) scale(.1)
{
translate([+3*crossbar/2+6,0,0])
rotate([0,0,-30])
teatro();

translate([-3*crossbar/2+6,0,0])
rotate([0,0,+30])
scale([-1,1,1])
teatro();

rotate([0,0,-90]) translate([0,-3*crossbar/2,0]) sign();
%translate([0,0*12,0]) cube([100*12,100*12,1], center=true);

color("green") translate([0,-20*12,0]) render() intersection() {
	sphere(r=12*18);
	translate([0,0,12*50/2]) cube([12*50,12*50,12*50], center=true);

}

}
