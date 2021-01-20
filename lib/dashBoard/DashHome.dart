import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
// Dashboard

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, double> dataMap = {
    "Men": 5,
    "Women": 3,
    "Children": 2,
    "Acesories": 2,
    "Shoes": 4,
  };
  List colorList = <Color>[
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.pink,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('Revenue:  ',
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
                  Text(
                    '\$${"2000000"}',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Users:  ',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                  Text('35689',
                      style: TextStyle(
                        fontSize: 24,
                      ))
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.blue,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          'Oders',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '70',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.red,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          'Return',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.black,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.point_of_sale_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          'Sold',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '49',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.black,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          'Stock',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '1005',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Sales per category',
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                // color: Colors.blueAccent,
                child: PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 15,
                  // centerText: "HYBRID",
                  legendOptions: LegendOptions(
                    showLegendsInRow: true,
                    legendPosition: LegendPosition.top,
                    showLegends: true,
                    // legendShape: _BoxShape.circle,
                    legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, wordSpacing: 0.5),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: false,
                    // showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
