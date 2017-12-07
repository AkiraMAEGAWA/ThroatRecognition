import processing.serial.*; //<>//

Serial myPort;

final int width = 800;
final int height = 600;

long[] graphValues;
int cursor;

float scale;
int shift;

void settings() {
  size(width, height);
}

void setup() {
  frameRate(15);

  // init buffer
  graphValues = new long[width];
  cursor = 0;

  // resizer
  scale = 1.0f;
  shift = 0;

  // setup my serial port
  myPort = new Serial(this, "/dev/tty.usbmodem1411", 115200);
}

void update() {
  // say IM READY!!
  myPort.write('r');

  // read from Arduino
  String buffer = myPort.readStringUntil(10);
  if (buffer == null) {
    //println("null...");
    return;
  } else {
    //println(buffer);
  }

  int val = Integer.parseInt(trim(buffer));

  graphValues[cursor] = val;
  //graphValues[cursor] = 200;//(int)random(512);
  //println("DATA:" + graphValues[cursor]);
  //while(myPort.available() <= 0);
  //print(myPort.readStringUntil(10));

  cursor++;
  if (cursor >= width) cursor=0;
  delay(10);
}

void draw() {
  update();

  background(0);
  stroke(255);

  for (int i=0; i<(width-cursor-1); i++) {
    //line(i,graphValues[cursor + i], i+1, graphValues[cursor+i+1]);
    line(i, (int)(graphValues[cursor + i]/scale) + shift, i+1, (int)(graphValues[cursor+i+1]/scale) + shift);
  }
  for (int i = (width-cursor); i<width; i++) {
    line(i, (int)(graphValues[i-(width-cursor)]/scale) + shift, i+1, (int)(graphValues[i-(width-cursor) + 1]/scale) + shift);
  }
}

void keyPressed() {
  if (keyCode == UP) {
    shift -= 10;
  } else if (keyCode == DOWN) {
    shift += 10;
  } else if (keyCode == ';') {
    scale -= 0.1f;
  } else if (keyCode == '-') {
    scale += 0.1f;
  }
}