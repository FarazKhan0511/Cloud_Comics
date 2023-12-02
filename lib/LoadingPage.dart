import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff9AC5D2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network('https://media.giphy.com/media/r3Yeh3aAjsyYGObizC/giphy-downsized.gif',height: 125.0, width: 125.0,),
              ),
              Text("Loading...\nFrom Cloud Storage",textAlign: TextAlign.center,style:TextStyle(
                fontFamily: "NunitoR",
                color:Colors.white,
                fontSize:25.0,
              )),
            ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setUpHomePage();
  }

  void setUpHomePage() async {
    String gotoThisPage = "";

    //Check if the current user is logged in or not if he did then take him to HomePage else to LoginPage
    if (await FirebaseAuth.instance.currentUser!= null) {
      // signed in
      gotoThisPage = "/Home";
    } else {
      gotoThisPage = "/Login";
    }
    print("I'm at This Page : "+gotoThisPage);

    await Future.delayed(Duration(seconds: 10));

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context)
          .pushReplacementNamed(gotoThisPage);
    });
  }
}