import "./perlin.js";

import {Image} from "jsr:@matmen/imagescript";

noise.seed(Math.random());

let n_x = 16;
let n_y = 16;
let a_a_n_perlinvalue = [];
for (var x = 0; x < n_x; x++) {
  for (var y = 0; y < n_y; y++) {
    // All noise functions return values in the range of -1 to 1.

    // noise.simplex2 and noise.perlin2 for 2d noise
    var value = noise.simplex2(x / 100, y / 100);
    // ... or noise.simplex3 and noise.perlin3:
    // var value = noise.simplex3(x / 100, y / 100, time);

    if(!a_a_n_perlinvalue[x]){
      a_a_n_perlinvalue[x] = [];
    }
    a_a_n_perlinvalue[x][y] = value;
    // image[x][y].r = Math.abs(value) * 256; // Or whatever. Open demo.html to see it used with canvas.
  }
}
// visualize by generating an image 


let o_img = new Image(n_x, n_y);
o_img.fill(x => Math.random());
// o_img.bitmap = new Array(n_x * n_y).fill([0,0,0,255]);
const output = await o_img.encode();
await Deno.writeFile('./output.png', output);

console.log(JSON.stringify(a_a_n_perlinvalue));
