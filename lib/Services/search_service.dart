import 'package:cloud_firestore/cloud_firestore.dart';

class Search {
  Future<List<DocumentSnapshot>> byTextOnly(col, subCol, tag, text) async {
    List<DocumentSnapshot> searchCollection = [];
    QuerySnapshot docs = await FirebaseFirestore.instance.collection(col).get();
    List<String> uids = [];
    for (int i = 0; i < docs.docs.length; i++) {
      uids.add(docs.docs[i].id);
    }

    for (int i = 0; i < uids.length; i++) {
      QuerySnapshot docs = await FirebaseFirestore.instance
          .collection(col)
          .doc(uids[i])
          .collection(subCol)
          .where(tag, arrayContains: text)
          .get();
      for (int i = 0; i < docs.docs.length; i++) {
        searchCollection.add(docs.docs[i]);
      }
    }
    return searchCollection;
  }

  Future<List<DocumentSnapshot>> byTPCL(String text, List jobOptions, int? job,
      double min, double max, int? loc) async {
    List<DocumentSnapshot> searchCollection = [];
    QuerySnapshot docs =
        await FirebaseFirestore.instance.collection('meeters').get();
    List<String> uids = [];
    for (int i = 0; i < docs.docs.length; i++) {
      uids.add(docs.docs[i].id);
    }
    if (loc != null) {
      for (int i = 0; i < uids.length; i++) {
        QuerySnapshot docs = await FirebaseFirestore.instance
            .collection('meeters')
            .doc(uids[i])
            .collection('meeter')
            .where('meetup_tags', arrayContainsAny: [
              text,
              job != null ? jobOptions[job] : "",
            ])
            .where("meetup_price", isGreaterThanOrEqualTo: min)
            .where("meetup_price", isLessThanOrEqualTo: max)
            .where('meetup_available_online',
                isEqualTo: loc == 1 ? true : false)
            .get();
        for (int i = 0; i < docs.docs.length; i++) {
          searchCollection.add(docs.docs[i]);
        }
      }
    } else {
      for (int i = 0; i < uids.length; i++) {
        QuerySnapshot docs = await FirebaseFirestore.instance
            .collection('meeters')
            .doc(uids[i])
            .collection('meeter')
            .where('meetup_tags', arrayContainsAny: [
              text,
              job != null ? jobOptions[job] : "",
            ])
            .where("meetup_price", isGreaterThanOrEqualTo: min)
            .where("meetup_price", isLessThanOrEqualTo: max)
            .get();
        for (int i = 0; i < docs.docs.length; i++) {
          searchCollection.add(docs.docs[i]);
        }
      }
    }
    return searchCollection;
  }

  Future<List<DocumentSnapshot>> byTPCL2(String text, List jobOptions, int? job,
      double min, double max, int? loc) async {
    List<DocumentSnapshot> searchCollection = [];
    QuerySnapshot docs =
        await FirebaseFirestore.instance.collection('demands').get();
    List<String> uids = [];
    for (int i = 0; i < docs.docs.length; i++) {
      uids.add(docs.docs[i].id);
    }

    if (loc != null) {
      for (int i = 0; i < uids.length; i++) {
        QuerySnapshot docs = await FirebaseFirestore.instance
            .collection('demands')
            .doc(uids[i])
            .collection('demand')
            .where('demand_tags', arrayContainsAny: [
              text,
              job != null ? jobOptions[job] : "",
            ])
            .where("demand_price", isGreaterThanOrEqualTo: min)
            .where("demand_price", isLessThanOrEqualTo: max)
            .where('demand_available_online',
                isEqualTo: loc == 1 ? true : false)
            .get();
        for (int i = 0; i < docs.docs.length; i++) {
          searchCollection.add(docs.docs[i]);
        }
      }
    } else {
      for (int i = 0; i < uids.length; i++) {
        QuerySnapshot docs = await FirebaseFirestore.instance
            .collection('demands')
            .doc(uids[i])
            .collection('demand')
            .where('demand_tags', arrayContainsAny: [
              text,
              job != null ? jobOptions[job] : "",
            ])
            .where("demand_price", isGreaterThanOrEqualTo: min)
            .where("demand_price", isLessThanOrEqualTo: max)
            .get();
        for (int i = 0; i < docs.docs.length; i++) {
          searchCollection.add(docs.docs[i]);
        }
      }
    }
    return searchCollection;
  }

  Future<List<DocumentSnapshot>> byPCL(
      List jobOptions, int? job, double min, double max, int? loc) async {
    List<DocumentSnapshot> searchCollection = [];
    QuerySnapshot docs =
        await FirebaseFirestore.instance.collection('meeters').get();
    List<String> uids = [];
    for (int i = 0; i < docs.docs.length; i++) {
      uids.add(docs.docs[i].id);
    }
    if (loc != null) {
      for (int i = 0; i < uids.length; i++) {
        QuerySnapshot docs = await FirebaseFirestore.instance
            .collection('meeters')
            .doc(uids[i])
            .collection('meeter')
            .where(
              'meetup_tags',
              arrayContains: job != null ? jobOptions[job] : null,
            )
            .where("meetup_price", isGreaterThanOrEqualTo: min)
            .where("meetup_price", isLessThanOrEqualTo: max)
            .where('meetup_available_online',
                isEqualTo: loc == 1 ? true : false)
            .get();
        for (int i = 0; i < docs.docs.length; i++) {
          searchCollection.add(docs.docs[i]);
        }
      }
    } else {
      for (int i = 0; i < uids.length; i++) {
        QuerySnapshot docs = await FirebaseFirestore.instance
            .collection('meeters')
            .doc(uids[i])
            .collection('meeter')
            .where(
              'meetup_tags',
              arrayContains: job != null ? jobOptions[job] : null,
            )
            .where("meetup_price", isGreaterThanOrEqualTo: min)
            .where("meetup_price", isLessThanOrEqualTo: max)
            .get();
        for (int i = 0; i < docs.docs.length; i++) {
          searchCollection.add(docs.docs[i]);
        }
      }
    }
    return searchCollection;
  }

  Future<List<DocumentSnapshot>> byPCL2(
      List jobOptions, int? job, double min, double max, int? loc) async {
    List<DocumentSnapshot> searchCollection = [];
    QuerySnapshot docs =
        await FirebaseFirestore.instance.collection('demands').get();
    List<String> uids = [];
    for (int i = 0; i < docs.docs.length; i++) {
      uids.add(docs.docs[i].id);
    }
    if (loc != null) {
      for (int i = 0; i < uids.length; i++) {
        QuerySnapshot docs = await FirebaseFirestore.instance
            .collection('demands')
            .doc(uids[i])
            .collection('demand')
            .where(
              'demand_tags',
              arrayContains: job != null ? jobOptions[job] : null,
            )
            .where("demand_price", isGreaterThanOrEqualTo: min)
            .where("demand_price", isLessThanOrEqualTo: max)
            .where('demand_available_online',
                isEqualTo: loc == 1 ? true : false)
            .get();
        for (int i = 0; i < docs.docs.length; i++) {
          searchCollection.add(docs.docs[i]);
        }
      }
    } else {
      for (int i = 0; i < uids.length; i++) {
        QuerySnapshot docs = await FirebaseFirestore.instance
            .collection('demands')
            .doc(uids[i])
            .collection('demand')
            .where(
              'demand_tags',
              arrayContains: job != null ? jobOptions[job] : null,
            )
            .where("demand_price", isGreaterThanOrEqualTo: min)
            .where("demand_price", isLessThanOrEqualTo: max)
            .get();
        for (int i = 0; i < docs.docs.length; i++) {
          searchCollection.add(docs.docs[i]);
        }
      }
    }
    return searchCollection;
  }
}
