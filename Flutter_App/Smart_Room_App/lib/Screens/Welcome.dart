import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_room/Screens/Signup.dart';
import 'package:smart_room/Screens/Login.dart';

class welcome extends StatefulWidget {
  welcome({Key? key}) : super(key: key);

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 15),
              height: 350,
              child: Lottie.asset("assets/Welcome.json"),
            ),
             
             
                  Text("Welcome to your smart room app ",
                      
                      style: TextStyle(fontSize: 23 ,
                       color: Colors.blue,
                       fontWeight: FontWeight.bold,
                       fontStyle: FontStyle.italic
                       ),
                    
                      
                      ),
                      SizedBox(
              height: 10,
                      ),
                       Text(
              "This app is designed to control your room devices from . ",
              style: TextStyle(color: Colors.blueGrey),
            
                           ),
                            Text(
              " your mobile phone from around the world .",
              style: TextStyle(color: Colors.blueGrey),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => signup()));
                }),

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
                      const EdgeInsets.symmetric(horizontal: 67, vertical: 15),
                ),
                child: const Text('Log In', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => login()));
                }),
            SizedBox(
              height: 7,
            ),
            
          ],
        ),
      ),
    );
  }
}