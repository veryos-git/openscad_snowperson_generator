include <BOSL2/std.scad>

module noisy_sphere(r=10, noise=0.5) {
    $fn = 128;
    
    sphere_mesh = sphere(r, $fn=$fn);
    
    noisy_points = [
        for (i = [0:len(sphere_mesh[0])-1])  // Loop through indices
            let(
                len = len(sphere_mesh[0]),
                p = sphere_mesh[0][i],  // Get the point at index i
                dir = unit(p),
                offset = sin((i/len)*360*5)
            )
            p + dir * offset
    ];
    
    polyhedron(noisy_points, sphere_mesh[1]);
}

noisy_sphere(r=20, noise=2);