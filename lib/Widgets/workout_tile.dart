import 'package:flutter/material.dart';
import 'package:jim/constants.dart';
import 'package:jim/Models/workout_model.dart';

class WorkoutTile extends StatelessWidget {
  final Workout workout;
  const WorkoutTile(this.workout, {super.key});
  static const double _pad = 18;
  static const double _verPad = 24;

  _div() {
    return Container(
      color: Colors.white.withOpacity(.4),
      height: 30,
      width: 1.5,
    );
  }

  Widget pad() => const SizedBox(
        width: _pad,
        height: 10, //just for testing
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: _verPad, horizontal: _pad),
      decoration: BoxDecoration(
          color: primaryColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.25),
                offset: const Offset(0, 2),
                blurRadius: 4)
          ],
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/workout_img.png',
            width: 30,
            color: Colors.white,
            height: 30,
            fit: BoxFit.fitHeight,
          ),
          pad(),
          _div(),
          pad(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${workout.exos.length} Exercises - 1H32MIN',
                  style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          _div(),
          pad(),
          const Icon(
            Icons.play_arrow,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
