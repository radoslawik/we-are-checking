import 'package:flutter/material.dart';

class ColorProvider {
  static final Map _colorMap = {
    'red_bull': '0b4081',
    'ferrari': 'f91536',
    'mercedes': '6cd3bf',
    'alpine': '2293d1',
    'mclaren': 'f58020',
    'alfa': 'c92d4b',
    'haas': 'b6babd',
    'alphatauri': '5e8faa',
    'aston_martin': '358c75',
    'williams': '37bedd',
  };

  static Color getColor(String key) {
    final hex = _colorMap.containsKey(key) ? _colorMap[key] : 'ffffff';
    return Color(int.parse('0xff$hex'));
  }
}