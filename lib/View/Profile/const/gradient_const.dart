import 'package:flutter/material.dart';

const LinearGradient SIGNUP_BACKGROUND = LinearGradient(
  begin: FractionalOffset(0.0, 0.4),
  end: FractionalOffset(0.9, 0.7),
  stops: [0.1, 0.9],
  colors: [Colors.white, Colors.white],
);

const LinearGradient SIGNUP_CARD_BACKGROUND = LinearGradient(
  tileMode: TileMode.clamp,
  begin: FractionalOffset.centerLeft,
  end: FractionalOffset.centerRight,
  stops: [0.1, 1.0],
  colors: [Colors.white, Colors.white],
);

const LinearGradient SIGNUP_CIRCLE_BUTTON_BACKGROUND = LinearGradient(
  tileMode: TileMode.clamp,
  begin: FractionalOffset.centerLeft,
  end: FractionalOffset.centerRight,
  stops: [0.4, 1],
  colors: [Colors.black, Colors.black54],
);
