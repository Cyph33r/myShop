import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import '../data/database_collection.dart';
import '../providers/auth.dart';

enum AuthMode { signUp, logIn }

class AuthScreen extends StatelessWidget {
  static var routeName = '/auth_screen';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .subtitle2
                              ?.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  AuthCardState createState() => AuthCardState();
}

class AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.logIn;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late Auth authProvider;

  void _submit() async {
    if (authProvider.user != null) {
      await authProvider.signOut();
    }
    if (!_formKey.currentState!.validate()) return; // Invalid!
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.signUp) {
      try {
        await authProvider.signUp(
            email: _emailController.text, password: _passwordController.text);
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            _showErrorDialog(context, "You entered an invalid email address");
            break;
          case "email-already-in-use":
            _showErrorDialog(context, 'This email already exists');
            break;
          case 'operation-not-allowed':
            _showErrorDialog(context, "Illegal operation");
            break;
          case 'weak-password':
            _showErrorDialog(context, "Your password is weak");
            break;
        }
      } on Exception catch (error) {
        _showErrorDialog(
            context, ("An unknown error occurred ${kDebugMode ? error : ""}"));
      }
    } else {
      try {
        await authProvider.loginIn(
            email: _emailController.text, password: _passwordController.text);
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            _showErrorDialog(context, "You entered an invalid email address");
            break;
          case "user-disabled":
            _showErrorDialog(context, 'This account has been disabled');
            break;
          case 'user-not-found':
            _showErrorDialog(context, "Email or Password is invalid");
            break;
          case 'wrong-password':
            _showErrorDialog(context, "Email or Password is invalid");
            break;
        }
      } on Exception catch (error) {
        _showErrorDialog(
            context, ("An unknown error occurred ${kDebugMode ? error : ""}"));
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    authProvider = Provider.of<Auth>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.signUp ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null &&
                        (value.isEmpty || !value.contains('@'))) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null && (value.isEmpty || value.length < 5)) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.signUp,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                      onPressed: _submit,
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0)),
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                        textStyle: const MaterialStatePropertyAll(
                            TextStyle(color: Colors.white)),
                      ),
                      child: Text(
                          style: const TextStyle(color: Colors.white),
                          _authMode == AuthMode.logIn ? 'LOGIN' : 'SIGN UP')),
                if (_authMode == AuthMode.logIn)
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          text: 'Are you a new user? ',
                          children: [
                        TextSpan(
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            text: 'Sign up.',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => setState(() => _switchAuthMode()))
                      ])),
                if (_authMode == AuthMode.signUp)
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          text: 'Already a user? ',
                          children: [
                        TextSpan(
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          text: 'Log in.',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => setState(() => _switchAuthMode()),
                        )
                      ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("An error occurred"),
              content: Text(message),
            ));
  }
}
