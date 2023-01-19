import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qibla_compass/controllers/compassController.dart';
import 'package:sprung/sprung.dart';

class HomePage extends GetView {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder(
      init: Get.put(CompassController()),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/images/5540930.jpg')),
            ),
            child: SizedBox.expand(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background
                  Image.asset(
                    'assets/images/bg.png',
                    height: _screenHeight,
                    width: _screenWidth,
                    opacity: const AlwaysStoppedAnimation(0.5),
                  ),
                  // Compass Dial Background
                  Image.asset(
                    'assets/images/dial.png',
                    height: _screenHeight,
                    width: _screenWidth,
                  ),
                  // Compass Dial (Ticks)
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 1000),
                    curve: Sprung.criticallyDamped,
                    turns: -(controller.compassHeading ?? 0) / 360,
                    child: Image.asset(
                      'assets/images/ticks.png',
                      height: _screenHeight,
                      width: _screenWidth,
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 1000),
                    curve: Sprung.criticallyDamped,
                    turns: ((controller.qiblagOffset ?? 0) / 360) -
                        ((controller.compassHeading ?? 0) / 360),
                    child: Image.asset(
                      'assets/images/kabaa.png',
                      // height: _screenHeight,
                      width: _screenWidth,
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 1000),
                    curve: Sprung.criticallyDamped,
                    turns: (((controller.jurOffset ?? 0)) / 360) -
                        ((controller.compassHeading ?? 0) / 360),
                    child: Image.asset(
                      'assets/images/jur.png',
                      // height: _screenHeight,
                      width: _screenWidth,
                    ),
                  ),
                  // Compass Dial (Pointer)
                  Image.asset(
                    'assets/images/pointer.png',
                    height: _screenHeight,
                    width: _screenWidth,
                  ),
                  // Compass Display (Text)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          '${controller.compassHeading?.round()}',
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4C4C4C),
                          ),
                        ),
                        Text(
                          '${controller.compassDirection}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xCC4C4C4C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Compass Display (Inner Shadow)
                  Image.asset(
                    'assets/images/shadow.png',
                    height: _screenHeight,
                    width: _screenWidth,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
