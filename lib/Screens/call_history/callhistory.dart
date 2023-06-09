
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mec/Configs/Dbkeys.dart';
import 'package:mec/Configs/Dbpaths.dart';
import 'package:mec/Configs/app_constants.dart';
import 'package:mec/Configs/optional_constants.dart';
import 'package:mec/Models/DataModel.dart';
import 'package:mec/Screens/Broadcast/AddContactsToBroadcast.dart';
import 'package:mec/Screens/Groups/AddContactsToGroup.dart';
import 'package:mec/Screens/contact_screens/SmartContactsPage.dart';
import 'package:mec/Services/Admob/admob.dart';
import 'package:mec/Services/Providers/AvailableContactsProvider.dart';
import 'package:mec/Services/Providers/Observer.dart';
import 'package:mec/Services/localization/language_constants.dart';
import 'package:mec/Screens/call_history/utils/InfiniteListView.dart';
import 'package:mec/Services/Providers/call_history_provider.dart';
import 'package:mec/Utils/call_utilities.dart';
import 'package:mec/Utils/permissions.dart';
import 'package:mec/Utils/open_settings.dart';
import 'package:mec/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallHistory extends StatefulWidget {
  final String? userphone;
  final DataModel? model;
  final SharedPreferences prefs;
  CallHistory(
      {required this.userphone, required this.model, required this.prefs});
  @override
  _CallHistoryState createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  call(BuildContext context, bool isvideocall, var peer) async {
    var mynickname = widget.prefs.getString(Dbkeys.nickname) ?? '';

    var myphotoUrl = widget.prefs.getString(Dbkeys.photoUrl) ?? '';

    CallUtils.dial(
        prefs: widget.prefs,
        currentuseruid: widget.userphone,
        fromDp: myphotoUrl,
        toDp: peer["photoUrl"],
        fromUID: widget.userphone,
        fromFullname: mynickname,
        toUID: peer['phone'],
        toFullname: peer["nickname"],
        context: context,
        isvideocall: isvideocall);
  }

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  final BannerAd myBanner = BannerAd(
    adUnitId: getBannerAdUnitId()!,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  AdWidget? adWidget;
  @override
  void initState() {
    super.initState();
    mec.internetLookUp();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final observer = Provider.of<Observer>(this.context, listen: false);
      if (IsBannerAdShow == true && observer.isadmobshow == true) {
        myBanner.load();
        adWidget = AdWidget(ad: myBanner);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (IsBannerAdShow == true) {
      myBanner.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final observer = Provider.of<Observer>(this.context, listen: false);
    return Consumer<FirestoreDataProviderCALLHISTORY>(
      builder: (context, firestoreDataProvider, _) => Scaffold(
        key: _scaffold,
        backgroundColor: mecWhite,
        bottomSheet: IsBannerAdShow == true &&
                observer.isadmobshow == true &&
                adWidget != null
            ? Container(
                height: 60,
                margin: EdgeInsets.only(
                    bottom: Platform.isIOS == true ? 25.0 : 5, top: 0),
                child: Center(child: adWidget),
              )
            : SizedBox(
                height: 0,
              ),
        floatingActionButton: firestoreDataProvider.recievedDocs.length == 0
            ? Padding(
                padding: EdgeInsets.only(
                    bottom:
                        IsBannerAdShow == true && observer.isadmobshow == true
                            ? 60
                            : 0),
                child: FloatingActionButton(
                    heroTag: "dfsf4e8t4yaddweqewt834",
                    backgroundColor: mecLightGreen,
                    child: Icon(
                      Icons.add_call,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SmartContactsPage(
                                  onTapCreateGroup: () {
                                    if (observer.isAllowCreatingGroups ==
                                        false) {
                                      mec.showRationale(getTranslated(
                                          this.context, 'disabled'));
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddContactsToGroup(
                                                    currentUserNo:
                                                        widget.userphone,
                                                    model: widget.model,
                                                    biometricEnabled: false,
                                                    prefs: widget.prefs,
                                                    isAddingWhileCreatingGroup:
                                                        true,
                                                  )));
                                    }
                                  },
                                  onTapCreateBroadcast: () {
                                    if (observer.isAllowCreatingBroadcasts ==
                                        false) {
                                      mec.showRationale(getTranslated(
                                          this.context, 'disabled'));
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddContactsToBroadcast(
                                                    currentUserNo:
                                                        widget.userphone,
                                                    model: widget.model,
                                                    biometricEnabled: false,
                                                    prefs: widget.prefs,
                                                    isAddingWhileCreatingBroadcast:
                                                        true,
                                                  )));
                                    }
                                  },
                                  prefs: widget.prefs,
                                  biometricEnabled: false,
                                  currentUserNo: widget.userphone!,
                                  model: widget.model!)));
                    }),
              )
            : Padding(
                padding: EdgeInsets.only(
                    bottom:
                        IsBannerAdShow == true && observer.isadmobshow == true
                            ? 60
                            : 0),
                child: FloatingActionButton(
                    heroTag: "dfsf4e8t4yt834",
                    backgroundColor: mecWhite,
                    child: Icon(
                      Icons.delete,
                      size: 30.0,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(getTranslated(context, 'clearlog')),
                            content: new Text(
                                getTranslated(context, 'clearloglong')),
                            actions: [
                              // ignore: deprecated_member_use
                              ElevatedButton(
                                child: Text(
                                  getTranslated(context, 'cancel'),
                                  style: TextStyle(
                                      color: mecgreen, fontSize: 18),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              // ignore: deprecated_member_use
                              ElevatedButton(
                                child: Text(
                                  getTranslated(context, 'delete'),
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  mec.toast(
                                      getTranslated(context, 'plswait'));
                                  FirebaseFirestore.instance
                                      .collection(DbPaths.collectionusers)
                                      .doc(widget.userphone)
                                      .collection(DbPaths.collectioncallhistory)
                                      .get()
                                      .then((snapshot) {
                                    for (DocumentSnapshot doc
                                        in snapshot.docs) {
                                      doc.reference.delete();
                                    }
                                  }).then((value) {
                                    firestoreDataProvider.clearall();
                                  });
                                },
                              )
                            ],
                          );
                        },
                        context: context,
                      );
                    }),
              ),
        body: Consumer<AvailableContactsProvider>(
          builder: (context, contactsProvider, _child) => InfiniteListView(
            firestoreDataProviderCALLHISTORY: firestoreDataProvider,
            datatype: 'CALLHISTORY',
            refdata: FirebaseFirestore.instance
                .collection(DbPaths.collectionusers)
                .doc(widget.userphone)
                .collection(DbPaths.collectioncallhistory)
                .orderBy('TIME', descending: true)
                .limit(14),
            list: ListView.builder(
                padding: EdgeInsets.only(bottom: 150),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: firestoreDataProvider.recievedDocs.length,
                itemBuilder: (BuildContext context, int i) {
                  var dc = firestoreDataProvider.recievedDocs[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        // padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        // height: 40,
                        child: FutureBuilder<Map<String, dynamic>>(
                            future: contactsProvider.getUserDoc(dc['PEER']),
                            builder: (BuildContext context,
                                AsyncSnapshot<Map<String, dynamic>> snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                var user = snapshot.data;
                                return ListTile(
                                  onLongPress: () {
                                    List<Widget> tiles = List.from(<Widget>[]);

                                    tiles.add(ListTile(
                                        dense: true,
                                        leading: Icon(Icons.delete),
                                        title: Text(
                                          getTranslated(context, 'delete'),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () async {
                                          Navigator.of(context).pop();

                                          FirebaseFirestore.instance
                                              .collection(
                                                  DbPaths.collectionusers)
                                              .doc(widget.userphone)
                                              .collection(
                                                  DbPaths.collectioncallhistory)
                                              .doc(dc['TIME'].toString())
                                              .delete();
                                          mec.toast('Deleted!');
                                          firestoreDataProvider
                                              .deleteSingle(dc);
                                        }));

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(children: tiles);
                                        });
                                  },
                                  isThreeLine: false,
                                  leading: Stack(
                                    children: [
                                      customCircleAvatar(
                                          url: user!['photoUrl'], radius: 22),
                                      dc['STARTED'] == null ||
                                              dc['ENDED'] == null
                                          ? SizedBox(
                                              height: 0,
                                              width: 0,
                                            )
                                          : Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    6, 2, 6, 2),
                                                decoration: BoxDecoration(
                                                    color: mecLightGreen,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Text(
                                                  dc['ENDED']
                                                              .toDate()
                                                              .difference(
                                                                  dc['STARTED']
                                                                      .toDate())
                                                              .inMinutes <
                                                          1
                                                      ? dc['ENDED']
                                                              .toDate()
                                                              .difference(
                                                                  dc['STARTED']
                                                                      .toDate())
                                                              .inSeconds
                                                              .toString() +
                                                          's'
                                                      : dc['ENDED']
                                                              .toDate()
                                                              .difference(
                                                                  dc['STARTED']
                                                                      .toDate())
                                                              .inMinutes
                                                              .toString() +
                                                          'm',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ))
                                    ],
                                  ),
                                  title: Text(
                                    user['nickname'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        height: 1.4,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          dc['TYPE'] == 'INCOMING'
                                              ? (dc['STARTED'] == null
                                                  ? Icons.call_missed
                                                  : Icons.call_received)
                                              : (dc['STARTED'] == null
                                                  ? Icons.call_made_rounded
                                                  : Icons.call_made_rounded),
                                          size: 15,
                                          color: dc['TYPE'] == 'INCOMING'
                                              ? (dc['STARTED'] == null
                                                  ? Colors.redAccent
                                                  : mecLightGreen)
                                              : (dc['STARTED'] == null
                                                  ? Colors.redAccent
                                                  : mecLightGreen),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        IsShowNativeTimDate == true
                                            ? Text(getTranslated(
                                                    this.context,
                                                    Jiffy(DateTime.fromMillisecondsSinceEpoch(dc["TIME"]))
                                                        .MMMM
                                                        .toString()) +
                                                ' ' +
                                                Jiffy(DateTime.fromMillisecondsSinceEpoch(
                                                        dc["TIME"]))
                                                    .date
                                                    // .Md
                                                    .toString() +
                                                ', ' +
                                                Jiffy(DateTime.fromMillisecondsSinceEpoch(
                                                        dc["TIME"]))
                                                    .Hm
                                                    .toString())
                                            : Text(Jiffy(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            dc["TIME"]))
                                                    .MMMMd
                                                    .toString() +
                                                ', ' +
                                                Jiffy(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            dc["TIME"]))
                                                    .Hm
                                                    .toString()),
                                        // Text(time)
                                      ],
                                    ),
                                  ),
                                  trailing: observer.isOngoingCall
                                      ? SizedBox()
                                      : IconButton(
                                          icon: Icon(
                                              dc['ISVIDEOCALL'] == true
                                                  ? Icons.video_call
                                                  : Icons.call,
                                              color: mecgreen,
                                              size: 24),
                                          onPressed:
                                              OnlyPeerWhoAreSavedInmyContactCanMessageOrCallMe ==
                                                      true
                                                  ? () {}
                                                  : observer.iscallsallowed ==
                                                          false
                                                      ? () {
                                                          mec.showRationale(
                                                              getTranslated(
                                                                  this.context,
                                                                  'callnotallowed'));
                                                        }
                                                      : () async {
                                                          if (dc['ISVIDEOCALL'] ==
                                                              true) {
                                                            //---Make a video call
                                                            await Permissions
                                                                    .cameraAndMicrophonePermissionsGranted()
                                                                .then(
                                                                    (isgranted) {
                                                              if (isgranted ==
                                                                  true) {
                                                                call(context,
                                                                    true, user);
                                                              } else {
                                                                mec
                                                                    .showRationale(
                                                                  getTranslated(
                                                                      context,
                                                                      'pmc'),
                                                                );
                                                                Navigator.push(
                                                                    context,
                                                                    new MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                OpenSettings()));
                                                              }
                                                            }).catchError(
                                                                    (onError) {
                                                              mec
                                                                  .showRationale(
                                                                getTranslated(
                                                                    context,
                                                                    'pmc'),
                                                              );
                                                              Navigator.push(
                                                                  context,
                                                                  new MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              OpenSettings()));
                                                            });
                                                          } else if (dc[
                                                                  'ISVIDEOCALL'] ==
                                                              false) {
                                                            //---Make a audio call
                                                            await Permissions
                                                                    .cameraAndMicrophonePermissionsGranted()
                                                                .then(
                                                                    (isgranted) {
                                                              if (isgranted ==
                                                                  true) {
                                                                call(
                                                                    context,
                                                                    false,
                                                                    user);
                                                              } else {
                                                                mec
                                                                    .showRationale(
                                                                  getTranslated(
                                                                      context,
                                                                      'pmc'),
                                                                );
                                                                Navigator.push(
                                                                    context,
                                                                    new MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                OpenSettings()));
                                                              }
                                                            }).catchError(
                                                                    (onError) {
                                                              mec
                                                                  .showRationale(
                                                                getTranslated(
                                                                    context,
                                                                    'pmc'),
                                                              );
                                                              Navigator.push(
                                                                  context,
                                                                  new MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              OpenSettings()));
                                                            });
                                                          }
                                                        }),
                                );
                              }
                              return ListTile(
                                onLongPress: () {
                                  List<Widget> tiles = List.from(<Widget>[]);

                                  tiles.add(ListTile(
                                      dense: true,
                                      leading: Icon(Icons.delete),
                                      title: Text(
                                        getTranslated(context, 'delete'),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        mec.toast(
                                            getTranslated(context, 'plswait'));
                                        FirebaseFirestore.instance
                                            .collection(DbPaths.collectionusers)
                                            .doc(widget.userphone)
                                            .collection(
                                                DbPaths.collectioncallhistory)
                                            .doc(dc['TIME'].toString())
                                            .delete();
                                        mec.toast('Deleted!');
                                        firestoreDataProvider.deleteSingle(dc);
                                      }));

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(children: tiles);
                                      });
                                },
                                isThreeLine: false,
                                leading: Stack(
                                  children: [
                                    customCircleAvatar(radius: 22),
                                    dc['STARTED'] == null || dc['ENDED'] == null
                                        ? SizedBox(
                                            height: 0,
                                            width: 0,
                                          )
                                        : Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  6, 2, 6, 2),
                                              decoration: BoxDecoration(
                                                  color: mecLightGreen,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Text(
                                                dc['ENDED']
                                                            .toDate()
                                                            .difference(
                                                                dc['STARTED']
                                                                    .toDate())
                                                            .inMinutes <
                                                        1
                                                    ? dc['ENDED']
                                                            .toDate()
                                                            .difference(
                                                                dc['STARTED']
                                                                    .toDate())
                                                            .inSeconds
                                                            .toString() +
                                                        's'
                                                    : dc['ENDED']
                                                            .toDate()
                                                            .difference(
                                                                dc['STARTED']
                                                                    .toDate())
                                                            .inMinutes
                                                            .toString() +
                                                        'm',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                            ))
                                  ],
                                ),
                                title: Text(
                                  contactsProvider
                                              .contactsBookContactList!.entries
                                              .toList()
                                              .indexWhere((element) =>
                                                  element.key == dc['PEER']) >=
                                          0
                                      ? contactsProvider
                                          .contactsBookContactList!.entries
                                          .toList()[contactsProvider
                                              .contactsBookContactList!.entries
                                              .toList()
                                              .indexWhere((element) =>
                                                  element.key == dc['PEER'])]
                                          .value
                                      : dc['PEER'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      height: 1.4, fontWeight: FontWeight.w500),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        dc['TYPE'] == 'INCOMING'
                                            ? (dc['STARTED'] == null
                                                ? Icons.call_missed
                                                : Icons.call_received)
                                            : (dc['STARTED'] == null
                                                ? Icons.call_made_rounded
                                                : Icons.call_made_rounded),
                                        size: 15,
                                        color: dc['TYPE'] == 'INCOMING'
                                            ? (dc['STARTED'] == null
                                                ? Colors.redAccent
                                                : mecLightGreen)
                                            : (dc['STARTED'] == null
                                                ? Colors.redAccent
                                                : mecLightGreen),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      IsShowNativeTimDate == true
                                          ? Text(getTranslated(
                                                  this.context,
                                                  Jiffy(DateTime.fromMillisecondsSinceEpoch(dc["TIME"]))
                                                      .MMMM
                                                      .toString()) +
                                              ' ' +
                                              Jiffy(DateTime.fromMillisecondsSinceEpoch(
                                                      dc["TIME"]))
                                                  .date
                                                  // .Md
                                                  .toString() +
                                              ', ' +
                                              Jiffy(DateTime.fromMillisecondsSinceEpoch(
                                                      dc["TIME"]))
                                                  .Hm
                                                  .toString())
                                          : Text(Jiffy(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          dc["TIME"]))
                                                  .MMMMd
                                                  .toString() +
                                              ', ' +
                                              Jiffy(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          dc["TIME"]))
                                                  .Hm
                                                  .toString()),
                                      // Text(time)
                                    ],
                                  ),
                                ),
                                trailing: observer.isOngoingCall
                                    ? SizedBox()
                                    : IconButton(
                                        icon: Icon(
                                            dc['ISVIDEOCALL'] == true
                                                ? Icons.video_call
                                                : Icons.call,
                                            color: mecgreen,
                                            size: 24),
                                        onPressed: null),
                              );
                            }),
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

Widget customCircleAvatar({String? url, double? radius}) {
  if (url == null || url == '') {
    return CircleAvatar(
      backgroundColor: Color(0xffE6E6E6),
      radius: radius ?? 30,
      child: Icon(
        Icons.person,
        color: Color(0xffCCCCCC),
      ),
    );
  } else {
    return CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              backgroundImage: NetworkImage('$url'),
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              child: Icon(
                Icons.person,
                color: Color(0xffCCCCCC),
              ),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              child: Icon(
                Icons.person,
                color: Color(0xffCCCCCC),
              ),
            ));
  }
}

Widget customCircleAvatarGroup({String? url, double? radius}) {
  if (url == null || url == '') {
    return CircleAvatar(
      backgroundColor: Color(0xffE6E6E6),
      radius: radius ?? 30,
      child: Icon(
        Icons.people,
        color: Color(0xffCCCCCC),
      ),
    );
  } else {
    return CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              backgroundImage: NetworkImage('$url'),
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              child: Icon(
                Icons.people,
                color: Color(0xffCCCCCC),
              ),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              child: Icon(
                Icons.people,
                color: Color(0xffCCCCCC),
              ),
            ));
  }
}

Widget customCircleAvatarBroadcast({String? url, double? radius}) {
  if (url == null || url == '') {
    return CircleAvatar(
      backgroundColor: Color(0xffE6E6E6),
      radius: radius ?? 30,
      child: Icon(
        Icons.campaign_sharp,
        color: Color(0xffCCCCCC),
      ),
    );
  } else {
    return CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              backgroundImage: NetworkImage('$url'),
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              child: Icon(
                Icons.campaign_sharp,
                color: Color(0xffCCCCCC),
              ),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: radius ?? 30,
              child: Icon(
                Icons.campaign_sharp,
                color: Color(0xffCCCCCC),
              ),
            ));
  }
}
