import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:motion_detection/check_user_visit_first_time.dart';
import 'package:motion_detection/notification_service.dart';
import 'package:motion_detection/relation_provider.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'get_detail.dart';

void main() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: "basic_channel",
            channelName: "basic_notification",
            channelDescription: "Notification Channel for basic")
      ],
      debug: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RelationProvider())
      ],
      child: const MaterialApp(
          home: CheckUserVistFirstTimeOrNot() //CheckUserVistFirstTimeOrNot(),
          ),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int contactMaxLength = 5;
  bool isButtonPress = false;
  int countWrongPassword = 0;
  TextEditingController passwordEditingController = TextEditingController();
  int count = 0;
  NotificationServices notificationServices = NotificationServices();
  bool isDialogOpen = false;
  DateTime? currentBackPresstime = null;

  List<String> nameList = [];
  List<String> contactList = [];
  List<String> relationList = [];

  String Userpasword = "";
  String NameOfUser = "";
  String contactNumber1 = "";

  // address variable
  String full_address = "";

  @override
  void initState() {
    super.initState();
    getTotalNumberOfContactDetails();
    locationPermission();
    isDialogOpen = false;
    // TODO: implement initState
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // locationPermission

    ShakeDetector shakeDetector = ShakeDetector.autoStart(onPhoneShake: () {
      if (isButtonPress) {
        triggerNotifications();
      }
      count++;
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (isButtonPress && !isDialogOpen) {
          showAlert();
          getlocation();
          isDialogOpen = true;
        }
      });

      //when user did not click in any button
      Future.delayed(const Duration(milliseconds: 30000), () {
        if (isDialogOpen) {
          getMemberDetail();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (isDialogOpen) {
      getMemberDetail();
    }
  }

  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: Drawer(
            child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      const DrawerHeader(
                          child: UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.green),
                        accountName: Text(
                          "abc",
                          style: TextStyle(fontSize: 18),
                        ),
                        currentAccountPictureSize: Size.square(50),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 165, 255, 137),
                          child: Text("A"),
                        ),
                        accountEmail: null,
                      )),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text(" My Profile"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text("Change Password"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text("Add contact"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("LogOut"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.contact_emergency),
                        title: const Text("Send Message"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: const [
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.settings), title: Text('Facebook')),
                    ListTile(leading: Icon(Icons.help))
                  ],
                ),
              ),
            )
          ],
        )),
        bottomSheet: Container(
            color: Colors.greenAccent,
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  return showRelation(index);
                })),
        body: Center(
            child: MaterialButton(
          color: Colors.blueAccent,
          shape: const CircleBorder(),
          onPressed: () {
            isButtonPress = isButtonPress ? false : true;
            setState(() {});
          },
          padding: EdgeInsets.all(35),
          child:
              isButtonPress ? const Text("I'm Safe") : const Text("Protect me"),
        )),
      ),
    );
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "if you'r save then enter password please",
              style: TextStyle(fontSize: 12),
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      controller: passwordEditingController,
                      maxLength: 15,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: 'Enter Your Password'),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    AwesomeNotifications().dismissAllNotifications();
                    if (passwordEditingController.text.isEmpty) {
                      ShowSnackBar.showInSnackBar(
                          "Enter Password", context, Colors.red);
                    } else {
                      if (matchPassword()) {
                        isDialogOpen = false;
                        countWrongPassword = 0;
                        passwordEditingController.clear();
                        Navigator.pop(context);
                      } else {
                        countWrongPassword++;
                        if (countWrongPassword < 3) {
                          ShowSnackBar.showInSnackBar(
                              "Your have only ${3 - countWrongPassword} chance to entry right password",
                              context,
                              Colors.red);
                        } else {
                          ShowSnackBar.showInSnackBar(
                              "Your exceed the limit ", context, Colors.red);
                        }
                        if (countWrongPassword == 3) {
                          countWrongPassword == 0;
                          getMemberDetail(); // sending mail to his/her family
                          isDialogOpen = false;
                          passwordEditingController.clear();
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    AwesomeNotifications().dismissAllNotifications();
                    getMemberDetail();
                    isDialogOpen = false;
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
            ],
          );
        });
  }

  triggerNotifications() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: "basic_channel",
            title: "Are You Safe ?",
            body: "If you are safe then please enter password in the app."));
  }

  bool matchPassword() {
    print("${passwordEditingController.text}");
    if (passwordEditingController.text.compareTo(Userpasword) == 0) {
      print("============= pasword match");
      return true;
    } else {
      return false;
    }
  }

  Widget showRelation(int i) {
    // String name = relationName[i];
    String name = nameList[i];
    return Container(
      padding: const EdgeInsets.only(top: 15, right: 30),
      child: Column(
        children: [
          Stack(children: [
            CircleAvatar(
              radius: 25,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 30),
              ),
            ),
            InkWell(
              onTap: () {
                removeFormSharedPreference(i);
                ShowSnackBar.showInSnackBar(
                    "it remove shortly", context, Colors.red);
              },
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 30,
                ),
                child: Icon(
                  Icons.minimize,
                  size: 25,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                GetContactDetail().getContactDetail(context);
                Future.delayed(const Duration(milliseconds: 15000), () {
                  setState(() {
                    super.setState(() {
                      contactList.length;
                    });
                  });
                });
                ShowSnackBar.showInSnackBar(
                    "It will add shortly", context, Colors.greenAccent);
              },
              child: const Icon(Icons.add),
            )
          ]),
          Text(name),
          Text(relationList[i]),
        ],
      ),
    );
  }

  void getMemberDetail() async {
    String msg = "Dear Sir,${NameOfUser.trim()} may some trouble last location:"
        "$full_address\n"
        "you Can contact:"
        "$contactNumber1";
    print("======================$msg");
    sendMail(msg);
  }

  Future sendMail(String message) async {
    // print("-------------------------under sendMain  $contactList");
    String result = await sendSMS(
            message: message, recipients: contactList, sendDirect: true)
        .catchError((onError) {
      print("error ================ $onError");
    });
    ShowSnackBar.showInSnackBar(
        result == null ? "Message not sent" : "Message sent",
        context,
        Colors.green);
  }

  void smsPermission() async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      await Permission.sms.request();
    }
  }

  void locationPermission() async {
    bool serviceEnalbe = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnalbe) {
      ShowSnackBar.showInSnackBar(
          "Permmission disabled, Please Inable", context, Colors.red);
    }
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        ShowSnackBar.showInSnackBar(
            "Location permission are denied", context, Colors.red);
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      ShowSnackBar.showInSnackBar(
          "Location permission are permanetly denied", context, Colors.red);
    }
    getlocation();
    smsPermission();
  }

  void getlocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      placemarkFromCoordinates(position.latitude, position.longitude)
          .then((List<Placemark> placemark) {
        Placemark place = placemark[0];
        full_address =
            " ${place.street},${place.subLocality},${place.subAdministrativeArea},${place.postalCode}";
        print("full address is =====================" + full_address);
      });
    } catch (e) {
      print("Excption========================= ${e.toString()}");
    }
  }

  void getTotalNumberOfContactDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    nameList = sharedPreferences.getStringList("nameList")!;
    contactList = sharedPreferences.getStringList("contactList")!;
    relationList = sharedPreferences.getStringList("relationList")!;
    Userpasword = sharedPreferences.getString("UserPass")!;
    NameOfUser = sharedPreferences.getString("UserName")!;
    contactNumber1 = sharedPreferences.getString("UserContact")!;
    print("**************************** contact list is $contactList");
    setState(() {});
  }

  void removeFormSharedPreference(int i) {
    nameList.removeAt(i);
    relationList.removeAt(i);
    contactList.removeAt(i);
    saveData();
    setState(() {});
  }

  saveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("nameList", nameList);
    sharedPreferences.setStringList("contactList", contactList);
    sharedPreferences.setStringList("relationList", relationList);
  }
}
