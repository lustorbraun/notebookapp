import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebookapp/database_provider/database_provider.dart';
import 'package:notebookapp/models/collectionsModel.dart';
import 'package:image_picker/image_picker.dart';
import 'expanded_image_screen.dart';
import 'package:image_cropper/image_cropper.dart';

class AddCollectionScreen extends StatefulWidget {
  Collection collection;
  Function updateCollectionList;
  AddCollectionScreen({this.collection,this.updateCollectionList});
  @override
  _AddCollectionScreenState createState() => _AddCollectionScreenState();
}

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  var titleTextController = TextEditingController();
  var descriptionTextController = TextEditingController();
  String _title;
  String _description;
  final _formkey=GlobalKey<FormState>();
  String _selectedcollectionColor='0xFFE7E7E7';
  String _imagesAsString;
  bool _isImageUploaded=false;
  String _selectedcategory='Others';

  @override
  void initState() {
    if(widget.collection!=null) {
      _fillInfo();
    }
    super.initState();
  }

  _fillInfo(){
    setState(() {
      titleTextController.text=widget.collection.collectionTitle;
      _title=widget.collection.collectionTitle;
      descriptionTextController.text=widget.collection.collectionDescription;
      _description=widget.collection.collectionDescription;
      _selectedcollectionColor=widget.collection.collectionColor;
      _imagesAsString=widget.collection.collectionImage;
      _selectedcategory=widget.collection.collectionCategory;
      if(_imagesAsString==null){
        _isImageUploaded=false;
      }else if (_imagesAsString!=null){
        _isImageUploaded=true;
      }
    });
  }

  @override
  void dispose() {
    titleTextController.dispose();
    descriptionTextController.dispose();
    super.dispose();
  }

    _handleDelete(){
    Collection _collection=Collection();
    _collection.collectionid = widget.collection.collectionid;
    DatabaseHelper.instance.deleteCollectionSlips(_collection.collectionid);
    DatabaseHelper.instance.deleteCollection(_collection.collectionid);
    widget.updateCollectionList();
    Navigator.pop(context);
    }

  _handleSubmit() {
    if ((_formkey.currentState.validate())&&(_isImageUploaded==true)) {
      if(widget.collection!=null){
        Collection _collection=Collection.withId(
          collectionid: widget.collection.collectionid,
          collectionTitle: _title,
          collectionDescription: _description,
          collectionImage: _imagesAsString,
          collectionColor: _selectedcollectionColor,
          collectionCategory: _selectedcategory,
        );
        _collection.collectionid=widget.collection.collectionid;
        _collection.isCollectionLiked=widget.collection.isCollectionLiked;
        DatabaseHelper.instance.updateCollection(_collection);
      }else {
        Collection _collection=Collection(
          collectionTitle: _title,
          collectionDescription: _description,
          collectionImage: _imagesAsString,
          collectionColor: _selectedcollectionColor,
          collectionCategory: _selectedcategory,
        );
        _collection.isCollectionLiked=false;
        DatabaseHelper.instance.insertCollection(_collection);
      }
      widget.updateCollectionList();
      Navigator.pop(context);
    }else{
      _showImageError();
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
      _imagesAsString=_imageAsString;
      _isImageUploaded=true;
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

  Future<void> _showImageError() async{
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Text('Please add an Image'),
          ),
        );
      }
    );
  }

  Widget colorTile(String _color){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: _selectedcollectionColor==_color?Colors.blue:Colors.black26
        ),
      ),
      margin: EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: (){
          setState(() {
            _selectedcollectionColor=_color;
          });
        },
        child: CircleAvatar(
          backgroundColor: Color(int.parse(_color)),
          radius: 13,
        ),
      ),
    );
  }

  Widget categoryAvatar(String _category){
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: (){
          setState(() {
            _selectedcategory=_category;
          });
        },
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 16,
              child: Image.asset('assets/cat$_category.png',height: 16,),
              backgroundColor: _selectedcategory==_category?Colors.blue[200]:Colors.white,
            ),
            SizedBox(height: 2,),
            Text('$_category')
          ],
        )
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
          color: Color(int.parse(_selectedcollectionColor)),
          margin: EdgeInsets.only(top: 20),
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: 10, right: 10),
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
                            widget.collection != null ?
                            IconButton(
                              alignment: Alignment.topLeft,
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: _handleDelete,
                            ) :
                            Text(''),
                            Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    colorTile('0xFFCFF4D2'),
                                    colorTile('0xFFE8B7D4'),
                                    colorTile('0xFFA5CAD2'),
                                    colorTile('0xFFF9E2AE'),
                                    colorTile('0xFFE2D36B'),
                                    colorTile('0xFFE7E7E7'),
                                  ],
                                ),
                              ],
                            ),
                          ]
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: titleTextController,
                        minLines: 1,
                        maxLines: 3,
                        maxLength: 100,
                        maxLengthEnforced: true,
                        onChanged: (value) => _title = value,
                        validator: (value) =>
                        titleTextController.text.isEmpty
                            ? 'Enter a Title'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: descriptionTextController,
                        minLines: 1,
                        maxLines: 6,
                        maxLength: 300,
                        maxLengthEnforced: true,
                        onChanged: (value) => _description = value,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Category',style: TextStyle(fontWeight: FontWeight.bold),),
                          Row(
                            children: <Widget>[
                              categoryAvatar('Education'),
                              categoryAvatar('Entertainment'),
                              categoryAvatar('Sports'),
                              categoryAvatar('Others'),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      _imagesAsString==null?
                      Text(''):
                      Container(
                        height: 160,
                        child: Padding(
                              padding: EdgeInsets.all(2),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return ExpandedImage(imageString: _imagesAsString,);
                                  }));
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Image.memory(
                                        base64Decode(
                                            _imagesAsString
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
                                              _imagesAsString=null;
                                              _isImageUploaded=false;
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _isImageUploaded==false?RaisedButton(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(39)),
                            ),
                            onPressed: _showMethodSelector,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            child: Row(
                                children: [
                                  Icon(Icons.add_a_photo,color: Colors.white,),
                                  SizedBox(width: 20,),
                                  Text('Add images',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                ]),
                            color: Colors.black87,
                          ):Text(''),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            onPressed: _handleSubmit,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            child: Text(
                              widget.collection != null ? 'Update' : 'Save',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.black87,
                          ),
                        ],
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