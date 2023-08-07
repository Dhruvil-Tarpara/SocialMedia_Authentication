import 'dart:math';

import 'package:flutter/material.dart';

extension RandomOpaqueColor on Colors {
  randomColor() {
    return Random().nextInt(0xffffffff);
  }
}
