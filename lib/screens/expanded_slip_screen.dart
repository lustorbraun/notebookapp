import '../models/slipsModel.dart';
import '../Constants/const.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'expanded_image_screen.dart';

class ExpandedSlipScreen extends StatelessWidget {
  Slip slip ;
  final int index;
  ExpandedSlipScreen({this.slip,this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(int.parse(slip.slipColor)),
        ),
        padding: EdgeInsets.only(top: 12,left: 20,right: 20),
        width: double.infinity,
        height: double.maxFinite,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: kPrimaryIconsColor,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${slip.slipTitle}',
                      style: kSlipTitleSlipTextStyle.copyWith(fontSize: 30),
                    ),
                    Divider(
                      color: kPrimaryIconsColor,
                      endIndent: 200,
                      thickness: 1,
                    ),
                    Text(
                      '${slip.slipDescription}',
                                  style: kSlipHintSlipTextStyle.copyWith(fontSize: 16),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.8,
                                  height: MediaQuery.of(context).size.height*0.5,
                                  child: ListView.builder(
                                    itemCount: slip.imagesStringList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return ExpandedImage(imageString: slip.imagesStringList[index],);
                                        }));
                                      },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              height: MediaQuery.of(context).size.height*0.4,
                                              width: MediaQuery.of(context).size.width*0.7,
                                              child: Image.memory(
                                                  base64Decode(
                                                      slip.imagesStringList[index],
                                                  )
                                              ),
                                            ),
                                            Positioned(
                                              right: 20,
                                              child: Text("${index+1}/${slip.imagesStringList.length}"),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                  color: Colors.black12,
                                  fontSize: 120,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
              ),
        ),
      ),
    );
  }
}
