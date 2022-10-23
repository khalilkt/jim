import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jim/Models/exercise_model.dart';
import 'package:jim/Models/workout_model.dart';
import 'package:jim/Pages/live_workout_page.dart';
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
                    child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding:
                            const EdgeInsets.only(bottom: defTilePadding + 30),
                        children: List.generate(
                          exos.length + 1,
                          (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: defTilePadding),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    expandedTile = index;
                                  });
                                },
                                child: index == exos.length
                                    ? ExerciseTile.add(
                                        // key: ValueKey(expandedTile == index),
                                        onAddTap: (Exercise? exo) {
                                          setState(() {
                                            expandedTile = null;
                                            if (exo != null) {
                                              exos.add(exo);
                                            }
                                          });
                                        },
                                        expanded: expandedTile == index,
                                      )
                                    : ExerciseTile.exercise(
                                        exos[index],
                                        expanded: expandedTile == index,
                                        inSet: expandedTile,
                                      ),
                              ),
                            );
                          },
                        )))
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
          return SizedBox();
        }
        return ElevatedButton(
            onPressed: () {},
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
