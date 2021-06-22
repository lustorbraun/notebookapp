import 'package:flutter/material.dart';
import 'package:notebookapp/models/sample_models.dart';
import 'package:notebookapp/screens/sample_expanded_screen.dart';
import 'package:notebookapp/widgets/appclipper.dart';
import 'package:notebookapp/Constants/const.dart';

class SampleSlipSwiperScreen extends StatefulWidget {
  @override
  _SampleSlipSwiperScreenState createState() => _SampleSlipSwiperScreenState();
}

class _SampleSlipSwiperScreenState extends State<SampleSlipSwiperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Stack(
          children: <Widget>[
                Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: ListView.builder(
                      itemExtent: MediaQuery.of(context).size.width*0.8,
                      itemCount: planets.length,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return SampleExpandedScreen(
                              planetInfo: planets[index],
                              index: index,
                            );
                          }));
                          },
                          child: _buildSlip(index),
                        );
                      }
                  ),
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
                child: Text('',
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

  Widget _buildSlip(int index){
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
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                        ),
                        Text(
                          '${planets[index].name}',
                          style: kSlipTitleSlipTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
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
              '${index + 1}',
              style: TextStyle(
                  color: Colors.black12,
                  fontSize: 100,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: Image.asset(
                planets[index].iconImage,
              height: 200,
            )
          ),
        ],
      ),
    );
  }
}
