import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

Color parseRGB(String? rgbString) {
// SPECIAL COLOR
  if (rgbString == null) {
    return primaryColor; // Màu vàng
  }

  // Loại bỏ "rgb(" và ")" khỏi chuỗi
  rgbString = rgbString.replaceAll("rgb(", "").replaceAll(")", "");

  // Tách chuỗi thành các giá trị R, G, B
  List<String> rgbValues = rgbString.split(",");
  

  // Chuyển đổi các giá trị thành số nguyên
  int r = int.parse(rgbValues[0].trim());
  int g = int.parse(rgbValues[1].trim());
  int b = int.parse(rgbValues[2].trim());

  if (r == 255 && g == 244 && b == 67) {
    return Color.fromRGBO(255, 208, 0, 1.0); // Màu vàng
  }

  // Trả về đối tượng Color
  return Color.fromRGBO(r, g, b, 1.0); // Alpha = 1.0 (độ trong suốt)
}