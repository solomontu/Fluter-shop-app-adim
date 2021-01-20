import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_admin/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shop_app_admin/db/products.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'model.dart';

// import 'package:event/event.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<String> sellectedProdutSizes = [];
  ProductServices _productServices = ProductServices();
  final _poductFormKey = GlobalKey<FormState>();
  // final _productNameController = TextEditingController();
  // final _productQuantityController = TextEditingController();
  // final _productPriceController = TextEditingController();

  bool isLoading = false;

  //Image holder
  final picker = ImagePicker();
  // File file;
  // File _image1;
  // File _image2;
  // File _image3;
  //the bellow was set to listened event in validaton method. the state of
  //upload event was use to build the visible widget.
  var streamSubscriptionImage1;
  var streamSubscriptionImage2;
  var streamSubscriptionImage3;
  // List<Widget> children;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderModel>(context);

    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onTap: () => Navigator.pop(context),
          ),
          elevation: 0,
          title: Text(
            'Add products',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: kWhiteColor,
        ),

        //porduct attribute
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _poductFormKey,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      imagePlaceHolder('image1', provider),
                      imagePlaceHolder('_image2', provider),
                      imagePlaceHolder('_image3', provider),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text('avaibeable colours'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Featured'),
                              Switch(
                                  value: provider.featuredState(),
                                  onChanged: (bool value) {
                                    provider.featuredAction();
                                  })
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          Row(
                            children: [
                              Text('sale'),
                              Switch(
                                  value: provider.saleState(),
                                  onChanged: (bool value) {
                                    provider.saleAction();
                                  })
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                        ],
                      )
                    ],
                  ),

                  //product name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextFormField(
                      // controller: _productNameController,
                      // onChanged: _productName(provider),
                      onChanged: (value) {
                        provider.productName = value;
                      },
                      maxLength: 10,
                      validator: (value) =>
                          value.isEmpty ? 'Name is requred' : null,
                      decoration: InputDecoration(
                        hintText: 'Product name',
                      ),
                    ),
                  ),

                  //pruoduct quantity
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            // onChanged: _productQty(provider),
                            keyboardType: TextInputType.number,
                            // controller: _productQuantityController,
                            onChanged: (newValue) {
                              provider.quantity = int.parse(newValue);
                            },
                            maxLength: 10,
                            validator: (value) =>
                                value.isEmpty ? 'Quantity is required' : null,
                            decoration: InputDecoration(
                              hintText: 'Product quantity',
                            ),
                          ),
                        ),
                      ),
                      //Product price
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            // controller: _productPriceController,
                            // onChanged: (value) => _productPrice(provider),
                            onChanged: (newValue) {
                              provider.price = double.parse(newValue);
                            },
                            maxLength: 10,
                            validator: (value) =>
                                value.isEmpty ? 'Price is required' : null,
                            decoration: InputDecoration(
                              hintText: 'Product price',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //category listTile;
                        Expanded(
                          child: Card(
                            child: ListTile(
                                title: Text(
                                  'Category',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[600]),
                                ),
                                subtitle: FutureBuilder<QuerySnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('Categories')
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Something went wrong");
                                    }

                                    if (snapshot.hasData) {
                                      final List<DocumentSnapshot> documents = snapshot.data.docs;
                                      return DropdownButton(
                                        underline: SizedBox(),
                                        value: provider.category,
                                        isDense: true,
                                        hint: Text('Sellect'),
                                        onChanged: (newValue) {
                                          provider.category = newValue;
                                        },
                                        items: snapshot.data.docs != null
                                            ? documents.map(
                                                (DocumentSnapshot
                                                    documentSnapshot) {
                                                return DropdownMenuItem<String>(
                                                    value: documentSnapshot.data
                                                        .toString(),
                                                    child: Text(
                                                      documentSnapshot.data
                                                          .toString(),
                                                    ));
                                              }).toList()
                                            : DropdownMenuItem(
                                                value: 'null',
                                                child: new Container(
                                                  height: 100.0,
                                                  child: new Text(
                                                      'Creat category'),
                                                ),
                                              ),
                                      );
                                      
                                    }
                                

                                    return Text("loading");
                                  },
                                )

                                // DropdownButton<String>(
                                //   value: provider.category,
                                //   style: TextStyle(color: Colors.deepPurple),
                                //   underline: Container(
                                //     height: 2,
                                //     color: Colors.deepPurpleAccent,
                                //   ),
                                //   onChanged: (newValue) {
                                //     provider.category = newValue;
                                //   },
                                //   items: provider.categoryList
                                //       .map<DropdownMenuItem<String>>((value) {
                                //     return DropdownMenuItem<String>(
                                //       value: value,
                                //       child: Text(value),
                                //     );
                                //   }).toList(),
                                // )

                                // StreamBuilder(
                                //     stream: FirebaseFirestore.instance
                                //         .collection('Categories')
                                //         .snapshots(),
                                //     builder: (context,
                                //         AsyncSnapshot<QuerySnapshot> snapshot) {
                                //       return DropdownButton(
                                //         underline: SizedBox(),
                                //         value: provider.category,
                                //         isDense: true,
                                //         hint: Text('Sellect'),
                                //         onChanged: (newValue) {
                                //           provider.category = newValue;
                                //         },
                                //         items: snapshot.data.docs != null
                                //             ? snapshot.data.docs.map(
                                //                 (DocumentSnapshot
                                //                     documentSnapshot) {
                                //                 return DropdownMenuItem<String>(
                                //                     value: documentSnapshot.data
                                //                         .toString(),
                                //                     child: Text(
                                //                       documentSnapshot.data
                                //                           .toString(),
                                //                     ));
                                //               }).toList()
                                //             : DropdownMenuItem(
                                //                 value: 'null',
                                //                 child: new Container(
                                //                   height: 100.0,
                                //                   child:
                                //                       new Text('Creat category'),
                                //                 ),
                                //               ),
                                //       );
                                //     }),
                                ),
                          ),
                        ),

                        //Brand listTile;
                        Expanded(
                          child: Card(
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8.0),
                              title: Text('Brand',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[600])),
                              subtitle: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Brands')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    return DropdownButton<String>(
                                      underline: SizedBox(),
                                      value: provider.brand,
                                      isDense: true,
                                      hint: Text('Sellect'),
                                      onChanged: (newValue) {
                                        // setState(() {
                                        provider.brand = newValue;
                                        // });
                                      },
                                      items: snapshot.data != null
                                          ? snapshot.data.docs
                                              .map((DocumentSnapshot document) {
                                              return new DropdownMenuItem<
                                                      String>(
                                                  value:
                                                      document.data.toString(),
                                                  child: new Text(
                                                    document.data.toString(),
                                                  ));
                                            }).toList()
                                          : DropdownMenuItem(
                                              value: 'null',
                                              child: new Container(
                                                height: 100.0,
                                                child: new Text(
                                                    'Awaintg category values'),
                                              ),
                                            ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //MATERIAL BUTTON FOR SIZES dialogue
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Card(
                            child: MaterialButton(
                              onPressed: () async {
                                await buildShowDialog(context, provider);
                              },
                              child: Text(
                                'Colors',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                      ), //MATERIAL BUTTON FOR SIZES dialogue
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Card(
                            child: MaterialButton(
                              onPressed: () {
                                sellectSizes(provider);
                                sellectedProdutSizes.clear();
                              },
                              child: Text(
                                'Sizes',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Save form button with validation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                        onPressed: () async {
                          addProduct(context, provider);
                          print(provider.brand);
                          print(provider.category);
                          print(provider.featured);
                          print(provider.sale);
                          print(provider.colorList);
                          print(provider.sizeList);
                          print("'Name: '${provider.productName}");
                          print("'quantity: '${provider.quantity}");
                          print("'price: '${provider.price}");
                        },
                        color: Colors.blue,
                        child: Text(
                          'Add product',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )),
                  )
                ],
              ),
            ),
          ),
          isLoading == true
              ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white60,
                    height: double.infinity,
                    width: double.infinity,
                    child: Positioned(
                      top: 50,
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 50),
                          Text('Loading.....',
                              style: TextStyle(color: Colors.blueGrey))
                        ],
                      ),
                    ),
                  ),
                )
              : Container()
        ]));
  }

  Future<void> buildShowDialog(
      BuildContext context, ProviderModel provider) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Availeble colours'),
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Wrap(runSpacing: 5.0, spacing: 5.0, children: [
                CircularCheckBox(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    value: provider.checkBoxState('blue'),
                    inactiveColor: Colors.blue,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      setState(() {
                        provider.colorList.contains('blue')
                            ? provider.removeColor('blue')
                            : provider.addColor('blue');
                      });
                    }),
                CircularCheckBox(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    value: provider.checkBoxState('orange'),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    inactiveColor: Colors.orange,
                    activeColor: Colors.orange,
                    onChanged: (bool value) {
                      setState(() {
                        provider.colorList.contains('orange')
                            ? provider.removeColor('orange')
                            : provider.addColor('orange');
                      });
                    }),
                CircularCheckBox(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    value: provider.checkBoxState('purple'),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    inactiveColor: Colors.purple,
                    activeColor: Colors.purple,
                    onChanged: (bool value) {
                      setState(() {
                        provider.colorList.contains('purple')
                            ? provider.removeColor('purple')
                            : provider.addColor('purple');
                      });
                    }),
                CircularCheckBox(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    value: provider.checkBoxState('yellow'),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    inactiveColor: Colors.yellow,
                    activeColor: Colors.yellow,
                    onChanged: (bool value) {
                      setState(() {
                        provider.colorList.contains('yellow')
                            ? provider.removeColor('yellow')
                            : provider.addColor('yellow');
                      });
                    }),
                CircularCheckBox(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    value: provider.checkBoxState('pink'),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    inactiveColor: Colors.pink,
                    activeColor: Colors.pink,
                    onChanged: (bool value) {
                      setState(() {
                        provider.colorList.contains('pink')
                            ? provider.removeColor('pink')
                            : provider.addColor('pink');
                      });
                    }),
              ]);
            }),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    // print(sellectedProdutSizes.length);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.redAccent),
                  )),
            ],
            actionsPadding: EdgeInsets.symmetric(horizontal: 30.0),
          );
        });
  }

  /*For image picker to work; ensure u iMPORT DART:IO */
  //IMAGE PICKER HANDLER
  Future getImage(String image, ProviderModel provider) async {
    try {
      var pickedFile = await picker.getImage(source: ImageSource.gallery);
      switch (image) {
        case 'image1':
          setState(() {
            provider.image1 = File(pickedFile.path);
          });
          break;
        case '_image2':
          setState(() {
            provider.image2 = File(pickedFile.path);
          });
          break;
        case '_image3':
          setState(() {
            provider.image3 = File(pickedFile.path);
          });
          break;
        default:
      }
    } catch (e) {
      print(e);
    }
  }

  //show image or icon
  Widget image(String img, ProviderModel provider) {
    var displayImage;
    if (img == 'image1') {
      if (provider.image1 == null) {
        displayImage =
            Icon(Icons.camera_alt, color: Colors.grey.withOpacity(0.9));
      } else {
        setState(() {
          displayImage = Image.file(provider.image1,
              fit: BoxFit.fill, width: double.infinity);
        });
      }
    }
    //image 2
    if (img == '_image2') {
      if (provider.image2 == null) {
        displayImage =
            Icon(Icons.camera_alt, color: Colors.grey.withOpacity(0.9));
      } else {
        setState(() {
          displayImage = Image.file(provider.image2,
              fit: BoxFit.fill, width: double.infinity);
        });
      }
    }
    //image 3
    if (img == '_image3') {
      if (provider.image3 == null) {
        return Icon(Icons.camera_alt, color: Colors.grey.withOpacity(0.9));
      } else {
        setState(() {
          displayImage = Image.file(provider.image3,
              fit: BoxFit.fill, width: double.infinity);
        });
      }
    }
    return displayImage;
  }

  // Image plceholder
  Widget imagePlaceHolder(String imgPickerWget, ProviderModel provider) {
    return Expanded(
      child: GestureDetector(
        onTap: () => getImage(imgPickerWget, provider),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            height: 80,
            width: 60,
            child: image(imgPickerWget, provider),
          ),
        ),
      ),
    );
  }

  //SIZES DIALOGUE
  sellectSizes(ProviderModel provider) async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Availeble sizes'),

            //str
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(child: Text('XS')),
                      Flexible(
                        child: Checkbox(
                            value: provider.sizeCheckState('xs'),
                            onChanged: (value) {
                              setState(() {
                                provider.sizeList.contains('xs')
                                    ? provider.removeSize('xs')
                                    : provider.addSize('xs');
                              });
                            }),
                      ),
                      Flexible(child: Text('S')),
                      Flexible(
                        child: Checkbox(
                            value: provider.sizeCheckState('s'),
                            onChanged: (value) {
                              setState(() {
                                provider.sizeList.contains('s')
                                    ? provider.removeSize('s')
                                    : provider.addSize('s');
                              });
                            }),
                      ),
                      Flexible(child: Text('M')),
                      Flexible(
                        child: Checkbox(
                            value: provider.sizeCheckState('m'),
                            onChanged: (value) {
                              setState(() {
                                provider.sizeList.contains('m')
                                    ? provider.removeSize('m')
                                    : provider.addSize('m');
                              });
                            }),
                      ),
                    ],
                  ),
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(child: Text('L')),
                      Flexible(
                        child: Checkbox(
                            value: provider.sizeCheckState('l'),
                            onChanged: (value) {
                              setState(() {
                                provider.sizeList.contains('l')
                                    ? provider.removeSize('l')
                                    : provider.addSize('l');
                              });
                            }),
                      ),
                      Flexible(child: Text('XL')),
                      Flexible(
                        child: Checkbox(
                            value: provider.sizeCheckState('xl'),
                            onChanged: (value) {
                              setState(() {
                                provider.sizeList.contains('xl')
                                    ? provider.removeSize('xl')
                                    : provider.addSize('xl');
                              });
                            }),
                      ),
                      Flexible(child: Text('XXL')),
                      Flexible(
                        child: Checkbox(
                            value: provider.sizeCheckState('xxl'),
                            onChanged: (value) {
                              setState(() {
                                provider.sizeList.contains('xxl')
                                    ? provider.removeSize('xxl')
                                    : provider.addSize('xxl');
                              });
                            }),
                      ),
                    ],
                  ),
                ],
              );
            }),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    print(sellectedProdutSizes.length);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.redAccent),
                  )),
            ],
            actionsPadding: EdgeInsets.symmetric(horizontal: 30.0),
          );
        });
  }

//ad prodct function
  void addProduct(BuildContext context, ProviderModel provider) async {
    FormState formState = _poductFormKey.currentState;
    if (formState.validate()) {
      assert(
          provider.image1 != null &&
              provider.image2 != null &&
              provider.image3 != null,
          Fluttertoast.showToast(
              msg: 'Requress three product imgaes', backgroundColor: kRedColr));
      assert(
          provider.category != null,
          Fluttertoast.showToast(
              msg: 'Reques product category', backgroundColor: kRedColr));
      assert(
          provider.sizeList.isNotEmpty,
          Fluttertoast.showToast(
              msg: 'Reques product sizes', backgroundColor: kRedColr));

      assert(
          provider.colorList.isNotEmpty,
          Fluttertoast.showToast(
              msg: 'Requires product colors', backgroundColor: kRedColr));

      setState(() {
        isLoading = true;
      });

      //Processing the image upload
      // Future<String> imageUrl1;
      // Future<String> imageUrl2;
      // String imageUrl3;
      // List<String> imageList = [];

      ///////////////////////////////////////////Imge 1
      // FirebaseStorage storage;
      var downloadUrl1;
      final String picture1Name1 =
          '1${DateTime.now().millisecondsSinceEpoch.toString()}';
      firebase_storage.Reference storageReference1 =
          firebase_storage.FirebaseStorage.instance.ref().child(picture1Name1);
      final firebase_storage.UploadTask uploadTask1 =
          storageReference1.putFile(provider.image1);

      final firebase_storage.TaskSnapshot snapshot1 = uploadTask1.snapshot;
      final firebase_storage.TaskState state1 = snapshot1.state;
      if (state1 == firebase_storage.TaskState.success) {
        downloadUrl1 = await snapshot1.ref.getDownloadURL();
      }

      // final String picture1Name1 =
      //       '1${DateTime.now().millisecondsSinceEpoch.toString()}';
      //   final StorageReference storageReference1 =
      //       FirebaseStorage().ref().child(picture1Name1);
      //   final StorageUploadTask uploadTask1 =
      //       storageReference1.putFile(provider.image1);
      //   StorageTaskSnapshot snapshot1 = await uploadTask1.onComplete;
      //   var downloadUrl1 = await snapshot1.ref.getDownloadURL();

      ////////////////////////////////////////////Imge 2
      var downloadUrl2;
      final String picture1Name2 =
          '2${DateTime.now().millisecondsSinceEpoch.toString()}';
      firebase_storage.Reference storageReference2 =
          firebase_storage.FirebaseStorage.instance.ref().child(picture1Name2);
      final firebase_storage.UploadTask uploadTask2 =
          storageReference2.putFile(provider.image2);
      final firebase_storage.TaskSnapshot snapshot2 = uploadTask2.snapshot;
      final firebase_storage.TaskState state2 = snapshot2.state;
      if (state2 == firebase_storage.TaskState.success) {
        downloadUrl2 = await snapshot1.ref.getDownloadURL();
      }

      // final String picture1Name2 =
      //     '2${DateTime.now().millisecondsSinceEpoch.toString()}';
      // final StorageReference storageReference2 =
      //     FirebaseStorage().ref().child(picture1Name2);
      // final StorageUploadTask uploadTask2 =
      //     storageReference2.putFile(provider.image2);
      // StorageTaskSnapshot snapshot2 = await uploadTask2.onComplete;
      // var downloadUrl2 = await snapshot2.ref.getDownloadURL();

      /////////////////////////////////////////////Imge 3
      var downloadUrl3;
      final String picture1Name3 =
          '2${DateTime.now().millisecondsSinceEpoch.toString()}';
      firebase_storage.Reference storageReference3 =
          firebase_storage.FirebaseStorage.instance.ref().child(picture1Name3);
      final firebase_storage.UploadTask uploadTask3 =
          storageReference3.putFile(provider.image3);
      final firebase_storage.TaskSnapshot snapshot3 = uploadTask3.snapshot;
      final firebase_storage.TaskState state3 = snapshot3.state;
      if (state3 == firebase_storage.TaskState.success) {
        downloadUrl3 = await snapshot3.ref.getDownloadURL();
      }

      // final String picture1Name3 =
      //     '3${DateTime.now().millisecondsSinceEpoch.toString()}';
      // final StorageReference storageReference3 =
      //     FirebaseStorage().ref().child(picture1Name3);
      // final StorageUploadTask uploadTask3 =
      //     storageReference3.putFile(provider.image3);
      // StorageTaskSnapshot snapshot3 = await uploadTask3.onComplete;
      // var downloadUrl3 = await snapshot3.ref.getDownloadURL();

      // if (uploadTask1.isComplete &&
      //     uploadTask2.isComplete &&
      //     uploadTask3.isComplete) {
      //   imageUrl1 = downloadUrl1.toString();
      //   imageUrl2 = downloadUrl2.toString();
      //   imageUrl3 = downloadUrl3.toString();

      provider.imageList.addAll([downloadUrl1, downloadUrl2, downloadUrl3]);
      //  provider.imageList.addAll([imageUrl1, imageUrl2, imageUrl3]);

      _productServices
          .createProduct(
        provider.toMap(),
      )
          .then((value) {
        value = false;
        setState(() {
          isLoading = value;
        });
      });
      formState.reset();
      Fluttertoast.showToast(msg: 'Product added', backgroundColor: kRedColr);
      Navigator.pop(context);
    }
    return null;
  }
}

// _productName(ProviderModel provider) {
//   provider.productName = _productNameController.text;
// }

// _productQty(ProviderModel provider) {
//   provider.quantity = int.parse(_productQuantityController.text);
// }

// _productPrice(ProviderModel provider) {
//   provider.price = double.parse(_productPriceController.text);
// }
// }
// uploadTask3.onComplete.then((snapshot3) async {
//   imageUrl1 = await snapshot1.ref.getDownloadURL();
//   imageUrl2 = await snapshot2.ref.getDownloadURL();
//   imageUrl3 = await snapshot3.ref.getDownloadURL();

//   _productServices.createProduct(
//       productName: _productNameController.text,
//       quantity: int.parse(_productQuantityController.text),
//       price: double.parse(_productPriceController.text),
//       category: _categoryValue,
//       brand: _brandValue,
//       size: sellectedProdutSizes,
//       image: imageList);
// });
// _poductFormKey.currentState.reset();

// final StreamSubscription<StorageTaskEvent> streamSubscription =
//     uploadTask.events.listen((event) {
//   // You can use this to notify yourself or your user in any kind of way.
//   // For example: you could use the uploadTask.events stream in a StreamBuilder instead
//   // to show your user what the current status is. In that case, you would not need to cancel any
//   // subscription as StreamBuilder handles this automatically.

//   // Here, every StorageTaskEvent concerning the upload is printed to the logs.
//   print('EVENT ${event.type}');
// });

// Cancel your subscription when done.
// await uploadTask.onComplete;
// streamSubscription.cancel();
