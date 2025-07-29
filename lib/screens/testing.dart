import 'package:flutter/material.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(1, -.4), // Top-right corner
              radius: 0.28, // 40% of the shortest side
              colors: [
                const Color.fromARGB(255, 48, 46, 98), // Start color (center)
                const Color.fromARGB(255, 28, 26, 49), // End color (outer)
              ],
              stops: [0.0, 0.9],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-1.0, -.0), // Top-right corner
              radius: 0.28, // 40% of the shortest side
              colors: [
                const Color.fromARGB(255, 48, 46, 98), // Start color (center)
                const Color.fromARGB(255, 28, 26, 49), // End color (outer)
              ],
              stops: [0.0, 0.9],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(1, .80), // Top-right corner
              radius: 0.28, // 40% of the shortest side
              colors: [
                const Color.fromARGB(255, 48, 46, 98), // Start color (center)
                const Color.fromARGB(255, 28, 26, 49), // End color (outer)
              ],
              stops: [0.0, 0.9],
            ),
          ),
        ),
      ],
    );
  }
}
