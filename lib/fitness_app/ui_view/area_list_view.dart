import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/core/size/size.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/database/database_service.dart';
import '../../main.dart';
import '../fitness_app_theme.dart';
import '../my_diary/provider/provider.dart';

class AreaListView extends StatefulWidget {
  const AreaListView(
      {super.key, this.mainScreenAnimationController, this.mainScreenAnimation});

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> areaListData = <String>[
    'assets/fitness_app/area3.png',
    'assets/fitness_app/1357ff9b8d6f46d.png',
    'assets/fitness_app/pngtree-aesthetic-ripped-paper-journaling-memo-png-image_13280081.png',
    'assets/fitness_app/area1.png',
  ];
    final List<Widget> screens = [
      const WorkoutLogScreen(),
      MealPlanScreen(),
      const JournalPage(),
      Screen4(),
    ];
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
  Route _createRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
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
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                  children: List<Widget>.generate(
                    areaListData.length,
                    (int index) {
                      final int count = areaListData.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController?.forward();
                      return AreaView(
                        imagepath: areaListData[index],
                        animation: animation,
                        animationController: animationController!,
                        call: screens[index],
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.87,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                              ),
                              child: screens[index],
                            ),
                          );
                          // Navigator.of(context).push(_createRoute(screens[index]));
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    super.key,
    this.imagepath,
    this.animationController,
    this.animation,
    required this.call,
    required this.onTap,
  });

  final String? imagepath;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Widget call;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: onTap,
                  // onTap: () {
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => call,));
                  // },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Image.asset(imagepath!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}




class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});

  @override
  _WorkoutLogScreenState createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  // final List<WorkoutLog> _workoutLogs = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user=context.read<DateProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.add,color: Colors.white,),
        title: const Text('Workout Log'  ,
          style: TextStyle(
          fontFamily: 'YourFontNameHere',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 1.2,
          color: Colors.black87,
        ),),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => hideKeyBoard,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) =>value=="" || value!.isEmpty?'Enter data':null,
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Enter workout title',
                      ),
                    ),
                    SizedBox(height: context.height*0.03),
                    TextFormField(
                      validator: (value) => value=="" || value!.isEmpty?'Enter data':null,
                      controller: _descriptionController,
                      minLines: 2,
                      maxLines: 20,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: 'Enter workout description',
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        // _formKey.currentState!.validate();
                       if(_formKey.currentState!.validate()){
                         FirebaseFirestore.instance.collection('db_workout').add(
                             {
                               'idUser':user.idUser,
                               'title':_titleController.text,
                               'description':_descriptionController.text,
                               'time':Timestamp.now()
                             }
                         );
                         Fluttertoast.showToast(msg: "Sucess",backgroundColor: Colors.green,textColor: Colors.white);
                         _titleController.clear();
                         _descriptionController.clear();
                       }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        margin: const EdgeInsets.only(top:10,right: 30,left: 30),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blue
                        ),
                        child: const Text('Add Workout',
                          style: TextStyle(
                          fontFamily: 'YourFontNameHere',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.
                collection('db_workout').
                where("idUser",isEqualTo:user.idUser ).snapshots(),
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No workout logs found'));
                    } else {
                    var docs=snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var doc=docs[index];
                        var docId=doc.id;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: FitnessAppTheme.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: FitnessAppTheme.grey.withOpacity(0.4),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: context.width*0.75,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc['title'], style: const TextStyle(
                                    fontFamily: 'YourFontNameHere',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.2,
                                    color: Colors.black87,
                                                                    ),),
                                    Text(doc['description'],
                                      style: TextStyle(
                                      fontFamily: 'YourFontNameHere',
                                      fontSize: 15,
                                      letterSpacing: 1.2,
                                      color: Colors.black87.withOpacity(0.7),
                                    ),),

                                  ],
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: context.height*0.05,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false, // User must tap a button to close the dialog
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text('Are you sure you want to delete this item?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
                                              onPressed: () {
                                                _deleteDocument(docId);
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    }, icon: const Icon(Icons.close)),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );}
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _deleteDocument(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('db_workout')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete document: $e')),
      );
    }
  }
}



class Meal {
  final String name;
  final int calories;
  final int protein;
  final int fat;
  final int carbs;

  Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });
}

// Định nghĩa lớp MealPlan để biểu diễn một kế hoạch ăn uống
class MealPlan {
  final String title;
  final String description;
  final List<Meal> breakfast; // Bữa sáng
  final List<Meal> lunch;     // Bữa trưa
  final List<Meal> dinner;    // Bữa tối
  final List<Meal> snacks;    // Bữa tối

  MealPlan({
    required this.title,
    required this.description,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });
}

// Màn hình chính hiển thị danh sách các kế hoạch ăn uống
class MealPlanScreen extends StatefulWidget {
  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final List<MealPlan> mealPlans = [
    MealPlan(
      title: 'Healthy Plan 1',
      description: 'A balanced diet for a healthy lifestyle.',
      breakfast: [
        Meal(
          name: 'Oatmeal with Banana and Chia Seeds',
          calories: 200,
          protein: 6,
          fat: 4,
          carbs: 35,
        ),
        Meal(
          name: 'Greek Yogurt with Berries and Honey',
          calories: 150,
          protein: 12,
          fat: 3,
          carbs: 18,
        ),
      ],
      lunch: [
        Meal(
          name: 'Grilled Chicken Salad with Avocado',
          calories: 350,
          protein: 32,
          fat: 15,
          carbs: 25,
        ),
        Meal(
          name: 'Quinoa with Roasted Vegetables and Chickpeas',
          calories: 300,
          protein: 18,
          fat: 10,
          carbs: 35,
        ),
      ],
      dinner: [
        Meal(
          name: 'Baked Salmon with Quinoa and Spinach',
          calories: 400,
          protein: 28,
          fat: 18,
          carbs: 40,
        ),
        Meal(
          name: 'Stir-fried Tofu with Broccoli and Brown Rice',
          calories: 350,
          protein: 22,
          fat: 15,
          carbs: 45,
        ),
      ],
      snacks: [
        Meal(
          name: 'Almonds and Walnuts',
          calories: 120,
          protein: 4,
          fat: 11,
          carbs: 4,
        ),
        Meal(
          name: 'Apple Slices with Almond Butter',
          calories: 170,
          protein: 5,
          fat: 10,
          carbs: 20,
        ),
      ],
    ),
    MealPlan(
      title: 'Healthy Plan 2',
      description: 'A nutritious plan for weight loss.',
      breakfast: [
        Meal(
          name: 'Green Smoothie with Spinach, Kale, and Berries',
          calories: 180,
          protein: 10,
          fat: 4,
          carbs: 30,
        ),
        Meal(
          name: 'Whole Grain Avocado Toast',
          calories: 220,
          protein: 7,
          fat: 12,
          carbs: 25,
        ),
      ],
      lunch: [
        Meal(
          name: 'Chicken and Vegetable Stir-fry with Brown Rice',
          calories: 350,
          protein: 30,
          fat: 10,
          carbs: 40,
        ),
        Meal(
          name: 'Quinoa Salad with Chickpeas and Fresh Vegetables',
          calories: 320,
          protein: 14,
          fat: 9,
          carbs: 45,
        ),
      ],
      dinner: [
        Meal(
          name: 'Grilled Turkey Breast with Steamed Asparagus',
          calories: 320,
          protein: 34,
          fat: 8,
          carbs: 12,
        ),
        Meal(
          name: 'Baked Sweet Potato with Cinnamon',
          calories: 180,
          protein: 3,
          fat: 1,
          carbs: 40,
        ),
      ],
      snacks: [
        Meal(
          name: 'Carrot Sticks with Hummus',
          calories: 130,
          protein: 4,
          fat: 8,
          carbs: 12,
        ),
        Meal(
          name: 'Mixed Berries with Greek Yogurt',
          calories: 100,
          protein: 6,
          fat: 2,
          carbs: 18,
        ),
      ],
    ),
    // Thêm các kế hoạch ăn uống khác tại đây
  ];
  late DateProvider dateProvider;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dateProvider = Provider.of<DateProvider>(context, listen: false);
      dateProvider.checkAndDisplayData();
    });
    super.initState();
  }
  DatabaseService databaseService=DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.add,color: Colors.white,),
        title: const Text('Healthy Meal Plans',
          style: TextStyle(
          fontFamily: 'YourFontNameHere',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 1.2,
          color: Colors.black87,
        ),),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: mealPlans.length,
        itemBuilder: (context, index) {
          var mealPlan = mealPlans[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  mealPlan.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  mealPlan.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 10.0),
              _buildMealList('Breakfast', mealPlan.breakfast),
              _buildMealList('Lunch', mealPlan.lunch),
              _buildMealList('Dinner', mealPlan.dinner),
              _buildMealList('Snacks', mealPlan.snacks),
              const Divider(),
            ],
          );
        },
      ),
    );
  }

  // Hàm xây dựng danh sách bữa ăn
  Widget _buildMealList(String title, List<Meal> meals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            var meal = meals[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: ListTile(
                title: Text(meal.name,style: const TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Calories: ${meal.calories}'),
                        Text('Protein: ${meal.protein}g'),
                        Text('Fat: ${meal.fat}g'),
                        Text('Carbs: ${meal.carbs}g'),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                          databaseService.addList(dateProvider.dataId,
                              title=="Breakfast"?"breakFastList":
                              title=="Lunch"?"lunchList":
                              title=="Dinner"?"dinnerList":"snackList"
                              , [{
                              'name':meal.name,
                              'kcal':'${meal.calories}',
                              'protein': '${meal.protein}',
                              'fat':'${meal.fat}',
                              'Carbs':'${meal.carbs}'
                              }]);
                            dateProvider.checkAndDisplayData();
                            Fluttertoast.showToast(
                            msg: "Item has been added to the list!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                      },
                      child: Container(
                        // height: context.height*0.05,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade200,
                        ),
                        child: const Text("Select",style: TextStyle(color: Colors.black87),),
                        ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _controller = TextEditingController();
  bool isCheck=false;
  String id='';
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user=context.read<DateProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.add,color: Colors.white,),
        title: const Center(
          child: Text('Journal' ,
            style: TextStyle(
            fontFamily: 'YourFontNameHere',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 1.2,
            color: Colors.black87,
          ),),
        ),
        actions: const [
          Icon(Icons.add,color: Colors.white,),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("db_journal").where("idUser", isEqualTo: user.idUser).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("You don't have a journal yet!!"),
                  );
                }
                var docs=snapshot.data!.docs??[];
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var doc = docs[index];
                    var docId=doc.id;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: FitnessAppTheme.grey.withOpacity(0.4),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox( width: context.width*0.6,child: Text('${doc['title']}',)),
                              Text(DateFormat('MM/dd/yyyy HH:mm').format(doc['time'].toDate()),style: TextStyle(
                                fontSize: 12,color: Colors.black87.withOpacity(0.3)
                              ),)
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                            setState(() {
                              _controller.text=doc['title'];
                              isCheck=true;
                              id=docId;
                            });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit_note_outlined),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // User must tap a button to close the dialog
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Are you sure you want to delete this item?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          FirebaseFirestore.instance.collection('db_journal').doc(docId).delete();
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                             child: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) => value==''|| value!.isEmpty?"Enter data":null,
                      controller: _controller,
                      minLines: 1,
                      maxLines: 20,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: isCheck?'Edit':'New Entry',
                          suffixIcon: isCheck?
                          InkWell(
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false, // User must tap a button to close the dialog
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Out'),
                                      content: const SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text('Are you sure you want to cancel the changes?'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Yes'),
                                          onPressed: () {
                                            setState(() {
                                              isCheck=false;
                                            });
                                            _controller.clear();
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () {
                                            // FirebaseFirestore.instance.collection('db_journal').doc(docId).delete();
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Icon(Icons.close)):null
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade200
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if(isCheck){
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // User must tap a button to close the dialog
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Update'),
                                content: const SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Are you sure you want to save these changes?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      setState(() {
                                        isCheck=false;
                                      });
                                      FirebaseFirestore.instance.collection('db_journal').doc(id).update(
                                          {
                                            "idUser":user.idUser,
                                            "title":_controller.text,
                                            "time":Timestamp.now(),
                                          }
                                      );
                                      Fluttertoast.showToast(msg: "Success");
                                      _controller.clear();
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }else{
                          FirebaseFirestore.instance.collection('db_journal').add(
                              {
                                "idUser":user.idUser,
                                "title":_controller.text,
                                "time":Timestamp.now(),
                              }
                          );
                          Fluttertoast.showToast(msg: "Success");
                          _controller.clear();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 4')),
      body: const Center(child: Text('But the capacity is being developed')),
    );
  }
}