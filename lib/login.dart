import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  SharedPreferences _sharedPreferences;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    checkUser();
  }

  void checkUser() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTextController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: "Please input your email.",
                  ),
                  validator: (value) {
                    return (value.isEmpty) ? "Email is empty." : null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordTextController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: "Please input your password.",
                  ),
                  validator: (value) {
                    return (value.isEmpty) ? "Password is empty." : null;
                  },
                ),
                SizedBox(height: 10),
                Material(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue[400],
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "SIGN IN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: signIn,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (_formKey.currentState.validate()) {
      if (_emailTextController.text == "erdin@gmail.com" &&
          _passwordTextController.text == "password") {
        print("Login Success");
        Fluttertoast.showToast(
            msg: "Login Successfully", toastLength: Toast.LENGTH_LONG);

        await _sharedPreferences.setBool("isLoggedIn", true);
        setState(() {
          isLoggedIn = true;
        });
        checkUser();
      } else {
        print("Login Failed");
        Fluttertoast.showToast(msg: "Login Failed");
      }
    }
  }
}
