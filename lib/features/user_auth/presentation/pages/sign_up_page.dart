import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/features/user_auth/firebase_auth_implementatin/firebase_auth_services.dart';
import 'package:demo/features/user_auth/presentation/pages/login_page.dart';
import 'package:demo/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:demo/global/common/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              // fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 150), // Adjusted spacing below background image
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height:
                          20), // Adjusted spacing between "Sign Up" and first form field
                  FormContainerWidget(
                    controller: _usernameController,
                    hintText: "Username",
                    isPasswordField: false,
                    keyboardType: null,
                  ),
                  SizedBox(height: 15),
                  FormContainerWidget(
                    controller: _emailController,
                    hintText: "Email",
                    isPasswordField: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),
                  FormContainerWidget(
                    controller: _passwordController,
                    hintText: "Password",
                    isPasswordField: true,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 15),
                  FormContainerWidget(
                    controller: _phoneNumberController,
                    hintText: "Phone Number",
                    isPasswordField: false,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      _signUp();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: isSigningUp
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String phoneNumber = _phoneNumberController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "User successfully created");

      // Update user data in Firestore
      await _updateUserData(email, username, phoneNumber);

      // Navigate to home page
      Navigator.pushNamed(context, "/home", arguments: {
        'username': username,
        'phoneNumber': phoneNumber,
      });
    } else {
      showToast(message: "Some error occurred");
    }
  }

  Future<void> _updateUserData(
    String email,
    String username,
    String phoneNumber,
  ) async {
    try {
      // Access your Firestore instance and update the user data
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'name': username,
        'mobile': phoneNumber,
        'email': email,
      });
    } catch (e) {
      print("Error updating user data: $e");
    }
  }
}
