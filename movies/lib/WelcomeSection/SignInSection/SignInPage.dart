import 'dart:ui';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movies/Colors/Colors.dart';
import 'package:movies/WelcomeSection/SignUpSection/SignUpPage.dart';
import 'package:movies/models/providers/ProviderAccount.dart';
import 'package:movies/models/providers/ProviderSignIn.dart';
import 'package:movies/models/typeAdapters/LoggedUser.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  _backToPreviousPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const FittedBox(
                child: Image(
                    image: AssetImage(
                        "assets/images/avatar_signin_background.jpg")),
                fit: BoxFit.fitWidth),
            Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 30),
                        onPressed: _backToPreviousPage)),
                const Padding(padding: EdgeInsets.only(top: 200)),
                Container(
                    child: const Text('Hi',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w500)),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30)),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Expanded(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      Colors.grey.shade200.withOpacity(0.35)),
                              child: const Center(child: SignInForm()),
                            ))))
              ],
            )
          ],
          fit: StackFit.expand,
        ));
  }
}

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderSignIn>(builder: (context, signInProvider, child) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: signInProvider.isResetPassword
              ? const ResetPasswordView()
              : const SignInView());
    });
  }
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _mailController = TextEditingController();

  final ButtonStyle _checkMailResetPasswordStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: Colors.white70),
      primary: ColorSelect.customBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  final ButtonStyle _cancelStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: ColorSelect.customViolet),
      primary: const Color(0xffDCDCDC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  _checkMailResetPassword() {}

  handleResetPassword(ProviderSignIn signInProvider) {
    signInProvider.updateResetPassword(false);
  }

  @override
  void dispose() {
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderSignIn>(builder: (context, signInProvider, child) {
      return SingleChildScrollView(
          child: Column(
        children: [
          const Text(
            "Insert your mail account in the field below, we will see if you are a registered member and send you a mail with your current password.\nOtherwise we will redirect you to the sign up page.",
            style: TextStyle(fontSize: 16),
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          TextField(
            style: const TextStyle(
              color: Colors.black87,
              fontFamily: 'Montserrat',
              fontSize: 18,
            ),
            keyboardType: TextInputType.emailAddress,
            controller: _mailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: ColorSelect.customBlue, width: 3.0)),
                contentPadding: const EdgeInsets.only(
                    left: 10, top: 5, right: 10, bottom: 5),
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 18),
                filled: true,
                fillColor: Colors.white),
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.mail, size: 30),
                  style: _checkMailResetPasswordStyle,
                  onPressed: _checkMailResetPassword,
                  label: const Text("Reset password",
                      style: TextStyle(color: Colors.white70)))),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
                style: _cancelStyle,
                onPressed: () => handleResetPassword(signInProvider),
                child: const Text("Cancel",
                    style: TextStyle(color: ColorSelect.customBlue))),
          )
        ],
      ));
    });
  }
}

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);
  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _mailController = TextEditingController();

  final ButtonStyle _continueLogInStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: ColorSelect.customBlue),
      primary: Colors.white70,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  final ButtonStyle _continueStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: ColorSelect.customBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  final TextStyle linkStyle =
      const TextStyle(fontSize: 16, color: ColorSelect.customYellow);

  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: Colors.white),
      primary: ColorSelect.customMagenta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  final ButtonStyle _textButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: Colors.white));

  openSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  handleResetPassword(ProviderSignIn signInProvider) {
    signInProvider.updateResetPassword(true);
  }

  _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  _validateMail(ProviderSignIn signInProvider) {
    final Box<LoggedUser> _userBox = Hive.box<LoggedUser>("userBox");
    if (_userBox.get("loggedUser") != null) {
      dynamic tempUser = _userBox.get("loggedUser");
      if (tempUser.email != _mailController.text) {
        signInProvider.updateIsInDB(false);
      } else {
        signInProvider.updateMailEntered(true);
      }
    } else {
      signInProvider.updateIsInDB(false);
    }
  }

  _signIn(ProviderAccount accountProvider) {
    final Box<LoggedUser> _userBox = Hive.box<LoggedUser>("userBox");
    dynamic tempUser = _userBox.get("loggedUser");
    LoggedUser user = LoggedUser(tempUser.id, tempUser.name, tempUser.email,
        tempUser.password, tempUser.imageUrl, true);
    _userBox.put("loggedUser", user);
    accountProvider.updateLogStatus(true);
  }

  Future<void> _showMyDialog(String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorSelect.customBlue,
          titleTextStyle: const TextStyle(color: Colors.white),
          contentTextStyle: const TextStyle(color: Colors.white),
          title: const Text('Oh no it seems there was a problem!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Sorry but $type login hasn't been implemented yet."),
                const Text("Check again when new update is available."),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("I'll try another login option"),
              style: _buttonStyle,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Close'),
              style: _textButton,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _loginFacebook() {
    _showMyDialog("facebook");
  }

  _loginGoogle() {
    _showMyDialog("google");
  }

  _loginApple() {
    _showMyDialog("apple");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderAccount>(
        builder: (context, accountProvider, child) {
      return Consumer<ProviderSignIn>(
          builder: (context, signInProvider, child) {
        return SingleChildScrollView(
            child: Column(children: [
          TextField(
            style: const TextStyle(
              color: Colors.black87,
              fontFamily: 'Montserrat',
              fontSize: 18,
            ),
            keyboardType: TextInputType.emailAddress,
            controller: _mailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: ColorSelect.customBlue, width: 3.0)),
                contentPadding: const EdgeInsets.only(
                    left: 10, top: 5, right: 10, bottom: 5),
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 18),
                filled: true,
                fillColor: Colors.white),
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Visibility(
              visible: signInProvider.isInDB,
              child: Column(children: [
                Visibility(
                  visible: signInProvider.isMailEntered,
                  child: Column(children: [
                    TextField(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _mailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: ColorSelect.customBlue, width: 3.0)),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 5, right: 10, bottom: 5),
                          hintText: "Password",
                          hintStyle: const TextStyle(
                              color: Colors.black54, fontSize: 18),
                          filled: true,
                          fillColor: Colors.white),
                    )
                  ]),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: _continueStyle,
                        onPressed: () => {
                              signInProvider.isMailEntered
                                  ? () => _signIn(accountProvider)
                                  : () => _validateMail(signInProvider)
                            },
                        child: Text(signInProvider.isMailEntered
                            ? "Continue"
                            : "Log in"))),
                const Padding(padding: EdgeInsets.only(top: 10)),
                const Text(
                  "or",
                  style: TextStyle(fontSize: 18),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.facebook,
                          size: 30,
                        ),
                        style: _continueLogInStyle,
                        onPressed: _loginFacebook,
                        label: const Text("Continue with Facebook",
                            style: TextStyle(color: ColorSelect.customBlue)))),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                        icon: const Image(
                            image: AssetImage("assets/images/google_logo.png"),
                            width: 30,
                            height: 30),
                        style: _continueLogInStyle,
                        onPressed: _loginGoogle,
                        label: const Text("Continue with Google",
                            style: TextStyle(color: ColorSelect.customBlue)))),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                        icon: const Image(
                            image: AssetImage("assets/images/apple_icon.png"),
                            width: 30,
                            height: 30),
                        style: _continueLogInStyle,
                        onPressed: _loginApple,
                        label: const Text("Continue with Apple",
                            style: TextStyle(color: ColorSelect.customBlue)))),
                const Padding(padding: EdgeInsets.only(top: 10)),
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  const TextSpan(text: "Don't have an account? "),
                  TextSpan(
                      text: "Sign up",
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => openSignUp(context))
                ])),
                const Padding(padding: EdgeInsets.only(top: 10)),
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Forgot your password?",
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => handleResetPassword(signInProvider))
                ]))
              ])),
          Visibility(
              visible: !signInProvider.isInDB,
              child: Column(children: [
                const Text(
                    "Seems you don't have an account, please Sign up with the button below"),
                Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: _continueStyle,
                        onPressed: _signUp,
                        child: const Text("Sign up")))
              ])),
        ]));
      });
    });
  }
}
