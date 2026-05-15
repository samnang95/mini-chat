import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int totalDots;
  final int currentIndex;

  const DotIndicator({
    super.key,
    required this.totalDots,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        bool isActive = index == currentIndex;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
          width: isActive ? 24.0 : 12.0, // A bit of a nice active stretch effect
          height: 12.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: isActive ? colorScheme.primary : Colors.transparent, // Theme aware
            border: Border.all(
              color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3), // Theme aware
              width: 2.0,
            ),
          ),
        );
      }),
    );
  }
}
