PGraphics Layer_MD;
int[] CanvasSize ={1080, 720};
int[] MenuSize = {CanvasSize[0], 300};
color Paint = color(0, 0, 0, 255);
float BrushSize = 5;

void settings() {
  size(CanvasSize[0], CanvasSize[1]+MenuSize[1]);
}

void setup() {
  Layer_MD = createGraphics(CanvasSize[0], CanvasSize[1]+MenuSize[1]);
  background(255);
  frameRate(300);
}

void draw() {
  FrameDraw();
  
  brush();
}

void FrameDraw() {
  strokeWeight(2);
  fill(255);
  rect(0, 0, MenuSize[0], MenuSize[1]);
  noFill();
  rect(0, MenuSize[1], CanvasSize[0], CanvasSize[1]);
}

void brush() {
  if (mousePressed) {
    if (MenuSize[1] < mouseY) {
      stroke(Paint);
      strokeWeight(BrushSize);
      line(pmouseX, pmouseY, mouseX, mouseY);
    }
  }
}

void MenuDown() {
  
}

void ColorPicker(){
  fill(255);
  rect(100,100,800,800);
  
}
