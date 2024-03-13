import 'dart:io';

import 'package:bifappp/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bifappp/service.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  Service _service = Service();
  TextEditingController _controllername = TextEditingController();
  TextEditingController _controllerphonenumber = TextEditingController();
  String? imageFilePath;

  Future<void> pickImage(ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(source: source);
      if (file == null) return;
      File imageFile = File(file.path);
      String filename = DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceroot = FirebaseStorage.instance.ref();
      Reference imagefolder = referenceroot.child("images");
      Reference imagefile = imagefolder.child(filename);

      try {
        await imagefile.putFile(imageFile);
        String imageUrl = await imagefile.getDownloadURL();
        setState(() {
          imageFilePath = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Add Contact'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controllername,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter a name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _controllerphonenumber,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter a phone number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.camera),
                  child: const Text('From Camera'),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickImage(ImageSource.gallery),
                    child: const Text('From Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Center(
              child: TextButton(
                onPressed: () {
                  if (imageFilePath != null) {
                    _service.addtofirestore(user(
                      name: _controllername.text.trim(),
                      phonenumber: _controllerphonenumber.text.trim(),
                      imageurl: imageFilePath!,
                    ));
                    Navigator.of(context).pop();
                  } else {
                    print('Image file path is null');
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
