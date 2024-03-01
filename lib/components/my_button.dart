import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String innerText;
  final Icon? icon;

  MyButton({Key? key, required this.onTap, required this.innerText, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      child: IntrinsicWidth(
        child:Container(
          width: 220,
          padding: const EdgeInsets.only(top: 16,bottom: 16,left: 30,right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.transparent,
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  innerText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (icon != null) // Conditionally display the icon
                Padding(
                  padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
                  child: icon,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
