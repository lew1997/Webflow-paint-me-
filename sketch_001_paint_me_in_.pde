<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.6.0/p5.min.js"></script>
<script>
let img;
let currentSizes = [];
let targetSizes = [];
let tileCount = 150; // Maximum number of tiles
let tileSize;

function preload() {
  img = loadImage('https://drive.google.com/uc?id=FILE_ID'); // Update with the correct URL
}

function setup() {
  createCanvas(1920, 1080, WEBGL); // Use WEBGL for 3D context
  img.resize(1920, 1080);

  // Initialize grids to store tile sizes
  for (let x = 0; x < tileCount; x++) {
    currentSizes[x] = [];
    targetSizes[x] = [];
    for (let y = 0; y < tileCount; y++) {
      currentSizes[x][y] = 0; // Start with no size
      targetSizes[x][y] = 0;  // Initial target size
    }
  }

  tileSize = width / tileCount; // Calculate tile size based on screen width
}

function draw() {
  background(241); // #f1f1f1
  noStroke();

  // Determine the range of tiles affected
  let affectedTilesX = min(tileCount, mouseX / tileSize + 50);
  let affectedTilesY = min(tileCount, mouseY / tileSize + 50);

  for (let x = 0; x < tileCount; x++) {
    for (let y = 0; y < tileCount; y++) {
      let xPos = x * tileSize - width / 2; // Adjust for WEBGL origin
      let yPos = y * tileSize - height / 2;

      // Check if the current tile is within the range of the mouse interaction
      if (abs(mouseX - xPos) < tileSize * 6 && abs(mouseY - yPos) < tileSize * 6) {
        // Get brightness from the image at the tile position
        let imgX = int((x / tileCount) * img.width);
        let imgY = int((y / tileCount) * img.height);
        let c = img.get(imgX, imgY);

        let targetBrightness = map(brightness(c), 0, 255, 0, 1);

        // Set the target size based on brightness
        targetSizes[x][y] = tileSize * targetBrightness;
      }

      // Smoothly interpolate current size toward target size
      currentSizes[x][y] = lerp(currentSizes[x][y], targetSizes[x][y], 0.1);

      // Draw the tile
      push();
      translate(xPos, yPos, 0);
      ellipse(0, 0, currentSizes[x][y], currentSizes[x][y]);
      pop();
    }
  }
}
</script>
