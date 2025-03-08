import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringAppbar extends StatelessWidget {
  const ShimmeringAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 20,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
