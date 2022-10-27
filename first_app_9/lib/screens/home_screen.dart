import 'dart:io';

import 'package:camera/camera.dart';
import 'package:first_app_9/screens/taken_picture_screen.dart';
import 'package:first_app_9/widgets/custom_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_app_9/helpers/database_helper.dart';
import 'package:first_app_9/models/cat_model.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription firstCamera;
  final String ImagePhath;

  const HomeScreen({Key? key,required this.ImagePhath, required this.firstCamera}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textControllerDescription = TextEditingController();
  final textControllerType = TextEditingController();
  final textControllerNature = TextEditingController();
  final textControllerSize = TextEditingController();
  final textControllerDistance = TextEditingController();
  int? planetID; 
  final textControllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite Database"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: textControllerName,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Type the celestial body Name."),
            ),

            TextFormField(
              controller: textControllerDescription,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Type the celestial body description."),
            ),

            TextFormField(
              controller: textControllerType,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Type the celestial body type."),
            ),

            TextFormField(
              controller: textControllerNature,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Type the celestial body nature."),
            ),

            TextFormField(
              controller: textControllerSize,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Type the celestial body size."),
            ),

            TextFormField(
              controller: textControllerDistance,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Type the celestial body distance."),
            ),
            
            Center(
              child: (FutureBuilder<List<Planet>>(
                future: DatabaseHelper.instance.getPlanets(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Planet>> snapshot
                  ){
                    if(!snapshot.hasData){
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Loading"),
                        ),);
                    }
                    else{
                          return snapshot.data!.isEmpty ?
                          Center(
                            child: Container(
                              child: const Text("No celestial bodys")
                              ),
                          )

                      :ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data!.map((planet) {
                          return Center(
                            child:ListTile(
                              title: Row(children: [Container(child: Image.file(File(planet.Image)), height: 50, width: 50,), Container(child: Text('Name:${planet.Name},| Description:${planet.Description},| Type:${planet.Type},| Nature:${planet.Nature},| Size:${planet.Size},| Distance:${planet.Distance}'),width: 150,)],),
                              onTap: (){
                                setState(() {
                                  final route = MaterialPageRoute(builder: (context) => TakenPictureScreen(camera: widget.firstCamera,));
                                  Navigator.push(context, route);
                                  textControllerDescription.text = planet.Description;
                                  textControllerType.text = planet.Type;
                                  textControllerNature.text = planet.Nature;
                                  textControllerSize.text = planet.Size;
                                  textControllerDistance.text = planet.Distance;
                                  planetID = planet.id;
                                  textControllerName.text = planet.Name;
                                });
                              },
                              onLongPress: (){
                                
                                setState(() {
                                  DatabaseHelper.instance.delete(planet.id!);
                                });
                              },
                            )
                          );
                        }).toList()
                      );
                  }
                }
              )
            ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (planetID != null){
            DatabaseHelper.instance.update(
              Planet(id: planetID, Description: textControllerDescription.text, Type: textControllerType.text, Nature: textControllerNature.text, Size: textControllerSize.text, Distance: textControllerDistance.text, Image: widget.ImagePhath, Name: textControllerName.text,)
            );
          }
          else{
            DatabaseHelper.instance.add(Planet(
            Description: textControllerDescription.text,
            Type: textControllerType.text,
            Nature: textControllerNature.text,
            Size: textControllerSize.text,
            Distance: textControllerDistance.text,
            Image: widget.ImagePhath,
            Name: textControllerName.text,
          ));
          }
          
          setState(() {
            textControllerDescription.clear();
            textControllerType.clear();
            textControllerNature.clear();
            textControllerSize.clear();
            textControllerDistance.clear();
          });
        },
      ),
    );
  }
}