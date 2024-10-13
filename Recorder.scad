

// Finger Position: [[OFFSET, ANGLE, CLIP]]
// OFFSET: Distance from the start of the recorder segment (without the mouthpiece) to the center of the finger hole
// ANGLE: The rotation amount from the top of the recorder
// CLIP: The portion of the hole to cover up
FINGER_POSITION = [
    [15, 180, 0],    // 0: Left thumb
    [20, 0, 0],      // 1: Left index
    [41.5, 0, 0],    // 2: Left middle
    [62, 0, 0],      // 3: Left ring
    [91, 0, 0],      // 4: Right index
    [97, 180, 0],    // -: Right thump
    [111.5, 0, 0],   // 5: Right middle
    [134.5, 0, 7],   // 6a: Right ring
    [134.5, 18, -7], // 6b: Right ring
    [161, 22, 7],    // 7a: Right pinky
    [161, 40, -7],   // 7b: Right pinky
];

TOLLERANCE = 0.5;
SHAFT_RADIUS = 12.5;
SHAFT_DUCT_RADIUS = 10.5;
SHAFT_LENGTH = 230;
EMBOUCHURE_LENGTH = 111;
MOUTHPIECE_LENGTH = 17.5;
MOUTHPIECE_DEPTH = 60;
EMBOUCHURE_RADIUS = SHAFT_RADIUS + 2;
CONNECTION_LENGTH = 20;

FINGER_DIAMETER = 11;
STEM_DIAMETER = 2;
STEM_DEPTH = SHAFT_RADIUS;
DOME_HEIGHT = 2;
SEMI_DOME = 6;
SCREW_HOLE_DIAMETER = 2.5;

MRP121 = [20, 34, 5];
MPRLS = [18.5, 16.7, 2];
PICO = [21, 51, 3];
USB_RADIUS = 6;

translate([0, EMBOUCHURE_LENGTH - MRP121[1], 0])
mrp121();

translate([-MPRLS[0]/2, MOUTHPIECE_DEPTH, -MPRLS[1]/2])
rotate([90, 0, 0])
mprls();

translate([0, EMBOUCHURE_LENGTH + SHAFT_LENGTH - PICO[1], 0])
pico();
translate([0, EMBOUCHURE_LENGTH, 0])
color("red", alpha=0.25)
!body();

//difference(){
color("green", alpha=0.5)
embouchure();
//translate([0, 0, 0])
//cube([1000, 1000, 1000]);
//}


translate([0, EMBOUCHURE_LENGTH + SHAFT_LENGTH, 0])
endcap();

module embouchure() {
    difference() {
        translate([0, 25, 0])
        scale([1, 2, 1])
        sphere(1.25 * SHAFT_RADIUS);
        
        translate([0, -50, 0])
        cube([100, 100, 100], center=true);
        
        translate([0, 0, -MOUTHPIECE_LENGTH])
        rotate([0, 90, 0])
        cylinder(h=100, d=40, center=true);
        
        translate([0, MOUTHPIECE_LENGTH, 0])
        rotate([-90, 0, 0])
        cylinder(h=EMBOUCHURE_LENGTH, r=SCREW_HOLE_DIAMETER + TOLLERANCE);
        
        translate([-5, -0.001, 4])
        cube([10, 30, 3]);

        translate([-5, 15, 2])
        cube([10, 15, 3]);
    }
    
    difference() {
        translate([0, 30, 0])
        rotate([-90, 0, 0])
        cylinder(h=EMBOUCHURE_LENGTH - CONNECTION_LENGTH - MOUTHPIECE_LENGTH, r=EMBOUCHURE_RADIUS);
        
        translate([0, MOUTHPIECE_DEPTH - 4, 0])
        rotate([-90, 0, 0])
        cylinder(h=EMBOUCHURE_LENGTH, r=SHAFT_RADIUS + TOLLERANCE);
        
        rotate([-90, 0, 0])
        cylinder(h=EMBOUCHURE_LENGTH, r=SCREW_HOLE_DIAMETER + TOLLERANCE);
    }
}

module body() {
    difference() {
        translate([0, -CONNECTION_LENGTH, 0])
        rotate([-90, 0, 0])
        cylinder(h=SHAFT_LENGTH + CONNECTION_LENGTH, r=SHAFT_RADIUS);
        
        for (finger_pos = FINGER_POSITION) {
            distance = finger_pos[0];
            angle = finger_pos[1];
            clip = finger_pos[2];
            
            rotate([0, angle, 0])
            translate([0, distance, SHAFT_RADIUS])
            fingerHole(clip);
        }
            
        difference() {
            BODY_LENGTH = SHAFT_LENGTH + CONNECTION_LENGTH + 2;
            rotate([-90, 0, 0])
            translate([0, 0, -CONNECTION_LENGTH-1])
            cylinder(h=BODY_LENGTH, r=SHAFT_DUCT_RADIUS);
            
            // top
            translate([-25, 0, SHAFT_DUCT_RADIUS - 2])
            cube([50, BODY_LENGTH, 50]);
            
            // bottom
            translate([-25, 0, 2-SHAFT_DUCT_RADIUS-50])
            cube([50, BODY_LENGTH, 50]);
            
            rotate([0, 35, 0])
            translate([-25, 110, SHAFT_DUCT_RADIUS - 2])
            cube([50, 70, 50]);
        }
    }
}

module endcap() {
    rotate([-90, 0, 0])
    difference() {
        cylinder(h=STEM_DEPTH, r=EMBOUCHURE_RADIUS);
        translate([0, 0, -2])
        cylinder(h=STEM_DEPTH, r=SHAFT_RADIUS + TOLLERANCE);
        cylinder(h=STEM_DEPTH, r=USB_RADIUS);
    }
}

module fingerHole(clip = 0) {
    scale([1, 1, -1]) {
        difference() {
            cylinder(h=DOME_HEIGHT, d=FINGER_DIAMETER);
            if (clip != 0) {
                translate([clip, 0, 0])
                cube(FINGER_DIAMETER, center=true);
            }
        }
        cylinder(h=STEM_DEPTH, d=STEM_DIAMETER, $fn=10);
    }
}

module mrp121() {    
    translate([-MRP121[0]/2, 0, -1]) {
        color("green")
        difference() {
            cube([MRP121[0], MRP121[1], 2]);
            
            translate([2.5, 2.5, -1])
            cylinder(h=4, d=SCREW_HOLE_DIAMETER, $fn=10);
            
            translate([2.5, MRP121[1] - 2.5, -1])
            cylinder(h=4, d=SCREW_HOLE_DIAMETER, $fn=10);
        }
        
        STEMMA = [6.5, 4.5, 3];
        color("white")
        translate([MRP121[0]/2 - STEMMA[0]/2, 0, 2])
        cube(STEMMA);
        
        color("white")
        translate([MRP121[0]/2 - STEMMA[0]/2, MRP121[1] - STEMMA[1], 2])
        cube(STEMMA);
    }    
}

module mprls() {    
    color("green")
    difference() {
        cube(MPRLS);
        
        translate([2.5, 2.5, -1])
        cylinder(h=4, d=SCREW_HOLE_DIAMETER, $fn=10);
        
        translate([2.5, MPRLS[1] - 2.5, -1])
        cylinder(h=4, d=SCREW_HOLE_DIAMETER, $fn=10);
    }
    
    color("silver")
    translate([MPRLS[0]/2, MPRLS[1]/2, 0])
    cylinder(h=7.5, d=SCREW_HOLE_DIAMETER, $fn=10);
}

module pico() {    
    translate([-PICO[0]/2, 0, -1]) {
        color("green")
        difference() {
            cube([PICO[0], PICO[1], 2]);
            
            translate([5, 2.5, -1])
            cylinder(h=4, d=SCREW_HOLE_DIAMETER, $fn=10);
            
            translate([5, PICO[1] - 2.5, -1])
            cylinder(h=4, d=SCREW_HOLE_DIAMETER, $fn=10);            
            translate([PICO[0] - 5, 2.5, -1])
            cylinder(h=4, d=SCREW_HOLE_DIAMETER, $fn=10);
            
            translate([PICO[0] - 5, PICO[1] - 2.5, -1])
            cylinder(h=4, d=SCREW_HOLE_DIAMETER, $fn=10);
        }
        
        USB = [6.5, 4.5, 3];
        color("white")
        translate([PICO[0]/2 - USB[0]/2, PICO[1] - USB[1], 2])
        cube(USB);
    }
}