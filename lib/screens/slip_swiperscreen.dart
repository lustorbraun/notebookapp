import 'package:flutter/cupertino.dart';
import 'package:notebookapp/database_provider/database_provider.dart';
import 'package:notebookapp/models/collectionsModel.dart';
import '../models/slipsModel.dart';
import '../screens/add_new_slipscreen.dart';
import '../screens/expanded_slip_screen.dart';
import 'package:flutter/material.dart';
import 'package:notebookapp/widgets/slip_tile.dart';

class SlipSwiperScreen extends StatefulWidget {
  Collection collection;
  SlipSwiperScreen({this.collection});
  @override
  _SlipSwiperScreenState createState() => _SlipSwiperScreenState();
}

class _SlipSwiperScreenState extends State<SlipSwiperScreen> {
  Future<List<Slip>> _slipsList ;

  @override
  void initState() {
    _updateSlipList();
    super.initState();
  }

  _updateSlipList() {
    setState(() {
      _slipsList = DatabaseHelper.instance.getSlipList(widget.collection.collectionid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddNewSlip(
                  updateSlipList: _updateSlipList,
                  collectionId: widget.collection.collectionid,
                );
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Color(int.parse(widget.collection.collectionColor)),
        ),
        child: Stack(
          children: <Widget>[
            FutureBuilder(
              future: _slipsList,
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return AddNewSlip(
                          updateSlipList: _updateSlipList,
                          collectionId: widget.collection.collectionid,
                        );
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.hourglass_empty,size: 54,color: Colors.black54),
                        Text(
                          'Hurry up!!make Slips',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),
                        ),
                      ],
                    ),
                  ));
                }
                final int totalSlipCount=snapshot.data.toList().length;
                return Container(
                  child: ListView.builder(
                      itemCount: totalSlipCount,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ExpandedSlipScreen(
                                    slip: snapshot.data[index],
                                    index: index,
                                  );
                                },
                              ),
                            );
                          },
                          child: SlipTile(
                            index: index,
                            slip: snapshot.data[index],
                            updatesliplist: _updateSlipList,
                          ),
                        );
                      }
                  ),
                );
              },
            ),
            Positioned(
              top: 20,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: (){
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            Positioned(
              top: 20,
              left: 50,
              child:Text(
                'Inspire',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            Positioned(
              top: 80,
              right: 20,
              child: Container(
                width: MediaQuery.of(context).size.width*0.7,
                child: Text('${widget.collection.collectionTitle}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
