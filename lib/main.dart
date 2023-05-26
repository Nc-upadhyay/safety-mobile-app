import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:motion_detection/notification_service.dart';
import 'package:motion_detection/relation_provider.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'check_user_visit_first_time.dart';

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
  bool isButtonPress = false;
  int countWrongPassword = 0;
  TextEditingController passwordEditingController = TextEditingController();
  int count = 0;
  NotificationServices notificationServices = NotificationServices();
  bool isDialogOpen = false;
  int numberOfRelation = 1;

  // address variable
  late String full_address;

  @override
  void initState() {
    super.initState();
    locationPermission();
    getTotalNumberOfContactDetails();
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
      print("=================shake  $isButtonPress  $isDialogOpen");
      count++;
      if (isButtonPress && !isDialogOpen) {
        Future.delayed(const Duration(milliseconds: 500), () {
          showAlert();
        });
        // showAlert()
        isDialogOpen = true;

        Future.delayed(const Duration(milliseconds: 35000), () {
          if (isDialogOpen) {
            print("============ after 15 secound");
            getMemberDetail();
          }
        });
      }
      // notificationServices.sendNotification(
      //     "Are You Save ?", "If you are save then please visit are app");
      // showDilog("Testgin ");
      // });
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text("Shake"),
      // ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (isDialogOpen) {
      print("========== before dispose");
      getMemberDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.red,
        height: 150,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return showRelation(index);
            }),
      ),
      body: Center(
          child: MaterialButton(
        color: Colors.blueAccent,
        shape: const CircleBorder(),
        onPressed: () {
          print("============= Button pressed");
          isButtonPress = isButtonPress ? false : true;
          setState(() {});
          print("============= isButtonpress  $isButtonPress");
        },
        padding: EdgeInsets.all(35),
        child: isButtonPress ? Text("I'm Safe") : Text("Protect me \n $count"),
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
    int pass = 1234;
    print("${passwordEditingController.text}");
    if (passwordEditingController.text.compareTo(pass.toString()) == 0) {
      print("============= pasword match");
      return true;
    } else {
      return false;
    }
  }

  Widget showRelation(int i) {
    return Container(
      padding: const EdgeInsets.only(top: 15, right: 30),
      child: Column(
        children: const [
          CircleAvatar(
            radius: 25,
            child: Text(
              "A",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Text("Naveen"),
          Text("Brother"),
        ],
      ),
    );
  }

  void getMemberDetail() async {
    print("======================== get memberDetail is running");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? totalRegisterMember = sharedPreferences.getInt("total");
    for (int i = 1; i <= totalRegisterMember!; i++) {
      String? name = sharedPreferences.getString("name$i");
      String? email = sharedPreferences.getString("email$i");
      String? contact = sharedPreferences.getString("contact$i");
      String? relation = sharedPreferences.getString("relation$i");
      String con = "$name $email $contact $relation";
      print("======== adddress ${totalRegisterMember}$full_address");
      String msg =
          "Dear $name, \n your daughter in some trable please contact to her "
          "their last location is bellow"
          "$full_address";
      sendMail(name!, email!, msg);
    }
  }

  Future sendMail(String name, String email, String message) async {
    print("=============== under email send method");
    final Email emailSend = Email(
        body: message,
        subject: 'Security',
        recipients: [email],
        bcc: [email],
        cc: [email],
        isHTML: false);

    try {
      await FlutterEmailSender.send(emailSend);
      ShowSnackBar.showInSnackBar("Email send", context, Colors.green);
    } catch (error) {
      print("---------------------error is  $error");
      ShowSnackBar.showInSnackBar("Email not send", context, Colors.red);
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

  void getTotalNumberOfContactDetails()async {
    SharedPreferences sharedPreferences=Sh
  }
}
