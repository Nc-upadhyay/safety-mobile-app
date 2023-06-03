import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:motion_detection/notification_service.dart';
import 'package:motion_detection/relation_provider.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';

import 'check_user_visit_first_time.dart';
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
        home: CheckUserVistFirstTimeOrNot(),
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
        Future.delayed(const Duration(milliseconds: 2000), () {
          print("=============== Notification triger");
          triggerNotifications();
        });
      }
      count++;
      Future.delayed(const Duration(milliseconds: 2000), () {
        print("=================== under calling showalder");

        if (isButtonPress && !isDialogOpen) {
          showAlert();
          // showAlert()
          isDialogOpen = true;

          //when user did not click in any button
          Future.delayed(const Duration(milliseconds: 35000), () {
            if (isDialogOpen) {
              getMemberDetail();
            }
          });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        ShowSnackBar.showInSnackBar(
                            "Your have only ${3 - countWrongPassword} chance to entry right password",
                            context,
                            Colors.red);
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    for (int i = 0; i < nameList.length; i++) {
      print("contact ================== $contactList");
      String name = nameList[i];
      String contactN = contactList[i];
      String msg = "Dear $name,${NameOfUser.trim()} in some trouble"
          "the last location is bellow "
          "$full_address\n"
          "you Can contact: "
          "$contactNumber1";
      sendMail(name, contactN, msg);
      // if (i == nameList.length - 1) {
      //   // makeCall(contactN);
      // }
    }
  }

  Future sendMail(String name, String con, String message) async {
    print("================ contact  $con");
    try {
      SmsSender smsSender = SmsSender();
      SmsMessage smsMessage = SmsMessage(con.trim(), message);
      smsSender.sendSms(smsMessage);
      ShowSnackBar.showInSnackBar("Message sent", context, Colors.red);
    } catch (e) {
      print("exception============== ${e.toString()}");
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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("========= location ${position.latitude}  ${position.longitude}");
    placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemark) {
      Placemark place = placemark[0];
      print(
          "address=========${place.locality}==========${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}");
      full_address =
          "The Location is ${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}";
    });
  }

  void getTotalNumberOfContactDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    nameList = sharedPreferences.getStringList("nameList")!;
    contactList = sharedPreferences.getStringList("contactList")!;
    relationList = sharedPreferences.getStringList("relationList")!;
    Userpasword = sharedPreferences.getString("UserPass")!;
    NameOfUser = sharedPreferences.getString("UserName")!;
    contactNumber1 = sharedPreferences.getString("UserContact")!;
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

  // makeCall(String num) async {
  //   final url = 'tel:${num.trim()}';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print('=============Could not launch $url');
  //   }
  // }
}
