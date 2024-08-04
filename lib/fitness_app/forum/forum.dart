// import 'package:flutter/material.dart';
// import 'package:health_app/core/size/size.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../fitness_app_theme.dart';
// import '../my_diary/provider/provider.dart'; // For date formatting

// class ForumScreen extends StatefulWidget {
//   const ForumScreen({super.key, this.animationController});

//   final AnimationController? animationController;

//   @override
//   _ForumScreenState createState() => _ForumScreenState();
// }

// class _ForumScreenState extends State<ForumScreen>
//     with TickerProviderStateMixin {
//   Animation<double>? topBarAnimation;
//   List<Widget> listViews = <Widget>[];
//   final ScrollController scrollController = ScrollController();
//   double topBarOpacity = 0.0;

//   DateTime selectedDate = DateTime.now(); // Selected date for posts

//   @override
//   void initState() {
//     topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: widget.animationController!,
//         curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
//       ),
//     );
//     addAllListData();

//     scrollController.addListener(() {
//       if (scrollController.offset >= 24) {
//         if (topBarOpacity != 1.0) {
//           setState(() {
//             topBarOpacity = 1.0;
//           });
//         }
//       } else if (scrollController.offset <= 24 &&
//           scrollController.offset >= 0) {
//         if (topBarOpacity != scrollController.offset / 24) {
//           setState(() {
//             topBarOpacity = scrollController.offset / 24;
//           });
//         }
//       } else if (scrollController.offset <= 0) {
//         if (topBarOpacity != 0.0) {
//           setState(() {
//             topBarOpacity = 0.0;
//           });
//         }
//       }
//     });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       dateProvider = Provider.of<DateProvider>(context, listen: false);
//     });
//     super.initState();
//   }

//   void addAllListData() {
//     const int count = 3; // Number of sections

//     // Example list views for user posts
//     listViews.add(
//       TitleView(
//         titleTxt: 'Recent Posts',
//         subTxt: 'Latest',
//         animation: Tween<double>(
//           begin: 0.0,
//           end: 1.0,
//         ).animate(
//           CurvedAnimation(
//             parent: widget.animationController!,
//             curve: const Interval((1 / count) * 0, 1.0,
//                 curve: Curves.fastOutSlowIn),
//           ),
//         ),
//         animationController: widget.animationController!,
//       ),
//     );

//     // Replace this with your custom ListView for user posts
//     listViews.add(
//       ListView.builder(
//         itemCount: 5, // Replace with actual data count
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           return PostWidget(
//             title: 'Bảng ghi nhớ ${index + 1}',
//             content:
//                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
//             date: DateFormat('yyyy-MM-dd').format(selectedDate),
//             // Replace with actual data from your user posts
//           );
//         },
//       ),
//     );
//   }

//   late DateProvider dateProvider;
//   void _incrementDate() {
//     dateProvider.incrementDate();
//   }

//   void _decrementDate() {
//     dateProvider.decrementDate();
//   }

//   bool _showNewPost = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: FitnessAppTheme.background,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: <Widget>[
//             getMainListViewUI(),
//             getAppBarUI(),
//             AnimatedContainer(
//               duration: Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//               margin: EdgeInsets.only(
//                 top:
//                     _showNewPost ? MediaQuery.of(context).size.height * 0.5 : 0,
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _showNewPost = !_showNewPost;
//                   });
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: _showNewPost
//                         ? BorderRadius.only(
//                             topLeft: Radius.circular(16),
//                             topRight: Radius.circular(16),
//                           )
//                         : BorderRadius.zero,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 1,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: _showNewPost
//                       ? const NewPostScreen()
//                       : const SizedBox.shrink(),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).padding.bottom,
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _showNewPost = !_showNewPost;
//             });
//           },
//           backgroundColor: Colors.blue,
//           child: const Icon(
//             Icons.add,
//             color: Colors.white,
//           ),
//         ),
//         bottomNavigationBar: SizedBox(
//           height: context.height * 0.08,
//         ),
//       ),
//     );
//   }

//   Widget getMainListViewUI() {
//     return ListView.builder(
//       controller: scrollController,
//       padding: EdgeInsets.only(
//         top: AppBar().preferredSize.height +
//             MediaQuery.of(context).padding.top +
//             24,
//         bottom: 62 + MediaQuery.of(context).padding.bottom,
//       ),
//       itemCount: listViews.length,
//       itemBuilder: (BuildContext context, int index) {
//         widget.animationController?.forward();
//         return listViews[index];
//       },
//     );
//   }

//   Widget getAppBarUI() {
//     return Column(
//       children: <Widget>[
//         AnimatedBuilder(
//           animation: widget.animationController!,
//           builder: (BuildContext context, Widget? child) {
//             return FadeTransition(
//               opacity: topBarAnimation!,
//               child: Transform(
//                 transform: Matrix4.translationValues(
//                   0.0,
//                   30 * (1.0 - topBarAnimation!.value),
//                   0.0,
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(topBarOpacity),
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(32.0),
//                     ),
//                     boxShadow: <BoxShadow>[
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.4 * topBarOpacity),
//                         offset: const Offset(1.1, 1.1),
//                         blurRadius: 10.0,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(
//                         height: MediaQuery.of(context).padding.top,
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.only(
//                             left: 16,
//                             right: 16,
//                             top: 16,
//                             bottom: 12,
//                           ),
//                           child: Consumer<DateProvider>(
//                             builder: (context, dateProvider, _) => Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 const Expanded(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8),
//                                     child: Center(
//                                       child: Text(
//                                         'Forum',
//                                         textAlign: TextAlign.left,
//                                         style: TextStyle(
//                                           fontFamily: 'YourFontNameHere',
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: 22,
//                                           letterSpacing: 1.2,
//                                           color: Colors.black87,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 38,
//                                   width: 38,
//                                   child: InkWell(
//                                     highlightColor: Colors.transparent,
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(32.0)),
//                                     onTap: _decrementDate,
//                                     child: const Center(
//                                       child: Icon(
//                                         Icons.keyboard_arrow_left,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(left: 8, right: 8),
//                                   child: Row(
//                                     children: <Widget>[
//                                       const Padding(
//                                         padding: EdgeInsets.only(right: 8),
//                                         child: Icon(
//                                           Icons.calendar_today,
//                                           color: Colors.grey,
//                                           size: 18,
//                                         ),
//                                       ),
//                                       Text(
//                                         DateFormat('yyyy-MM-dd')
//                                             .format(dateProvider.selectedDate),
//                                         textAlign: TextAlign.left,
//                                         style: const TextStyle(
//                                           fontFamily: 'YourFontNameHere',
//                                           fontWeight: FontWeight.normal,
//                                           fontSize: 18,
//                                           letterSpacing: -0.2,
//                                           color: Colors.black87,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 38,
//                                   width: 38,
//                                   child: InkWell(
//                                     highlightColor: Colors.transparent,
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(32.0)),
//                                     onTap: _incrementDate,
//                                     child: const Center(
//                                       child: Icon(
//                                         Icons.keyboard_arrow_right,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// // Example widget for displaying user posts
// class PostWidget extends StatelessWidget {
//   final String title;
//   final String content;
//   final String date;

//   const PostWidget({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.date,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         color: FitnessAppTheme.nearlyWhite,
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//               color: FitnessAppTheme.nearlyBlack.withOpacity(0.4),
//               offset: const Offset(8.0, 8.0),
//               blurRadius: 8.0),
//         ],
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               content,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: $date',
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Example of TitleView widget (optional, for section titles)
// class TitleView extends StatelessWidget {
//   final String titleTxt;
//   final String subTxt;
//   final Animation<double> animation;
//   final AnimationController animationController;

//   const TitleView({
//     super.key,
//     required this.titleTxt,
//     required this.subTxt,
//     required this.animation,
//     required this.animationController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: animation,
//       child: Transform(
//         transform: Matrix4.translationValues(
//           0.0,
//           30 * (1.0 - animation.value),
//           0.0,
//         ),
//         child: Padding(
//           padding:
//               const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 titleTxt,
//                 textAlign: TextAlign.left,
//                 style: const TextStyle(
//                   fontFamily: 'YourFontNameHere',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                   letterSpacing: 1.2,
//                   color: Colors.black87,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // Action when tapping on the section title (optional)
//                 },
//                 child: Text(
//                   subTxt,
//                   style: const TextStyle(
//                     color: Colors.blue,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NewPostScreen extends StatefulWidget {
//   const NewPostScreen({Key? key}) : super(key: key);

//   @override
//   _NewPostScreenState createState() => _NewPostScreenState();
// }

// class _NewPostScreenState extends State<NewPostScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('New Post'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.done),
//             onPressed: () {
//               final String title = _titleController.text;
//               final String content = _contentController.text;
//               // Implement your logic to save the post (e.g., save to database)
//               Navigator.pop(context); // Navigate back to previous screen
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 labelText: 'Title',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _contentController,
//               maxLines: null, // Allow multiple lines for content
//               decoration: InputDecoration(
//                 labelText: 'Content',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/model/dairy.dart';
import 'package:health_app/core/size/size.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../screens/home/home/home.dart';
import '../fitness_app_theme.dart';
import '../my_diary/provider/provider.dart'; // For date formatting

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key, this.animationController});

  final AnimationController? animationController;

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  DateTime selectedDate = DateTime.now(); // Selected date for posts


  void addAllListData() {
    const int count = 4; // Number of sections

    // Example list views for user posts
    listViews.add(
      TitleView(
        titleTxt: 'Thẻ Ghi nhớ',
        subTxt: 'Latest',
        animation: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 0, 1.0,
                curve: Curves.fastOutSlowIn),
          ),
        ),
        animationController: widget.animationController!,
      ),
    );

    // Fetch data from Firestore
    listViews.add(
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('db_posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                var post = snapshot.data!.docs[index];
                print(
                    'Post data: ${post.data()}'); // In ra dữ liệu post để kiểm tra
                return PostWidget(
                  title: post['title'],
                  content: post['content'],
                  diary: post['diary'],
                  date: DateFormat('yyyy-MM-dd').format(post['date'].toDate()),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            SizedBox(height: context.height,child: const HomeForumScreen()),
            // SizedBox(
            //   height: MediaQuery.of(context).padding.bottom,
            // ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPostScreen(),
              ),
            ).then((_) {
              // Refresh the screen after adding a new post
              setState(() {
                listViews.clear();
                addAllListData();
              });
            });
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: listViews.length,
      itemBuilder: (BuildContext context, int index) {
        widget.animationController?.forward();
        return listViews[index];
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  30 * (1.0 - topBarAnimation!.value),
                  0.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4 * topBarOpacity),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    'Forum',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'YourFontNameHere',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                      letterSpacing: 1.2,
                                      color: Colors.black87,
                                    ),
                                  ),
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
            );
          },
        ),
      ],
    );
  }
}

// Example widget for displaying user posts
class PostWidget extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String diary;

  const PostWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
    required this.diary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: FitnessAppTheme.nearlyWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: FitnessAppTheme.nearlyBlack.withOpacity(0.4),
            offset: const Offset(8.0, 8.0),
            blurRadius: 8.0,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              diary,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: $date',
              style: const TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example of TitleView widget (optional, for section titles)
class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final Animation<double> animation;
  final AnimationController animationController;

  const TitleView({
    Key? key,
    required this.titleTxt,
    required this.subTxt,
    required this.animation,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Transform(
        transform: Matrix4.translationValues(
          0.0,
          30 * (1.0 - animation.value),
          0.0,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                titleTxt,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'YourFontNameHere',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1.2,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Optional action for the section title
                },
                child: Text(
                  subTxt,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen for adding new posts
class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _diaryController = TextEditingController();

  void _savePost() {
    final String title = _titleController.text;
    final String content = _contentController.text;
    final String diary = _diaryController.text;

    // Add to Firestore
    FirebaseFirestore.instance.collection('posts').add({
      'title': title,
      'content': content,
      'diary': diary,
      'date': DateTime.now(),
    }).then((value) {
      print('Post added successfully!');
      Navigator.pop(context); // Navigate back to previous screen
    }).catchError((error) {
      print('Failed to add post: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add post. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _savePost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: null, // Allow multiple lines for content
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _diaryController,
              maxLines: null, // Allow multiple lines for content
              decoration: InputDecoration(
                labelText: 'Diary',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _diaryController.dispose();

    super.dispose();
  }
}
