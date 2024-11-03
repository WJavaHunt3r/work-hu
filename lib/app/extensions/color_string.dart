import 'package:flutter/material.dart';

extension ColorString on Color {
  String toHexString(value) {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
