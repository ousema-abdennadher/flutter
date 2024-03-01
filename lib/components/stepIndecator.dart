import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Etape",
              style: TextStyle(
                fontFamily: "KoHo",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 5,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StepCircle(0, currentStep),
                    _StepCircle(1, currentStep),
                    _StepCircle(2, currentStep),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final int currentStep;

  const _StepCircle(this.stepNumber, this.currentStep);

  @override
  Widget build(BuildContext context) {
    final isActive = stepNumber == currentStep;
    final circleColor = isActive ? const Color(0xFF00FFA3) : Colors.white;
    final textColor = isActive ?Colors.white :  const Color(0xFF6BB9F0);

    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          (stepNumber + 1).toString(),
          style: TextStyle(
            fontFamily: "KoHo",
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
