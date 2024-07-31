import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/features/user_auth/firebase_auth_implementatin/firebase_auth_services.dart';
import 'package:demo/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:demo/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/form_container_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align content to bottom
                children: [
                  SizedBox(height: 70), // Adjusted spacing from top
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Image.asset(
                          'assets/light-1.png',
                          height: 200,
                          width: 200,
                        ),
                      ),
                      // FadeInUp(
                      //   duration: Duration(milliseconds: 1000),
                      //   child: Image.asset(
                      //     'assets/light-2.png',
                      //     height: 100,
                      //     width: 100,
                      //   ),
                      // ),
                      // FadeInUp(
                      //   duration: Duration(milliseconds: 1200),
                      //   child: Image.asset(
                      //     'assets/clock.png',
                      //     height: 100,
                      //     width: 100,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 110), // Adjusted spacing below images
                  FormContainerWidget(
                    controller: _emailController,
                    hintText: "Email",
                    isPasswordField: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  FormContainerWidget(
                    controller: _passwordController,
                    hintText: "Password",
                    isPasswordField: true,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: GestureDetector(
                      onTap: () {
                        _signIn();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors
                              .indigoAccent, // Changed button color to purple
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _isSigning
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: GestureDetector(
                      onTap: () {
                        _signInWithGoogle();
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors
                              .indigoAccent, // Changed button color to purple
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");

      // Fetch user data from Firestore
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      // Pass user data to HomePage
      Navigator.pushNamed(context, "/home", arguments: {
        'username': userData['name'],
        'contact': userData['mobile'],
      });
    } else {
      showToast(message: "Some error occurred");
    }
  }

  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushNamed(context, "/home");
      }
    } catch (e) {
      showToast(message: "Some error occurred $e");
    }
  }
}
