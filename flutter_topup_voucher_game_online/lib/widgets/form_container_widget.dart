import 'dart:ui';
import 'package:flutter/material.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final Icon? icon;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;

  const FormContainerWidget({
    super.key,
    this.controller,
    this.fieldKey,
    this.isPasswordField,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
    this.icon,
  });

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  double getWidth() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalWidth = view.physicalSize.width;
    double devicePixelRatio = view.devicePixelRatio;
    return physicalWidth / devicePixelRatio;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth() / 2 * 1.9,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A40), // ✅ Background gelap yang enak dilihat
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.white), // ✅ Teks putih
        cursorColor: Colors.white, // ✅ Kursor putih
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField == true ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor:
              Colors
                  .transparent, // ❗Ditransparankan karena sudah dibungkus container
          hintText: widget.hintText,
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.white70), // ✅ Label cerah
          hintStyle: const TextStyle(color: Colors.white54), // ✅ Hint cerah
          icon: widget.icon,
          suffix:
              widget.isPasswordField == true
                  ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70, // ✅ Ikon juga putih terang
                      size: 20,
                    ),
                  )
                  : null,
        ),
      ),
    );
  }
}
