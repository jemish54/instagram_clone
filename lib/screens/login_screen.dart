import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:instagram_clone/domain/authentication.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/credential_field.dart';
import 'package:instagram_clone/widgets/progress_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: webScreenBreakpoint),
              child: loginSection(
                  context: context,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onLoginClicked: () async {
                    String res = await AuthService().logInUser(
                        _emailController.text, _passwordController.text);
                    if (mounted && res == 'Success') {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => const HomeScreen())));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(res)));
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

Widget loginSection(
    {required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required Function onLoginClicked}) {
  return Center(
    child: Neumorphic(
      style: NeumorphicStyle(
        depth: 8,
        color: Colors.blue[900],
        shadowLightColor: Colors.blue,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text("Welcome Back!",
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                CredentialField(
                    textController: emailController,
                    hint: "Email",
                    iconData: Icons.email_rounded,
                    inputType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                CredentialField(
                    textController: passwordController,
                    hint: "Password",
                    iconData: Icons.lock_rounded,
                    inputType: TextInputType.text,
                    isPassword: true),
                const SizedBox(
                  height: 18,
                ),
                ProgressButton(
                    text: 'Login',
                    size: const Size(double.infinity, 28),
                    onPressed: onLoginClicked)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account ? ",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const SignUpScreen()));
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
