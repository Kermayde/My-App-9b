import 'dart:ffi';
import 'package:first_app_9/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakenPictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakenPictureScreen({super.key, required this.camera});

  @override
  State<TakenPictureScreen> createState() => _TakenPictureScreenState();
}

class _TakenPictureScreenState extends State<TakenPictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState(){
    super.initState();


    _controller = CameraController(
      widget.camera, 
      ResolutionPreset.ultraHigh
      );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState ==ConnectionState.done){
            return CameraPreview(_controller);
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          try{
            await _initializeControllerFuture;

            final image = await _controller.takePicture();
            Directory? documentDirectory = await getExternalStorageDirectory();
            String path = join(documentDirectory!.path, image.name);
            image.saveTo(path);
            
            if(!mounted){
              return;
            }


            await Navigator.of(context).push(
              MaterialPageRoute(
                builder:(context)=>ResultScreen(
                  imagePhath:image.path,
                  camera: widget.camera,
                )
              )
            );
          }
          catch(e){
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}


class ResultScreen extends StatelessWidget {
  final String imagePhath;
  final CameraDescription camera;

  const ResultScreen({Key? key, required this.imagePhath, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the picture')),
      body: Center(
        child: Column(
          children: [
            Image.file(File(imagePhath)),
            GestureDetector(
              onTap:() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      firstCamera: camera
                    )
                  )
                );
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.black
                ),
                child: const Text("Next",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}