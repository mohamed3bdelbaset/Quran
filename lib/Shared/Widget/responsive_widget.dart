double largetext(double height) {
  if (height <= 812.0) {
    return 16;
  } else if (height <= 926.0) {
    return 18;
  } else if (height <= 960.0) {
    return 20;
  } else if (height <= 1080.0) {
    return 22;
  } else if (height <= 1280.0) {
    return 24;
  } else if (height <= 1350.0) {
    return 26;
  } else {
    return 30;
  }
}

double middletext(double height) {
  if (height <= 812.0) {
    return 12;
  } else if (height <= 960.0) {
    return 14;
  } else if (height <= 1080.0) {
    return 16;
  } else if (height <= 1280.0) {
    return 18;
  } else if (height <= 1350.0) {
    return 22;
  } else {
    return 26;
  }
}

double smalltext(double height) {
  if (height <= 812.0) {
    return 10;
  } else if (height <= 960.0) {
    return 12;
  } else if (height <= 1080.0) {
    return 14;
  } else if (height <= 1280.0) {
    return 16;
  } else if (height <= 1350.0) {
    return 18;
  } else {
    return 22;
  }
}

double iconSize(double height) {
  if (height <= 844.0) {
    return 20;
  } else if (height <= 926.0) {
    return 23;
  } else if (height <= 960.0) {
    return 25;
  } else if (height <= 1080.0) {
    return 27;
  } else if (height <= 1280.0) {
    return 30;
  } else if (height <= 1350.0) {
    return 35;
  } else {
    return 40;
  }
}
