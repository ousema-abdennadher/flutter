import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../pages/Notification.dart';
import '../pages/parametre.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Image leading;
  final bool showBackArrow;
  const CustomAppBar({
    required this.leading,
    this.showBackArrow = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7BC7BF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top:20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showBackArrow)
              GestureDetector(
                onTap: () {
                  // Handle back button press, you can use Navigator.pop() here
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            SizedBox(width: 130, child: leading),
            const SizedBox(width: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NotificationIcon(),
                NewIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationIcon extends StatefulWidget {
  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  bool isPressed = false; // Track if the icon is currently pressed

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          // Change the color to green when the user presses the icon
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          // Change the color back to white when the user's finger leaves the icon
          isPressed = false;
        });

        // Handle the onTap action for notification icon
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ),
        );
      },
      onTapCancel: () {
        setState(() {
          // Change the color back to white when the tap is canceled
          isPressed = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'svg/notification.svg',
          height: 35,
          width: 35,
          color: isPressed ? const Color(0xFF00FFA3) : Colors.white,
        ),
      ),
    );
  }
}



class NewIcon extends StatefulWidget {
  @override
  _NewIconState createState() => _NewIconState();
}

class _NewIconState extends State<NewIcon> {
  bool isPressed = false; // Track if the icon is currently pressed

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          // Change the color to green when the user presses the icon
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          // Change the color back to white when the user's finger leaves the icon
          isPressed = false;
        });

        // Handle the onTap action for the new icon
        // Add your navigation logic here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
      },
      onTapCancel: () {
        setState(() {
          // Change the color back to white when the tap is canceled
          isPressed = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'svg/settings.svg', // Replace with the path to your new icon SVG
          height: 35,
          width: 35,
          color: isPressed ? const Color(0xFF00FFA3) : Colors.white,
        ),
      ),
    );
  }
}
