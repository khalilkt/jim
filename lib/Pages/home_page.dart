import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jim/BloC/workout_cubit.dart';
import 'package:jim/Widgets/workout_tile.dart';

import 'package:jim/constants.dart';
import 'package:jim/main.dart';
import 'package:jim/Models/workout_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String search = '';
  FocusNode searchNode = FocusNode();
  late final AnimationController _searchTransAnimController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200));
  late final Animation _seachTransAnimation = CurvedAnimation(
      parent: _searchTransAnimController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut);
  @override
  void initState() {
    context.read<WorkoutCubit>().init();
    searchNode.addListener(() {
      if (searchNode.hasFocus) {
        _searchTransAnimController.forward();
      } else {
        _searchTransAnimController.reverse();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    searchNode.dispose();
    super.dispose();
  }

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
      key: const ValueKey('search bar container'),
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
              key: const ValueKey('seach bar'),
              onChanged: (s) {
                setState(() {
                  search = s;
                });
              },
              focusNode: searchNode,
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
      children: [
        const Text(
          'My Workout List',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async {
            Navigator.pushNamed(context, Pages.createWorkout);
          },
          child: const Text(
            '+',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildTransAnimatedBuilder(Widget child) {
    return AnimatedBuilder(
        animation: _seachTransAnimation,
        child: child,
        builder: (c, child) {
          return Opacity(
            opacity: 1.0 - _seachTransAnimation.value,
            child: Align(
              heightFactor: 1.0 - _seachTransAnimation.value,
              child: Transform.scale(
                  scaleY: 1.0 - _seachTransAnimation.value, child: child),
            ),
          );
        });
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
              _buildTransAnimatedBuilder(_buildHeader()),
              _buildSearchBar(),
              _buildTransAnimatedBuilder(_buildTitle()),
              Expanded(
                child: Builder(builder: (context) {
                  List<Workout> wws =
                      context.watch<WorkoutCubit>().state.workouts;
                  wws = wws.where((e) {
                    return e.name.toLowerCase().contains(search.toLowerCase());
                  }).toList();
                  return ListView(
                    children: List.generate(wws.length, (index) {
                      return Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Pages.liveWorkout,
                                    arguments: wws[index]);
                              },
                              child: WorkoutTile(wws[index])));
                    }),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
