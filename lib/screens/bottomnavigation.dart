import 'package:flutter/material.dart';

import '../fitness_app/forum/forum_admin.dart';
import '../introduction_animation/QR.dart';
import 'account/view_all_account.dart';
import 'home/home/home.dart';
class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;
  AnimationController? animationController;
  late final List<Widget> _children;
  @override
  void initState() {
    _children = [
      const ViewAllAcount(),
      const ForumAdminScreen(),
      const Qr()
    ];

    super.initState();
  }
  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'View Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.foggy),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR',
          ),
        ],
      ),
    );
  }
}