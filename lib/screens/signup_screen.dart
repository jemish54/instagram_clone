import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/domain/authentication.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/main_screen.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/credential_field.dart';
import 'package:instagram_clone/widgets/progress_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
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
              child: Consumer(
                builder: (context, ref, child) => signUpSection(
                    context: context,
                    usernameController: _usernameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onSignUpClicked: () async {
                      String res = await ref
                          .read(authServiceProvider)
                          .signUpUser(_usernameController.text,
                              _emailController.text, _passwordController.text);
                      if (mounted && res == 'Success') {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => const MainScreen())));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(res)));
                      }
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget signUpSection(
    {required BuildContext context,
    required TextEditingController usernameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required Function onSignUpClicked}) {
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
                  child: Text("Hello !",
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                CredentialField(
                    textController: usernameController,
                    hint: "Username",
                    iconData: Icons.person_rounded,
                    inputType: TextInputType.name),
                const SizedBox(height: 16),
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
                  isPassword: true,
                ),
                const SizedBox(
                  height: 18,
                ),
                ProgressButton(
                    text: 'Sign Up',
                    size: const Size(double.infinity, 28),
                    onPressed: onSignUpClicked)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account ? ",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: Text(
                    "Log in",
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
