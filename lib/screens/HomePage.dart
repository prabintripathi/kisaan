import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:kisaan/components/BottomNavBar.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _items = [
    'दुग्धजन्य',
    'हरियो सागपात',
    'फलफूल',
    'दलहन',
    'तेलहन',
    'अनाज',
    'अन्य',
  ];
  String productName;
  String productCategory;
  String productPrice;
  String imageUrl;
  File _image;

  final _storage = FirebaseStorage.instance;
  CollectionReference productDetails =
      FirebaseFirestore.instance.collection('Product Details');

  Future _getImage() async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      var tasbir = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = tasbir;
      });
    } else {
      print('Grant permission and try again');
    }
  }

  uploadImage() async {
    var file = File(_image.path);
    if (_image != null) {
      var snapshot =
          await _storage.ref().child('folderName/fileName').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        print('photo added');
        return imageUrl;

      });
    }
  }

  Future<void> _addProduct() {
    return productDetails
        .add({
          'Product Name': productName,
          'Product Category': productCategory,
          'Product Price': productPrice,
          //'Product Image': _image,
        })
        .then((value) => print("Product Added"))
        .catchError((error) => print("Failed to add product: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent[100],
        appBar: AppBar(
          title: Text('आफ्नो काम, आफ्नै दाम!'),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                (_image != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _image,
                          fit: BoxFit.fill,
                          height: 200,
                          width: 200,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black26, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.photo,
                          color: Colors.white,
                        )),
                        height: 100,
                        width: 100,
                      ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    decoration: InputDecoration(
                      labelText: 'उत्पादनको नाम',
                      border: OutlineInputBorder(),
                      hintText: 'जस्तैः धान, मकै, काउली, उखू, आदि',
                    ),
                    onChanged: (value) {
                      productName = value;
                    }),
                SizedBox(
                  height: 10,
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'उत्पादनको प्रकार',
                    hintText: 'उत्पादनको प्रकार',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        elevation: 1,
                        isExpanded: true,
                        isDense: true,
                        value: productCategory,
                        items: _items.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (selectedItem) => setState(
                              () => productCategory = selectedItem,
                            )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    decoration: InputDecoration(
                      labelText: 'उत्पादनको मूल्य (प्रति क्विन्टल)',
                      border: OutlineInputBorder(),
                      hintText: 'रू. 00/-',
                    ),
                    onChanged: (value) {
                      productPrice = value;
                    }),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    child: InputDecorator(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'उत्पादनको फोटो',
                            ),
                            Icon(Icons.add_a_photo),
                          ],
                        )),
                    onTap: () {
                      _getImage();
                    }),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                    height: 100,
                    minWidth: double.infinity,
                    textColor: Colors.black,
                    color: Colors.red,
                    child: Text('ठिक छ'),
                    onPressed: () async {
                      _addProduct();
                      uploadImage();
                    }),

              ]),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar());
  }
}
