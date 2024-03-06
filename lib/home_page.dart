import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String log = 'Selected media and logs will appear here',
      filePathInfo = 'Selected file paths will be shown here',
      filePath = 'Selected file paths will be shown here',
      fileType = '';
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? vidPlayController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        title: const Text('Image Picker Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 300,
              color: Colors.grey[500],
              child: Center(
                child: filePath == filePathInfo
                    ? Text(log, style: const TextStyle(color: Colors.white))
                    : fileType == 'image'
                        ? Image.file(
                            File(filePath),
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return const Center(
                                  child:
                                      Text('This image type is not supported'));
                            },
                          )
                        : Stack(
                            children: [
                              Center(
                                child: AspectRatio(
                                  aspectRatio:
                                      vidPlayController!.value.aspectRatio,
                                  child: VideoPlayer(vidPlayController!),
                                ),
                              ),
                              Center(
                                child: IconButton(
                                    onPressed: () {
                                      vidPlayController!.play();
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow_outlined,
                                      color: Colors.grey,
                                    )),
                              )
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 10),
            Text(filePath, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => handleImagePicking(ImageSource.gallery),
              child: const Text('Choose an image from gallery'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => handleVideoPicking(ImageSource.gallery),
              child: const Text('Choose a video from gallery'),
            ),
            const SizedBox(height: 10),
            if (_picker.supportsImageSource(ImageSource.camera))
              ElevatedButton(
                onPressed: () => handleImagePicking(ImageSource.camera),
                child: const Text('Capture an image using camera'),
              ),
            const SizedBox(height: 10),
            if (_picker.supportsImageSource(ImageSource.camera))
              ElevatedButton(
                onPressed: () => handleVideoPicking(ImageSource.camera),
                child: const Text('Capture a video using camera'),
              ),
            const SizedBox(height: 10),
            Text(
              'App developer: Zulfequar Ali\nEmail: developerzull@gmail.com',
              style: TextStyle(color: Colors.grey[900], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleImagePicking(ImageSource source) async {
    fileType = 'image';
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        if (pickedFile != null) {
          filePath = pickedFile.path;
        } else {
          filePath = filePathInfo;
          log = source == ImageSource.gallery
              ? 'No image picked'
              : 'No image captured';
        }
      });
    } catch (e) {
      String error = e.toString();
      setState(() {
        debugPrint(error);
        log = error;
      });
    }
  }

  Future<void> handleVideoPicking(ImageSource source) async {
    fileType = 'video';
    try {
      final XFile? pickedFile = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 30));
      setState(() {
        if (pickedFile != null) {
          filePath = pickedFile.path;
          vidPlayController = VideoPlayerController.file(File(filePath));
          vidPlayController!.initialize();
          vidPlayController!.setLooping(false);
          vidPlayController!.play();
        } else {
          filePath = filePathInfo;
          log = source == ImageSource.gallery
              ? 'No video picked'
              : 'No video captured';
        }
      });
    } catch (e) {
      String error = e.toString();
      setState(() {
        debugPrint(error);
        log = error;
      });
    }
  }
}
