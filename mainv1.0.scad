/**
 * Star Generator
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
 * 
 * Changelog:
 * [v1.0] Initial release
 */


//wont work in makerworld
//include <BOSL/constants.scad>
//use <BOSL/shapes.scad>

//using BOSL2 for makerworld compatibility
include <BOSL2/std.scad>;


scl_x = 1;
scl_y = 1; 
scl_z = 1;
padding = 1;
chamfer = 0.4;


function sizesfrominput(scl_x, scl_y, scl_z, padding) =
    let(
        scl_x_b = max(scl_x + padding * 2, 10),
        scl_y_b = max(scl_y + padding * 2, 16),
        scl_z_b = 1.2,
        scl_z_text = 1.2,
        scl_y_text = 4
    )
    [
        ["scl_x_b", scl_x_b],
        ["scl_y_b", scl_y_b],
        ["scl_z_b", scl_z_b],
        ["scl_z_text", scl_z_text],
        ["scl_y_text", scl_y_text]
    ];
// Helper function to get values
function get(dict, key) = dict[search([key], dict)[0]][1];

module reference_cube_plate(
    scl_x,
    scl_y,
    scl_z,
    scl_x_b,
    scl_y_b,
    scl_z_b,
    scl_z_text,
    scl_y_text,
    chamfer = 0.2,
    font = "Liberation Sans"
){

    echo(scl_y_text)
    difference(){
        union(){
            translate([0,0,scl_z/2])
            //cube1 without chamfer
            cuboid([scl_x,scl_y,scl_z], chamfer=chamfer, trimcorners=false);

            //bottom plate
            translate([0,0, -scl_z_b/2])
            cuboid([scl_x_b,scl_y_b,scl_z_b], chamfer=0.2, trimcorners=false);
        }

        let(
            lineheight = 1.2,
            marginy = scl_y_text*lineheight
        ){

            translate([0,marginy,-scl_z_b-0.4])
            mirror([1,0,0])
            linear_extrude(height=scl_z_text){
                text(text = str("x",scl_x), font = font, size = scl_y_text, halign = "center", valign="center");
            }
            translate([0,0,-scl_z_b-0.4])
            mirror([1,0,0])
            linear_extrude(height=scl_z_text){
                text(text = str("y",scl_y), font = font, size = scl_y_text, halign = "center", valign="center");
            }
            translate([0,-marginy,-scl_z_b-0.4])
            mirror([1,0,0])
            linear_extrude(height=scl_z_text){
                text(text = str("z",scl_z), font = font, size = scl_y_text, halign = "center", valign="center");
            }
        }
    }


}
module reference_cubes_with_plate(
    scl_x,
    scl_y,
    scl_z,
    padding = 1, 
    chamfer = 0.4
){
    // cuboid([scl_x,scl_y,scl_z], chamfer=chamfer, trimcorners=false);
    // Usage
    sizes = sizesfrominput(scl_x, scl_y, scl_z, padding);
    scl_x_b = get(sizes, "scl_x_b");
    scl_y_b = get(sizes, "scl_y_b");
    scl_z_b = get(sizes, "scl_z_b");
    scl_z_text = get(sizes, "scl_z_text");
    scl_y_text = get(sizes, "scl_y_text");
    
    reference_cube_plate(
        scl_x = scl_x,
        scl_y = scl_y,
        scl_z = scl_z,
        scl_x_b = scl_x_b,
        scl_y_b = scl_y_b,
        scl_z_b = scl_z_b,
        scl_z_text = scl_z_text,
        scl_y_text = scl_y_text,
        chamfer = 0.0
    );
    translate([scl_x_b,0,0])
    reference_cube_plate(
        scl_x = scl_x,
        scl_y = scl_y,
        scl_z = scl_z,
        scl_x_b = scl_x_b,
        scl_y_b = scl_y_b,
        scl_z_b = scl_z_b,
        scl_z_text = scl_z_text,
        scl_y_text = scl_y_text,
        chamfer = chamfer
    );
}


reference_cubes_with_plate(scl_x, scl_y, scl_z, padding, chamfer);