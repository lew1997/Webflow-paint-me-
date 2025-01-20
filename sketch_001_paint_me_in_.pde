let img;
let currentSizes = [];  // Current sizes of tiles
let targetSizes = [];   // Target sizes of tiles
let tileCount = 150;    // Maximum number of tiles
let tileSize;           // Size of each tile

function preload() {
  img = loadImage('https://github.com/lew1997/Webflow-paint-me-/blob/41ddbc86d1106013296d774de936cf4ff1dbb93a/me%205.png');  // Preload the image
}

function setup() {
  createCanvas(1920, 1080);
  img.resize(1920, 1080);

  // Initialize grids to store tile sizes
  for (let i = 0; i < tileCount; i++) {
    currentSizes[i] = [];
    targetSizes[i] = [];
    for (let j = 0; j < tileCount; j++) {
      currentSizes[i][j] = 0; // Start with no size
      targetSizes[i][j] = 0;  // Initial target size
    }
  }

  // Calculate tile size based on screen width
  tileSize = width / tileCount;
}

function draw() {
  background(241, 241, 241);
  fill(0);
  noStroke();

  // Determine the range of tiles that will be affected
  let affectedTilesX = min(tileCount, mouseX / tileSize + 50); // Influence width
  let affectedTilesY = min(tileCount, mouseY / tileSize + 50); // Influence height

  for (let x = 0; x < tileCount; x++) {
    for (let y = 0; y < tileCount; y++) {
      let xPos = x * tileSize;
      let yPos = y * tileSize;

      // Check if the current tile is within the range of the mouse interaction
      if (abs(mouseX - xPos) < tileSize * 6 && abs(mouseY - yPos) < tileSize * 6) {

        // Get brightness from the image at the tile position
        let c = img.get(int(xPos), int(yPos));
        let targetBrightness = map(brightness(c), 0, 255, 0, 1);

        // Set the target size based on brightness
        targetSizes[x][y] = tileSize * targetBrightness;
      }

      // Smoothly interpolate current size toward target size
      currentSizes[x][y] = lerp(currentSizes[x][y], targetSizes[x][y], 0.1);

      // Draw the tile
      push();
      translate(xPos, yPos);
      ellipse(0, 0, currentSizes[x][y], currentSizes[x][y]);
      pop();
    }
  }
}
