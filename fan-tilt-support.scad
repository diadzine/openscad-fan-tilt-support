$fn = 50;
print = 2;
thickness = 3;
fan_width = 92;
fan_depth = 30;

bracket_width = 30;
bracket_height = 15;
bracket_depth = 30;

screw_hole_size = 3;
screw_head_size = 5;
screw_head_thickness = 4;


module bracket() {
	cube([bracket_width, thickness, bracket_height]);
	translate([0, bracket_depth + thickness, 0]) cube([bracket_width, thickness, bracket_height]);
	difference () {
		translate([0, 0, bracket_height]) cube([bracket_width, bracket_depth + 2*thickness, screw_head_thickness + thickness]);	
		translate([bracket_width/2, bracket_depth/2 + thickness, bracket_height + screw_head_thickness]) cylinder(r=screw_hole_size/2, h=thickness);
		translate([bracket_width/2, bracket_depth/2 + thickness, bracket_height]) cylinder(r=screw_head_size/2, h=screw_head_thickness);
	}
}

module tilt_support() {
	tilt_height = fan_width/2 + thickness;
	tilt_half_depth = fan_depth/2 + thickness;
	hypotenuse = sqrt(pow(tilt_height, 2) + pow(tilt_half_depth, 2));
	
	width = fan_width + 2*screw_head_thickness + 4*thickness + 2*bracket_width;
	height = ceil(hypotenuse) + 2*thickness + bracket_depth/2;

	difference() {
		cube([width, bracket_depth, thickness]);
		translate([bracket_width/2, bracket_depth/2, 0]) cylinder(r=screw_hole_size/2, h=thickness);
		translate([width-bracket_width/2, bracket_depth/2, 0]) cylinder(r=screw_hole_size/2, h=thickness);
	}
	difference() {
		translate([bracket_width, 0, thickness]) cube([thickness, bracket_depth, height-thickness]);
		translate([bracket_width-thickness, bracket_depth/2, height-bracket_depth/2]) rotate([0, 90, 0]) cylinder(r=screw_hole_size/2, h=3*thickness);
	}
	//difference() {
		translate([width - bracket_width, 0, thickness]) cube([thickness, bracket_depth, height-thickness]);
		//translate([width - bracket_width - thickness, bracket_depth/2, height-bracket_depth/2]) rotate([0, 90, 0]) cylinder(r=screw_hole_size/2, h=thickness);
	//}
}


if (print == 1) {
	rotate([0, -90, 0]) bracket();
} else if (print == 2) {
	tilt_support();
} else if (print == 3) {
} else {
	// Brackets
	bracket();
	translate([fan_width + 2*screw_head_thickness + 4*thickness + bracket_width, 0, 0]) bracket();

	// Tilt support
	translate([0, thickness, bracket_height + screw_head_thickness + thickness]) tilt_support();

	// Fan corners supports

}