import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:notebookapp/database_provider/database_provider.dart';
import '../models/slipsModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'expanded_image_screen.dart';


class AddNewSlip extends StatefulWidget {
  final Function updateSlipList;
  final Slip slip;
  final int collectionId;
  AddNewSlip({this.updateSlipList,this.slip,@required this.collectionId});


  @override
  _AddNewSlipState createState() => _AddNewSlipState();
}

class _AddNewSlipState extends State<AddNewSlip> {
  var titleTextController = TextEditingController();
  var descriptionTextController = TextEditingController();
  var hintTextController = TextEditingController();
  String _title;
  String _hint;
  String _description;
  String _selectedslipColor='0xFFE7E7C7';
  final _formkey=GlobalKey<FormState>();
  List<String> _imagesAsString=[];

  @override
  void initState() {
    super.initState();
    if(widget.slip!=null) {
      _fillInfo();
    }
  }

  _fillInfo(){
    setState(() {
      titleTextController.text=widget.slip.slipTitle;
      _title=widget.slip.slipTitle;
      hintTextController.text=widget.slip.slipHint;
      _hint=widget.slip.slipHint;
      descriptionTextController.text=widget.slip.slipDescription;
      _description=widget.slip.slipDescription;
      _imagesAsString=widget.slip.imagesStringList;
      _selectedslipColor=widget.slip.slipColor;
    });
  }

  @override
  void dispose() {
    titleTextController.dispose();
    descriptionTextController.dispose();
    hintTextController.dispose();
    super.dispose();
  }

  _handleSubmit(){
    if(_formkey.currentState.validate()){
      Slip _slip=Slip(
          slipTitle: _title,
          slipDescription: _description,
          slipHint: _hint,
          imagesStringList: _imagesAsString,
          collectionid: widget.collectionId,
          slipColor: _selectedslipColor
      );
      if(widget.slip!=null){
        _slip.slipId=widget.slip.slipId;
        DatabaseHelper.instance.updateSlip(_slip);
      }else{
        DatabaseHelper.instance.insertSlip(_slip);
      }
      widget.updateSlipList();
      Navigator.pop(context);
    }
  }

  _handleAddImagefromcamera()async{
    var _pickedimage= await ImagePicker()
        .getImage(
        source: ImageSource.camera,
    );
    _imageCropper(_pickedimage);
    Navigator.pop(context);
  }

  _handleAddImagefromgallery()async{
    var _pickedimage= await ImagePicker()
        .getImage(
      source: ImageSource.gallery,
    );
    _imageCropper(_pickedimage);
    Navigator.pop(context);
  }

  _imageCropper(PickedFile _pickedImage) async{
    var _croppedImage= await ImageCropper.cropImage(
      sourcePath: _pickedImage.path,
      compressQuality: 75,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
      ],
      androidUiSettings: AndroidUiSettings(
        showCropGrid: false,
        lockAspectRatio: true,
        initAspectRatio: CropAspectRatioPreset.ratio4x3,
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.orange,
      )
    );
    String _imageAsString=base64Encode(File(_croppedImage.path).readAsBytesSync());
    setState(() {
      _imagesAsString.add(_imageAsString);
    });
  }

  Future<void> _showMethodSelector() async {
    await showDialog(
      barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            title: const Text('Select a method'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: _handleAddImagefromcamera,
                child: const Text('Select from camera'),
              ),
              SimpleDialogOption(
                onPressed: _handleAddImagefromgallery,
                child: const Text('select from gallery'),
              ),
              SimpleDialogOption(
                onPressed: ()=>Navigator.pop(context),
                child: const Text('cancel'),
              ),
            ],
          );
        });
  }

  _handleDelete(){
    Slip slip=Slip.withId();
    slip.slipId = widget.slip.slipId;
    print(slip.slipId);
    DatabaseHelper.instance.deleteSlip(slip.slipId);
    widget.updateSlipList();
    Navigator.pop(context);
  }

  Widget colorTile(String _color){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedslipColor==_color?Colors.blue:Colors.black26
        ),
      ),
      margin: EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: (){
          setState(() {
            _selectedslipColor=_color;
          });
        },
        child: CircleAvatar(
          backgroundColor: Color(int.parse(_color)),
          radius: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          margin: EdgeInsets.only(top: 20),
          color: Color(int.parse(_selectedslipColor)),
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: 10,right: 10),
          child: SingleChildScrollView(
            child: SafeArea(
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget>[
                          widget.slip!=null?
                          IconButton(
                            alignment: Alignment.topLeft,
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: _handleDelete,
                          ):
                          Text(''),
                          Row(
                            children: <Widget>[
                              colorTile('0xFFCFF4B2'),
                              colorTile('0xFFE8B7B4'),
                              colorTile('0xFFA5CAB2'),
                              colorTile('0xFFF9E2BE'),
                              colorTile('0xFFE2D31B'),
                              colorTile('0xFFE7E7C7'),
                            ],
                          ),
                        ]
                      ),
//TODO: decide if you want back arrow button
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(
//                            Icons.arrow_back_ios,
//                            color: Colors.black54,
//                          ),
//                          onPressed: ()=>Navigator.pop(context),
//                        ),
//                        widget.slip!=null?
//                        IconButton(
//                          icon: Icon(
//                            Icons.delete,
//                            color: Colors.redAccent,
//                          ),
//                          onPressed: _handleDelete,
//                        ):
//                        Text(''),
//                      ],
//                    ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: titleTextController,
                        minLines: 1,
                        maxLines: 3,
                        maxLength: 300,
                        maxLengthEnforced: true,
                        onChanged: (value) => _title = value,
                        validator: (value) => titleTextController.text.isEmpty
                            ? 'Enter a Title'
                            : null,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(color: Colors.black54),
//TODO: decide if you want border or not(currently non border)
//                          filled: true,
//                          border: OutlineInputBorder(
//                            borderRadius: BorderRadius.all(Radius.circular(12)),
//                          ),
//                          focusedBorder: OutlineInputBorder(
//                            borderSide: BorderSide(color: Colors.black,width: 2),
//                            borderRadius: BorderRadius.all(Radius.circular(10)),
//                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: descriptionTextController,
                        minLines: 1,
                        maxLines: 6,
                        maxLength: 1000,
                        maxLengthEnforced: true,
                        onChanged: (value) => _description = value,
                        validator: (value) => descriptionTextController.text.isEmpty
                            ? 'Enter description'
                            : null,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.black54),
//                          filled: true,
//                          border: OutlineInputBorder(
//                            borderRadius: BorderRadius.all(Radius.circular(12)),
//                          ),
//                          focusedBorder: OutlineInputBorder(
//                            borderSide: BorderSide(color: Colors.black,width: 2),
//                            borderRadius: BorderRadius.all(Radius.circular(10)),
//                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: hintTextController,
                        minLines: 1,
                        maxLines: 3,
                        maxLength: 300,
                        maxLengthEnforced: true,
                        onChanged: (value) => _hint = value,
                        decoration: InputDecoration(
                            labelText: 'Hint Text',
                            labelStyle: TextStyle(color: Colors.black54),
//                          filled: true,
//                          border: OutlineInputBorder(
//                            borderRadius: BorderRadius.all(Radius.circular(12)),
//                          ),
//                          focusedBorder: OutlineInputBorder(
//                            borderSide: BorderSide(color: Colors.black,width: 2),
//                            borderRadius: BorderRadius.all(Radius.circular(10)),
//                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      RaisedButton(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(39)),
                        ),
                        onPressed: _showMethodSelector,
                        padding: EdgeInsets.symmetric(),
                        child: ListTile(
                          leading: Icon(Icons.add_a_photo,color: Colors.white,),
                          title: Text('Add images',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        color: Colors.black87,
                      ),
                      _imagesAsString.length==0?
                      Text(''):
                      Container(
                        height: 160,
                        child: ListView.builder(
                          itemCount: _imagesAsString.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                              return Padding(
                                padding: EdgeInsets.all(2),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ExpandedImage(imageString: _imagesAsString[index],);
                                    }));
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Image.memory(
                                          base64Decode(
                                              _imagesAsString[index]
                                          )
                                      ),
                                      Positioned(
                                        left: 4,
                                        top: 4,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white24,
                                          child: GestureDetector(
                                            child: Icon(Icons.delete,color: Colors.red[500],),
                                            onTap: (){
                                              setState(() {
                                                _imagesAsString.remove(_imagesAsString[index]);
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          onPressed: _handleSubmit,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                          child: Text(
                            widget.slip!=null?'Update':'Save',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
