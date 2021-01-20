// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../model.dart';

class CategoryServices {
  String collationName = 'Categories';
  //Create categories
  Future createCategory(String name) async {
    var id = Uuid();
    String categoryId = id.v1();

    await FirebaseFirestore.instance
        .collection(collationName)
        .doc(categoryId)
        .set({'Category': name});
  }

    FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<ProviderModel>> getCategories() {
    return _firestore
        .collection('Categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<ProviderModel> featuredProducts = [];
      querySnapshot.docs.map((snapShot) {
        return featuredProducts.add(ProviderModel.categoryFromSnapShot(snapShot));
      });
      return featuredProducts;
    });
  }
}
