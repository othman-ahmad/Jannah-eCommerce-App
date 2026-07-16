import 'package:flutter/material.dart';
import 'package:jannah/core/glopal_constants.dart/colors.dart';

class PrimaryTextField extends StatefulWidget {
  PrimaryTextField({
    super.key,
    this.hintText = '',
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });
  String hintText;
  double verticalPadding;
  double horizontalPadding;
  bool isPassword = false;
  TextEditingController? controller;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  ValueChanged<String>? onSubmitted;

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
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
        obscureText: widget.isPassword ? isObscureText : false,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          label: Text(widget.hintText),
          labelStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 24,
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
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isObscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade600,
                  ),
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
