import 'package:flutter/material.dart';
import 'package:jim/Widgets/workout_tile.dart';

import 'package:jim/constants.dart';
import 'package:jim/main.dart';
import 'package:jim/Models/workout_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 69,
          width: 69,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: defPagePadding,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hello, Welcome',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Khalil Ktiri',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            )
          ],
        )
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.fromLTRB(14, 36, 14, 36),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 4,
            offset: const Offset(0, 4))
      ], color: primaryColor, borderRadius: BorderRadius.circular(7)),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(
              Icons.search,
              color: secondaryColor,
              size: 32,
            ),
          ),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search Workout',
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: const [
        Text(
          'My Workout List',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        Text(
          '+',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backColor,
        body: Padding(
          padding: const EdgeInsets.only(
              left: defPagePadding, right: defPagePadding, top: defPagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildTitle(),
              Expanded(
                child: ListView(
                  children: List.generate(3, (index) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Pages.liveWorkout,
                                  arguments: pushDay);
                            },
                            child: WorkoutTile(pushDay)));
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
