import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ProgressButton extends StatefulWidget {
  final String text;
  final Size size;
  final Function onPressed;
  const ProgressButton({
    Key? key,
    required this.text,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        await widget.onPressed();
      },
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        color: Colors.blue[600],
        shadowLightColor: Colors.blue[700],
        depth: 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8.0)),
      ),
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Center(
          child: _isLoading
              ? SizedBox(
                  width: widget.size.height,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(widget.text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
