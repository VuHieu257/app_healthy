import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:health_app/screens/login/sign_in.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'fitness_app/my_diary/provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb || Platform.isAndroid
      ? await Firebase.initializeApp(
          // name:"b-idea-b5e02",
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDA5u3V7M2c0JBFK2d5DG9LZ54jwZh0Ep8',
              appId: '1:642440346990:android:dc321e52c352c15951157f',
              messagingSenderId: '642440346990',
              projectId: 'health-app-f961f',
              storageBucket: "health-app-f961f.appspot.com"))
      : await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DateProvider()),
        ],
        child: GetMaterialApp(
          title: 'Flutter UI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // textTheme: AppTheme.textTheme,
            platform: TargetPlatform.android,
          ),
          home: const SignInScreen(),
        ));
  }
}

class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({super.key});
  final Color leftBarColor = Colors.blueAccent;
  final Color rightBarColor = Colors.greenAccent;

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = -1;
  late DateProvider dateProvider;

  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DateTime now = DateTime.now();
    DateTime lastMonday = now.subtract(Duration(days: now.weekday - 1));
    DateTime nextSunday = lastMonday.add(const Duration(days: 6));

    final waterSnapshot = await FirebaseFirestore.instance
        .collection('db_water')
        .where('time', isGreaterThanOrEqualTo: lastMonday)
        .where('time', isLessThanOrEqualTo: nextSunday)
        .where('idUser', isEqualTo: user!.uid)
        .get();

    final diarySnapshot = await FirebaseFirestore.instance
        .collection('db_Diary')
        .where('time', isGreaterThanOrEqualTo: lastMonday)
        .where('time', isLessThanOrEqualTo: nextSunday)
        .where('idUser', isEqualTo: user!.uid)
        .get();

    Map<String, double> totalWaterData = {};
    Map<String, double> totalKcalData = {};

    for (var doc in waterSnapshot.docs) {
      final data = doc.data();
      final date =
          (data['time'] as Timestamp).toDate().toString().split(' ')[0];
      totalWaterData[date] = data['totalWater'].toDouble();
    }

    for (var doc in diarySnapshot.docs) {
      final data = doc.data();
      final date =
          (data['time'] as Timestamp).toDate().toString().split(' ')[0];
      final totalKcal = calculateTotalKcal(data);
      totalKcalData[date] = totalKcal;
    }

    List<BarChartGroupData> items = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = lastMonday.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final totalKcal = totalKcalData[formattedDate] ?? 0;
      final totalWater = totalWaterData[formattedDate] ?? 0;
      items.add(makeGroupData(i, totalKcal, totalWater));
    }

    setState(() {
      rawBarGroups = items;
      showingBarGroups = rawBarGroups;
    });
  }

  double calculateTotalKcal(Map<String, dynamic> data) {
    double totalKcal = 0;

    if (data['breakFastList'] != null) {
      for (var item in data['breakFastList']) {
        totalKcal += double.parse(item['kcal']);
      }
    }

    if (data['lunchList'] != null) {
      for (var item in data['lunchList']) {
        totalKcal += double.parse(item['kcal']);
      }
    }

    if (data['dinnerList'] != null) {
      for (var item in data['dinnerList']) {
        totalKcal += double.parse(item['kcal']);
      }
    }

    if (data['snackList'] != null) {
      for (var item in data['snackList']) {
        totalKcal += double.parse(item['kcal']);
      }
    }

    return totalKcal;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // final Color leftBarColor = Colors.blueAccent;
                // final Color rightBarColor = Colors.greenAccent;
                Container(
                  height: 6,
                  width: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                const Text(
                  'Kcal',
                  style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 6,
                  width: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                const Text(
                  'Water',
                  style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 7000,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }
                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                  toY: avg, color: widget.leftBarColor);
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 500,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 1000) {
      text = '1000';
    } else if (value == 2000) {
      text = '2000';
    } else if (value == 3000) {
      text = '3000';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Tu', 'Wd', 'Th', 'Fr', 'Sa', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.red + other.red) ~/ 2;
    final green = (this.green + other.green) ~/ 2;
    final blue = (this.blue + other.blue) ~/ 2;
    final alpha = (this.alpha + other.alpha) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
