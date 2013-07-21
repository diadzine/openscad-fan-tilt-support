$fn = 50;
print = 3;
thickness = 3;
fan_width = 92;
fan_depth = 30;
fan_hole_distance = 6;
fan_hole_size = 3;

bracket_width = 30;
bracket_height = 15;
bracket_depth = 30;

screw_hole_size = 3;
screw_head_size = 5;
screw_head_thickness = 4;

// Computation
tilt_height = fan_width/2 + thickness;
tilt_half_depth = fan_depth/2 + thickness;
hypotenuse = sqrt(pow(tilt_height, 2) + pow(tilt_half_depth, 2));

tilt_support_width = fan_width + 2*screw_head_thickness + 4*thickness;
tilt_support_height = ceil(hypotenuse) + 2*thickness + bracket_depth/2;

corner_support_height = fan_width/2 + thickness;
corner_support_depth = fan_depth + 2*thickness;
corner_support_width = 2*fan_hole_distance + screw_head_thickness + thickness;



module bracket() {
	// Front vertical support
	cube([bracket_width, thickness, bracket_height]);

	// Back vertical support
	translate([0, bracket_depth + thickness, 0]) cube([bracket_width, thickness, bracket_height]);
	
	// Horizontal support + screw hole
	difference () {
		translate([0, 0, bracket_height]) cube([bracket_width, bracket_depth + 2*thickness, screw_head_thickness + thickness]);	
		translate([bracket_width/2, bracket_depth/2 + thickness, bracket_height + screw_head_thickness]) cylinder(r=screw_hole_size/2, h=thickness);
		translate([bracket_width/2, bracket_depth/2 + thickness, bracket_height]) cylinder(r=screw_head_size/2, h=screw_head_thickness);
	}
}

module tilt_support() {
	// Horizontal support + screw holes
	difference() {
		cube([tilt_support_width, bracket_depth, thickness]);
		translate([bracket_width/2, bracket_depth/2, 0]) cylinder(r=screw_hole_size/2, h=thickness);
		translate([tilt_support_width-bracket_width/2, bracket_depth/2, 0]) cylinder(r=screw_hole_size/2, h=thickness);
	}

	// Left vertical support + screw hole
	difference() {
		translate([0, 0, thickness]) cube([thickness, bracket_depth, tilt_support_height-thickness]);
		translate([-thickness, bracket_depth/2, tilt_support_height-bracket_depth/2]) rotate([0, 90, 0]) cylinder(r=screw_hole_size/2, h=3*thickness);
	}

	// Right vertical support + screw hole
	difference() {
		translate([tilt_support_width - thickness, 0, thickness]) cube([thickness, bracket_depth, tilt_support_height-thickness]);
		translate([tilt_support_width - 2*thickness, bracket_depth/2, tilt_support_height-bracket_depth/2]) rotate([0, 90, 0]) cylinder(r=screw_hole_size/2, h=3*thickness);
	}
}

module corner_support() {
	union() {
		// Side vertical support + screw hole
		difference() {
			translate([0, thickness, 0]) cube([thickness, corner_support_depth-2*thickness, corner_support_height]);
			translate([-thickness, corner_support_depth/2, corner_support_height-bracket_depth/2]) rotate([0, 90, 0]) cylinder(r=screw_hole_size/2, h=3*thickness);
		}

		// Bottom horizontal support
		cube([corner_support_width, corner_support_depth, thickness]);

		// Front vertical support + screw hole
		difference() {
			translate([0, 0, thickness]) cube([corner_support_width, thickness, corner_support_width-screw_head_thickness]);
			translate([thickness + screw_head_thickness + fan_hole_distance, -thickness, thickness + fan_hole_distance]) rotate([-90, 0, 0]) cylinder(r=fan_hole_size/2, h=3*thickness);
		}

		// Back vertical support + screw hole
		difference() {
			translate([0, corner_support_depth-thickness, thickness]) cube([corner_support_width, thickness, corner_support_width-screw_head_thickness]);
			translate([thickness + screw_head_thickness + fan_hole_distance, corner_support_depth-2*thickness, thickness + fan_hole_distance]) rotate([-90, 0, 0]) cylinder(r=fan_hole_size/2, h=3*thickness);
		}
	}
}


if (print == 1) {
	rotate([0, -90, 0]) bracket();
} else if (print == 2) {
	tilt_support();
} else if (print == 3) {
	rotate([0, -90, 0]) corner_support();
} else {
	// Brackets
	bracket();
	translate([tilt_support_width - bracket_width, 0, 0]) bracket();

	// Tilt support
	translate([0, thickness, bracket_height + screw_head_thickness + thickness]) tilt_support();

	// Fan corners supports
	translate([thickness, bracket_depth/2 + thickness - corner_support_depth/2, bracket_height + screw_head_thickness + thickness + tilt_support_height - corner_support_height]) corner_support();
	translate([tilt_support_width-thickness, bracket_depth + 2*thickness, bracket_height + screw_head_thickness + thickness + tilt_support_height - corner_support_height]) rotate([0, 0, 180]) corner_support();
}