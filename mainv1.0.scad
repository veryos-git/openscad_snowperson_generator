/**
 * Mandala Generator
 *
 * Sourcecode: git@github.com:veryos-git/openscad_mandala.git
 * Author: veryos  
 * Version: 1.0
 *
 * Description:
 * This OpenSCAD script generates a mandala with different extrusion heights 
 * 3D printed and backlit this object creates a nice lithophane effect
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
 * 
 * Changelog:
 * [v1.0] Initial release
 */





//change this number to get a different random pattern
model_variation = 23.4; // [0:0.1:100]
objects_to_generate = 4; // [4,9,16,25]

/* [Advanced] */
diameter = 130; // [10:400]
mandala_radius = diameter/2;
corners = 5; // [3:12]
max_rand_angle = 360/corners;
layerheight = 0.2; // [0.08,0.12,0.16,0.2]
seed = model_variation;

// Distance from center to a 'leaf' of the mandala
center_translation = -5; // [-100:0]

angle1_max = 360/corners;
anglefactor = 0.7; // [0:0.05:2]
p2_angle = angle1_max / 2 * anglefactor;

radiusfactor = 0.5; // [0:0.05:2]
p2_radius = mandala_radius * radiusfactor;

p2x = p2_radius * sin(p2_angle);
p2y = p2_radius * cos(p2_angle);

p1 = [0,0];
p2 = [p2x, p2y];
p3 = [0,mandala_radius];
points = [p1, p2, p3];
faces = [[0,1,2]];

sector_basis_scl_z = layerheight;
sector_max_scl_z = layerheight*10;
randompoints = 6; 
randomfactor = 0.5; // [0:0.01:1]





module randompolygons(seed_offset=0){
    s = seed+seed_offset;
    rand_nor = [
        for(i = [0:randompoints-1]) 
            rands(0, 1, 1, s+i)[0]
    ];
    
    for(i = [0:randompoints-1]) {
        let(
            dist_linear = mandala_radius / randompoints,
            p_now = [0, i * dist_linear + dist_linear * rand_nor[i]*randomfactor],
            p_before = (i == 0) ? [0,0] : [0, (i-1) * dist_linear + dist_linear * rand_nor[i-1]],
            points3 = [
                p_before, 
                p_now, 
                p2
            ],
            faces2 = [[0,1,2]], 
            scl_z = rands(0, sector_max_scl_z, 1, s+i+123)[0]
        )
        linear_extrude(height = scl_z)
            polygon(points = points3, paths = faces2);
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

module sector(seed_offset=0) {
    union() {
        sector_with_hole(seed_offset);
        mirror([1, 0, 0])
            sector_with_hole(seed_offset);
    }
}


module mandala(seed_offset=0) {
    for(i = [0:corners-1]) {
        rotate([0, 0, i * 360/corners])
            translate([0, center_translation, 0])
            sector(seed_offset);
    }
}

module mandalas() {
    spacing = diameter*1.01+center_translation;
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

// randompolygons(0);
// mandala();
mandalas();
