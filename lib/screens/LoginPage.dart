import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;

  Future<void> _createUser() async {
    try {
      print('Email: $_email Password: $_password');
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      print('User: $userCredential');
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    } catch (e) {
      print('Error: $e');
    }

    Map<String, dynamic> userData = {'Email': '$_email'};
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('_user');
    collectionReference.add(userData);
  }

  Future<void> _logIn() async {
    try {
      print('Email: $_email Password: $_password');
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      print('User: $userCredential');
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'किसानको खाता',
          textScaleFactor: 1.5,
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'कृपया आफ्नो खाता खोल्नुहोस्',
                textScaleFactor: 1.5,
              ),
              TextField(
                onChanged: (value) {
                  _email = value;
                },
                decoration: InputDecoration(
                    labelText: 'ईमेल', hintText: 'आफ्नो ईमेल टाइप गर्नुहोस्'),
              ),
              TextField(
                onChanged: (value) {
                  _password = value;
                },
                decoration: InputDecoration(
                    labelText: 'पासवर्ड',
                    hintText: 'आफ्नो पासवर्ड टाइप गर्नुहोस्'),
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      _logIn();
                    },
                    child: Text(
                      'पुरानै खाता',
                      textScaleFactor: 1.25,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _createUser();
                    },
                    child: Text(
                      'नयाँ खाता',
                      textScaleFactor: 1.25,
                    ),
                  )
                ],
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/homepage');
                  },
                  child: Text('पासवर्ड बिर्सनुभयो?'))
            ],
          ),
        ),
      ),
    );
  }
}
