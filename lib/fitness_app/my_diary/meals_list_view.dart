import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/core/size/size.dart';
import 'package:health_app/fitness_app/my_diary/provider/provider.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../core/database/database_service.dart';
import '../fitness_app_theme.dart';
import '../models/meals_list_data.dart';

class MealsListView extends StatefulWidget {
  const MealsListView(
      {super.key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation});

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;
  double totalKcal = 0.0;
  DateTime selectedDate = DateTime.now();
  late DateProvider dateProvider;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dateProvider = Provider.of<DateProvider>(context, listen: false);
      dateProvider.checkAndDisplayData();
      dateProvider.checkAndDisplayWaterData();
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: SizedBox(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: mealsListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.65,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return MealDetailBottomSheet(
                                meal: mealsListData[index]);
                          },
                        ),
                      );
                    },
                    child: MealsView(
                      mealsListData: mealsListData[index],
                      animation: animation,
                      animationController: animationController!,
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

class MealsView extends StatelessWidget {
  const MealsView(
      {super.key,
      this.mealsListData,
      this.animationController,
      this.animation});

  final MealsListData? mealsListData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: context.width * 0.3,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(mealsListData!.endColor)
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(mealsListData!.startColor),
                            HexColor(mealsListData!.endColor),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 54, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              mealsListData!.titleTxt,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      mealsListData!.meals!.join('\n'),
                                      style: const TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        color: FitnessAppTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Consumer<DateProvider>(
                              builder: (context, dateProvider, _) => Column(
                                children: <Widget>[
                                  if (dateProvider
                                      .isLoading) // Show loading indicator if isLoading is true
                                    const CircularProgressIndicator(),
                                  if (!dateProvider.isLoading)
                                    mealsListData!.titleTxt == 'Breakfast'
                                        ? dateProvider.totalBreakfastKcal != 0
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: context.width * 0.12,
                                                    child: Text(
                                                      dateProvider
                                                          .totalBreakfastKcal
                                                          .toStringAsFixed(1),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              FitnessAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18,
                                                          letterSpacing: 0.2,
                                                          color: FitnessAppTheme
                                                              .white,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4, bottom: 3),
                                                    child: Text(
                                                      'kcal',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FitnessAppTheme
                                                                .fontName,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10,
                                                        letterSpacing: 0.2,
                                                        color: FitnessAppTheme
                                                            .white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: FitnessAppTheme
                                                      .nearlyWhite,
                                                  shape: BoxShape.circle,
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: FitnessAppTheme
                                                            .nearlyBlack
                                                            .withOpacity(0.4),
                                                        offset: const Offset(
                                                            8.0, 8.0),
                                                        blurRadius: 8.0),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: HexColor(
                                                        mealsListData!
                                                            .endColor),
                                                    size: 24,
                                                  ),
                                                ),
                                              )
                                        : mealsListData!.titleTxt == 'Lunch'
                                            ? dateProvider.totalLunchKcal != 0
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        dateProvider
                                                            .totalLunchKcal
                                                            .toStringAsFixed(1),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              FitnessAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18,
                                                          letterSpacing: 0.2,
                                                          color: FitnessAppTheme
                                                              .white,
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 4,
                                                                bottom: 3),
                                                        child: Text(
                                                          'kcal',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FitnessAppTheme
                                                                    .fontName,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 10,
                                                            letterSpacing: 0.2,
                                                            color:
                                                                FitnessAppTheme
                                                                    .white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color: FitnessAppTheme
                                                          .nearlyWhite,
                                                      shape: BoxShape.circle,
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color:
                                                                FitnessAppTheme
                                                                    .nearlyBlack
                                                                    .withOpacity(
                                                                        0.4),
                                                            offset:
                                                                const Offset(
                                                                    8.0, 8.0),
                                                            blurRadius: 8.0),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: HexColor(
                                                            mealsListData!
                                                                .endColor),
                                                        size: 24,
                                                      ),
                                                    ),
                                                  )
                                            : mealsListData!.titleTxt ==
                                                    'Dinner'
                                                ? dateProvider
                                                            .totalDinnerKcal !=
                                                        0
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            dateProvider
                                                                .totalDinnerKcal
                                                                .toStringAsFixed(
                                                                    1),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  FitnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0.2,
                                                              color:
                                                                  FitnessAppTheme
                                                                      .white,
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4,
                                                                    bottom: 3),
                                                            child: Text(
                                                              'kcal',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FitnessAppTheme
                                                                        .fontName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 10,
                                                                letterSpacing:
                                                                    0.2,
                                                                color:
                                                                    FitnessAppTheme
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FitnessAppTheme
                                                              .nearlyWhite,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                                color: FitnessAppTheme
                                                                    .nearlyBlack
                                                                    .withOpacity(
                                                                        0.4),
                                                                offset:
                                                                    const Offset(
                                                                        8.0,
                                                                        8.0),
                                                                blurRadius:
                                                                    8.0),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: HexColor(
                                                                mealsListData!
                                                                    .endColor),
                                                            size: 24,
                                                          ),
                                                        ),
                                                      )
                                                : dateProvider.totalSnackKcal !=
                                                        0
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            dateProvider
                                                                .totalSnackKcal
                                                                .toStringAsFixed(
                                                                    1),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  FitnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0.2,
                                                              color:
                                                                  FitnessAppTheme
                                                                      .white,
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4,
                                                                    bottom: 3),
                                                            child: Text(
                                                              'kcal',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FitnessAppTheme
                                                                        .fontName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 10,
                                                                letterSpacing:
                                                                    0.2,
                                                                color:
                                                                    FitnessAppTheme
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FitnessAppTheme
                                                              .nearlyWhite,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                                color: FitnessAppTheme
                                                                    .nearlyBlack
                                                                    .withOpacity(
                                                                        0.4),
                                                                offset:
                                                                    const Offset(
                                                                        8.0,
                                                                        8.0),
                                                                blurRadius:
                                                                    8.0),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: HexColor(
                                                                mealsListData!
                                                                    .endColor),
                                                            size: 24,
                                                          ),
                                                        ),
                                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 8,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(mealsListData!.imagePath),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealDetailBottomSheet extends StatefulWidget {
  final MealsListData meal;

  const MealDetailBottomSheet({super.key, required this.meal});

  @override
  State<MealDetailBottomSheet> createState() => _MealDetailBottomSheetState();
}

class _MealDetailBottomSheetState extends State<MealDetailBottomSheet> {
  final NutritionService _nutritionService = NutritionService();
  Map<String, dynamic>? _nutritionData;
  DatabaseService databaseService = DatabaseService();
  String vL = '';
  String addTitle = '';
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> breakfastItems = [
    {
      'name': 'Oatmeal',
      'calories': 150,
      'protein': 5,
      'fat': 3,
      'carbs': 27,
      'selected': false
    },
    {
      'name': 'Scrambled Eggs',
      'calories': 200,
      'protein': 14,
      'fat': 15,
      'carbs': 1,
      'selected': false
    },
    {
      'name': 'Orange Juice',
      'calories': 110,
      'protein': 2,
      'fat': 0.5,
      'carbs': 26,
      'selected': false
    },
    {
      'name': 'Greek Yogurt',
      'calories': 100,
      'protein': 10,
      'fat': 0,
      'carbs': 15,
      'selected': false
    },
    {
      'name': 'Avocado Toast',
      'calories': 250,
      'protein': 6,
      'fat': 17,
      'carbs': 22,
      'selected': false
    },
    {
      'name': 'Smoothie Bowl',
      'calories': 300,
      'protein': 8,
      'fat': 10,
      'carbs': 45,
      'selected': false
    },
    {
      'name': 'Granola',
      'calories': 200,
      'protein': 4,
      'fat': 10,
      'carbs': 30,
      'selected': false
    },
    {
      'name': 'Pancakes',
      'calories': 350,
      'protein': 8,
      'fat': 10,
      'carbs': 55,
      'selected': false
    },
    {
      'name': 'Fruit Salad',
      'calories': 150,
      'protein': 2,
      'fat': 1,
      'carbs': 35,
      'selected': false
    },
    {
      'name': 'Bagel with Cream Cheese',
      'calories': 290,
      'protein': 9,
      'fat': 11,
      'carbs': 40,
      'selected': false
    },
    {
      'name': 'Breakfast Burrito',
      'calories': 400,
      'protein': 18,
      'fat': 20,
      'carbs': 35,
      'selected': false
    },
    {
      'name': 'Chia Pudding',
      'calories': 250,
      'protein': 6,
      'fat': 14,
      'carbs': 29,
      'selected': false
    },
  ];

  final List<Map<String, dynamic>> lunchItems = [
    {
      'name': 'Grilled Chicken Salad',
      'calories': 350,
      'protein': 30,
      'fat': 15,
      'carbs': 20,
      'selected': false
    },
    {
      'name': 'Tomato Soup',
      'calories': 150,
      'protein': 4,
      'fat': 7,
      'carbs': 20,
      'selected': false
    },
    {
      'name': 'Bread Roll',
      'calories': 120,
      'protein': 4,
      'fat': 1,
      'carbs': 23,
      'selected': false
    },
    {
      'name': 'Turkey Sandwich',
      'calories': 320,
      'protein': 25,
      'fat': 10,
      'carbs': 35,
      'selected': false
    },
    {
      'name': 'Caesar Salad',
      'calories': 400,
      'protein': 10,
      'fat': 30,
      'carbs': 20,
      'selected': false
    },
    {
      'name': 'Quinoa Bowl',
      'calories': 350,
      'protein': 12,
      'fat': 14,
      'carbs': 45,
      'selected': false
    },
    {
      'name': 'Veggie Wrap',
      'calories': 300,
      'protein': 8,
      'fat': 10,
      'carbs': 40,
      'selected': false
    },
    {
      'name': 'Chicken Stir Fry',
      'calories': 450,
      'protein': 35,
      'fat': 15,
      'carbs': 45,
      'selected': false
    },
  ];

  final List<Map<String, dynamic>> snackItems = [
    {
      'name': 'Apple',
      'calories': 95,
      'protein': 0.5,
      'fat': 0.3,
      'carbs': 25,
      'selected': false
    },
    {
      'name': 'Greek Yogurt',
      'calories': 100,
      'protein': 10,
      'fat': 0,
      'carbs': 15,
      'selected': false
    },
    {
      'name': 'Granola Bar',
      'calories': 150,
      'protein': 4,
      'fat': 5,
      'carbs': 25,
      'selected': false
    },
    {
      'name': 'Almonds',
      'calories': 160,
      'protein': 6,
      'fat': 14,
      'carbs': 6,
      'selected': false
    },
    {
      'name': 'Hummus with Carrots',
      'calories': 180,
      'protein': 5,
      'fat': 10,
      'carbs': 15,
      'selected': false
    },
    {
      'name': 'Banana',
      'calories': 105,
      'protein': 1,
      'fat': 0.3,
      'carbs': 27,
      'selected': false
    },
    {
      'name': 'Cheese Stick',
      'calories': 80,
      'protein': 6,
      'fat': 6,
      'carbs': 1,
      'selected': false
    },
    {
      'name': 'Protein Shake',
      'calories': 200,
      'protein': 20,
      'fat': 3,
      'carbs': 20,
      'selected': false
    },
  ];

  final List<Map<String, dynamic>> dinnerItems = [
    {
      'name': 'Grilled Salmon',
      'calories': 450,
      'protein': 40,
      'fat': 25,
      'carbs': 0,
      'selected': false
    },
    {
      'name': 'Steamed Vegetables',
      'calories': 100,
      'protein': 4,
      'fat': 1,
      'carbs': 20,
      'selected': false
    },
    {
      'name': 'Brown Rice',
      'calories': 200,
      'protein': 5,
      'fat': 2,
      'carbs': 45,
      'selected': false
    },
    {
      'name': 'Beef Steak',
      'calories': 500,
      'protein': 45,
      'fat': 30,
      'carbs': 0,
      'selected': false
    },
    {
      'name': 'Quinoa Salad',
      'calories': 350,
      'protein': 12,
      'fat': 14,
      'carbs': 45,
      'selected': false
    },
    {
      'name': 'Chicken Alfredo Pasta',
      'calories': 600,
      'protein': 35,
      'fat': 25,
      'carbs': 60,
      'selected': false
    },
    {
      'name': 'Vegetable Curry',
      'calories': 400,
      'protein': 8,
      'fat': 20,
      'carbs': 50,
      'selected': false
    },
    {
      'name': 'Tofu Stir Fry',
      'calories': 350,
      'protein': 15,
      'fat': 20,
      'carbs': 30,
      'selected': false
    },
  ];
  void _toggleSelection(Map<String, dynamic> item) {
    setState(() {
      item['selected'] = !item['selected'];
    });
  }

  late DateProvider dateProvider;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dateProvider = Provider.of<DateProvider>(context, listen: false);
      dateProvider.checkAndDisplayData();
    });
    super.initState();
  }

  bool isCheck=false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: FitnessAppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Consumer<DateProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // _panelController.close();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                        const Spacer(),
                        Text(
                          widget.meal.titleTxt,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (value) async {
                        print(value);
                        setState(() {
                          vL = value;
                          isCheck=true;
                        });
                        if (value != '') {
                          final data =
                              await _nutritionService.fetchNutritionData(value);
                          setState(() {
                            _nutritionData = data;
                            isCheck=false;
                          });
                          widget.meal.titleTxt == 'Breakfast'
                              ? breakfastItems.add({
                                  'protein': _nutritionData!['foods'][0]
                                      ['foodNutrients'][0]['value'],
                                  'fat': _nutritionData!['foods'][0]
                                      ['foodNutrients'][1]['value'],
                                  'carbs': _nutritionData!['foods'][0]
                                      ['foodNutrients'][2]['value'],
                                  'name': value,
                                  'calories': _nutritionData!['foods'][0]
                                      ['foodNutrients'][3]['value'],
                                  'selected': false,
                                })
                              : widget.meal.titleTxt == 'Lunch'
                                  ? lunchItems.add({
                                      'protein': _nutritionData!['foods'][0]
                                          ['foodNutrients'][0]['value'],
                                      'fat': _nutritionData!['foods'][0]
                                          ['foodNutrients'][1]['value'],
                                      'carbs': _nutritionData!['foods'][0]
                                          ['foodNutrients'][2]['value'],
                                      'name': value,
                                      'calories': _nutritionData!['foods'][0]
                                          ['foodNutrients'][3]['value'],
                                      'selected': false,
                                    })
                                  : widget.meal.titleTxt == 'Dinner'
                                      ? dinnerItems.add({
                                          'protein': _nutritionData!['foods'][0]
                                              ['foodNutrients'][0]['value'],
                                          'fat': _nutritionData!['foods'][0]
                                              ['foodNutrients'][1]['value'],
                                          'carbs': _nutritionData!['foods'][0]
                                              ['foodNutrients'][2]['value'],
                                          'name': value,
                                          'calories': _nutritionData!['foods']
                                              [0]['foodNutrients'][3]['value'],
                                          'selected': false,
                                        })
                                      : snackItems.add({
                                          'protein': _nutritionData!['foods'][0]
                                              ['foodNutrients'][0]['value'],
                                          'fat': _nutritionData!['foods'][0]
                                              ['foodNutrients'][1]['value'],
                                          'carbs': _nutritionData!['foods'][0]
                                              ['foodNutrients'][2]['value'],
                                          'name': value,
                                          'calories': _nutritionData!['foods']
                                              [0]['foodNutrients'][3]['value'],
                                          'selected': false,
                                        });
                        }
                      },
                      decoration: InputDecoration(
                          // labelText: 'Enter food name',
                          suffixIcon: vL != ''
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      vL = '';
                                      _controller.clear();
                                      _nutritionData = null;
                                    });
                                  },
                                )
                              : null,
                          hintText: "Looking for something",
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                  ),
                  Visibility(
                    visible: vL != '',
                    child:
                    isCheck?
                        const Center(child: CircularProgressIndicator(),)
                        :Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(35),
                                bottomLeft: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            color: Colors.grey.shade300,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: HexColor('#FFB295').withOpacity(0.6),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor('#FA7D82'),
                                HexColor('#FFB295'),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_nutritionData != null) ...[
                                Text(
                                  'Description: ${_nutritionData!['foods'][0]['description']}',
                                  style: const TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                                Text(
                                  'Calories: ${_nutritionData!['foods'][0]['foodNutrients'][3]['value']} kcal',
                                  style: const TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ), // Example nutrient data
                                Text(
                                  'Protein: ${_nutritionData!['foods'][0]['foodNutrients'][0]['value']} g',
                                  style: const TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                                Text(
                                  'Fat: ${_nutritionData!['foods'][0]['foodNutrients'][1]['value']} g',
                                  style: const TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                                Text(
                                  'Carbs: ${_nutritionData!['foods'][0]['foodNutrients'][2]['value']} g',
                                  style: const TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                                // Hiển thị các thông tin khác
                              ],
                              SizedBox(
                                width: context.width * 0.2,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          vL = '';
                                          _controller.clear();
                                          _nutritionData = null;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.nearlyWhite,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: FitnessAppTheme.nearlyBlack
                                                    .withOpacity(0.4),
                                                offset: const Offset(8.0, 8.0),
                                                blurRadius: 8.0),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.close,
                                            color: HexColor('#FFB295'),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        widget.meal.titleTxt == 'Breakfast'
                                            ? setState(() {
                                                addTitle = 'breakFastList';
                                              })
                                            : widget.meal.titleTxt == 'Lunch'
                                                ? setState(() {
                                                    addTitle = 'lunchList';
                                                  })
                                                : widget.meal.titleTxt == 'Dinner'
                                                    ? setState(() {
                                                        addTitle = 'dinnerList';
                                                      })
                                                    : setState(() {
                                                        addTitle = 'snackList';
                                                      });
                                        databaseService
                                            .addList(provider.dataId, addTitle, [
                                          {
                                            'name':
                                                '${_nutritionData!['foods'][0]['description']}',
                                            'kcal':
                                                '${_nutritionData!['foods'][0]['foodNutrients'][3]['value']}',
                                            'protein':
                                                '${_nutritionData!['foods'][0]['foodNutrients'][0]['value']}',
                                            'fat':
                                                '${_nutritionData!['foods'][0]['foodNutrients'][1]['value']}',
                                            'Carbs':
                                                '${_nutritionData!['foods'][0]['foodNutrients'][2]['value']}'
                                          }
                                        ]);

                                        Fluttertoast.showToast(
                                          msg: "Item has been added to the list!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              HexColor('#FA7D82').withOpacity(0.6),
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        setState(() {
                                          vL = '';
                                          _controller.clear();
                                          _nutritionData = null;
                                        });
                                        provider.checkAndDisplayData();
                                      },
                                      // Thêm hiệu ứng khi click vào
                                      splashColor: Colors.blue
                                          .withOpacity(0.5), // Màu hiệu ứng
                                      highlightColor: Colors.blue.withOpacity(
                                          0.1), // Màu highlight khi giữ
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            50), // Định hình cho hiệu ứng ripple
                                      ),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(top: 5, left: 10),
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.nearlyWhite,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: FitnessAppTheme.nearlyBlack
                                                  .withOpacity(0.4),
                                              offset: const Offset(8.0, 8.0),
                                              blurRadius: 8.0,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.done,
                                            color: HexColor('#FFB295'),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                        child: Text(
                          "History",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                  SizedBox(
                    width: context.width,
                    child: Wrap(
                      children: List.generate(
                          widget.meal.titleTxt == 'Breakfast'
                              ? breakfastItems.length
                              : widget.meal.titleTxt == 'Lunch'
                                  ? lunchItems.length
                                  : widget.meal.titleTxt == 'Dinner'
                                      ? dinnerItems.length
                                      : snackItems.length, (index) {
                        var data = widget.meal.titleTxt == 'Breakfast'
                            ? breakfastItems[index]
                            : widget.meal.titleTxt == 'Lunch'
                                ? lunchItems[index]
                                : widget.meal.titleTxt == 'Dinner'
                                    ? dinnerItems[index]
                                    : snackItems[index];
                        return InkWell(
                          onTap: () {
                            _toggleSelection(breakfastItems[index]);
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 5),
                              decoration: BoxDecoration(
                                  color: data['selected'] ? Colors.blue : null,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  border: Border.all(
                                      width: 2,
                                      color: data['selected']
                                          ? Colors.blue
                                          : Colors.blue)),
                              child: Text(
                                data['name'],
                                style: TextStyle(
                                    color: data['selected']
                                        ? Colors.white
                                        : Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: Text(
                          "For You",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: context.width,
                    // height: context.height * 0.14,
                    child: StreamBuilder(
                      // stream: databaseService.getFind('idUser', 'aa'),
                      stream: databaseService
                          .getChatDocumentStream(provider.dataId),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const CircularProgressIndicator();
                        // }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Text('No data found');
                        }
                        var mealList;
                        var doc = snapshot.data!;
                        switch (widget.meal.titleTxt) {
                          case 'Breakfast':
                            mealList = doc['breakFastList'];
                            break;
                          case 'Lunch':
                            mealList = doc['lunchList'];
                            break;
                          case 'Dinner':
                            mealList = doc['dinnerList'];
                            break;
                          default:
                            mealList = doc['snackList'];
                            break;
                        }
                        if (mealList == null || mealList.isEmpty) {
                          return const Text(
                              "You haven't selected a menu"); // Return an empty widget if no meal data is available
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(mealList.length, (mealIndex) {
                            var mealData = mealList[mealIndex];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(10),
                              // margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(35),
                                  bottomLeft: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                color: Colors.grey.shade300,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: HexColor('#FFB295').withOpacity(0.6),
                                    offset: const Offset(1.1, 4.0),
                                    blurRadius: 8.0,
                                  ),
                                ],
                                gradient: LinearGradient(
                                  colors: <HexColor>[
                                    HexColor('#FA7D82'),
                                    HexColor('#FFB295'),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${mealData['name']}',
                                    style: const TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                  Text(
                                    'Calories: ${mealData['kcal']} kcal',
                                    style: const TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                  Text(
                                    'Protein: ${mealData['protein']} g',
                                    style: const TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                  Text(
                                    'Fat: ${mealData['fat']} g',
                                    style: const TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                  Text(
                                    'Carbs: ${mealData['Carbs']} g',
                                    style: const TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
