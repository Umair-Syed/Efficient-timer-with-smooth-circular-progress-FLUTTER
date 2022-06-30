import 'dart:async';

import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer Demo"),
      ),
      body: const Center(child: TimerProgress(totalSeconds: 120,)),
    );
  }
}

class TimerProgress extends StatefulWidget {
  final int totalSeconds;

  const TimerProgress({Key? key, required this.totalSeconds}) : super(key: key);

  @override
  State<TimerProgress> createState() => _TimerProgressState();
}

class _TimerProgressState extends State<TimerProgress> with TickerProviderStateMixin {
  int totalSeconds = 300; // 5mins
  double currentAnimationValue = 0.0;
  int currentSecond = 0;
  late AnimationController controller;

  @override
  void initState() {
    totalSeconds = widget.totalSeconds;
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalSeconds),
    )..addListener(() {
      currentAnimationValue = controller.value;
      currentSecond = (totalSeconds*currentAnimationValue).toInt();
      print("TICKER: Animation Value: $currentAnimationValue,  Time: $currentSecond / $totalSeconds");
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          const SizedBox(height: 40.0),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  value: controller.value,
                  strokeWidth: 14,
                  color: Colors.blue,
                  // valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              Text("$currentSecond / $totalSeconds")
            ]
          ),
          const SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              controller.stop();
            },
            child: Text("Pause"),
          ),
          const SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              controller.forward(from: currentAnimationValue);
            },
            child: Text("resume"),
          ),
          const SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              controller.forward();
            },
            child: Text("start"),
          ),
          const SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              controller.reset();
            },
            child: Text("stop"),
          ),

        ],
      );
  }
}

