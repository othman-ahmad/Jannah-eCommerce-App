import 'package:flutter/material.dart';
import 'package:jannah/core/colors.dart';

class PrimaryTextField extends StatefulWidget {
  PrimaryTextField({
    super.key,
    this.hintText = '',
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.isPassword = false,
  });
  String hintText;
  double verticalPadding;
  double horizontalPadding;
  bool isPassword = false;

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.verticalPadding,
        horizontal: widget.horizontalPadding,
      ),
      child: TextField(
        obscureText: widget.isPassword ? isObscureText : false,
        decoration: InputDecoration(
          label: Text(widget.hintText),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 32,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: mainGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: mainGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: mainGray, width: 2.0),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: isObscureText
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isObscureText = !isObscureText;
                    });
                  },
                )
              : null,
        ),
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
