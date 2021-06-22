import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebookapp/database_provider/database_provider.dart';
import 'package:notebookapp/screens/add_new_collectionscreen.dart';
import 'package:notebookapp/models/collectionsModel.dart';
import 'dart:convert';


class CollectionTile extends StatefulWidget {
  int index;
  Collection collection;
  Function updatecollectionlist;
  CollectionTile({this.index,this.collection,this.updatecollectionlist});
  @override
  _CollectionTileState createState() => _CollectionTileState();
}

class _CollectionTileState extends State<CollectionTile> {
  bool _isLiked=false;

  @override
  initState(){
    _isLiked=widget.collection.isCollectionLiked;
    super.initState();
  }

  _toogleLike(){
    setState(() {
      _isLiked=!_isLiked;
    });
    widget.collection.isCollectionLiked=_isLiked;
    DatabaseHelper.instance.updateCollection(widget.collection);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(int.parse(widget.collection.collectionColor)),
      ),
      margin: EdgeInsets.only(bottom: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('${widget.collection.collectionid}'),
              CircleAvatar(
                radius: 16,
                child: Image.asset('assets/cat${widget.collection.collectionCategory}.png',height: 16,),
                backgroundColor: Colors.white10,
              ),
              SizedBox(width: 20,),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>AddCollectionScreen(
                      collection: widget.collection,
                      updateCollectionList: widget.updatecollectionlist,
                    )),);
                },
              ),
            ],
          ),
          widget.collection.collectionImage==null?Container(margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.625),child: Text(''),):Image.memory(
            base64Decode(widget.collection.collectionImage),
            fit: BoxFit.contain,
          ),
          ListTile(
            title: Text('${widget.collection.collectionTitle}'),
            subtitle: widget.collection.collectionDescription==null?Text(''):Text('${widget.collection.collectionDescription}',overflow: TextOverflow.ellipsis,maxLines: 3,),
          ),
          IconButton(
            icon: Icon(_isLiked?Icons.favorite:Icons.favorite_border),
            onPressed: _toogleLike,
          ),
        ],
      ),
    );
  }
}
