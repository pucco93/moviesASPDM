import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movies/welcome_section/sign_in_section/sign_in_page.dart';
import 'package:movies/welcome_section/sign_up_section/sign_up_page.dart';
import 'package:movies/home_section/homepage.dart';
import 'package:movies/colors/colors_theme.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: const Size(350, 50),
      maximumSize: const Size(350, 50),
      primary: ColorSelect.customMagenta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  final ButtonStyle skipStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: ColorSelect.customViolet),
      minimumSize: const Size(350, 50),
      maximumSize: const Size(350, 50),
      primary: const Color(0xffDCDCDC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  final TextStyle linkStyle =
      const TextStyle(fontSize: 16, color: ColorSelect.customYellow);

  openSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  openSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  skipSign() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ColorSelect.customBlue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: const AssetImage("assets/images/cinema_welcome.jpg"), 
            width: MediaQuery.of(context).orientation == Orientation.landscape ? 200 : double.infinity),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).orientation == Orientation.landscape ? 0 : 100, bottom: MediaQuery.of(context).orientation == Orientation.landscape ? 25 : 50)),
            ElevatedButton(
                style: style,
                onPressed: openSignUp,
                child: const Text("Sign up")),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            ElevatedButton(
                style: skipStyle,
                onPressed: skipSign,
                child: const Text(
                  "Ask me later",
                  style:
                      TextStyle(fontSize: 20, color: ColorSelect.customViolet),
                )),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            RichText(
                text: TextSpan(children: <TextSpan>[
              const TextSpan(text: "Already have an account? "),
              TextSpan(
                  text: "Sign in",
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()..onTap = openSignIn)
            ]))
          ],
        ));
  }
}
