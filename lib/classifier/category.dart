String getCategory(String label) {
  String cat = 'NOTHING';
  switch (label) {
    case "apple":
    case "carrot":
    case "tomato":
    case "zfood":
      cat = "FOOD";
      break;
    case "cardboard":
    case "metal":
    case "paper":
    case "pen":
      cat = "RECYCLABLE";
      break;
    case "battery":
    case "mask":
      cat = "HAZARDOUS";
      break;
    case "pencil":
    case "medicine":
      cat = "RESIDUAL";
      break;

    default:
      cat = "NOTHING";
  }
  return cat;
}

String? getImage(String category) {
  String? img;
  switch (category) {
    case "FOOD":
      img = "assets/Backgrounds/4.png";
      break;
    case "RECYCLABLE":
      img = "assets/Backgrounds/1.png";
      break;
    case "HAZARDOUS":
      img = "assets/Backgrounds/2.png";
      break;
    case "RESIDUAL":
      img = "assets/Backgrounds/3.png";
      break;
    default:
      img = null;
  }
  return img;
}
