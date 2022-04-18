import 'package:flutter/material.dart';
import 'package:meeter/Providers/requests_bloc.dart';
import 'package:meeter/View/Explore_Buyer/search_buyer_screen.dart';
import 'package:meeter/Widgets/HWidgets/menu.dart';
import 'package:meeter/Widgets/HWidgets/upcomingMeetings.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_seller.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Model/demand.dart';
import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/Services/firebase_api.dart';
import 'package:async/async.dart';
import 'package:meeter/Widgets/HWidgets/mainlists_buyer.dart';

class HomeBuyerScreen extends StatefulWidget {
  @override
  _HomeBuyerScreenState createState() => _HomeBuyerScreenState();
}

class _HomeBuyerScreenState extends State<HomeBuyerScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 2;
  TextEditingController searchController = TextEditingController();
  late ApplicationBloc applicationBloc;
  late StreamZip<List<DemandData>> stream;
  List<List<DemandData>>? nearest;
  late RequestBloc bloc;

  getNearestDemands(List<List<DemandData>> list) async {
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    if (applicationBloc.currentLocation != null) {
      nearest = await FirebaseApi()
          .getNearestDemandCollection(list, applicationBloc.currentLocation);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final demand = Provider.of<List<Demand>>(context, listen: false);
    stream = FirebaseApi().getDemandCollection(demand);
    setState(() {});
    stream.listen((event) {
      getNearestDemands(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    final demand = Provider.of<List<Demand>>(context);
    bloc = Provider.of<RequestBloc>(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: Menu(
          clr: Colors.green,
        ),
        body: StreamProvider<List<List<DemandData>>>(
            initialData: [],
            create: (context) => FirebaseApi().getDemandCollection(demand),
            child: Consumer<List<List<DemandData>>>(
                builder: (_, demand, __) => SafeArea(
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () {
                                                _scaffoldKey.currentState!
                                                    .openDrawer();
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50 / 2),
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
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: w * 2.4,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .rightToLeft,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  200),
                                                          curve: Curves.easeIn,
                                                          child: BottomNavBar(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    50 / 2),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.sync,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: w * 4.8,
                                                  vertical: h * 2.2),
                                              child: Text(
                                                'Welcome Back \nFind a request you can address!',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: w * 7.3,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: w * 3.6),
                                              child: TextField(
                                                controller: searchController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  focusColor: Colors.green,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                  ),
                                                  hintText: 'Search',
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchBuyerScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: h * 1.12,
                              ),
                              Container(
                                height: 136,
                                child: UpcomingMeetings(
                                    clr: Colors.green,
                                    clr1: Colors.green,
                                    requests: bloc.requests
                                        .where((element) =>
                                            element['type'] == 'demand')
                                        .toSet()
                                        .toList()),
                              ),
                              Container(
                                height: 232,
                                color: Colors.green,
                                child: MainListsBuyer(
                                  mainText: 'FEATURED DEMAND',
                                  demandsCollections: demand
                                      .map((doc) => doc
                                          .where((element) =>
                                              element.featured == true)
                                          .toList())
                                      .toList(),
                                  clr: Colors.green,
                                  clr1: Colors.green,
                                ),
                              ),
                              Container(
                                height: 232,
                                child: MainListsBuyer(
                                  mainText: 'SUGGESTED DEMAND FOR YOU',
                                  demandsCollections: demand,
                                  clr: Colors.green,
                                  clr1: Colors.green,
                                ),
                              ),
                              nearest != null
                                  ? Container(
                                      height: 232,
                                      child: MainListsBuyer(
                                        mainText: 'DEMAND NEAR YOU',
                                        demandsCollections: nearest,
                                        clr: Colors.green,
                                        clr1: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              Container(
                                height: 232,
                                child: MainListsBuyer(
                                  mainText: 'HIGH-VALUE DEMAND',
                                  demandsCollections: demand
                                      .map((ldoc) => ldoc
                                          .where(
                                              (doc) => doc.demand_price! >= 50)
                                          .toList())
                                      .toList(),
                                  clr: Colors.green,
                                  clr1: Colors.green,
                                ),
                              ),
                              SizedBox(
                                height: h * 8.9,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))));
  }
}
