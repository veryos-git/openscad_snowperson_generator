/**
* snowperson generator
*
* Sourcecode: git@github.com:veryos-git/openscad_size_reference_objects.git
* Author: veryos  
* Version: 1.0
*
* Description:
* This OpenSCAD script generates a 3d object that is a size reference.
*
* License:
*    Licensed under the GNU General Public License v3.0 or later.
*    See the LICENSE.txt file in the repository root for details.
*
* Opensource credits:
* - openscad 'language': https://openscad.org/ 
* - online openscad playground: https://ochafik.com/openscad2
* - free image editor : https://rawtherapee.com/
* - free source code hosting: https://github.com/
* - online photo collage: https://pixlr.com/photo-collage/
* - thumbnail designer: https://tools.datmt.com/tools/thumb-maker
* - perlin noise js generator: https://raw.githubusercontent.com/josephg/noisejs/refs/heads/master/perlin.js
* - https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-sphere
* Changelog:
* [v1.0] Initial release
*/


//wont work in makerworld
//include <BOSL/constants.scad>
//use <BOSL/shapes.scad>

//using BOSL2 for makerworld compatibility
include <BOSL2/std.scad>
/* [balls 🏐] */
dia_ball1 = 30; 
dia_ball2 = 18; 
dia_ball3 = 11;
/* [ball distance ↕️] */
dist_ball2 = 3;
dist_ball3 = 5; 

r1 = dia_ball1/2;
r2 = dia_ball2/2;
r3 = dia_ball3/2;

bottom_cut_y_offset = 0;

/* [left arm 💪] */
left_arm_thickness = 2; 
left_arm_length = 20;
left_arm_finger_count = 5;
left_arm_finger_length = 5;
left_arm_finger_thickness = 1;
left_arm_x_offset = 0;
left_arm_y_offset = -5;
left_arm_rotation = 45;

/* [right arm 💪] */
right_arm_thickness = 2; 
right_arm_length = 20;
right_arm_finger_count = 5;
right_arm_finger_length = 5;
right_arm_finger_thickness = 1;
right_arm_x_offset = 0;
right_arm_y_offset = -5;
right_arm_rotation = -45;

/* [buttons 🔘] */
button_count = 5; 
button_size = 1.4; 

/* [eyes 👀] */
left_eye_size = 0.8;
right_eye_size = 0.8;
left_eye_x_offset = 0.3; // relative to center
left_eye_y_offset = 0.3;
right_eye_x_offset = -0.3; // relative to center
right_eye_y_offset = 0.3;

/* [gender 🚻] */
gender = "female"; // [male, female]
breast_size = 3.5;
breast_x_offset = 0.2;
breast_y_offset = 0.2;

/* [nose 👃] */
nose_radius_back = 1.0; 
nose_radius_front = 0.2;
nose_length = 5;
nose_y_offset = 0.1;

$fn = 100;

function rtclr(seed) = [
    rands(0,1,1,seed+234.2)[0],
    rands(0,1,1,seed+123443.23)[0],
    rands(0,1,1,seed+545.23)[0],
    0.6
];

module cylindercapped(
    h = 10, 
    r1 = 5, 
    r2 = 5
){
    let(
        h2 = h - r1*2
    ){
        translate([0,0,r1])
        union(){
            cylinder(h=h2, r1=r1, r2=r2);
            translate([0,0,h2])
            difference(){
                sphere(r=r2);
                translate([0,0,-(r2*2)/2])
                cuboid([r2*2,r2*2,r2*2]);
            }
            difference(){
                sphere(r=r1);
                translate([0,0,(r1*2)/2])
                cuboid([r1*2,r1*2,r1*2]);
            }
        }
    }
}


module ahp(
    length = 100
){

    color([1,0,0,0.2])
    cuboid([length,length, 0.2]);
    color([1,0,0,0.4])
    cuboid([length,2, 0.2]);
    rotate([90,0,0])
    color([0,1,0,0.2])
    cuboid([length,length, 0.2]);
    color([0,1,0,0.4])
    cuboid([length,2, 0.2]);
    rotate([0,90,0])
    color([0,0,1,0.2])
    cuboid([length,length, 0.2]);
    color([0,0,1,0.4])
    cuboid([length,2, 0.2]);
}


module arm(
    length = 5, 
    thick = 2, 
    fingers = 5, 
    fingerlength = 3,
    fingerthick = 1, 
){
    cylindercapped(h=length, r1=thick/2+(thick*0.5), r2=thick/2);
    translate([0,0,length-thick])

    for(i=[0:fingers-1]){
        let(
            inor = i/fingers
        ){
            rotate([0,45-inor*120,0])
            cylindercapped(h=fingerlength/2, r1=thick/4, r2=thick/4);
        }
    }
    
}
module ballbuttons(
    buttons = 3, 
    size = 2, 
    radius = 10
){
    for (i=[0:buttons-1]){ 
        let(
            inor = i/buttons, 
            spreadangle = 90
        ){
            rotate([(90-spreadangle/2)+inor*spreadangle,0,0])
            translate([0,0,radius])
            sphere(size);
        }
    }
}

module ballonsphere(
    radius=10, 
    size= 2,
    xoffsetnor= 0.2,
    yoffsetnor= 0.2 
){
    rotate([90-yoffsetnor*90,0,xoffsetnor*90])
    translate([0,0,radius])
    sphere(size);
}

module snowperson(){

    // ball 1------------------------------------------------
    color(rtclr(1))
    sphere(r1);
    ballbuttons(button_count, button_size, r1);

    // ball 2 ------------------------------------------------
    translate([0, 0, r1+dist_ball2])
    color(rtclr(2))
    sphere(r2);
    //arm right
    translate([0,0,r1+dist_ball2+left_arm_x_offset+left_arm_y_offset])
    rotate([0,left_arm_rotation,0])
    arm(left_arm_length, left_arm_thickness, left_arm_finger_count, left_arm_finger_length, left_arm_finger_thickness);
    // arm left
    translate([0,0,r1+dist_ball2+right_arm_x_offset+right_arm_y_offset])
    rotate([0, right_arm_rotation,0])
    arm(right_arm_length, right_arm_thickness, right_arm_finger_count, right_arm_finger_length, right_arm_finger_thickness);

    if(gender == "female"){
        // add boobs 
        translate([0,0,r1+dist_ball2])
        ballonsphere(r2-(r2*0.2), breast_size, breast_x_offset, breast_y_offset);
        translate([0,0,r1+dist_ball2])
        ballonsphere(r2-(r2*0.2), breast_size, -breast_x_offset, breast_y_offset);

    }
    // ball 3------------------------------------------------
    translate([0, 0, r1+r2+dist_ball3])
    color(rtclr(3))
    sphere(r3);
    //eyes
    translate([0, 0, r1+r2+dist_ball3])
    ballonsphere(r3, left_eye_size, left_eye_x_offset, left_eye_y_offset);
    translate([0, 0, r1+r2+dist_ball3])
    ballonsphere(r3, right_eye_size, right_eye_x_offset, right_eye_y_offset);
    //nose
    translate([0, -r3+nose_radius_back, r1+r2+dist_ball3])
    rotate([90-nose_y_offset*90,0,0])
    cylindercapped(h=nose_length, r1=nose_radius_back, r2=nose_radius_front);
}

module snowperson_basecut(){
    difference(){
        snowperson();

        let(
            sl=r1*2, 
            bottom_cut = 5
        ){

            translate([0,0,-sl+bottom_cut+bottom_cut_y_offset])
            cuboid([sl,sl,sl]);
        }
    }
}

snowperson_basecut();

// arm();

// cylindercapped(h=20, r1=5, r2
// ahp(100);
