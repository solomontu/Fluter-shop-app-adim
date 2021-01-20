import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProviderModel with ChangeNotifier {
  Uuid uuId;
  String _id;
  String _productName;
  String _imageUrl;
  List<String> _colorsList;
  List<String> _sizeList;
  List<String> _imageList;
  List<String> _categoryList;
  String _categoryValue;
  String _brandValue;
  bool _sale;
  bool _featured;
  int _quantity;
  double _price;
  bool _blueColor;
  File _image1;
  File _image2;
  File _image3;

  ProviderModel(
      [this._productName,
      this._imageUrl,
      this._quantity,
      this._price,
      this._image1,
      this._image2,
      this._image3]) {
    _colorsList = [];
    _sizeList = [];
    _imageList = [];
    _categoryValue = 'Informal';
    _brandValue = 'Gucci';
    _featured = false;
    _sale = false;
    uuId = Uuid();
    _id = uuId.v1();
  }

  String get productName => _productName;
  String get id => _id;
  String get imageUrl => _imageUrl;
  List<String> get colorList => _colorsList;
  List<String> get sizeList => _sizeList;
  String get category => _categoryValue;
  List<String> get imageList => _imageList;
  String get brand => _brandValue;
  bool get featured => _featured;
  bool get sale => _sale;
  int get quantity => _quantity;
  double get price => _price;
  bool get blueColor => _blueColor;
  File get image1 => _image1;
  File get image2 => _image2;
  File get image3 => _image3;
  List get categoryList => _categoryList;

  set productName(String newproductName) {
    this._productName = newproductName;
    notifyListeners();
  }

  set id(String newId) {
    this._id = newId;
  }

  set imageUrl(String newimageUrl) {
    this._imageUrl = newimageUrl;
  }

  set colorList(List<String> newColors) {
    this._colorsList = newColors;
    notifyListeners();
  }

  set sizeList(List<String> newSizeList) {
    this._sizeList = newSizeList;
    notifyListeners();
  }

  set imageList(List<String> newImageList) {
    this._imageList = newImageList;
    notifyListeners();
  }

  set category(String newCategory) {
    this._categoryValue = newCategory;
    notifyListeners();
  }

  set brand(String newBrand) {
    this._brandValue = newBrand;
    notifyListeners();
  }

  set featured(bool newFeatured) {
    this._featured = newFeatured;
    notifyListeners();
  }

  set sale(bool newOnslae) {
    this._sale = newOnslae;
    notifyListeners();
  }

  set quantity(int newQuantity) {
    this._quantity = newQuantity;
    notifyListeners();
  }

  set price(double newPrice) {
    this._price = newPrice;
    notifyListeners();
  }

  set image1(File newImage1) {
    this._image1 = newImage1;
    notifyListeners();
  }

  set image2(File newImage2) {
    this._image2 = newImage2;
    notifyListeners();
  }

  set image3(File newImage3) {
    this._image3 = newImage3;
    notifyListeners();
  }

//FUNCTIONS
  addColor(String color) {
    if (_colorsList.contains(color) == false) {
      _colorsList.add(color);
      notifyListeners();
    }
  }

  removeColor(String color) {
    if (_colorsList.contains(color) == true) {
      _colorsList.remove(color);
      notifyListeners();
    }
  }

  checkBoxState(String value) {
    if (colorList.contains(value)) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  //ADD SIZES
  addSize(String size) {
    if (_sizeList.contains(size) == false) {
      _sizeList.add(size);
      notifyListeners();
    }
  }

  removeSize(String size) {
    if (_sizeList.contains(size) == true) {
      _sizeList.remove(size);
      notifyListeners();
    }
  }

  sizeCheckState(String value) {
    if (_sizeList.contains(value)) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

//FEATURESTATE
  bool featuredState() {
    if (_featured) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  featuredAction() {
    if (_featured) {
      notifyListeners();
      _featured = false;
    } else {
      notifyListeners();
      _featured = true;
    }
  }

  bool saleState() {
    if (!_sale) {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  saleAction() {
    if (_sale) {
      notifyListeners();
      _sale = false;
    } else {
      notifyListeners();
      _sale = true;
    }
  }

  // CONVERT TO MAP;
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['featured'] = _featured;
    map['sale'] = _sale;
    map['name'] = _productName;
    map['qty'] = _quantity;
    map['price'] = _price;
    map['category'] = _categoryValue;
    map['brands'] = _brandValue;
    map['colors'] = _colorsList;
    map['sizes'] = _sizeList;
    map['images'] = _imageList;
    return map;
  }

  ProviderModel.categoryFromSnapShot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    this._categoryList = data['Categories'];
    print(_categoryList.length);
  }

  ProviderModel.brandsFromSnapShot(DocumentSnapshot snapshot) {
    this._brandValue = snapshot['Brands'];
  }
}
