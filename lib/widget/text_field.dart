import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
  });

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;

    final padH = (w * 0.05).clamp(12.0, 30.0);
    final padV = (h * 0.008).clamp(4.0, 10.0);

    final textSize = (isTablet ? w * 0.022 : w * 0.045).clamp(14.0, 20.0);
    final hintSize = (isTablet ? w * 0.02 : w * 0.04).clamp(13.0, 18.0);

    final contentV = (h * 0.018).clamp(10.0, 16.0);
    final contentH = (w * 0.05).clamp(14.0, 22.0);

    final radius = (w * 0.03).clamp(10.0, 16.0);
    final iconSize = (isTablet ? w * 0.028 : w * 0.06).clamp(18.0, 26.0);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padV, horizontal: padH),
      child: TextField(
        controller: widget.textEditingController,
        style: TextStyle(fontSize: textSize),
        obscureText: widget.isPass ? _isObscured : false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black45, fontSize: hintSize),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: EdgeInsets.symmetric(
            vertical: contentV,
            horizontal: contentH,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(radius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue, width: (w * 0.004).clamp(1.5, 2.5)),
            borderRadius: BorderRadius.circular(radius),
          ),
          suffixIcon: widget.isPass
              ? GestureDetector(
                  onTap: () {
                    setState(() => _isObscured = !_isObscured);
                  },
                  child: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: iconSize,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
