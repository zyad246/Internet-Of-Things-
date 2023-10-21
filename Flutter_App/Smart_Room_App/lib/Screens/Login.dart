// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import  'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_button/sign_button.dart';

import 'package:smart_room/Screens/Signup.dart';
import 'package:smart_room/Screens/controls.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _signupState();
}

class _signupState extends State<login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 15),
              height: 350,
              child: Lottie.asset("assets/signup&login.json"),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Enter your E-mail"),
                style: TextStyle(fontSize: 18),
              ),
            ),
            //make space between two textfield
            SizedBox(
              height: 15,
            ),

            SizedBox(
              height: 7,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Enter your Password"),
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                child: const Text('Log In', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  var name = emailController.text.trim();
                  var password = passwordController.text.trim();

                  try {
                    final User? firebaseUser =
                        (await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    ))
                            .user;
                    if (firebaseUser != null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Signed In Successfully'),
                        ),
                      ); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Controls(),
                        ),
                      );
                    } else {
                      print('Check your email and password');
                    }
                  } on FirebaseAuthException catch (e) {
                    print('ERROR $e');
                  }
                }),
            SizedBox(
              height: 7,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(fontSize: 15)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => signup()));
                    },
                    child: Text("Sign Up",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              // ignore: prefer_const_constructors
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("OR",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              // ignore: prefer_const_constructors
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton.mini(
                   buttonType: ButtonType.google,
                   //btnText: 'Google',
                   // width: 100,
                   buttonSize: ButtonSize.large,
                    onPressed: () async{
                      
                      signInWithGoogle();
                      //show message after login
                     

                            }),
              

                


                  
                ],
              ),
            ),

           
          ],
        ),
      ),
    );
  }
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? firebaseUser = userCredential.user;
    if (firebaseUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Controls(),
        ),
      );
    }
  }
  
}
