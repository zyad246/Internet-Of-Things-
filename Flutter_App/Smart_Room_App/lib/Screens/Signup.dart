import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class signup extends StatefulWidget {
  signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Signup "),
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
                controller: nameController,
                decoration: InputDecoration(hintText: "Enter your name"),
                style: TextStyle(fontSize: 18),
              ),
            ),
            //make space between two textfield
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: emailController,
                decoration:
                    InputDecoration(hintText: "Enter your E-mail Address"),
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: IntlPhoneField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  initialCountryCode: 'EG',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                )),
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
                child: const Text('Sign Up', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  var username = nameController.text.trim();
                  var email = emailController.text.trim();
                  var password = passwordController.text.trim();

                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                   ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Signed Up Successfully'),
                        ),
                      ); 
                  //create popup message to user to say his account created successfully
                 
                }),
            SizedBox(
              height: 7,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                      style: TextStyle(fontSize: 15)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => login()));
                    },
                    child: Text("Login",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
