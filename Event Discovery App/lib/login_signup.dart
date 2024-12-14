import 'package:cen_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'components/forgot_password_check.dart';
import 'components/my_textfield.dart';
import 'components/rounded_button.dart';
import 'forgot_password.dart';
import 'logger_settings.dart';
import 'main.dart';

final supabase = Supabase.instance.client;

class LoginWrapper extends StatelessWidget {
  const LoginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.startOnSignUp = false}); // Default is login

  final bool startOnSignUp;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _confirmPass = TextEditingController();
  bool _isLoading = false;
  late bool _isSignUp;
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _newUser = TextEditingController();
  final PageController _pageController = PageController();
  late final TextEditingController _passwordController =
      TextEditingController();

  late final TextEditingController _usernameController =
      TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.startOnSignUp;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_isSignUp ? 1 : 0);
    });
  }

  Future<void> signup() async {
    try {
      setState(() => _isLoading = true);
      final nameInput = _newUser.text.trim();
      final passInput = _newPass.text.trim();
      final confirmPassInput = _confirmPass.text.trim();

      if (passInput != confirmPassInput) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final data =
          await supabase.from('user').select().eq('username', nameInput);
      if (data.isEmpty) {
        await supabase
            .from('user')
            .insert({'username': nameInput, 'password': passInput});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successful Registration')),
        );
        CustomUser pass = CustomUser(nameInput);
        setUser(pass);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavigationBarApp()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Username is already taken, please try again')),
        );
        _newUser.clear();
        _newPass.clear();
      }
    } catch (e) {
      logger.e('Error during sign-in', error: e);
    }
  }

  Future<void> _signIn() async {
    try {
      setState(() => _isLoading = true);
      final nameInput = _usernameController.text.trim();
      final passwordInput = _passwordController.text.trim();

      final data = await supabase
          .from('user')
          .select()
          .eq('username', nameInput)
          .eq('password', passwordInput);

      if (data.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid login, please try again')),
        );
      } else {
        CustomUser pass = CustomUser(nameInput);
        setUser(pass);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavigationBarApp()));
      }

      setState(() => _isLoading = false);
      _usernameController.clear();
      _passwordController.clear();
    } catch (e) {
      logger.e('Error during sign-in', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade200],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _isSignUp = false);
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            _isSignUp ? Colors.black : Colors.white,
                        backgroundColor:
                            _isSignUp ? Colors.white : kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                        textStyle: GoogleFonts.poppins(fontSize: 15),
                        elevation: 10,
                      ),
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _isSignUp = true);
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            _isSignUp ? Colors.white : Colors.black,
                        backgroundColor:
                            _isSignUp ? kPrimaryColor : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                        textStyle: GoogleFonts.poppins(fontSize: 15),
                        elevation: 10,
                      ),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 90),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        child:Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 26,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Please sign in to continue.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          MyTextField(
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.email),
                                hintText: "Username",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          PasswordTextField(
                            controller: _passwordController,
                            hintText: "Password",
                          ),
                          SizedBox(height: size.height * 0.02),
                          RoundedButton(
                            text: _isLoading ? 'Loading...' : 'LOGIN',
                            press: _isLoading ? null : _signIn,
                            isLoading: _isLoading,
                          ),
                          SizedBox(height: size.height * 0.03),
                          // AlreadyHaveAnAccountCheck(
                          //   press: () {
                          //     setState(() => _isSignUp = true);
                          //     _pageController.animateToPage(1,
                          //         duration: Duration(milliseconds: 300),
                          //         curve: Curves.easeInOut);
                          //   },
                          // ),
                          ForgotPasswordCheck(
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                  ));
                            },
                          ),
                        ],
                      ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 26,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Please create an account to continue.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          MyTextField(
                            child: TextField(
                              controller: _newUser,
                              decoration: InputDecoration(
                                icon: Icon(Icons.email),
                                hintText: "Username",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          PasswordTextField(
                            controller: _newPass,
                            hintText: "Password",
                          ),
                          PasswordTextField(
                            controller: _confirmPass,
                            hintText: "Confirm Password",
                          ),
                          SizedBox(height: size.height * 0.02),
                          RoundedButton(
                            text: _isLoading ? 'Loading...' : 'SIGNUP',
                            press: _isLoading ? null : signup,
                            isLoading: _isLoading,
                          ),
                          SizedBox(height: size.height * 0.03),
                        ],
                      ),
                        )

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomUser {
  CustomUser(this.username);

  final String username;
}

CustomUser userToPass = CustomUser('Guest');

CustomUser getUser() {
  return userToPass; //should return statement be user? once user is an object with the signed in username, or, do User(nameInput)
}

void setUser(CustomUser newUser) {
  userToPass = newUser;
}
