import 'package:flutter/material.dart';
import 'package:meeter/View/Explore_Buyer/search_buyer_screen.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/HWidgets/search_list.dart';
import 'package:meeter/Widgets/HWidgets/menu.dart';
import 'package:meeter/Model/demand_data.dart';

class BuyerSearchResultScreen extends StatefulWidget {
  final List<DemandData> ldoc;
  BuyerSearchResultScreen({required this.ldoc});
  @override
  _BuyerSearchResultScreenState createState() =>
      _BuyerSearchResultScreenState();
}

class _BuyerSearchResultScreenState extends State<BuyerSearchResultScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool search = false;
  int i = 4;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(
        clr: Colors.green,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  color: Colors.green,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 1.9, vertical: h * 0.8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: h * 4.4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              child: Container(
                                height: h * 5.6,
                                width: w * 12.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50 / 2),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 10.1),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              // controller: searchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                hintText: 'Search',
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchBuyerScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 1.1),
              SearchList(
                clr: Colors.green,
                ldoc: widget.ldoc.take(i).toList(),
              ),
              SizedBox(height: h * 1.1),
              Container(
                width: w * 65.8,
                height: h * 5.6,
                child: GradientButton(
                  title: "View More",
                  fontSize: w * 2.9,
                  clrs: [Colors.green, Colors.green],
                  onpressed: () {
                    i += 4;
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: h * 3.3),
            ],
          ),
        ),
      ),
    );
  }
}
