import 'package:flutter/material.dart';
import 'package:notebookapp/models/sample_models.dart';
import 'package:notebookapp/screens/sample_slip_screen.dart';

class SampleCollectionScreen extends StatefulWidget {
  @override
  _SampleCollectionScreenState createState() => _SampleCollectionScreenState();
}

class _SampleCollectionScreenState extends State<SampleCollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Text(
                'Sample Collections',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20,),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14,),
                  height: MediaQuery.of(context).size.height-120,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: collections.length,
                      itemExtent: 350,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return SampleSlipSwiperScreen();
                            }));
                          },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                              margin: EdgeInsets.only(bottom: 14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    collections[index].collectionImage,
                                    width: double.maxFinite,
                                  ),
                                  ListTile(
                                    title: Text(
                                      '${collections[index].collectionTitle}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
