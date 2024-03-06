import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google SignIn"),
      ),
      body: _user != null ? _userInfo() : _googleSignInButton(),
    );
  }

  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
          height: 50,
          child: SignInButton(
            Buttons.google,
            text: "Sign in with Google",
            onPressed: () {
              _handleGoogleSignIn();
            },
          )),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 180,
              width: 108,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: NetworkImage(_user!.photoURL!))),
            ),
            Text(_user!.email!),
            _user!.displayName != null
                ? Text(_user!.displayName!)
                : const SizedBox.shrink(),
            MaterialButton(
              onPressed: () {
                _auth.signOut();
              },
              color: Colors.purple,
              child: const Text("Sign Out",style: TextStyle(color: Colors.white),),
            )
          ]),
    );
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}
