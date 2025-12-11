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
 * 
 * Changelog:
 * [v1.0] Initial release
 */


//wont work in makerworld
//include <BOSL/constants.scad>
//use <BOSL/shapes.scad>
include <BOSL2/std.scad>


//using BOSL2 for makerworld compatibility
function sum_up_to(arr, i) = 
    (i < 0) ? 0 : arr[i] + sum_up_to(arr, i-1);

function build_factors(n, factor, i=0, arr=[1]) = 
    (i >= n-1) ? arr : 
    build_factors(n, factor, i+1, concat(arr, [arr[i] * factor]));

module snowperson(
    n_spheres = 3, 
    n_radius_start = 30,
    n_sphere_downsize_factor_perit = 0.8
){
    let(
        a_n_factors = build_factors(n_spheres, n_sphere_downsize_factor_perit),
        a_n_sphere_size = [
            for (i = [0:n_spheres-1])
                a_n_factors[i] * n_radius_start
        ],
        a_n_sphere_trn = [
            for (i = [0:n_spheres-1])
                a_n_factors[i] * n_radius_start
        ]
    ){
        for (i=[0:n_spheres-1]) {
            let(
                radius = a_n_sphere_size[i],
                z_pos = sum_up_to(a_n_sphere_trn, i-1),
                x_pos = 0//-radius / 2  // Align on x-axis edge
            ) {
                translate([x_pos, 0, z_pos])
                color([rands(0,1, 1, i)[0], rands(0,1, 1, i+100)[0], rands(0,1, 1, i+200)[0]])
                    cuboid(radius);
                color([rands(0,1, 1, i+32)[0], rands(0,1, 1, i+22)[0], rands(0,1, 1, i+33)[0]])
                    sphere(radius);
            }
        }
    }
}

snowperson(
    n_spheres = 5, 
    n_radius_start = 60/2,
    n_sphere_downsize_factor_perit = 0.8 // each next sphere will be half the size of the previous one
);