import 'package:flutter/material.dart';
import 'package:maj_project/Colors.dart';
import 'package:maj_project/Functions/authFunction.dart';
import 'package:maj_project/Screens/Student/Googlesignin.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;
  String email = "";
  String password = "";
  String username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("WELCOME"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        key: ValueKey('email'),
                        enabled: true,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: primary),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primary))),
                        validator: (value) {
                          if (!value.toString().contains('@')) {
                            return 'Invalid Email';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            email = value!;
                          });
                        },
                      )),
                  const SizedBox(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: !isLogin
                        ? TextFormField(
                            key: ValueKey('username'),
                            enabled: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.face),
                                hintText: 'Username',
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: primary),
                                    borderRadius: BorderRadius.circular(8)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: primary))),
                            validator: (value) {
                              if (value.toString().length < 3) {
                                return 'Username is so small';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                username = value!;
                              });
                            },
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      cursorColor: primary,
                      obscureText: true,
                      key: ValueKey('Password'),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: primary),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: primary))),
                      validator: (value) {
                        if (value.toString().length < 6) {
                          return 'Password is so small';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          password = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {}, child: Text("Forgot password"))
                      ],
                    ),
                  ),
                  const SizedBox(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                    ),
                  ),
                  loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              isLogin
                                  ? (await signin(email, password, context))
                                  : (await signup(email, password, context));
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                          child: isLogin
                              ? Text(
                                  "LOGIN",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text("SIGNUP",
                                  style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              shape: RoundedRectangleBorder()),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: isLogin
                          ? Text("Don't have an account? Signup")
                          : Text('Already signed up? Login')),
                  // Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  SignInButton(Buttons.google, text: "Continue with google",
                      onPressed: () {
                    signInWithGoogle(context);
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
