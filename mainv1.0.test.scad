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

    //using BOSL2 for makerworld compatibility
    include <BOSL2/std.scad>

    function sum_up_to(arr, i) = 
        (i < 0) ? 0 : arr[i] + sum_up_to(arr, i-1);

    module sphere_summand(radius){
        sphere(r=radius);
    }

    module snowperson(
        n_spheres = 3, 
        n_radius_start = 30,
        n_sphere_downsize_factor_perit = undef
    ){
        let(
            downsize_factor = (n_sphere_downsize_factor_perit == undef) 
                ? 1./n_spheres 
                : n_sphere_downsize_factor_perit,
            
            a_n_cube_size = [
                for (i = [0:n_spheres-1])
                    n_radius_start * (1. - downsize_factor * i)
            ],
            
            a_n_cube_heights = [
                for (i = [0:n_spheres-1])
                    a_n_cube_size[i]
            ]
        ){
            for (i=[0:n_spheres-1]) {
                let(
                    cube_size = a_n_cube_size[i],
                    z_pos = sum_up_to(a_n_cube_heights, i-1),
                    // Align on negative x edge: offset by half of current cube size
                    x_pos = -cube_size / 2
                ) {
                    translate([x_pos, 0, z_pos])
                    color([rands(0,1, 1, i)[0], rands(0,1, 1,i+2)[0], rands(0,1, 1,i+3)[0]])
                        cube(cube_size);
                }
            }
        }
    }

    snowperson(
        n_spheres = 5, 
        n_radius_start = 60/2,
        n_sphere_downsize_factor_perit = 0.1
    );