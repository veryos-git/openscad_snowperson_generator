module custom_sphere(r = 10, lat_divs = 16, lon_divs = 16) {
    // Generate points
    points = [
        [0, 0, r],  // top pole
        for (lat = [1:lat_divs-1])
            for (lon = [0:lon_divs-1])
                let(
                    theta = lat * 180 / lat_divs,
                    phi = lon * 360 / lon_divs, 
                    r_offset = 
                )
                [
                    r * sin(theta) * cos(phi),
                    r * sin(theta) * sin(phi),
                    r * cos(theta)
                ],
        [0, 0, -r]  // bottom pole
    ];
    
    // Generate faces
    faces = concat(
        // Top cap triangles
        [for (lon = [0:lon_divs-1])
            [0, 1 + lon, 1 + (lon + 1) % lon_divs]
        ],
        
        // Middle quads (as two triangles each)
        [for (lat = [0:lat_divs-3])
            for (lon = [0:lon_divs-1])
                let(
                    tl = 1 + lat * lon_divs + lon,
                    tr = 1 + lat * lon_divs + (lon + 1) % lon_divs,
                    bl = 1 + (lat + 1) * lon_divs + lon,
                    br = 1 + (lat + 1) * lon_divs + (lon + 1) % lon_divs
                )
                each [[tl, bl, br], [tl, br, tr]]
        ],
        
        // Bottom cap triangles
        [for (lon = [0:lon_divs-1])
            let(bottom_ring_start = 1 + (lat_divs - 2) * lon_divs)
            [len(points) - 1, bottom_ring_start + (lon + 1) % lon_divs, bottom_ring_start + lon]
        ]
    );
    
    polyhedron(points, faces);
}

custom_sphere(r = 10, lat_divs = 10, lon_divs = 16);