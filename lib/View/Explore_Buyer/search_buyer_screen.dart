import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meeter/Widgets/HWidgets/search_filter.dart';
import 'package:meeter/Widgets/HWidgets/menu.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:provider/provider.dart';

import 'home_buyer_screen.dart';

class SearchBuyerScreen extends StatefulWidget {
  @override
  _SearchBuyerScreenState createState() => _SearchBuyerScreenState();
}

class _SearchBuyerScreenState extends State<SearchBuyerScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    ApplicationBloc _appBloc = Provider.of<ApplicationBloc>(context);
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
                              controller: _appBloc.searchController2,
                              decoration: InputDecoration(
                                prefixIcon: GestureDetector(
                                  onTap: () => Get.offAll(() => HomeBuyerScreen()),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                hintText: 'Search',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 1.6),
              SearchFilter(
                clr: Colors.green,
              ),
              SizedBox(
                height: h * 8.9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
