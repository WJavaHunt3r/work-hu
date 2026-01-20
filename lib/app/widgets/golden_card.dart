import 'dart:math' as math;

import 'package:flutter/material.dart';

class GoldenCard extends StatefulWidget {
  const GoldenCard({super.key, required this.child, this.height = 110});

  final Widget child;
  final double height;

  @override
  State<GoldenCard> createState() => _GoldenCardState();
}

class _GoldenCardState extends State<GoldenCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFffd700), // gold
              Color(0xFFdaa520), // goldenrod
              Color(0xFFb8860b), // darkgoldenrod
            ],
            stops: [0.1, 0.5, 0.9],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30.0,
              spreadRadius: 5.0,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // We use Transform.rotate to spin the shine element around
                return Transform.rotate(
                  // The controller's value goes from 0.0 to 1.0, which we multiply
                  // by 2*pi to get a full 360-degree rotation.
                  angle: _controller.value * 2 * math.pi,
                  child: Container(
                    // A very large container with a radial gradient for the shine
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.0, // Large radius
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.6],
                      ),
                    ),
                  ),
                );
              },
            ),
            // The content of the card
            Center(child: widget.child),
          ],
        ),
      ),
    );
  }
}
