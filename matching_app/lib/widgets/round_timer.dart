import 'package:flutter/material.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {
  final VoidCallback? onTimerEnd;

  const TimerWidget({
    super.key,
    this.onTimerEnd, // Initialize it in the constructor
  });

  @override
  State<TimerWidget> createState() => TimerState();
}

class TimerState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  static const Duration countdownDuration = Duration(seconds: 30);
  final ValueNotifier<Duration> durationNotifier = ValueNotifier<Duration>(
    countdownDuration,
  );
  Timer? timer;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // It will go back and forth
  }

  @override
  void dispose() {
    _animationController.dispose();
    timer?.cancel();
    durationNotifier.dispose();
    super.dispose();
  }

  void start() {
    timer?.cancel(); // Cancel any existing timer
    durationNotifier.value = countdownDuration; // Reset to 30 seconds
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final seconds = durationNotifier.value.inSeconds - 1;
    if (seconds < 0) {
      timer?.cancel();
      widget.onTimerEnd?.call();
    } else {
      durationNotifier.value = Duration(seconds: seconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: durationNotifier,
      builder: (context, duration, child) {
        Color timerColor = Colors.blue;
        final totalSeconds = countdownDuration.inSeconds;
        final remainingSeconds = duration.inSeconds;

        bool isFlashing = false;

        if (remainingSeconds <= totalSeconds ~/ 4) {
          timerColor = Colors.redAccent;
          isFlashing = true;
        } else if (remainingSeconds <= totalSeconds ~/ 2) {
          timerColor = Colors.orange.shade400;
        }

        String twoDigits(int n) => n.toString().padLeft(2, '0');
        final minutes = twoDigits(duration.inMinutes.remainder(60));
        final seconds = twoDigits(duration.inSeconds.remainder(60));
        final textWidget = Text(
          '$minutes:$seconds',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: timerColor,
          ),
        );

        if (isFlashing) {
          return FadeTransition(
            opacity: _animationController,
            child: textWidget,
          );
        } else {
          return textWidget;
        }
      },
    );
  }
}
