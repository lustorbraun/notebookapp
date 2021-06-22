import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebookapp/database_provider/database_provider.dart';
import 'package:notebookapp/screens/add_new_collectionscreen.dart';
import 'package:notebookapp/screens/slip_swiperscreen.dart';
import 'package:notebookapp/widgets/collection_tile.dart';
import 'collections_drawer.dart';
import 'package:notebookapp/models/collectionsModel.dart';
import 'package:notebookapp/Constants/const.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  Future<List<Collection>> _collectionsList;

  @override
  void initState() {
    _updateCollectionList();
    super.initState();
  }

  _updateCollectionList() {
    setState(() {
      _collectionsList = DatabaseHelper.instance.getCollectionsList();
    });
  }

  openDrawer() {
    setState(() {
      xOffset = 270;
      yOffset = 150;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: closeDrawer,
        child: Container(
          child: Stack(
            children: <Widget>[
              CollectionDrawer(
                closeDrawer: closeDrawer,
                updateCollectionsList: _updateCollectionList,
              ),
              AnimatedContainer(
                height: double.maxFinite,
                transform: Matrix4.translationValues(xOffset, yOffset, 0)
                  ..scale(scaleFactor)
                  ..rotateY(isDrawerOpen ? -0.5 : 0),
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: kCollectionScreenBackgroundColor,
                  borderRadius: isDrawerOpen ? BorderRadius.circular(30) : null,
                ),
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        isDrawerOpen
                            ? IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () => closeDrawer())
                            : IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () => openDrawer()),
                        Text(
                          'Collections',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddCollectionScreen(
                                  updateCollectionList: _updateCollectionList);
                            }));
                          },
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: _collectionsList,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              SizedBox(
                                height: 200,
                              ),
                              Center(
                                  child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AddCollectionScreen(
                                        updateCollectionList:
                                            _updateCollectionList);
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.hourglass_empty,
                                        size: 54, color: Colors.black),
                                    Text(
                                      'Add a New Collection',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          );
                        }
                        return Container(
                          height: MediaQuery.of(context).size.height*0.87,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
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
                            },
                          ),
                        );
                      },
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
