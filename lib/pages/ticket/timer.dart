import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class CountdownTimerWidget extends StatelessWidget {
  final DateTime endTime; // Specify the end time for the countdown

  const CountdownTimerWidget({required this.endTime, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(const Duration(seconds: 1),
        builder: (context) {
      Duration duration = endTime.difference(DateTime.now());

      // Handle when the timer reaches or goes below zero
      if (duration.inSeconds <= 0) {
        return const Text('Countdown ended');
      }

      // Calculate days, hours, minutes, and seconds
      int days = duration.inDays;
      int hours = duration.inHours.remainder(24);
      int minutes = duration.inMinutes.remainder(60);
      int seconds = duration.inSeconds.remainder(60);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  days.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                _buildLabel('DAY'),
              ],
            ),
            Column(
              children: [
                Text(
                  hours.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                _buildLabel('HOUR'),
              ],
            ),
            Column(
              children: [
                Text(
                  minutes.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                _buildLabel('MIN'),
              ],
            ),
            Column(
              children: [
                Text(
                  seconds.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                _buildLabel('SEC'),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 68, 67, 67), width: 0.5),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 68, 67, 67),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
