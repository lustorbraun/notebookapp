import 'dart:convert';

import 'package:flutter/material.dart';

class ExpandedImage extends StatelessWidget {
  final String imageString;
  ExpandedImage({this.imageString});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7c94b6),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(base64Decode(imageString),),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: ()=>Navigator.pop(context),
                color: Colors.black,
                iconSize: 30,
                autofocus: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
