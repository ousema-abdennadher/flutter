import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function() editingFinish;
  final String hintText;
  final bool isValid;
  final double height;
  final bool showPrefixIcon;
  final Widget? prefixIcon;
  final bool obscureText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.isValid,
    required this.editingFinish,
    this.height = 57.0,
    this.showPrefixIcon = false,
    this.prefixIcon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        height: widget.height,
        child: TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          onEditingComplete: widget.editingFinish,
          decoration: InputDecoration(
            errorText: widget.isValid ? null : 'Invalid email',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.green, width: 1.0),
            ),
            prefixIcon: widget.showPrefixIcon
                ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.srcIn,
              ),
              child: widget.prefixIcon,
            )
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
                child: Icon(
                  _obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            )
                : null,
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
