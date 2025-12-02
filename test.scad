
pa = [0,0,0];
pb  = [20, 10, 0];
p3 = [10, 30, 0];
seed = 12345;
layerheight = 0.2;
sector_max_scl_z = 10;  
n_randomlines = 5;
thickness = 2;
extrusionwidth = 0.42;

function triangle_max_sideleng(a,b,c) = 
    let(
        a = norm(pb - pa),
        b = norm(p3 - pb),
        c = norm(pa - p3)
    )
    max([a,b,c]);



function random_point_in_triangle(pa, pb, pc, seed) =
    let(
        r1 = rands(0, 1, 1, seed)[0],
        r2 = rands(0, 1, 1, seed+23)[0],
        u  = r1 + r2 > 1 ? 1 - r1 : r1,
        v  = r1 + r2 > 1 ? 1 - r2 : r2
    )
    pa + u*(pb - pa) + v*(pc - pa);


        union(){
            for(i = [0:n_randomlines-1]) 
                let(
                    max_sidelength = triangle_max_sideleng(pa, pb, p3),
                    trn_rand = random_point_in_triangle(pa, pb, p3 , seed+i), 
                    rotation = rands(0,360,1, seed+i+50)[0], 
                    random_z_offset = rands(layerheight, thickness,1, seed+i+100)[0], 
                    width = max_sidelength, 
                    height = rands(extrusionwidth , extrusionwidth*5, 1, seed+i+150)[0] // width of the 'line'
                    // get a random point in the area of the 
                ){
                    translate([trn_rand[0], trn_rand[1], random_z_offset])
                    rotate([0,0,rotation])
                    translate([-(width/2), 0, 0])
                    color([0.2, 0.5, 0.8, 0.4])
                    cube([
                        width, 
                        height, 
                        sector_max_scl_z*2
                    ]);
                }
        } 
//visualize the triangle 
points = [[pa[0], pa[1]], [pb[0], pb[1]], [p3[0], p3[1]]];
faces = [[0,1,2]];
linear_extrude(height = thickness)
    polygon(points = points, paths = faces);