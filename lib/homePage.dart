import 'package:flutter/material.dart';
import './constants/constants.dart';
import 'db/brand.dart';
import 'db/category.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';

import 'addProduct.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum Page { dashboard, manage }
// enum Orientation { portrait, landscape }

class _MyHomePageState extends State<MyHomePage> {
  Page selectedPage = Page.dashboard;
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();
  final _brandFormKey = GlobalKey<FormState>();
  final _categoryFormKey = GlobalKey<FormState>();
  final _categoryDbs = CategoryServices();
  final _brandDbs = BrandServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.dashboard,
                    color: selectedPage == Page.dashboard
                        ? kActivecolor
                        : kinActivecolor,
                  ),
                  label: Text(
                    'Dash',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedPage = Page.dashboard;
                    });
                  },
                ),
              ),
              Flexible(
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.sort,
                    color: selectedPage == Page.manage
                        ? kActivecolor
                        : kinActivecolor,
                  ),
                  label: Text(
                    'Manage',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedPage = Page.manage;
                    });
                  },
                ),
              ),
            ]),
      ),
      body: bodi(),
    );
  }

  Widget bodi() {
    //listtile for the dashboard screen
    Widget adminTile({Icon icon, String title, int body, String page}) {
      return Card( shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.blue
                ),
                height: 45,
                width: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        icon,
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            // color: Colors.white
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                    Text(
                      '$body',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              )
              //  ListTile(
              //   title:
              //       FlatButton.icon(onPressed: null, icon: icon, label: Text(title)),
              //   subtitle: Text(
              //     '$body',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       color: Colors.red,
              //       fontSize: 20,
              //     ),
              //   ),
              // ),
              ));
    }

    switch (selectedPage) {
      //Show dashboard
      case Page.dashboard:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(
            //   child: ListTile(
            //     title: Text(
            //       'Revenue',
            //       style: TextStyle(color: Colors.grey, fontSize: 24),
            //       textAlign: TextAlign.center,
            //     ),
            //     subtitle: FlatButton.icon(
            //         onPressed: () {},
            //         icon: Icon(
            //           Icons.attach_money,
            //           color: Colors.green,
            //           size: 30,
            //         ),
            //         label: Text('22,000.99',
            //             style: TextStyle(
            //               fontSize: 30,
            //               color: Colors.green,
            //             ))),
            //   ),
            // ),
            Expanded(
              child: OrientationBuilder(builder: (context, orientation) {
                return Container(
                  child: GridView.count(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    primary: false,
                    padding: const EdgeInsets.all(5),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    children: <Widget>[
                      //users title
                      adminTile(
                          icon: Icon(Icons.people_outline),
                          body: 7,
                          title: 'Users'),
                      //category tile
                      adminTile(
                          icon: Icon(Icons.category),
                          body: 23,
                          title: 'Category'),
                      //category tile
                      adminTile(
                          icon: Icon(Icons.branding_watermark),
                          body: 173,
                          title: 'Brand'),
                      //products tile
                      adminTile(
                          icon: Icon(Icons.track_changes),
                          body: 1609,
                          title: 'Products'),
                      adminTile(
                          icon: Icon(Icons.insert_emoticon),
                          body: 100,
                          title: 'Sold'),
                      adminTile(
                          icon: Icon(Icons.shopping_cart),
                          body: 100,
                          title: 'Orders'),
                      adminTile(
                          icon: Icon(Icons.cancel), body: 100, title: 'Return'),
                    ],
                  ),
                );
              }),
            )
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
              leading: Icon(Icons.add),
              title: Text('Add product'),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.change_history),
              title: Text('Product list'),
            ),
            ListTile(
              onTap: () {
                createCategory();
              },
              leading: Icon(Icons.add_circle),
              title: Text('Add category'),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.category),
              title: Text('category list'),
            ),
            ListTile(
              onTap: () {
                createBrand();
              },
              leading: Icon(Icons.add_circle_outline),
              title: Text('Add brand'),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.library_books),
              title: Text('Brand list'),
            ),
          ],
        );
        break;

      default:
        return Container();
    }
  }

//create category
  Future<void> createCategory() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Create category'),
            content: Form(
              key: _categoryFormKey,
              child: TextFormField(
                autofocus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Category name is required';
                  }
                  return null;
                },
                controller: _categoryController,
                maxLength: 50,
                enableSuggestions: true,
                decoration: InputDecoration(hintText: 'Category name'),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    FormState _categoryFormState =
                        _categoryFormKey.currentState;
                    if (_categoryFormState.validate()) {
                      _categoryDbs.createCategory(_categoryController.text);
                      Fluttertoast.showToast(msg: 'Category created');
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.green),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent),
                  )),
            ],
            actionsPadding: EdgeInsets.symmetric(horizontal: 30.0),
          );
        });
  }

//create brand
  Future createBrand() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Create brand'),
            content: Form(
              key: _brandFormKey,
              child: TextFormField(
                autofocus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Category name is required';
                  }
                  return null;
                },
                controller: _brandController,
                maxLength: 50,
                enableSuggestions: true,
                decoration: InputDecoration(hintText: 'Brand name'),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    FormState _brandFormState = _brandFormKey.currentState;
                    if (_brandFormState.validate()) {
                      _brandDbs.createBrand(_brandController.text);
                      Fluttertoast.showToast(
                        msg: 'Brand created',
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.green),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent),
                  )),
            ],
            actionsPadding: EdgeInsets.symmetric(horizontal: 30.0),
          );
        });
  }
}
