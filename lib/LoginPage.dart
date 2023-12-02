import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:typicons_flutter/typicons_flutter.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //0-SplashScreen , 1-Login Page , 2-signup Page
  int _pageState = 0;

  var _bacgroundColor = Color(0xff9AC5D2);
  var _headingColor = Colors.white;
  var _normalTextColor = Colors.black;
  double windowWidth = 0;
  double windowHeight = 0;

  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerOffset = 0;
  double _loginWidth = 0;
  double _loginOpacity = 1;

  double _loginHeight = 0;
  double _registerHeight = 0;

  double _splashScreenPadding = 60;

  late bool _keyboardState ;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  late User currentUser;
  late String uid,name,email,imageUrl;

  Future<User?> _handleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User? user = (await _auth.signInWithCredential(credential)).user;
   // print("signed in " + user?.displayName);

    currentUser = await _auth.currentUser!;
    assert(user?.uid == currentUser.uid);

    /*uid = user.uid;
    name = user.displayName!;
    email = user.email!;
    imageUrl = user.photoURL!;


    print(uid);
    print(email);
    print(name);
    print(imageUrl);*/

    return user;

  }

  Future<void> _handleSignOut()async {
    _googleSignIn.disconnect();
    currentUser.delete();
  }

  @override
  void initState() {
    super.initState();
    _keyboardState = KeyboardVisibility.isVisible;
    KeyboardVisibility.onChange.listen((bool visible) {
      setState(() {
        _keyboardState = visible;
      });
    });
  }

  Widget _bodyWidget(){
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            setState(() {
              _pageState = 0;
            });
          },
          child: AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              milliseconds: 1000,
            ),
            padding: EdgeInsets.only(top:_splashScreenPadding),
            color: _bacgroundColor,
            child: Column(
              children: <Widget>[
                Text("Read Free",style: TextStyle(
                  color: Colors.white,
                  fontSize: 45.0,
                  fontFamily: "NunitoR",
                ),),
                Text("Your Favourite Toons Comics!",style: TextStyle(
                  fontFamily: "NunitoR",
                  fontSize: 18.0,
                  color: _normalTextColor,
                  //fontWeight: FontWeight.bold,
                ),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(80.0,0.0,80.0,0.0),
                  child: Image.network('https://media.giphy.com/media/r3Yeh3aAjsyYGObizC/giphy-downsized.gif'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0),
                  child: Image.asset('assets/images/Simple_Comic.png',width: 200,height: 200,),
                ),
                LoginCard()
              ],
            ) ,
          ),
        ),
        AnimatedContainer(
          width: _loginWidth,
          height: _loginHeight,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
            milliseconds: 1000,
          ),
          transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0)),
            color: Color(0xff9AC5D2).withOpacity(_loginOpacity),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(140.0,10.0,140.0,0.0),
                child: Center(
                    child: Image.network('https://media.giphy.com/media/r3Yeh3aAjsyYGObizC/giphy-downsized.gif'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Hello , Welcome! To Carmics , ",textAlign: TextAlign.center,style: TextStyle(
                  fontFamily: "NunitoR",
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white,
                ),),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Let's read free comics Please Sign in with your google account to start reading",textAlign: TextAlign.center,style: TextStyle(
                  fontFamily: "NunitoR",
                  fontWeight: FontWeight.w400,
                  fontSize: 25.0,
                  color: Colors.white,
                ),),
              ),
              SizedBox(height: 30.0,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _pageState = 2;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrimaryBtn(btnText: "Read Free!"),
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          height: _registerHeight,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
            milliseconds: 1000,
          ),
          transform: Matrix4.translationValues(0, _registerOffset, 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0)),
            color: Color(0xff9AC5D2),
          ),
          child: Column(

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(140.0,10.0,140.0,0.0),
                child: Center(
                    child: Image.network('https://media.giphy.com/media/r3Yeh3aAjsyYGObizC/giphy-downsized.gif'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Create a new Account",style: TextStyle(
                  fontFamily: "NunitoR",
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white,
                ),),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Please Tap Below to Continue! Reading  Comic Books!",textAlign: TextAlign.center,style: TextStyle(
                  fontFamily: "NunitoR",
                  fontSize: 25.0,
                  color: Colors.white,
                ),),
              ),
              GestureDetector(
                onTap: ()=>_handleSignIn()
                    .then((var user) => Navigator.of(context)
                    .pushReplacementNamed("/Home"))
                    .catchError((e) => print("Login Errror"+e.toString())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AuthBtns(icon: Typicons.social_google_plus
                    ,btnText: "Continue with Gmail",),
                ),
              ),


              GestureDetector(
                onTap: (){
                  setState(() {
                    _pageState = 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutLineBtn(btnText: "Go Back"),
                ),
              ),

            ],
          ),
        )
      ],
    );
  }


  Widget LoginCard(){
    return GestureDetector(
      onTap:(){
        setState(() {
          _pageState = 1;
        });
      },
      child: Container(
        margin: EdgeInsets.only(top:30.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(new Radius.circular(100.0)),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(60.0,20.0,60.0,20.0),
          child: Text("Get Started",style: TextStyle(
            color: Colors.white,
            fontFamily: "NunitoR",
            fontSize: 20.0,
          ),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    //Returns the Mobile Screen width and height
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight -190;
    _registerHeight = windowHeight - 190;

    print(_pageState);
    switch(_pageState){
      case 0:
        _bacgroundColor = Color(0xff9AC5D2);
        _normalTextColor = Colors.black;
        _registerOffset = windowHeight;
        //Y offset will be the window height which means it will stay below the whole screen whatever the screen height is
        _loginYOffset = windowHeight;
        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        _splashScreenPadding = 60;
        _loginHeight = _keyboardState?windowHeight:windowHeight-190;
        print("Key"+_keyboardState.toString());
        break;
      case 1:
        print("Key"+_keyboardState.toString());
        _bacgroundColor = Colors.black;
        _normalTextColor = Colors.white;
        _registerOffset=windowHeight;
        _loginYOffset = _keyboardState?50:190.0;
        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        _splashScreenPadding = 50;
        //_loginHeight = _keyboardState?windowHeight:windowHeight-40;
        break;
      case 2:
        print("Key"+_keyboardState.toString());
        _bacgroundColor = Colors.black;
        _normalTextColor = Colors.white;
        _loginYOffset = _keyboardState?50:190.0;
        _registerOffset = _keyboardState?70:210.0;
        _loginXOffset = 10.0;
        _loginWidth = windowWidth-20.0;
        _loginOpacity = 0.75;
        _splashScreenPadding = 40;
        break;
    }
    return Scaffold(
      backgroundColor: _bacgroundColor,
      body: Center(
        child:SafeArea(child: _bodyWidget()),
      ),
    );
  }





}



class PrimaryBtn extends StatefulWidget {
  final String btnText;
  PrimaryBtn({required this.btnText});
  @override
  _PrimaryBtnState createState() => _PrimaryBtnState();
}

class _PrimaryBtnState extends State<PrimaryBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.black,
      ),
      child: Center(
        child: Text(widget.btnText,style:
        TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontFamily: 'NunitoR',
        ),),
      ),
    );
  }
}

class OutLineBtn extends StatefulWidget {
  final String btnText;
  OutLineBtn({required this.btnText});
  @override
  _OutLineBtnState createState() => _OutLineBtnState();
}

class _OutLineBtnState extends State<OutLineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.white,
      ),
      child: Center(
        child: Text(widget.btnText,style:
        TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontFamily: 'NunitoR',
        ),),
      ),
    );
  }
}

class InputWithIcon extends StatefulWidget {

  final String hintText ;
  final IconData icon ;

  InputWithIcon({required this.hintText,required this.icon});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0,6.0,20.0,6.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          )
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(widget.icon),
          ),
          SizedBox(width: 10.0,),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: widget.hintText ,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "NunitoR",
                ),
                contentPadding: EdgeInsets.all(8.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthBtns extends StatefulWidget {
  final String btnText;
  final IconData icon;
  AuthBtns({required this.btnText,required this.icon});

  @override
  _AuthBtnsState createState() => _AuthBtnsState();
}

class _AuthBtnsState extends State<AuthBtns> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.black,
      ),
      child:Row(

        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Icon(widget.icon,color: Colors.white,size: 32,),
          ),
          SizedBox(width: 24.0,),
          Center(
            child: Text(widget.btnText,style:
            TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontFamily: 'NunitoR',
            ),),
          ),
        ],
      ),
    );
  }


}
