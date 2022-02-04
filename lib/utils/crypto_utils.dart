import 'dart:math';

import 'package:flutter/material.dart';

class CryptoUtils {
  static String format(int amount, int decimals) {
    return (amount / pow(10, decimals)).toStringAsFixed(2);
  }

  String name;
  cont() => Container(decoration: BoxDecoration());
}
