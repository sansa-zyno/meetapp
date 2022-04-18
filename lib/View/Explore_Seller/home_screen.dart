import 'package:flutter/material.dart';
import 'package:meeter/Services/firebase_api.dart';
import 'package:meeter/Providers/requests_bloc.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_buyer.dart';
import 'package:meeter/Widgets/HWidgets/upcomingMeetings.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/View/Explore_Seller/search_screen.dart';
import 'package:meeter/Widgets/HWidgets/mainlists.dart';
import 'package:meeter/Widgets/HWidgets/menu.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Model/meetup.dart';
import 'package:async/async.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 2;
  late ApplicationBloc applicationBloc;
  late StreamZip<List<MeetupData>> stream;
  List<List<MeetupData>>? nearest;
  late RequestBloc bloc;

  getNearestMeetups(List<List<MeetupData>> list) async {
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    if (applicationBloc.currentLocation != null) {
      nearest = await FirebaseApi()
          .getNearestMeeterCollection(list, applicationBloc.currentLocation);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final meetup = Provider.of<List<Meetup>>(context, listen: false);
    stream = FirebaseApi().getMeeterCollection(meetup);
    stream.listen((event) {
      getNearestMeetups(event);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;

    UserController _currentUser = Provider.of<UserController>(context);
    OurUser currentUser = _currentUser.getCurrentUser;
    final meetup = Provider.of<List<Meetup>>(context);
    bloc = Provider.of<RequestBloc>(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: Menu(
          clr: Colors.blue,
        ),
        body: StreamProvider<List<List<MeetupData>>>(
            initialData: [],
            create: (context) => FirebaseApi().getMeeterCollection(meetup),
            child: Consumer<List<List<MeetupData>>>(
              builder: (_, meetup, __) => SafeArea(
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
                            color: Colors.blue,
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
                                                BorderRadius.circular(50 / 2),
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
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: w * 2.4,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    curve: Curves.easeIn,
                                                    child: BuyerBottomNavBar(),
                                                  ),
                                                );
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
                                                    Icons.sync,
                                                    color: Colors.blue,
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
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: w * 4.8,
                                          vertical: h * 2.2),
                                      child: currentUser.displayName != null
                                          ? Text(
                                              'Welcome Back \n${currentUser.displayName}!',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: w * 7.3,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )
                                          : Container(),
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
                                                builder: (context) =>
                                                    SearchScreen(),
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
                              clr: Colors.blue,
                              clr1: Colors.blue,
                              requests: bloc.requests
                                  .where(
                                      (element) => element['type'] == 'service')
                                  .toSet()
                                  .toList()),
                        ),
                        Container(
                          height: 232,
                          color: Colors.blue,
                          child: MainLists(
                            mainText: 'FEATURED SERVICES',
                            meetersCollections: meetup
                                .map((doc) => doc
                                    .where(
                                        (element) => element.featured == true)
                                    .toList())
                                .toList(),
                            clr: Colors.blue,
                            clr1: Colors.blue,
                          ),
                        ),
                        Container(
                          height: 240,
                          child: MainLists(
                            mainText: 'SUGGESTED SERVICES FOR YOU',
                            meetersCollections: meetup,
                            clr: Colors.blue,
                            clr1: Colors.blue,
                          ),
                        ),
                        nearest != null
                            ? Container(
                                height: 232,
                                child: MainLists(
                                  mainText: 'SERVICES NEAR YOU',
                                  meetersCollections: nearest,
                                  clr: Colors.blue,
                                  clr1: Colors.blue,
                                ),
                              )
                            : Container(),
                        Container(
                          height: 232,
                          child: MainLists(
                            mainText: 'HIGH-VALUE SERVICES',
                            meetersCollections: meetup
                                .map((ldoc) => ldoc
                                    .where((doc) => doc.meetup_price! >= 50)
                                    .toList())
                                .toList(),
                            clr: Colors.blue,
                            clr1: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          height: h * 8.9,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
