import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Services/search_service.dart';
import 'package:meeter/View/Explore_Buyer/buyer_search_result_screen.dart';
import 'package:meeter/View/Explore_Seller/search_result_screen.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/Model/demand_data.dart';

class SearchFilter extends StatefulWidget {
  final Color clr;
  SearchFilter({
    required this.clr,
  });
  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  RangeValues _currentRangeValues = RangeValues(0, 100);
  late double minimum;
  late double maximum;

  int? job;
  int? loc;

  List<String> jobOptions = [
    'Marketing',
    'Buisness',
    'Industry',
    'Training',
    'Trade',
  ];

  List<String> locationoptions = [
    'Online',
    'On-site',
  ];

  @override
  Widget build(BuildContext context) {
    minimum = _currentRangeValues.start;
    maximum = _currentRangeValues.end;

    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    ApplicationBloc _appBloc = Provider.of<ApplicationBloc>(context);
    return Container(
      // height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                  ),
                  border: Border.all(
                    width: w * 0.2,
                    color: widget.clr,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: w * 36.5,
                      height: h * 6.7,
                      child: Divider(
                        thickness: 5,
                        color: Colors.grey[30],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.5,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 4.8, vertical: h * 1.6),
                            child: Text(
                              'Price Range (\$${minimum.ceil()} - \$${maximum.ceil()})',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: w * 5.3,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                child: Center(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor: widget.clr,
                                            thumbColor: widget.clr,
                                            showValueIndicator:
                                                ShowValueIndicator.always,
                                          ),
                                          child: RangeSlider(
                                            values: _currentRangeValues,
                                            min: 0,
                                            max: 100,
                                            divisions: null,
                                            labels: RangeLabels(
                                              _currentRangeValues.start
                                                  .round()
                                                  .toString(),
                                              _currentRangeValues.end
                                                  .round()
                                                  .toString(),
                                            ),
                                            onChanged: (RangeValues values) {
                                              setState(
                                                () {
                                                  _currentRangeValues = values;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.5,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 4.8, vertical: h * 1.6),
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: w * 5.3,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 4.8),
                            child: Wrap(
                              children: List<Widget>.generate(
                                5,
                                (int index) {
                                  return ChoiceChip(
                                    label: Text(jobOptions[index]),
                                    padding: EdgeInsets.all(10),
                                    selectedColor: widget.clr,
                                    selected: job == index,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        job = selected ? index : null;
                                      });
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.5,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 4.8, vertical: h * 1.6),
                            child: Text(
                              'Location',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: w * 5.3,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 4.8),
                            child: Wrap(
                              children: List<Widget>.generate(
                                2,
                                (int index) {
                                  return ChoiceChip(
                                    label: Text(locationoptions[index]),
                                    padding: EdgeInsets.all(10),
                                    selectedColor: widget.clr,
                                    selected: loc == index,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        loc = selected ? index : null;
                                      });
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 3.3,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 1.2),
                              height: 48,
                              child: GradientButton(
                                title: "Show Result",
                                clrs: [widget.clr, widget.clr],
                                fontSize: w * 2.9,
                                letterSpacing: 0,
                                onpressed: () async {
                                  List<DocumentSnapshot> searchCollection = [];
                                  if (widget.clr == Colors.blue) {
                                    if (_appBloc.searchController1.text != "") {
                                      searchCollection = await Search().byTPCL(
                                          _appBloc.searchController1.text,
                                          jobOptions,
                                          job,
                                          _currentRangeValues.start,
                                          _currentRangeValues.end,
                                          loc);
                                      List<MeetupData> col = searchCollection
                                          .map(
                                              (doc) => MeetupData.fromSnap(doc))
                                          .toList();
                                      col.isNotEmpty
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchResultScreen(
                                                        ldoc: col),
                                              ),
                                            )
                                          : Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  'There is no item that matches your search'),
                                            ));
                                    } else {
                                      searchCollection = await Search().byPCL(
                                          jobOptions,
                                          job,
                                          _currentRangeValues.start,
                                          _currentRangeValues.end,
                                          loc);

                                      List<MeetupData> col = searchCollection
                                          .map(
                                              (doc) => MeetupData.fromSnap(doc))
                                          .toList();

                                      col.isNotEmpty
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchResultScreen(
                                                        ldoc: col),
                                              ),
                                            )
                                          : Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  'There is no item that matches your search'),
                                            ));
                                    }
                                  } else {
                                    if (_appBloc.searchController2.text != "") {
                                      searchCollection = await Search().byTPCL2(
                                          _appBloc.searchController2.text,
                                          jobOptions,
                                          job,
                                          _currentRangeValues.start,
                                          _currentRangeValues.end,
                                          loc);

                                      List<DemandData> col = searchCollection
                                          .map(
                                              (doc) => DemandData.fromSnap(doc))
                                          .toList();

                                      col.isNotEmpty
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BuyerSearchResultScreen(
                                                        ldoc: col),
                                              ),
                                            )
                                          : Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  'There is no item that matches your search'),
                                            ));
                                    } else {
                                      searchCollection = await Search().byPCL2(
                                          jobOptions,
                                          job,
                                          _currentRangeValues.start,
                                          _currentRangeValues.end,
                                          loc);

                                      List<DemandData> col = searchCollection
                                          .map(
                                              (doc) => DemandData.fromSnap(doc))
                                          .toList();

                                      col.isNotEmpty
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BuyerSearchResultScreen(
                                                        ldoc: col),
                                              ),
                                            )
                                          : Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  'There is no item that matches your search'),
                                            ));
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 1.2),
                              height: 48,
                              child: GradientButton(
                                fontSize: 12,
                                letterSpacing: 0,
                                title: "Clear",
                                textClr: widget.clr,
                                clrs: [Colors.white, Colors.white],
                                border: Border.all(
                                  color: widget.clr,
                                ),
                                onpressed: () {
                                  setState(() {
                                    _currentRangeValues = RangeValues(0, 100);
                                    job = null;
                                    loc = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 3.3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
