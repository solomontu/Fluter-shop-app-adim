// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BrandServices {
  String collationName = 'Brands';
  //Create categories
  Future createBrand(String name) async {
    var id = Uuid();
    String brandId = id.v1();
    await FirebaseFirestore.instance
        .collection(collationName)
        .doc(brandId)
        .set({'Brand': name});
  }
}
