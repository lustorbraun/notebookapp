import 'package:flutter/material.dart';
import 'package:notebookapp/database_provider/database_provider.dart';
import 'package:notebookapp/models/collectionsModel.dart';
import 'package:notebookapp/models/slipsModel.dart';
import 'package:notebookapp/screens/slip_swiperscreen.dart';
import 'package:notebookapp/widgets/collection_tile.dart';
import 'package:notebookapp/widgets/slip_tile.dart';

class FavouritesScreen extends StatefulWidget {
  Function updatecollectionlist;
  FavouritesScreen({this.updatecollectionlist});
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  PageController _pageController;
  Future<List<Collection>> _collectionsList;
  Future<List<Slip>> _slipsList ;

  @override
  void initState() {
    _updateCollectionList();
    _updateSlipList();
    super.initState();
  }

  _updateCollectionList(){
    setState(() {
      _collectionsList= DatabaseHelper.instance.getLikedCollectionsList();
    });
  }

  _updateSlipList() {
    setState(() {
      _slipsList = DatabaseHelper.instance.getLikedSlipList();
    });
  }

  @override
  void dispose() {
    //TODO: implement the update collection when like is changed
    widget.updatecollectionlist();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Scaffold(
            body: Container(
              color: Colors.grey[200],
              child: FutureBuilder(
                future: _collectionsList,
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Center(
                      child: Text('No Favourites Found'),
                    );
                  }
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Container(
                        height: MediaQuery.of(context).size.height*0.9,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return SlipSwiperScreen(
                                      collection: snapshot.data[index],
                                    );
                                  }));
                                },
                                child: CollectionTile(
                                  index: index,
                                  collection: snapshot.data[index],
                                  updatecollectionlist: _updateCollectionList,
                                ),
                              );
                            }
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
//          Scaffold(
//            body: Container(
//              child: FutureBuilder(
//                future: _slipsList,
//                builder: (context,snapshot){
//                  if(!snapshot.hasData){
//                    return Center(
//                      child: Text('No Favourites Found'),
//                    );
//                  }
//                  return ListView.builder(
//                      itemCount: snapshot.data.length,
//                      itemBuilder: (context,index){
//                        return GestureDetector(
//                          onTap: (){
//                            Navigator.push(context, MaterialPageRoute(builder: (context){
//                              return SlipSwiperScreen(
//                                collection: snapshot.data[index],
//                              );
//                            }));
//                          },
//                          child: Text('${snapshot.data[index].slipTitle}')
//                        );
//                      }
//                  );
//                },
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
