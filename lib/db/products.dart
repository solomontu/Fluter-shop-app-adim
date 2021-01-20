// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProductServices {
  String collationName = 'Products';
//      FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
// FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: secondaryApp);
  //Create categories
  Future createProduct( Map<String,dynamic> map) async {
 
    var id = Uuid();
    String productId = id.v1();
    await FirebaseFirestore.instance
        .collection(collationName)
        .doc(productId)
        .set(map);
  }
}
