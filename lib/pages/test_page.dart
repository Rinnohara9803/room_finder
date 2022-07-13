import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final List<XFile> _selectedImages = [];

  Future<void> _getUserPicture() async {
    ImagePicker _picker = ImagePicker();
    final images = await _picker.pickMultiImage();
    if (images == null) {
      return;
    }
    setState(() {
      _selectedImages.addAll(images);
    });
  }

  void showImageChooseOptions() async {
    await _getUserPicture().then((value) {
      if (_selectedImages.isEmpty) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _uploadFile() async {
    if (_selectedImages.isEmpty) {
      return;
    }
    List<String> imageUrls = [];
    for (var _selectedImage in _selectedImages) {
      var fileName = '';
      fileName = path.basename(_selectedImage.path);
      var destination = '';
      destination = 'files/$fileName';

      final ref = FirebaseStorage.instance.ref(destination);

      ref.putFile(File(_selectedImage.path)).then((p0) {
        print('Sagar');
      }).catchError((e) {
        print(
          e.toString(),
        );
      });

      String imageUrl = await FirebaseStorage.instance
          .ref('files/${path.basename(
            _selectedImage.path,
          )}')
          .getDownloadURL();
      imageUrls.add(
        imageUrl,
      );
      print(imageUrl);
    }
    // FirebaseFirestore.instance
    //     .collection('rentFloors')
    //     .doc('Sagar')    
    //     .get()
    //     .then((value) {
    //   print(value);
    // });
    await FirebaseFirestore.instance.collection('rentFloors').doc('Pagal').set(
      {
        'imageUrl': imageUrls,
      },
    ).then((value) {
      print('tad');
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _getUserPicture();
              },
              child: const Text(
                'Pick Images',
              ),
            ),
            if (_selectedImages.isNotEmpty)
              Text(
                'Tada',
              ),
            ElevatedButton(
              onPressed: () async {
                await _uploadFile();
              },
              child: const Text(
                'Upload Image',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
