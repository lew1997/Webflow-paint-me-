PImage img;
float[][] currentSizes; // Current sizes of tiles
float[][] targetSizes;  // Target sizes of tiles
int tileCount = 150;    // Maximum number of tiles
float tileSize;         // Size of each tile

void setup() {
  size(1920, 1080, P3D);
  img = loadImage("me 3_.png");
  img.resize(1920, 1080);

  // Initialize grids to store tile sizes
  currentSizes = new float[tileCount][tileCount];
  targetSizes = new float[tileCount][tileCount];

  // Calculate tile size based on screen width
  tileSize = width / tileCount;

  for (int x = 0; x < tileCount; x++) {
    for (int y = 0; y < tileCount; y++) {
      currentSizes[x][y] = 0; // Start with no size
      targetSizes[x][y] = 0;  // Initial target size
    }
  }
}

void draw() {
  background(#f1f1f1);
  fill(0);
  noStroke();

  // Determine the range of tiles that will be affected
  float affectedTilesX = min(tileCount, mouseX / tileSize + 50); // Influence width
  float affectedTilesY = min(tileCount, mouseY / tileSize + 50); // Influence height

  for (int x = 0; x < tileCount; x++) {
    for (int y = 0; y < tileCount; y++) {
      float xPos = x * tileSize;
      float yPos = y * tileSize;

      // Check if the current tile is within the range of the mouse interaction
      if (abs(mouseX - xPos) < tileSize * 6 && abs(mouseY - yPos) < tileSize * 6) {

        // Get brightness from the image at the tile position
        color c = img.get(int(xPos), int(yPos));
        float targetBrightness = map(brightness(c), 0, 255, 0, 1);

        // Set the target size based on brightness
        targetSizes[x][y] = tileSize * targetBrightness;

      }

      // Smoothly interpolate current size toward target size
      currentSizes[x][y] = lerp(currentSizes[x][y], targetSizes[x][y], 0.1);

      // Draw the tile
      pushMatrix();
      translate(xPos, yPos);
      ellipse(0, 0, currentSizes[x][y], currentSizes[x][y]);
      popMatrix();
    }
  }
}
