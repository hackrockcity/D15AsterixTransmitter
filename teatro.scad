upright_dim=36;
crossbar=13*12;
teatro_width=8*12;
floor1=1*12;
floor2=9*12;
floor3=17*12;

module helios()
{
	color("red") rotate([0,0,0]) cylinder(r=3,h=15*12);
	color("green") rotate([0,12,0]) cylinder(r=3,h=15*12);
	color("blue") rotate([0,24,0]) cylinder(r=3,h=15*12);
}

module upright(len1,len2)
{
	color("purple")
	{
	translate([-3,-3,0]) cube([6,6,len1]);
	translate([upright_dim-3,-3,0]) cube([6,6,len2]);
	for(i=[1:(len2/36)])
	{
		translate([0,-3,35*i-6]) cube([upright_dim,6,6]);
	}
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

module crossbar(x,y,z)
{
	//color("purple")
	translate([x,y+3,z-3]) cube([6,crossbar-6,6]);
}

module crossbar_pair(x,y,z)
{
	crossbar(x,y,z);
	crossbar(x+upright_dim,y,z);
}

module floor(x,y,z,w)
{
	color("green", 0.5)
	translate([x,y,z+6]) cube([w,crossbar,2]);
}

module teatro()
{
// back uprights are only partial
translate([0,0*crossbar,0]) upright(17*12,14*12);
translate([teatro_width,0*crossbar,0]) rotate([0,0,180]) upright(17*12,14*12);

// two front uprights are full
translate([0,1*crossbar,0]) upright(21*12,21*12);
translate([teatro_width,1*crossbar,0]) rotate([0,0,180]) upright(21*12,21*12);

translate([0,2*crossbar,0]) upright(21*12,21*12);
translate([teatro_width,2*crossbar,0]) rotate([0,0,180]) upright(21*12,21*12);

// first floor
for (box=[0,1])
{
	crossbar_pair(0,box*crossbar,floor1);
	crossbar_pair(1*teatro_width-upright_dim,box*crossbar,floor1);
	floor(0,box*crossbar,floor1, teatro_width);
}

// second floor with rail up the backside of the top box
for (box=[0,1])
{
	crossbar_pair(0,box*crossbar,floor2);
	crossbar_pair(1*teatro_width-upright_dim,box*crossbar,floor2);
	crossbar(teatro_width,box*crossbar,floor2+30);
	//crossbar(teatro_width,box*crossbar,floor2+48);
	crossbar(teatro_width,box*crossbar,floor2+60);
	floor(0,box*crossbar,floor2, teatro_width);
}


// the third floor only has the front half
for (box=[1])
{
	crossbar_pair(0,box*crossbar,floor3);
	crossbar_pair(1*teatro_width-upright_dim,box*crossbar,floor3);

	// railings to keep us from falling off
	crossbar(0,box*crossbar,21*12);
	crossbar(teatro_width,box*crossbar,21*12);

	floor(0,box*crossbar,floor3, teatro_width);
}


// cross bars on the other half are just for support
// and are not danceable
crossbar(0,0,floor3);
crossbar(teatro_width,0,floor3);

// tarp at an angle
color("red") polyhedron(
	points=[
		[0,0,21*12],
		[0,crossbar,21*12],
		[teatro_width,crossbar,21*12],
		[teatro_width,0,floor3],
		],
	faces=[
		[0,1,2],
		[2,0,3],
	]
);

// ladder to the first level
translate([-teatro_width+40,0*crossbar,0])
rotate([0,0,90])
rotate([30,0,0])
ladder(10*12,24);

// ladder to the second level
translate([teatro_width-24-8,90,floor2])
rotate([30,0,180])
ladder(10*12,24);

translate([0,2*crossbar+12,(21-15)*12])
helios();

translate([teatro_width,2*crossbar+12,12+15*12])
rotate([0,180,0])
helios();
}


module sign()
{
translate([0,0*crossbar,0]) upright(21*12,21*12);
translate([0,1*crossbar,0]) upright(21*12,21*12);
translate([0,2*crossbar,0]) upright(21*12,21*12);
translate([0,3*crossbar,0]) upright(21*12,21*12);

translate([teatro_width,0*crossbar,0]) rotate([0,0,180]) upright(17*12,14*12);
translate([teatro_width,1*crossbar,0]) rotate([0,0,180]) upright(17*12,14*12);
translate([teatro_width,2*crossbar,0]) rotate([0,0,180]) upright(17*12,14*12);
translate([teatro_width,3*crossbar,0]) rotate([0,0,180]) upright(17*12,14*12);

// solid floor across the mid level
for (box=[0,1,2])
{
	crossbar_pair(0,box*crossbar,floor2);
	crossbar_pair(1*teatro_width-upright_dim,box*crossbar,floor2);

	// safety rails
	crossbar(0,box*crossbar,floor2+36);
	crossbar(teatro_width,box*crossbar,floor2+36);

	// sign and tarp support
	crossbar(0,box*crossbar,floor3);
	crossbar(teatro_width,box*crossbar,floor3);

	// sign work platform is only half deep
	floor(0,box*crossbar, floor3, upright_dim);

	// the sign top mount
	crossbar(0,box*crossbar,21*12);

	floor(0,box*crossbar,floor2, teatro_width);
}

// sign itself
color("DeepPink", 0.9)
translate([0,39*12,floor3-20])
scale(0.6)
rotate([90,0,-90])
linear_extrude(height=5)
import("disorient.dxf");

// half tarp, half floor
color("red")
translate([upright_dim+6,0,floor3])
cube([teatro_width-upright_dim-6,3*crossbar,6]);


}


// put it all together...

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

// put the dome in the background, cut in half by the ground
color("green") translate([0,-30*12,0]) render() difference() {
	sphere(r=12*18);
	sphere(r=11.5*18);
	translate([0,0,-12*50/2]) cube([12*50,12*50,12*50], center=true);
	translate([0,18*12,0]) sphere(r=12*18);

}

}

