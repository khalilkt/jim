import 'dart:math';

import 'package:flutter/material.dart';

import '../Models/exercise_model.dart';
import '../constants.dart';

class ExerciseTile extends StatefulWidget {
  final Exercise? exo; //if exo is null => adding mode
  final bool expanded;
  final int? inSet;
  final void Function(Exercise? exercise)? onAddTap;

  ///if exo is null => tape on X
  const ExerciseTile(
      {super.key,
      required this.onAddTap,
      required this.exo,
      required this.expanded,
      required this.inSet});

  const ExerciseTile.add(
      {super.key,
      required this.expanded,
      required void Function(Exercise?) this.onAddTap})
      : exo = null,
        inSet = null;
  const ExerciseTile.exercise(
    Exercise this.exo, {
    super.key,
    required this.expanded,
    required this.inSet,
  }) : onAddTap = null;

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile>
    with TickerProviderStateMixin {
  late final AnimationController _animController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 150));

  late final Animation animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut);

  late final AnimationController _addAnimController;
  late final Animation _addAnimation;
  late List<TextEditingController> _addFieldsControllers;
  late final TextEditingController _nameController;
  static const double _pad = 18;
  static const double _verPad = 24;

  Widget _div() {
    return Container(
      color: Colors.white.withOpacity(.4),
      height: 30,
      width: 1.5,
    );
  }

  Widget padW() => const SizedBox(
        width: _pad,
        height: 10, //just for testing
      );

  void _addExercice() {
    String name = _nameController.text;
    String weight = _addFieldsControllers[1].text;
    String reps = _addFieldsControllers[1].text;
    String sets = _addFieldsControllers[2].text;
    widget.onAddTap!(Exercise(
        name: name,
        weight: double.tryParse(weight),
        reps: int.parse(reps),
        sets: int.parse(sets)));
  }

  void _textFieldListennerHandler() {
    try {
      String name = _nameController.text;
      int reps = int.parse(_addFieldsControllers[1].text);
      int sets = int.parse(_addFieldsControllers[2].text);

      if (reps != 0 && sets != 0 && name != '') {
        _addAnimController.forward();
        return;
      }
    } catch (_) {}
    _addAnimController.reverse();
  }

  @override
  void initState() {
    if (widget.exo == null) {
      _nameController = TextEditingController();
      _addFieldsControllers =
          List.generate(3, (index) => TextEditingController());
      _nameController.addListener(_textFieldListennerHandler);
      for (var element in _addFieldsControllers) {
        element.addListener(_textFieldListennerHandler);
      }
      _addAnimController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 100));
      _addAnimation = CurvedAnimation(
          parent: _addAnimController,
          curve: Curves.easeIn,
          reverseCurve: Curves.easeOut);
    }
    if (widget.expanded) {
      _animController.value = 1;
    }
    super.initState();
  }

  void reset() {
    if (widget.exo == null) {
      _addAnimController.reset();
      _nameController.text = '';
      for (var c in _addFieldsControllers) {
        c.text = '';
      }
    }
  }

  @override
  void dispose() {
    if (widget.exo == null) {
      for (var element in _addFieldsControllers) {
        element.dispose();
      }
      _addAnimController.dispose();
      _nameController.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExerciseTile oldWidget) {
    if (widget.expanded) {
      if (_animController.isDismissed) {
        reset();
      }
      _animController.forward();
    } else {
      _animController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildHeader(
      {required Widget title, required Widget start, required Widget end}) {
    return Row(
      children: [start, padW(), _div(), padW(), Expanded(child: title), end],
    );
  }

  final TextStyle _style = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);
  Widget _buildStat() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 9),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: secondaryColor,
          )),
      child: Text(
        '${widget.exo!.sets}x${widget.exo!.reps}',
        style: const TextStyle(
            color: secondaryColor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildAddExpanded() {
    Widget buildCol(String hint, String name,
            {required TextEditingController controller, bool last = false}) =>
        Column(
          children: [
            TextField(
              controller: controller,
              maxLength: 3,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 24,
              ),
              textInputAction:
                  last ? TextInputAction.done : TextInputAction.next,
              decoration: InputDecoration(
                counterText: '',
                hintStyle: const TextStyle(color: Color(0xff999999)),
                isCollapsed: true,
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
            // Text(
            //   hint,
            //   style: const TextStyle(
            //     fontWeight: FontWeight.w900,
            //     fontSize: 24,
            //   ),
            // ),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff989898),
                  fontWeight: FontWeight.w600),
            )
          ],
        );

    Widget buildAddButton(void Function() onTap) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: _addAnimation,
          builder: (c, child) {
            return Align(
                heightFactor: _addAnimation.value,
                child:
                    Transform.scale(scaleY: _addAnimation.value, child: child));
          },
          child: Container(
            margin: const EdgeInsets.only(top: _verPad),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 3,
                  offset: const Offset(0, 3))
            ], color: secondaryColor, borderRadius: BorderRadius.circular(6)),
            child: const Text(
              'Add',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: _verPad),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: buildCol(
                'N\\A',
                'weight',
                controller: _addFieldsControllers[0],
              )),
              Expanded(
                  child: buildCol(
                "0",
                'Reps',
                controller: _addFieldsControllers[1],
              )),
              Expanded(
                  child: buildCol('0', 'Sets',
                      controller: _addFieldsControllers[2], last: true)),
            ],
          ),
        ),
        buildAddButton(_addExercice),
      ],
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
            buildCol(widget.exo!.weight?.toString() ?? 'N\\A', 'weight'),
            buildCol(widget.exo!.reps.toString(), 'Reps'),
            buildCol(widget.exo!.sets.toString(), 'Sets'),
          ],
        ),
        LayoutBuilder(builder: (context, cc) {
          if (widget.inSet == null) {
            return const SizedBox();
          }
          double w =
              (cc.maxWidth / widget.exo!.sets) - 6 /*(widget.exo!.sets * 2)*/;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.exo!.sets, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: MColorAnimatedContainer(
                  width: w,
                  height: 6,
                  color: index == widget.inSet
                      ? Colors.white
                      : index < (widget.inSet ?? -1)
                          ? secondaryColor
                          : const Color(0xff989898),
                ),
              );
            }),
          );
        })
      ]),
    );
  }

  Widget _buildAddTitle() {
    assert(widget.exo == null);
    if (widget.expanded) {
      return TextField(
        autofocus: true,
        style: _style,
        textInputAction: TextInputAction.next,
        controller: _nameController,
        decoration: const InputDecoration(
            hintStyle: TextStyle(
              color: Color(
                0xff888888,
              ),
            ),
            hintText: 'Exercise Name',
            border: InputBorder.none),
      );
    }
    return Text(
      'Add an exercise',
      overflow: TextOverflow.ellipsis,
      style: _style,
    );
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
          _buildHeader(
            title: widget.exo != null
                ? Text(
                    widget.exo!.name,
                    overflow: TextOverflow.ellipsis,
                    style: _style,
                  )
                : _buildAddTitle(),
            start: widget.exo == null
                ? AnimatedBuilder(
                    animation: animation,
                    builder: (c, child) {
                      return Transform.rotate(
                        angle: pi / 4 * animation.value,
                        child: animation.value == 1
                            ? GestureDetector(
                                onTap: () {
                                  widget.onAddTap!(null);
                                },
                                child: child,
                              )
                            : child,
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  )
                : Image.asset(
                    'assets/images/exercise_img.png',
                    width: 30,
                    color: Colors.white,
                    height: 30,
                    fit: BoxFit.fitHeight,
                  ),
            end: AnimatedBuilder(
                animation: animation,
                builder: (c, w) {
                  return Opacity(
                      opacity: 1.0 - animation.value,
                      child:
                          Align(widthFactor: 1.0 - animation.value, child: w));
                },
                child: widget.exo == null ? const SizedBox() : _buildStat()),
          ),
          AnimatedBuilder(
              animation: animation,
              child:
                  widget.exo == null ? _buildAddExpanded() : _buildExpanded(),
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

class MColorAnimatedContainer extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  const MColorAnimatedContainer(
      {super.key,
      required this.height,
      required this.color,
      required this.width});

  @override
  State<MColorAnimatedContainer> createState() =>
      _MColorAnimatedContainerState();
}

class _MColorAnimatedContainerState extends State<MColorAnimatedContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  late final Animation _animation =
      CurvedAnimation(parent: _animController, curve: Curves.easeIn);

  late Color color = widget.color;

  @override
  void didUpdateWidget(covariant MColorAnimatedContainer oldWidget) {
    if (widget.color != color) {
      _animate();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _animate() async {
    await _animController.forward();
    setState(() {
      color = widget.color;
    });
    _animController.reset();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          color: color,
        ),
        AnimatedBuilder(
            animation: _animController,
            builder: (c, w) {
              return Container(
                width: widget.width * _animation.value,
                color: widget.color,
                height: widget.height,
              );
            }),
      ],
    );
  }
}
