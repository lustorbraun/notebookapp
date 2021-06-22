import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:notebookapp/database_provider/database_provider.dart';
import '../models/slipsModel.dart';
import '../screens/add_new_slipscreen.dart';
import 'package:flutter/material.dart';
import '../Constants/const.dart';
import 'package:notebookapp/screens/expanded_image_screen.dart';
import 'package:notebookapp/widgets/appclipper.dart';

class SlipTile extends StatefulWidget {
  int index;
  Slip slip;
  Function updatesliplist;
  SlipTile({this.index,this.updatesliplist,this.slip});
  @override
  _SlipTileState createState() => _SlipTileState();
}

class _SlipTileState extends State<SlipTile> {
  bool _isLiked=false;

  @override
  initState(){
    _isLiked=widget.slip.isSlipLiked;
    super.initState();
  }

  _toogleLike()async{
    setState(() {
      _isLiked=!_isLiked;
    });
    Slip _updateSlip = Slip.withId();
    _updateSlip.slipId=widget.slip.slipId;
    _updateSlip.isSlipLiked=_isLiked;
    _updateSlip.slipTitle=widget.slip.slipTitle;
    _updateSlip.slipDescription=widget.slip.slipDescription;
    _updateSlip.slipHint=widget.slip.slipHint;
    _updateSlip.slipId=widget.slip.slipId;
    _updateSlip.collectionid=widget.slip.collectionid;
    _updateSlip.imagesStringList=widget.slip.imagesStringList;
    _updateSlip.slipColor=widget.slip.slipColor;
    await DatabaseHelper.instance.updateSlip(_updateSlip);
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(top: 120),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipPath(
                  clipper: AppClipper(cornerSize: 25, diagonalHeight: 170),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Color(int.parse(widget.slip.slipColor)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                        ),
                        Text(
                          '${widget.slip.slipTitle}',
                          style: kSlipTitleSlipTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.slip.slipHint==null?"":'${widget.slip.slipHint}',
                          style: kSlipHintSlipTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(_isLiked?Icons.favorite:Icons.favorite_border),
                              onPressed: _toogleLike,
                            ),
                            IconButton(
                              icon: Icon(Icons.mode_edit),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AddNewSlip(
                                        updateSlipList: widget.updatesliplist,
                                        slip: widget.slip,
                                        collectionId: widget.slip.collectionid,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            top: 55,
            child: Text(
              '${widget.index + 1}',
              style: TextStyle(
                  color: Colors.black12,
                  fontSize: 100,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ExpandedImage(imageString: widget.slip.imagesStringList.first,);
                }));
              },
              child: widget.slip.imagesStringList.isEmpty?
              Text(''):
              Image.memory(
                base64Decode(widget.slip.imagesStringList.first),
                height: 200,
                width: 220,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
