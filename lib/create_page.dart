import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePage extends StatefulWidget {
  final FirebaseUser user;

  CreatePage(this.user);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final textEditingController = TextEditingController();

  File _image;

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(onPressed: _getImage,
      child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.send), onPressed: () {
            final firebaseStorageRef = FirebaseStorage.instance
                .ref()
                .child('post')
                .child('${DateTime.now().millisecondsSinceEpoch}.png'); // 현재시간의 milliseconds

          final task = firebaseStorageRef.putFile(
            _image, StorageMetadata(contentType: 'image/png'));

          task.onComplete.then((value) {
            var downloadUrl = value.ref.getDownloadURL();

            downloadUrl.then((uri) {
              var doc = Firestore.instance.collection('post').document(); // post collection을 만들고 새로운 문서를 만들것임
              doc.setData({
                'id': doc.documentID,
                'photoUrl': uri.toString(),
                'contents': textEditingController.text,
                'email': widget.user.email,
                'displayName': widget.user.displayName,
                'userPhotoUrl': widget.user.photoUrl
              }).then((onValue) {
                Navigator.pop(context); // 화면 닫고 이전 화면으로 돌아감
              });
            });
          });

        },
        )
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _image == null ? Text('No Image') : Image.file(_image),
          TextField(
            decoration: InputDecoration(hintText: '내용을 입력하세요'),
            controller: textEditingController,
          )
        ],
      ),
    );
  }

  Future _getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}
