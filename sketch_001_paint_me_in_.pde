let img;
let currentSizes = [];
let targetSizes = [];
const tileCount = 100; // Reduce tile count for performance
let tileSize;

function preload() {
  // Use the raw image URL
  img = loadImage("https://raw.githubusercontent.com/lew1997/Webflow-paint-me-/653cdac05e24a7852088d0f7c2e59a4644d911da/me%205.png");
}

function setup() {
  createCanvas(windowWidth, windowHeight, WEBGL);

  // Adjust image size to match the window's aspect ratio
  let imgAspectRatio = img.width / img.height;
  let canvasAspectRatio = width / height;

  if (canvasAspectRatio > imgAspectRatio) {
    // Canvas is wider than the image's aspect ratio
    img.resize(height * imgAspectRatio, height);
  } else {
    // Canvas is taller than the image's aspect ratio
    img.resize(width, width / imgAspectRatio);
  }

  // Initialize grids
  for (let x = 0; x < tileCount; x++) {
    currentSizes[x] = [];
    targetSizes[x] = [];
    for (let y = 0; y < tileCount; y++) {
      currentSizes[x][y] = 0;
      targetSizes[x][y] = 0;
    }
  }

  tileSize = width / tileCount;
}

function draw() {
  background(241, 241, 241);
  noStroke();

  // Translate origin to top-left corner
  translate(-width / 2, -height / 2);

  for (let x = 0; x < tileCount; x++) {
    for (let y = 0; y < tileCount; y++) {
      // Correct tile position
      let xPos = x * tileSize + tileSize / 2;
      let yPos = y * tileSize + tileSize / 2;

      // Adjust mouse coordinates for WEBGL
      let mouseAdjustedX = mouseX - width / 2;
      let mouseAdjustedY = mouseY - height / 2;

      // Check if tile is affected by the mouse
      let d = dist(mouseAdjustedX, mouseAdjustedY, xPos, yPos);
      if (d < tileSize * 20) {
        // Correct image mapping
        let imgX = map(xPos, 0, width, 0, img.width);
        let imgY = map(yPos, 0, height, 0, img.height);

        // Get brightness from image
        let c = img.get(int(imgX), int(imgY));
        let targetBrightness = map(brightness(c), 0, 100, 0, 1);

        // Set target size based on brightness
        targetSizes[x][y] = tileSize * targetBrightness;
      }

      // Smooth interpolation
      currentSizes[x][y] = lerp(currentSizes[x][y], targetSizes[x][y], 0.1);

      // Draw the tile
      push();
      translate(xPos, yPos, 0);
      fill(0);
      ellipse(0, 0, currentSizes[x][y], currentSizes[x][y]);
      pop();
    }
  }
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);

  // Adjust image size again on window resize
  let imgAspectRatio = img.width / img.height;
  let canvasAspectRatio = width / height;

  if (canvasAspectRatio > imgAspectRatio) {
    img.resize(height * imgAspectRatio, height);
  } else {
    img.resize(width, width / imgAspectRatio);
  }

  tileSize = width / tileCount;
}
