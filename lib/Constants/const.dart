import 'package:flutter/material.dart';

const kSlipTitleSlipTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const kSlipHintSlipTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

const Color kPrimaryIconsColor=Colors.black54;

const kActiveCardColour = Color(0xFF1D1E33);
const kInactiveCardColour = Color(0xFF111328);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

Color kCollectionDrawerColor= Colors.blueAccent[200];

Color kCollectionScreenBackgroundColor=Colors.grey[200];