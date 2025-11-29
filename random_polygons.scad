layers = 3*10;
scl_z = 2;
seed = 23;
vertices = [
    for(i = [0:layers-1]) 
        [
            rands(-1, 1, 1, seed+i)[0],
            rands(-1, 1, 1, seed+i+123)[0]
        ]
];

// take always 3 points and make a polygon out of it
for (i = [0 : 3 : layers-3]) {
    points = [
        [vertices[i][0], vertices[i][1]],
        [vertices[i+1][0], vertices[i+1][1]],
        [vertices[i+2][0], vertices[i+2][1]]
    ];
    faces = [[0,1,2]];
    color([rands(0,1,1,seed+i+456)[0], rands(0,1,1,seed+i+789)[0], rands(0,1,1,seed+i+101112)[0]])
    linear_extrude(height = scl_z)
        polygon(points = points, paths = faces);

}

