import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_app/core/auth_service.dart';
import 'package:health_app/core/get_x/get_x.dart';
import 'package:health_app/not%20used/navigation_home_screen.dart';
import 'package:health_app/screens/layout/bottom/bottom_navigation_bar.dart';
import 'package:health_app/screens/login/sign_up.dart';
import 'package:provider/provider.dart';

import '../../fitness_app/fitness_app_home_screen.dart';
import '../../fitness_app/my_diary/provider/provider.dart';
import '../bottomnavigation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String validPassword = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isCheck=false;

  late DateProvider dateProvider;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dateProvider = Provider.of<DateProvider>(context, listen: false);
    });
    super.initState();
  }

  void _login() async {
    try {
      setState(() {
        isCheck=true;
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;

      dateProvider.setIdUser(user!.uid);

      if (user != null) {
        String uid = user.uid;

        DocumentSnapshot userDoc = await _firestore.collection('db_user').doc(uid).get();
        if (userDoc.exists) {
          String role = userDoc['role'];
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
            );
            setState(() {
              isCheck=false;
            });
          } else if (role == 'user') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FitnessAppHomeScreen()),
            );
            setState(() {
              isCheck=false;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Unknown role: $role"),
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No user data found"),
          ));
          setState(() {
            isCheck=false;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? "Login failed"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        // onTap: () => AuthService().hideKeyBoard(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height,
                child: Stack(
                  children: [
                    Container(
                      height: height * 0.4,
                      width: width,
                      color: Colors.green,
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.05,
                        padding: const EdgeInsets.only(bottom: 40),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/introduction_animation/care_image.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: height * 0.65,
                        width: width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: SizedBox(
                                        width: width * 0.85,
                                        child: TextFormField(
                                          validator: (value) => EmailValidator
                                                  .validate(value!)
                                              ? null
                                              : "Please enter a valid email",
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.email_outlined,
                                              size: 30,
                                            ),
                                            hintText: "Enter E-mail",
                                            labelText: "E-mail",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: SizedBox(
                                        width: width * 0.85,
                                        child: TextFormField(
                                          validator: (value) =>
                                              validPassword == ""
                                                  ? null
                                                  : "Wrong Password",
                                          obscureText: obscureText,
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.lock_outline,
                                              size: 30,
                                            ),
                                            hintText: "Enter Password",
                                            labelText: "Password",
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  obscureText = !obscureText;
                                                });
                                              },
                                              child: Icon(
                                                obscureText
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              isCheck?
                              const Center(child: CircularProgressIndicator(),):
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  _formKey.currentState!.validate();
                                  setState(() {
                                    validPassword='';
                                  });
                                  final message = await AuthService().login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  if (_formKey.currentState!.validate()) {
                                    if (message != null &&
                                        message.contains('Success')) {
                                      _login();
                                    } else {
                                      setState(() {
                                        validPassword =
                                            message ?? "Unknown error";
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(message ?? "Unknown error"),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  height: height * 0.06,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 35),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                        offset: const Offset(1.1, 1.1),
                                        blurRadius: 10.0,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Sign In',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                        color: Color(0xFFffffff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "You don't have an account?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Create account.",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
                                          fontSize: 15,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
