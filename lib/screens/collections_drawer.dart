import 'package:flutter/material.dart';
import 'package:notebookapp/screens/add_new_collectionscreen.dart';
import 'package:notebookapp/screens/favouritesScreen.dart';
import 'package:notebookapp/screens/sample_collection_screen.dart';
import 'package:notebookapp/screens/loginScreen.dart';
import 'package:notebookapp/Constants/const.dart';

class CollectionDrawer extends StatelessWidget {
  Function updateCollectionsList;
  Function closeDrawer;
  CollectionDrawer({this.closeDrawer,this.updateCollectionsList});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCollectionDrawerColor         //shi hai??
      ),
      padding: EdgeInsets.only(top:50,bottom: 70,left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white70,
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UserName',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
                  Text('No. of Collections',style: TextStyle(color: Colors.white60,fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          Column(
            children: <Widget>[
              drawerItem(Icons.person_outline, 'Sample Collections',
                  SampleCollectionScreen(),
                  context),
              drawerItem(Icons.flight_takeoff, 'Go Online',
                  LoginScreen(),
                  context),
              drawerItem(Icons.add, 'Add Collection',
                  AddCollectionScreen(updateCollectionList: updateCollectionsList,),
                  context),
              drawerItem(Icons.favorite_border, 'Favourites',
                  FavouritesScreen(updatecollectionlist: updateCollectionsList,),
                  context),
              draweritem(Icons.info_outline, 'About Us'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.settings,color: Colors.white70,),
              SizedBox(width: 10,),
              Text('Settings',style:TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
              SizedBox(width: 10,),
              Container(width: 2,height: 20,color: Colors.white70,),
              SizedBox(width: 10,),
              Text('Log out',style:TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),)
            ],
          )
        ],
      ),
    );
  }

  Widget draweritem(IconData icon,String title){
    return Row(
      children: [
        Icon(icon,color: Colors.white70,size: 30,),
        SizedBox(width: 20,),
        Text(title,style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold,fontSize: 20))
      ],
    );
  }

  Widget drawerItem(IconData icon,String title,Widget page,BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return page;
        }));
        closeDrawer();
      },
      child: Row(
        children: [
          Icon(icon,color: Colors.white70,size: 30,),
          SizedBox(width: 20,),
          Text(title,style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold,fontSize: 20))
        ],
      ),
    );
  }
}
