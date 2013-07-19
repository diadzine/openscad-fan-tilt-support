$fn = 50;
print = 0;
thickness = 3;
fan_width = 92;

bracket_width = 30;
bracket_height = 15;
bracket_depth = 30;

screw_head_size = 5;
screw_head_thickness = 3;


module bracket() {
	cube([bracket_width, thickness, bracket_height]);
	translate([0, bracket_depth + thickness, 0]) cube([bracket_width, thickness, bracket_height]);
	translate([0, 0, bracket_height]) cube([bracket_width, bracket_depth + 2*thickness, screw_head_thickness + thickness]);	
}


if (print == 1) {
	rotate([0, -90, 0]) bracket();
} else if (print == 1) {
	rotate([0, -90, 0]) bracket();
} else {
	// Brackets
	bracket();
	translate([fan_width + bracket_width, 0, 0]) bracket();

	// Tilt support

	// Fan corners supports

}