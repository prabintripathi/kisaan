import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kisaan/components/BottomNavBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  int productCount = 4;

  getImageUrl() async {
    var user = auth.currentUser;
    if (user != null) {
      print('User: $user');
      try {
        return await _storage
            .ref()
            .child('folderName/fileName')
            .getDownloadURL();
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('No user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('मेरो उत्पादन'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 1,
            children: List<Widget>.generate(
                productCount,
                (index) => index < (productCount - 1)
                    ? Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 5,
                        child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(getImageUrl().toString()),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Text(
                              'Product',
                              textAlign: TextAlign.center,
                            ),
                         
                        ),

                      )
                    : GestureDetector(
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            child: Center(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/homepage');
                                  }),
                            ))))),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

// firebase.auth().onAuthStateChanged(function(user){
//   if(user){
//     print('user');
//   }
//   else{
//     print('no user');
//   }
// });
