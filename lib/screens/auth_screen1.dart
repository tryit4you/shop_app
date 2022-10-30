import 'dart:math';

import 'package:flutter/material.dart';

enum AuthMode {
  LOGIN,
  SIGNUP,
}

class AuthScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devicesSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                Color.fromARGB(255, 73, 157, 226).withOpacity(0.9),
                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.5, 1],
            )),
          ),
          Container(
            height: devicesSize.height,
            width: devicesSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: Container(
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepOrange.shade700,
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 170, 74, 37),
                            blurRadius: 8,
                            spreadRadius: 0.1,
                            offset: Offset(2, 5))
                      ]),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'MyShop',
                    style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline6.color,
                        fontSize: 50,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal),
                  ),
                )),
                Flexible(child: AuthCard())
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  Map<String, String> _authForm = <String, String>{
    'email': '',
    'password': '',
    'confirm': '',
  };
  @override
  Widget build(BuildContext build) {
    return Card(
      child: Form(
          child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                labelText: 'E-Mail',
                labelStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 5)),
            validator: (value) {
              if (value.isEmpty && !value.contains('@')) {
                return 'Invalid email';
              }
              return null;
            },
            onSaved: (value) {
              _authForm['email'] = value;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: () {}, child: Text('LOGIN'))
        ],
      )),
    );
  }
}
