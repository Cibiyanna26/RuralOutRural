import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/widgets/animated_bar.dart';

class CustomBottomNavItem extends StatelessWidget {
  const CustomBottomNavItem({
    super.key,
    required this.onPressed,
    required this.currentIndex,
    required this.index,
    required this.icon,
  });

  final Function(int p1) onPressed;
  final int currentIndex;
  final int index;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onPressed(index),
      child: SizedBox(
        width: 40,
        height: 50,
        child: Column(
          children: [
            AnimatedBar(isActive: isSelected),
            Opacity(
                opacity: isSelected ? 1 : 0.5,
                child: Icon(icon, color: kBlackColor.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}
