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
    // return; //TODO
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: backColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/page_img.png',
                    height: SS.hh * .3,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  BackButton(
                    color: Colors.white,
                  )
                ],
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
                                  padding: const EdgeInsets.only(
                                      top: defTilePadding),
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
                                    child: ExerciseTile.exercise(
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Builder(builder: (context) {
            LiveState state = _getState();
            String tt;
            IconData icon;
            switch (state) {
              case LiveState.start:
                tt = 'Start';
                icon = Icons.play_arrow;
                break;
              case LiveState.nextExo:
                tt = 'Next Exo';
                icon = Icons.arrow_forward;
                break;
              case LiveState.nextSet:
                tt = 'Next Set';
                icon = Icons.arrow_forward;

                break;
              case LiveState.end:
                tt = 'Finish';
                icon = Icons.stop;
                break;
            }
            return NextButton(
              key: ValueKey(set),
              text: tt,
              icon: icon,
              onTap: _next,
            );
          })),
    );
  }
}

class NextButton extends StatefulWidget {
  final void Function() onTap;
  final IconData icon;
  final String text;
  const NextButton(
      {super.key, required this.text, required this.icon, required this.onTap});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton>
    with SingleTickerProviderStateMixin {
  late String text = widget.text;

  late final AnimationController _animController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _animateChange();

    super.didChangeDependencies();
  }

  void _animateChange() async {
    print('animating change');
    await _animController.animateTo(.6);
    setState(() {
      text = widget.text;
    });
    await _animController.forward();
    _animController.reset();
  }

  @override
  Widget build(BuildContext context) {
    {
      const double pad = 18;
      return GestureDetector(
        // onTap: widget.onTap,
        onTapDown: (d) async {
          // _animController.animateTo(.2);
        },
        onTapCancel: () {
          _animController.reverse();
        },
        onTapUp: (d) {
          widget.onTap();
          print('reversing : ${_animController.isAnimating}');
          if (!_animController.isAnimating) {
            print('revese aniamtion');
            _animController.reverse();
          }
        },
        child: AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              bool secondPhase = _animController.value > .6;
              double value;
              if (!secondPhase) {
                value = const Interval(0, .6, curve: Curves.easeIn)
                    .transform(_animController.value);
              } else {
                value = const Interval(.6, 1, curve: Curves.easeIn)
                    .transform(_animController.value);
              }

              return Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: pad),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.25),
                          blurRadius: 4,
                          spreadRadius: 2,
                          offset: const Offset(0, -2))
                    ],
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Builder(builder: (context) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.translate(
                        offset:
                            Offset(-100.0 * value * (secondPhase ? 0 : 1), 0),
                        child: Opacity(
                          opacity: (secondPhase ? 2.0 * value : 1.0) - value,
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: pad / 2,
                      ),
                      AnimatedBuilder(
                          animation: _animController,
                          builder: (context, _) {
                            return Transform.translate(
                              offset: Offset(
                                  100.0 * value * (secondPhase ? 0 : 1), 0),
                              child: Opacity(
                                opacity:
                                    (secondPhase ? 2.0 * value : 1.0) - value,
                                child: Icon(
                                  widget.icon,
                                  color: primaryColor,
                                  size: 24,
                                ),
                              ),
                            );
                          })
                    ],
                  );
                }),
              );
            }),
      );
    }
  }
}
