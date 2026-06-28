import 'package:flutter/material.dart';

class AboutUsImageCard extends StatelessWidget {
  const  AboutUsImageCard({super.key, 
    required this.borderRadius,
    required this.imageAsset,
    required this.height,
  });

  final double borderRadius;
  final String imageAsset;
  final double height;


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Semantics(
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}