import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jim/Models/exercise_model.dart';

import '../constants.dart';

class ExerciseTile extends StatefulWidget {
  final Exercise exo;
  final bool expanded;
  final int? inSet;
  const ExerciseTile(this.exo, {super.key, required this.expanded, this.inSet});

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile>
    with SingleTickerProviderStateMixin {
  static const double _pad = 18;
  static const double _verPad = 24;

  late final AnimationController _animController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 150));

  late final Animation animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut);

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

  Widget _buildStat() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 9),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: secondaryColor,
          )),
      child: Text(
        '${widget.exo.sets}x${widget.exo.reps}',
        style: const TextStyle(
            color: secondaryColor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildExpanded() {
    Widget buildCol(String value, String name) => Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff989898),
                  fontWeight: FontWeight.w600),
            )
          ],
        );
    return Padding(
      padding: const EdgeInsets.only(top: _verPad),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildCol(widget.exo.weight?.toString() ?? 'N\\A', 'weight'),
            buildCol(widget.exo.reps.toString(), 'Reps'),
            buildCol(widget.exo.sets.toString(), 'Sets'),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        LayoutBuilder(builder: (context, cc) {
          double w = (cc.maxWidth / widget.exo.sets) - (widget.exo.sets * 3);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.exo.sets, (index) {
              return Container(
                width: w,
                height: 6,
                color: index == widget.inSet
                    ? Colors.white
                    : index < (widget.inSet ?? -1)
                        ? secondaryColor
                        : const Color(0xff989898),
              );
            }),
          );
        })
      ]),
    );
  }

  @override
  void initState() {
    if (widget.expanded) {
      _animController.value = 1;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExerciseTile oldWidget) {
    if (widget.expanded) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/exercise_img.png',
                width: 30,
                color: Colors.white,
                height: 30,
                fit: BoxFit.fitHeight,
              ),
              pad(),
              _div(),
              pad(),
              Expanded(
                child: Text(
                  widget.exo.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              AnimatedBuilder(
                  animation: animation,
                  builder: (c, w) {
                    return Opacity(opacity: 1.0 - animation.value, child: w);
                  },
                  child: _buildStat()),
            ],
          ),
          AnimatedBuilder(
              animation: animation,
              child: _buildExpanded(),
              builder: (context, w) {
                if (animation.value == 0) {
                  return const SizedBox();
                }
                return Align(
                    heightFactor: animation.value,
                    child: Transform.scale(scaleY: animation.value, child: w!));
              })
        ],
      ),
    );
  }
}
