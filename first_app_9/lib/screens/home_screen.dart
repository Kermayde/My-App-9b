import 'package:camera/camera.dart';
import 'package:first_app_9/screens/taken_picture_screen.dart';
import 'package:first_app_9/widgets/custom_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_app_9/helpers/database_helper.dart';
import 'package:first_app_9/models/cat_model.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription firstCamera;

  const HomeScreen({Key? key, required this.firstCamera}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textControllerRace = TextEditingController();
  final textControllerName = TextEditingController();
  int? catID; 

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
              controller: textControllerRace,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Input the race of the cat"),
            ),
            TextFormField(
              controller: textControllerName,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Input the name of the cat"),
            ),
            Center(
              child: (FutureBuilder<List<Cat>>(
                future: DatabaseHelper.instance.getCats(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Cat>> snapshot
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
                              child: const Text("No cats")
                              ),
                          )

                      :ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data!.map((cat) {
                          return Center(
                            child:ListTile(
                              title: Text('Name:${cat.name},| Race:${cat.race}'),
                              onTap: (){
                                setState(() {
                                  final route = MaterialPageRoute(builder: (context) => TakenPictureScreen(camera: widget.firstCamera,));
                                  Navigator.push(context, route);
                                  textControllerName.text = cat.name;
                                  textControllerName.text = cat.race;
                                  catID = cat.id;
                                });
                              },
                              onLongPress: (){
                                
                                setState(() {
                                  DatabaseHelper.instance.delete(cat.id!);
                                });
                              },
                            )
                          );
                        }).toList()
                      );
                  }
  })),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (catID != null){
            DatabaseHelper.instance.update(
              Cat(id: catID, race: textControllerRace.text, name: textControllerName.text)
            );
          }
          else{
            DatabaseHelper.instance.add(Cat(
            race: textControllerRace.text,
            name: textControllerName.text,
          ));
          }
          
          setState(() {
            textControllerRace.clear();
            textControllerName.clear();
          });
        },
      ),
    );
  }
}