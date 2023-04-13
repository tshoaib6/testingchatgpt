import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imechano/ui/modal/approve_jobcard_model.dart';
import 'package:imechano/ui/provider/theme_provider.dart';
import 'package:imechano/ui/repository/repository.dart';
import 'package:imechano/ui/shared/widgets/appbar/custom_appbar_widget.dart';
import 'package:imechano/ui/styling/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../modal/send_notification_admin_modal.dart';
import '../../styling/config.dart';
import '../../styling/global.dart';

class ProgressReportActive extends StatefulWidget {
  const ProgressReportActive({this.job_number});
  final String? job_number;

  @override
  _ProgressReportActiveState createState() => _ProgressReportActiveState();
}

class _ProgressReportActiveState extends State<ProgressReportActive> {
  DateTime _selectedValue = DateTime.now();
  DateTime _dateTime = DateTime.now();
  double hh = 0;
  double ww = 0;
  var steps = [];
  int check = 0;
  int deliveryStatus = 0;
  XFile? image, temp;
  String? id;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? imagefiles = <XFile>[];
  TextEditingController workdoneController = TextEditingController();
  final _repository = Repository();
  @override
  void initState() {
    super.initState();
    loadSteps();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  acceptbookingApiCall(String jobNumber) async {
    Loader().showLoader(context);
    final ApproveJobCardModel isapprovejobcard =
        await _repository.approveJobCardAPI(jobNumber);
    if (isapprovejobcard.code != '0') {
      Loader().hideLoader(context);
      snackBar(isapprovejobcard.message ?? 'Accept Booking');
      setState(() {});
      // incomingBookingsBloc.onincomingBookSink('0', '', '');
      // incomingBookingsBloc.onincomingBookSink(
      //     '2', formatter.format(fromDate), formatter.format(toDate));
      // onSendNotificationAPI();
    } else {
      Loader().hideLoader(context);
      showpopDialog(context, 'Error',
          isapprovejobcard.message != null ? isapprovejobcard.message! : '');
    }
  }

  // void onResumed() {
  //   print("~~~~~~~ resumed");
  //   loadSteps();
  //   setState(() {});
  // }

  // void onPaused() {
  //   print("~~~~~~~ onPaused");
  // }

  // void onInactive() {
  //   print("~~~~~~~ onInactive");
  // }

  // void onDetached() {
  //   print("~~~~~~~ onDetached");
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       onResumed();

  //       break;
  //     case AppLifecycleState.inactive:
  //       onPaused();
  //       break;
  //     case AppLifecycleState.paused:
  //       onInactive();
  //       break;
  //     case AppLifecycleState.detached:
  //       onDetached();
  //       break;
  //   }
  // }

  dynamic appModelTheme;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    loadSteps();
    print("length");
    print(steps.length);
    hh = MediaQuery.of(context).size.height;
    ww = MediaQuery.of(context).size.width;
    final appModel = Provider.of<AppModel>(context);
    appModelTheme = appModel;
    return ScreenUtilInit(
        designSize: Size(360, 690),
        builder: () => Scaffold(
              backgroundColor: appModelTheme.darkTheme ? black : logoBlue,
              appBar: WidgetAppBar(
                  title: 'Progress Report',
                  menuItem: 'assets/svg/Arrow_alt_left.svg',
                  action: 'assets/svg/shopping-cart.svg',
                  action2: 'assets/svg/ball.svg'),
              body: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: appModelTheme.darkTheme ? darkmodeColor : white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'BMW',
                          style: TextStyle(fontFamily: "Poppins2"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 63),
                        child: Image.asset(
                          "assets/icons/select_car/2021-BMW.png",
                          height: 130,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        // child: Image.asset("assets/images/Group 9247.png"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      steps.length > 0
                          ? Stepper(
                              physics: ClampingScrollPhysics(),
                              controlsBuilder: (BuildContext context,
                                  ControlsDetails controls) {
                                return Row(
                                  children: <Widget>[
                                    Container(),
                                  ],
                                );
                              },
                              currentStep: _index,
                              // onStepCancel: () {
                              //   if (_index > 0) {
                              //     setState(() {
                              //       _index -= 1;
                              //     });
                              //   }
                              // },
                              // onStepContinue: () {
                              //   if (_index <= 0) {
                              //     setState(() {
                              //       _index += 1;
                              //     });
                              //   }
                              // },
                              onStepTapped: (int index) {
                                setState(() {
                                  print(steps.length);
                                  print(_index);

                                  _index = index;
                                });
                              },
                              steps: <Step>[
                                for (int i = 0; i < steps.length; i++)
                                  Step(
                                    title: Text(steps[i]['name']),
                                    content: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(children: <Widget>[
                                        for (int j = 0;
                                            j <
                                                (steps[i]['work_image']
                                                        .toString()
                                                        .contains(",")
                                                    ? steps[i]['work_image']
                                                            .split(",")
                                                            .length -
                                                        1
                                                    : 0);
                                            j++)
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Image.network(
                                                  Config.imageurl +
                                                      steps[i]['work_image']
                                                          .split(",")[j]
                                                          .toString(),
                                                  height: 120,
                                                ),
                                              ),
                                            ],
                                          ),
                                        new Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, top: 10),
                                          child: Text(
                                            steps[i]['status'] != "0"
                                                ? "WORK DONE"
                                                : "COMING SOON...",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        new Row(
                                          children: [
                                            // Text("WORK DONE: ",
                                            //     style: const TextStyle(
                                            //         fontWeight:
                                            //             FontWeight.bold)),
                                            // Text(
                                            //   steps[i]['work_done'],
                                            //   textAlign: TextAlign.center,
                                            // ),
                                            Flexible(
                                              child: Text(
                                                steps[i]['status'] != "0"
                                                    ? steps[i]['work_done']
                                                                .toString()
                                                                .length >
                                                            0
                                                        ? steps[i]['work_done']
                                                        : "Not Explained."
                                                    : "",
                                                maxLines: 10,
                                                softWrap: true,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                    isActive: steps[i]['status'] != "0"
                                        ? true
                                        : false,
                                  ),
                              ],
                            )
                          : Text(""),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                          height: 0.5,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Service Details',
                          style:
                              TextStyle(fontFamily: "poppins2", fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Engnie",
                            style: TextStyle(fontFamily: "poppins2")),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 15.w,
                          bottom: 15.w,
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.h),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 20.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 13.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_outline_sharp,
                                      color: presenting,
                                    ),
                                    Text(
                                      '4.5',
                                      style: TextStyle(
                                        fontFamily: 'Poppins1',
                                        color: presenting,
                                      ),
                                    ),
                                    SizedBox(width: 10.w.h),
                                    Text(
                                      '250 Ratings',
                                      style: TextStyle(
                                        fontFamily: 'Poppins1',
                                        color: appModelTheme.darkTheme
                                            ? Colors.white54
                                            : Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.w, top: 15.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                      size: 10.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'Takes 4 Hour',
                                      style: TextStyle(
                                        fontFamily: 'Poppins1',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 20.w,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Every 6 Months or 5000 kms',
                                      style: TextStyle(
                                        fontFamily: 'Poppins1',
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                    ),
                                    // Text(
                                    //   "KDW 4.000",
                                    //   style: TextStyle(
                                    //       fontFamily: "poppins1",
                                    //       fontSize: 15,
                                    //       color: red),
                                    // ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Alignment & Balancing Included',
                                      style: TextStyle(
                                        fontFamily: 'Poppins1',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Wheel Rotation Inlcluded',
                                      style: TextStyle(
                                        fontFamily: 'Poppins1',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  "KDW 4.000",
                                  style: TextStyle(
                                      fontFamily: "poppins1",
                                      fontSize: 15,
                                      color: red),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      check == 0 || check == 1
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  check == 0
                                      ? "Admin Has Not Requestedkk Yet"
                                      : "Admin Has Requested For Delivery",
                                  style: TextStyle(
                                    fontFamily: 'Poppins1',
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _bookSchedule()
                              ],
                            )
                          : deliveryStatus == 1 || deliveryStatus == 2
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      deliveryStatus == 1
                                          ? "Please Confirm Delivery or Reject with reason"
                                          : "",
                                      style: TextStyle(
                                        fontFamily: 'Poppins1',
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //Confirm Delivertyyy
                                    _confirmDelivery(
                                        widget.job_number.toString()),
                                    _rejectDelivery()
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    'Delivery Request Has Been Accepted',
                                    style: TextStyle(
                                      fontFamily: 'Poppins1',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget _bookSchedule() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 20),
      child: GestureDetector(
        onTap: () {
          check == 0
              ? showSnackBar(context, "Admin Has Not Requested Yet")
              : showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.all(20.h),
                    child: Container(
                      height: hh * 0.57,
                      child: _DateTime(),
                    ),
                  ),
                );
        },
        child: Container(
          height: 48,
          width: 380.w,
          decoration: BoxDecoration(
            color: check == 0 ? Colors.grey : logoBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Accept Request',
                style: TextStyle(
                  fontFamily: 'Poppins1',
                  color: white,
                  fontSize: 15,
                ),
              ),
              // Icon(
              //   Icons.shopping_cart,
              //   color: white,
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmDelivery(String jobNumber) {
    if (deliveryStatus == 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 25, right: 20),
        child: GestureDetector(
          onTap: () {
            acceptbookingApiCall(jobNumber);
            // onSendNotificationAdminAPI();
          },
          child: Container(
            height: 48,
            width: 380.w,
            decoration: BoxDecoration(
              color: deliveryStatus == 1 ? logoBlue : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Confirm Delivery',
                  style: TextStyle(
                    fontFamily: 'Poppins1',
                    color: white,
                    fontSize: 15,
                  ),
                ),
                // Icon(
                //   Icons.shopping_cart,
                //   color: white,
                // )
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 25, right: 20),
        child: GestureDetector(
          onTap: () {
            showSnackBar(context, "You have already confirmed delivery.");
          },
          child: Container(
            height: 48,
            width: 380.w,
            decoration: BoxDecoration(
              color: deliveryStatus == 1 ? logoBlue : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Delivery Confirmed',
                  style: TextStyle(
                    fontFamily: 'Poppins1',
                    color: white,
                    fontSize: 15,
                  ),
                ),
                // Icon(
                //   Icons.shopping_cart,
                //   color: white,
                // )
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _rejectDelivery() {
    if (deliveryStatus == 1) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 20, top: 20, bottom: 20),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Container(
                margin: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 105.h, bottom: 135.h),
                child: _dialogBox(),
              ),
            );
          },
          child: Container(
            height: 48,
            width: 380.w,
            decoration: BoxDecoration(
              color: deliveryStatus == 1 ? Colors.red : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Reject Delivery',
                  style: TextStyle(
                    fontFamily: 'Poppins1',
                    color: white,
                    fontSize: 15,
                  ),
                ),
                // Icon(
                //   Icons.shopping_cart,
                //   color: white,
                // )
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 25, right: 20),
        child: GestureDetector(
          onTap: () {
            showSnackBar(context, "You have already confirmed delivery.");
          },
          child: Container(
            height: 48,
            width: 380.w,
            decoration: BoxDecoration(
              color: deliveryStatus == 1 ? logoBlue : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Delivery Confirmed',
                  style: TextStyle(
                    fontFamily: 'Poppins1',
                    color: white,
                    fontSize: 15,
                  ),
                ),
                // Icon(
                //   Icons.shopping_cart,
                //   color: white,
                // )
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _DateTime() {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        color: appModelTheme.darkTheme ? darkmodeColor : Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: appModelTheme.darkTheme
                      ? Color(0xff252525)
                      : Color(0xff70bdf1)),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Text('Select Date and Time',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Poppins1')),
                  ),
                  SizedBox(height: 5.h),
                  Divider(color: Colors.white),
                  Center(
                    child: DatePicker(
                      DateTime.now(),
                      height: hh * 0.13,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: appModelTheme.darkTheme
                          ? darkmodeColor
                          : Colors.transparent,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        // New date selected
                        setState(() {
                          _selectedValue = date;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Time(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all()),
                    padding: EdgeInsets.only(
                        left: 40, right: 40, top: 10, bottom: 10),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins3',
                          color:
                              appModelTheme.darkTheme ? white : Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30.w,
                ),
                GestureDetector(
                  onTap: () async {
                    Loader().showLoader(context);
                    await _repository.scheduledelivery(
                      widget.job_number!,
                      DateFormat('yyyy/MM/dd kk:mm').format(_dateTime),
                    );
                    Loader().hideLoader(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);

                    // userStr
                    //     ? callCarBookingAPI()
                    //     : showsuccessfullyToastMessage();

                    // snackBar('Appoinment Successfully!!');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.only(
                        left: 40, right: 40, top: 10, bottom: 10),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Poppins3'),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h)
          ],
        ),
      ),
    );
  }

  Widget Time() {
    return Container(
      height: hh * 0.25,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        onDateTimeChanged: (datetime) {
          print(datetime);
          setState(() {
            _dateTime = datetime;
          });
        },
        initialDateTime: _dateTime,
        use24hFormat: false,
      ),
    );
  }

  loadSteps() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(Config.apiurl + Config.viewitems));
    request.fields.addAll({
      'job_number': widget.job_number.toString(),
    });

    var res = request
        .send()
        .then((value) => http.Response.fromStream(value).then((onvalue) {
              log("BODY ");
              print(onvalue.body);

              final result = jsonDecode(onvalue.body) as Map<String, dynamic>;
              log("CODE");
              print(result['code']);
              if (result['code'] != '0') {
                // FocusScope.of(context).requestFocus(FocusNode());
                //
                // Loader().hideLoader(context);
                // snackBar(result['message'].toString());

                setState(() {
                  print("osamam");

                  steps = result['data'];
                  print("Status");
                  print(steps[0]['status']);
                  var booking = result['booking'];
                  deliveryStatus = int.parse(booking['delivery_status']);
                  check = int.parse(result['request']);
                  // print(booking);
                  print(result['data'].toString());
                  print(steps[0]['name']);
                });
              } else {
                print(result['message'].toString());
                // Loader().hideLoader(context);
                // showpopDialog(
                //     context, 'Error', result['message'] != null ? result['message'] : '');
              }
            }));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  dynamic onSendNotificationAdminAPI() async {
    // show loader
    Loader().showLoader(context);
    final SendNotificationAdminModel isAdmin =
        await _repository.onSendNotificationAdminAPI(
            'Delivery Confirmed', 'User has confirmed delivery.');
    Loader().hideLoader(context);
    if (isAdmin.code != '0') {
      FocusScope.of(context).requestFocus(FocusNode());
      Loader().hideLoader(context);
      return showSnackBar(context, "You have confirmed delivery. Thank you");
    } else {
      Loader().hideLoader(context);
      showpopDialog(
          context, 'Error', isAdmin.message != null ? isAdmin.message! : '');
    }
  }

  dynamic onRejectSendNotificationAdminAPI() async {
    // show loader
    Loader().showLoader(context);
    final SendNotificationAdminModel isAdmin =
        await _repository.onSendNotificationAdminAPI('Delivery Rejected',
            'User has rejected delivery. Please check rejected Job Card!');
    Loader().hideLoader(context);
    if (isAdmin.code != '0') {
      FocusScope.of(context).requestFocus(FocusNode());
      Loader().hideLoader(context);
      return showSnackBar(
          context, "You have rejected delivery. We will contact you soon!");
    } else {
      Loader().hideLoader(context);
      showpopDialog(
          context, 'Error', isAdmin.message != null ? isAdmin.message! : '');
    }
  }

  Widget _dialogBox() {
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    print("dialogbox called");
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    imagefiles = null;
    workdoneController.text = "";
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.w, top: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                            'assets/icons/My Account/Group 9412.png',
                            cacheHeight: 20,
                            cacheWidth: 20),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    'Upload Image',
                    style: TextStyle(fontSize: 17.sp, fontFamily: 'Poppins2'),
                  ),
                ),
                Center(
                  child: Text(
                    'File Should be PNG of JPEG',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Poppins1',
                      color: buttonNaviBlue4c5e6bBorder,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
            SizedBox(height: 10.h),
            _dottedContainer(),
            SizedBox(height: 10.h),
            _containerTextfield(),
            SizedBox(height: 40.h),
            _submitButton(),
            SizedBox(height: 40.h),
            _submitWithoutImagesButton(),
            SizedBox(height: 10.h)
          ],
        ),
      ),
    );
  }

  Widget _dottedContainer() {
    return DottedBorder(
        color: Color(0xff70BDF1),
        borderType: BorderType.RRect,
        radius: Radius.circular(12.sp),
        dashPattern: [5, 5],
        child: StatefulBuilder(
          builder: (context, setState1) => ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.sp)),
            child: GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width * 0.77,
                  color: Color(0xffF5FAFF),
                  child: Column(
                    children: [
                      // SizedBox(height: 20),
                      // Image.asset('assets/icons/My Account/file.png',
                      //     cacheHeight: 50, cacheWidth: 55),
                      // SizedBox(height: 10),
                      // GestureDetector(
                      //
                      //   child: Text(
                      //     'Upload here Your car\'s images',
                      //     style: TextStyle(
                      //       fontSize: 14.sp,
                      //       fontFamily: 'Poppins1',
                      //       color: buttonNaviBlue4c5e6bBorder,
                      //     ),
                      //   ),
                      // ),
                      imagefiles != null
                          ? Wrap(
                              children: imagefiles!.map((imageone) {
                                return Container(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Card(
                                      child: Container(
                                        height: 100,
                                        width: 100 / (imagefiles!.length * 0.5),
                                        child: Image.file(File(imageone.path)),
                                      ),
                                    ));
                              }).toList(),
                            )
                          : Container(
                              child: Column(children: [
                              SizedBox(height: 20),
                              Image.asset('assets/icons/My Account/file.png',
                                  cacheHeight: 50, cacheWidth: 55),
                              SizedBox(height: 10),
                              GestureDetector(
                                child: Text(
                                  'Upload here Your car\'s images',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins1',
                                    color: buttonNaviBlue4c5e6bBorder,
                                  ),
                                ),
                              ),
                            ]))
                    ],
                  ),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Center(
                          child: Text(
                            "SELECT ANY ONE",
                            style: TextStyle(fontFamily: "Poppins2"),
                          ),
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SimpleDialogOption(
                                child: InkWell(
                                  onTap: () async {
                                    openCamera();
                                    // image = await _picker.pickImage(
                                    //     source: ImageSource.camera);
                                    // if (image != null) {
                                    //   setState(() {
                                    //     temp = image;
                                    //     XFile imageFile = XFile(image!.path);
                                    //
                                    //     var imagefile = imageFile as List<XFile>?;
                                    //     imagefiles = [...?imagefiles, ...?imagefile].toSet().toList();
                                    //   });
                                    //
                                    // }
                                    // Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 60.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: logoBlue,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "camera",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                            fontFamily: "Poppins1"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SimpleDialogOption(
                                child: InkWell(
                                  onTap: () async {
                                    openGallery();
                                    // image = await _picker.pickImage(
                                    //     source: ImageSource.gallery);
                                    //
                                    // setState(() {
                                    //   temp = image;
                                    // });
                                  },
                                  child: Container(
                                    height: 60.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: logoBlue,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Gallary",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                            fontFamily: "Poppins1"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
        ));
  }

  Widget _containerTextfield() {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height / 9.8,
        margin: EdgeInsets.only(left: 40, right: 40),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: TextField(
            controller: workdoneController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: buttonNaviBlue4c5e6bBorder,
                  fontFamily: 'Poppins1',
                  fontSize: 14,
                ),
                hintText: 'Rejection Reason...'),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        print("test");
        print(temp);
        if (workdoneController.text.isEmpty) {
          Fluttertoast.showToast(
              msg: 'Please Add Details',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.black,
              fontSize: 16.0);
        } else if (imagefiles == null) {
          // snackBar('Please Add Image');
          Fluttertoast.showToast(
              msg: 'Please Add Image',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.black,
              fontSize: 16.0);
        } else {
          // uploadImageHTTP(imagefiles!);
          // Navigator.pop(context);
          onRejectSendNotificationAdminAPI();
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 40.w, right: 40.w),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: logoBlue,
        ),
        child: Center(
          child: Text(
            'Submit',
            style: TextStyle(
              color: white,
              fontFamily: 'Poppins1',
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitWithoutImagesButton() {
    return GestureDetector(
      onTap: () {
        // updateCustomerItemApi(id.toString());
        // Navigator.pop(context);
        onRejectSendNotificationAdminAPI();
      },
      child: Container(
        margin: EdgeInsets.only(left: 40.w, right: 40.w),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: logoBlue,
        ),
        child: Center(
          child: Text(
            'Submit without Images',
            style: TextStyle(
              color: white,
              fontFamily: 'Poppins1',
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  openCamera() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        temp = image;
        List<XFile>? imagefile = <XFile>[];
        imagefile.add(image);

        setState(() {
          imagefiles = [...?imagefiles, ...imagefile].toSet().toList();
        });
        Navigator.pop(context);
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file. $e");
    }
  }

  openGallery() async {
    try {
      var pickedfiles = await _picker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        setState(() {
          imagefiles = [...?imagefiles, ...pickedfiles].toSet().toList();
        });
        Navigator.pop(context);
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }
}

