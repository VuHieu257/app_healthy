import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/fitness_app/my_diary/provider/provider.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../fitness_app_theme.dart';
import '../ui_view/wave_view.dart';
import '../../app_theme.dart';

class WaterView extends StatefulWidget {
  const WaterView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _WaterViewState createState() => _WaterViewState();
}

class _WaterViewState extends State<WaterView> with TickerProviderStateMixin {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  bool isCheckWater = true;
  @override
  void initState() {
    DateTime dateTime = DateTime.now();
    if ((dateTime.hour == 7) ||
        (dateTime.hour == 9) ||
        (dateTime.hour == 12) ||
        (dateTime.hour == 14) ||
        (dateTime.hour == 16) ||
        (dateTime.hour == 18) ||
        (dateTime.hour == 20) ||
        (dateTime.hour == 23)) {
      setState(() {
        isCheckWater = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timestamp time = Timestamp.now();
    DateTime date = time.toDate();
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Consumer<DateProvider>(
                builder: (context, provider, child) {
                  DateTime dateTime = DateTime.now();
                  var data;
                  switch (dateTime.hour) {
                    case 6:
                      data = "timeFrame1";
                      break;
                    case 8:
                      data = "timeFrame2";
                      break;
                    case 11:
                      data = "timeFrame3";
                      break;
                    case 13:
                      data = "timeFrame4";
                      break;
                    case 15:
                      data = "timeFrame5";
                      break;
                    case 17:
                      data = "timeFrame6";
                      break;
                    case 19:
                      data = "timeFrame7";
                      break;
                    case 22:
                      data = "timeFrame8";
                      break;
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(68.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: FitnessAppTheme.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                          child: Text(
                                            '${provider.water}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 32,
                                              color: FitnessAppTheme
                                                  .nearlyDarkBlue,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, bottom: 8),
                                          child: Text(
                                            'ml',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              letterSpacing: -0.2,
                                              color: FitnessAppTheme
                                                  .nearlyDarkBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 4, top: 2, bottom: 14),
                                      child: Text(
                                        'of daily goal 2L',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          color: FitnessAppTheme.darkText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, right: 4, top: 8, bottom: 16),
                                  child: Container(
                                    height: 2,
                                    decoration: const BoxDecoration(
                                      color: FitnessAppTheme.background,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (dateTime.hour == 6) ||
                                      (dateTime.hour == 8) ||
                                      (dateTime.hour == 11) ||
                                      (dateTime.hour == 13) ||
                                      (dateTime.hour == 15) ||
                                      (dateTime.hour == 17) ||
                                      (dateTime.hour == 19) ||
                                      (dateTime.hour == 22),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${dateTime.hour}:00-${dateTime.hour + 1}:00 ${dateTime.hour > 12 ? 'PM' : 'AM'} !!!\nTop up your water for focus & energy.",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontSize: 14),
                                      ),
                                      Visibility(
                                        visible: isCheckWater,
                                        child: InkWell(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('db_water')
                                                .doc(provider.dataWaterId)
                                                .update({
                                              'time': Timestamp.now(),
                                              data: true,
                                              // 'timeFrame2':true,
                                              'totalWater':
                                                  provider.water + 250,
                                            });
                                            setState(() {
                                              isCheckWater = false;
                                            });
                                            provider.checkAndDisplayWaterData();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                left: 20, right: 20, top: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              color:
                                                  FitnessAppTheme.nearlyWhite,
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: FitnessAppTheme
                                                        .nearlyDarkBlue
                                                        .withOpacity(0.4),
                                                    offset:
                                                        const Offset(4.0, 4.0),
                                                    blurRadius: 8.0),
                                              ],
                                            ),
                                            child: const Text(
                                              "To Drink",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: isCheckWater == false,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Image.asset(
                                                    'assets/fitness_app/bell.png'),
                                              ),
                                              const Flexible(
                                                child: Text(
                                                  'That\'s great, fill it up!.',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    letterSpacing: 0.0,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: (dateTime.hour != 6) &&
                                      (dateTime.hour != 8) &&
                                      (dateTime.hour != 11) &&
                                      (dateTime.hour != 13) &&
                                      (dateTime.hour != 15) &&
                                      (dateTime.hour != 17) &&
                                      (dateTime.hour != 19) &&
                                      (dateTime.hour != 22),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4),
                                              child: Icon(
                                                Icons.access_time,
                                                color: FitnessAppTheme.grey
                                                    .withOpacity(0.5),
                                                size: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                'Last drink ${provider.timeWater.hour}:${provider.timeWater.minute} AM',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  color: FitnessAppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Image.asset(
                                                    'assets/fitness_app/bell.png'),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Your bottle is empty, refill it!.',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    letterSpacing: 0.0,
                                                    color: HexColor('#F65283'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 34,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('db_water')
                                        .doc(provider.dataWaterId)
                                        .update({
                                      'time': Timestamp.now(),
                                      'timeFrame1':true,
                                      'totalWater':
                                      provider.water + 250,
                                    });
                                    SnackBar(
                                      backgroundColor: Colors.blueAccent.shade400,
                                      content:
                                      const Text("You have drunk another glass of water today!"),
                                    );
                                    provider.setWater(provider.water + 250);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FitnessAppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: FitnessAppTheme.nearlyDarkBlue
                                                .withOpacity(0.4),
                                            offset: const Offset(4.0, 4.0),
                                            blurRadius: 8.0),
                                      ],
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.add,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('db_water')
                                        .doc(provider.dataWaterId)
                                        .update({
                                      'time': Timestamp.now(),
                                      'timeFrame1':true,
                                      'totalWater':
                                      provider.water - 250,
                                    });
                                    SnackBar(
                                      backgroundColor: Colors.blueAccent.shade400,
                                      content:
                                      const Text("You have drunk another glass of water today!"),
                                    );
                                    provider.setWater(provider.water - 250);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FitnessAppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: FitnessAppTheme.nearlyDarkBlue
                                                .withOpacity(0.4),
                                            offset: const Offset(4.0, 4.0),
                                            blurRadius: 8.0),
                                      ],
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.remove,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 8, top: 16),
                            child: Container(
                              width: 60,
                              height: 160,
                              decoration: BoxDecoration(
                                color: HexColor('#E8EDFE'),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(80.0),
                                    bottomLeft: Radius.circular(80.0),
                                    bottomRight: Radius.circular(80.0),
                                    topRight: Radius.circular(80.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.4),
                                      offset: const Offset(2, 2),
                                      blurRadius: 4),
                                ],
                              ),
                              child: WaveView(
                                percentageValue: provider.water / 2000 * 100,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
