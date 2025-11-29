/**
 * Mandala Generator
 *
 * Sourcecode: git@github-veryos:veryos-git/openscad_stargen_v3.git
 * Author: veryos  
 * Version: 1.0
 *
 * Description:
 * This OpenSCAD script generates a 3d object that is ornamental mandala like.
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
 * 
 * Changelog:
 * [v1.0] Initial release
 */


//change this number to get a different random pattern
model_variation = 28.9; // [0:0.1:100]
objects_to_generate = 9; // [1,4,9,16,25]
// will randomize all models , disables some parameters!
fully_random = true; // [true,false]


/* [Advanced] */
diameter = 80; // [10:400]
mandala_radius = diameter/2;
corners = 5; // [3:12]
s = model_variation;

// how far one sector is translated from the center
center_translation_factor = 0; // [-1:0.01:0]
center_translation_factor_ = fully_random ? rands(-1,0.0,1, s+3)[0] : center_translation_factor;
center_translation = mandala_radius * center_translation_factor_;
radiusfactor = 0.7; // [0:0.05:2]
anglefactor = 0.5; // [0:0.01:1]
layers = 4;
randomfactor = 0.5; // [0:0.01:1]
module mandala(seed_offset=0) {

    s = model_variation + seed_offset;
    corners_ = fully_random ? floor(rands(3,9,1, s)[0]) : corners;




    max_rand_angle = 360/corners_;
    layerheight = 0.12; // [0.08,0.12,0.16,0.2]
    seed = s;


    p1_angle = 360/corners_;


    // how far away the trough is away from the center
    radiusfactor_ = fully_random ? rands(0.2,1,1, s+111)[0] : radiusfactor;
    // how far away the trough is rotated towards the next corner
    anglefactor_ = fully_random ? rands(0.2,0.5,1, s+222)[0] : anglefactor;

    pa = [0, 0];
    pb = [0, mandala_radius];
    p1 = [mandala_radius * sin(p1_angle), mandala_radius * cos(p1_angle)];
    p1_angle_2 = atan2(p1[0], p1[1]);
    // the middle point between pb and p1 
    p2 = pb + anglefactor_ * (p1-pb);
    lengthp2 = norm(p2);
    newradiusfactor = radiusfactor_* lengthp2;
    p3angle = atan2(p2[0], p2[1]);
    p3 = [newradiusfactor * sin(p3angle), newradiusfactor * cos(p3angle)];

    rv = pb-p3; 

    rvap3 = p3 - pa;

    points = [pa, pb, p3];
    faces = [[0,1,2]];

    sector_basis_scl_z = layerheight;
    
    layers_ = fully_random ? rands(2,9,1, s+111)[0] : layers; 

    sector_max_scl_z = layerheight*layers_;
    // how much a point is not linear distributed towards the mandala radius
    

    hole_at_corners = true; // [true,false]





    module randompolygons(seed_offset=0){
        s = seed+seed_offset;
        let(
            lenrpA = layers_, 
            lenrpB = ceil(layers_/2),
            lenrpC = floor(layers_/2)
        ){

            rpA = [
                for(i = [0:lenrpA-1]) 
                    let(
                        rand = rands(0, 1, 1, s+i+23.23)[0], 
                        dist_linear = mandala_radius / lenrpA
                    )
                        [0, i * dist_linear + dist_linear * rand*radiusfactor_],
                    
            ];
            rpB = [
                for(i = [0:lenrpB-1]) 
                    let(
                        rand = rands(0, 1, 1, s+i+34.34)[0],
                        tp = 1/lenrpB ,
                        t = i*tp + tp * rand * radiusfactor_

                    )
                        pa + [
                            t*rvap3[0],
                            t*rvap3[1],
                        ],
                    
            ];
            
            rpC = [
                for(i = [0:lenrpC-1]) 
                    let(
                        rand = rands(0, 1, 1, s+i+45.45)[0],
                        tp = (1/lenrpC),
                        t = i*tp + tp * rand * radiusfactor_,

                    )
                        echo("t")
                        echo(t)
                        p3+[
                            t*rv[0],
                            t*rv[1],
                        ]
                    
            ];

            rpN = concat(rpB, rpC);
            
            for(i = [0:layers_-1]) {
                let(
                    dist_linear = mandala_radius / layers_,
                    p_now = rpA[i],
                    p_before = (i == 0) ? [0,0] : rpA[i-1],
                    points3 = [
                        p_before, 
                        p_now, 
                        rpN[i]
                    ],
                    faces2 = [[0,1,2]], 
                    scl_z = rands(0, sector_max_scl_z, 1, s+i+77.44)[0]
                )
                // rainbow color 
                color([rands(0,1,1,s+i+456)[0], rands(0,1,1,s+i+789)[0], rands(0,1,1,s+i+101112)[0]])
                linear_extrude(height = scl_z)
                    polygon(points = points3, paths = faces2);
            }
        }


    }

    module sector_half_intersector() {
        linear_extrude(height = sector_basis_scl_z*20)
            polygon(points = points, paths = faces);
    }

    module sector_half_positive(seed_offset=0) {
        union(){
            randompolygons(seed_offset);
            intersection(){
                linear_extrude(height = sector_basis_scl_z)
                polygon(points = points, paths = faces);
                sector_half_intersector();
            }
        }
    }
    module sector_with_hole(seed_offset=0) {
        let(
            downscalefactor = 0.2
        ){
            difference(){
                sector_half_positive(seed_offset);
                translate([0, mandala_radius-mandala_radius*downscalefactor*2, 0])
                scale([downscalefactor,downscalefactor, 222])
                sector_half_intersector();
            }
        }
    }
    module sector_if(seed_offset=0){
        if (hole_at_corners) {
            sector_with_hole(seed_offset);
        } else {
            sector_half_positive(seed_offset);
        }
    }
    module sector(seed_offset=0) {
        union() {
            sector_if(seed_offset);
            mirror([1, 0, 0])
                sector_if(seed_offset);
        }
    }



    for(i = [0:corners_-1]) {
        rotate([0, 0, i * 360/corners_])
            translate([0, center_translation, 0])
            sector(seed_offset);
    }
}




module mandalas() {
    spacing = diameter*1.01;
    rows = sqrt(objects_to_generate);
    cols = sqrt(objects_to_generate);
    
    translate([-spacing*(cols-1)/2, -spacing*(rows-1)/2, 0])
    for(x = [0:cols-1]){
        for(y = [0:rows-1]){
            translate([x*spacing, y*spacing, 0])
                let(
                    seed_offset_unique = (x*rows + y)*10
                )
                mandala(seed_offset_unique);
        }
    }
}

// sector_half_positive();
// randompolygons(0);
// mandala();
mandalas();
