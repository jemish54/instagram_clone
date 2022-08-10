import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CredentialField extends StatelessWidget {
  final TextEditingController textController;
  final TextInputType inputType;
  final String hint;
  final IconData iconData;
  final bool isPassword;

  const CredentialField({
    Key? key,
    required this.textController,
    required this.inputType,
    required this.hint,
    required this.iconData,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        depth: -4,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8.0)),
      ),
      child: TextFormField(
          keyboardType: inputType,
          controller: textController,
          obscureText: isPassword,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: Icon(
              iconData,
              color: Colors.blue,
            ),
            border: InputBorder.none,
            hintText: hint,
          )),
    );
  }
}
