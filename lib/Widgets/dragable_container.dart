import 'package:flutter/material.dart';

import 'package:jim/constants.dart';

class DragableContainer extends StatefulWidget {
  final Widget child;
  final List<Widget> actions;
  final bool isDraggable;
  final void Function(int) onActionTap;
  final double maxDrag;
  const DragableContainer(
      {super.key,
      this.maxDrag = 160,
      required this.isDraggable,
      required this.actions,
      required this.child,
      required this.onActionTap});

  @override
  State<DragableContainer> createState() => _DragableContainerState();
}

class _DragableContainerState extends State<DragableContainer>
    with TickerProviderStateMixin {
  late final AnimationController dragAnimController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));

  late final Animation dragAnimation =
      CurvedAnimation(parent: dragAnimController, curve: Curves.easeInOut);
  int dragDirection = 1;
  late double ww;

  @override
  void dispose() {
    dragAnimController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DragableContainer oldWidget) {
    if (!widget.isDraggable) {
      dragAnimController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Align(
        alignment:
            dragDirection == 1 ? Alignment.centerLeft : Alignment.centerRight,
        child: SizedBox(
          width: widget.maxDrag,
          child: AnimatedBuilder(
            animation: dragAnimation,
            builder: (c, child) {
              return Transform.scale(
                scale: dragAnimation.value,
                child: child,
              );
            },
            child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.actions.length, (index) {
                  return GestureDetector(
                      onTap: () {
                        widget.onActionTap(index);
                      },
                      child: widget.actions[index]);
                })),
          ),
        ),
      ),
      GestureDetector(
          onHorizontalDragEnd: (d) {
            // isDragingLeft = d.velocity.pixelsPerSecond.dx < 0;
            if (!widget.isDraggable) {
              return;
            }
            if (d.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
              double visualVelocity = (dragDirection) *
                  d.velocity.pixelsPerSecond.dx /
                  MediaQuery.of(context).size.width;
              dragAnimController.fling(velocity: visualVelocity);
            } else if (dragAnimController.value < 0.5) {
              dragAnimController.reverse();
            } else {
              dragAnimController.forward();
            }
          },
          onHorizontalDragUpdate: (d) {
            if (!widget.isDraggable) {
              return;
            }
            if (dragAnimController.isDismissed) {
              setState(() {
                dragDirection = d.delta.dx > 0 ? 1 : -1;
              });
            }
            double delta = d.primaryDelta! / widget.maxDrag * dragDirection;

            dragAnimController.value += delta;
          },
          // onTap: () {
          //   // widget.onTap();
          // },
          child: AnimatedBuilder(
              animation: dragAnimController,
              builder: (c, child) {
                return Transform.translate(
                    offset: Offset(
                        dragDirection * widget.maxDrag * dragAnimation.value,
                        0),
                    child: child);
              },
              child: widget.child))
    ]);
  }
}
