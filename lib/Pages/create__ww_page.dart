import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jim/BloC/workout_cubit.dart';
import 'package:jim/Models/exercise_model.dart';
import 'package:jim/Models/workout_model.dart';
import 'package:jim/Pages/live_workout_page.dart';
import 'package:jim/Widgets/dragable_container.dart';
import 'package:jim/Widgets/exercise_tile.dart';

import '../constants.dart';
import '../ss.dart';

class CreateEditWorkoutPage extends StatefulWidget {
  const CreateEditWorkoutPage({super.key});

  @override
  State<CreateEditWorkoutPage> createState() => _CreateEditWorkoutPageState();
}

class _CreateEditWorkoutPageState extends State<CreateEditWorkoutPage> {
  final TextEditingController nameController = TextEditingController();

  final List<Exercise> exos = [];
  final animatedListDuration = const Duration(milliseconds: 150);
  int? expandedTile;
  Widget _buildField() {
    return Row(
      children: [
        const Icon(
          Icons.edit,
          color: Color(0xff888888),
          size: 28,
        ),
        const SizedBox(
          width: defPagePadding,
        ),
        Expanded(
            child: TextField(
          controller: nameController,
          onChanged: (_) {
            //DONT DELETE : used to remove the create button if textfiel  == ''
            setState(() {});
          },
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Workout Name',
            hintStyle: TextStyle(color: Color(0xff999999)),
            border: InputBorder.none,
          ),
        ))
      ],
    );
  }

  Widget _buildAction(IconData icon, Color iconColor, Color backColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 24,
        color: iconColor,
      ),
    );
  }

  Widget _buildTile(int index,
      {required void Function() onDeleteTap,
      required void Function(Exercise?) onAddTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: defTilePadding),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (expandedTile != index) {
              expandedTile = index;
            } else {
              expandedTile = null;
            }
          });
        },
        child: DragableContainer(
          isDraggable: expandedTile != index && index != exos.length,
          actions: [
            _buildAction(Icons.edit, primaryColor, Colors.white),
            _buildAction(
              Icons.delete_rounded,
              const Color(0xffff5959),
              Colors.white,
            ),
          ],
          onActionTap: (int tapedIndex) {
            if (tapedIndex == 0) {
            } else if (tapedIndex == 1) {
              onDeleteTap();
            }
          },
          child: index == exos.length
              ? ExerciseTile.add(
                  // key: ValueKey(expandedTile == index),

                  onAddTap: onAddTap,
                  expanded: expandedTile == index,
                )
              : ExerciseTile.exercise(
                  exos[index],
                  expanded: expandedTile == index,
                  inSet: null,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backColor,
      body: Column(
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
              children: [
                _buildField(),
                Expanded(
                    child: AnimatedList(
                  physics: const BouncingScrollPhysics(),
                  initialItemCount: 1,
                  padding: const EdgeInsets.only(bottom: defTilePadding + 30),
                  itemBuilder: ((context, index, animation) {
                    return _buildTile(index, onDeleteTap: () async {
                      AnimatedList.of(context).removeItem(index,
                          (context, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          child: _buildTile(index,
                              onAddTap: (exo) {}, onDeleteTap: () {}),
                          builder: (c, child) {
                            double value = CurvedAnimation(
                                    parent: animation, curve: Curves.easeIn)
                                .value;

                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                  offset: Offset(0, -100 * (1 - value)),
                                  child:
                                      Align(heightFactor: value, child: child)),
                            );
                          },
                        );
                      }, duration: animatedListDuration);
                      // await Future.delayed(animatedListDuration);
                      setState(() {
                        exos.removeAt(index);
                      });
                    }, onAddTap: (exo) {
                      setState(() {
                        expandedTile = null;
                        if (exo != null) {
                          exos.add(exo);
                          AnimatedList.of(context).insertItem(index,
                              duration: animatedListDuration);
                        }
                      });
                    });
                  }),
                ))
              ],
            ),
          ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(builder: (context) {
        if (expandedTile == exos.length ||
            nameController.text == '' ||
            exos.isEmpty) {
          return const SizedBox();
        }
        return ElevatedButton(
            onPressed: () async {
              try {
                await context
                    .read<WorkoutCubit>()
                    .createWorkout(name: nameController.text, exos: exos);
                Navigator.pop(context);
              } catch (_) {}
            },
            style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Text(
                'Create Workout',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ));
      }),
    ));
  }
}
