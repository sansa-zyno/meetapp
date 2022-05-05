import 'package:flutter/material.dart';
import 'package:meeter/View/Explore_Seller/search_screen.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/HWidgets/search_list.dart';
import 'package:meeter/Widgets/HWidgets/menu.dart';
import 'package:meeter/Model/meetup_data.dart';

class SearchResultScreen extends StatefulWidget {
  final List<MeetupData> ldoc;
  SearchResultScreen({required this.ldoc});

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool search = false;
  int i = 4;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  color: Colors.blue,
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
                                    color: Colors.blue,
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
                              decoration: const InputDecoration(
                                // prefixIcon: GestureDetector(
                                //   onTap: () => Navigator.pop(context),
                                //   child: const Icon(
                                //     Icons.arrow_back,
                                //     color: Colors.black,
                                //   ),
                                // ),
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
                                    builder: (context) => SearchScreen(),
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
                clr: Colors.blue,
                ldoc: widget.ldoc.take(i).toList(),
              ),
              SizedBox(height: h * 1.1),
              Container(
                width: w * 65.8,
                height: h * 5.6,
                child: GradientButton(
                  title: "View More",
                  fontSize: w * 2.9,
                  clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
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
