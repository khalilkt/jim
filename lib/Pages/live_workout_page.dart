import 'package:flutter/material.dart';
import 'package:jim/Models/workout_model.dart';
import 'package:jim/constants.dart';
import 'package:jim/ss.dart';

import '../Widgets/exercise_tile.dart';

enum LiveState { start, nextExo, nextSet, end }

class LiveWorkoutPage extends StatefulWidget {
  final Workout workout;
  const LiveWorkoutPage(this.workout, {super.key});

  @override
  State<LiveWorkoutPage> createState() => _LiveWorkoutPageState();
}

class _LiveWorkoutPageState extends State<LiveWorkoutPage> {
  int? expandedTile;

  int? exo;
  int? set;

  LiveState _getState() {
    if (exo == null || set == null) {
      return LiveState.start;
    }
    if (exo! == widget.workout.exos.length - 1 &&
        set == widget.workout.exos[exo!].sets - 1) {
      return LiveState.end;
    } else if (set == widget.workout.exos[exo!].sets - 1) {
      return LiveState.nextExo;
    } else {
      return LiveState.nextSet;
    }
  }

  void _next() {
    var state = _getState();

    switch (state) {
      case LiveState.start:
        exo = 0;
        set = 0;
        expandedTile = 0;
        break;
      case LiveState.nextExo:
        exo = exo! + 1;

        set = 0;
        expandedTile = exo;
        break;
      case LiveState.nextSet:
        set = set! + 1;
        break;
      case LiveState.end:
        exo = null;
        set = null;
        expandedTile = null;
        break;
    }

    setState(() {});
  }

  Widget _buildNextButton(void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SS.w * 7.5,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: const Offset(0, -2))
            ],
            color: secondaryColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Builder(builder: (context) {
          LiveState state = _getState();
          String tt;
          switch (state) {
            case LiveState.start:
              tt = 'Start';
              break;
            case LiveState.nextExo:
              tt = 'Next Exo';
              break;
            case LiveState.nextSet:
              tt = 'Next Set';
              break;
            case LiveState.end:
              tt = 'Finish';
              break;
          }
          return Text(
            tt,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: primaryColor, fontSize: 28, fontWeight: FontWeight.w600),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/images/page_img.png',
              height: SS.hh * .3,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    defPagePadding, defPagePadding, defPagePadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.workout.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 36),
                    ),
                    Expanded(
                      child: ListView(
                        children: List.generate(
                            widget.workout.exos.length,
                            (index) => Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (expandedTile == index) {
                                        expandedTile = null;
                                      } else {
                                        expandedTile = index;
                                      }
                                    });
                                  },
                                  child: ExerciseTile(
                                    widget.workout.exos[index],
                                    expanded: index == expandedTile,
                                    inSet: exo == index ? set : null,
                                  ),
                                ))),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildNextButton(() {
          _next();
        }),
      ),
    );
  }
}
