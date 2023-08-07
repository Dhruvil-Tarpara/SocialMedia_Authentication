import 'package:flutter/material.dart';

class CommonHero extends StatelessWidget {
  final String tag;
  final Widget child;

  const CommonHero({super.key, required this.tag, required this.child});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return Container();
      },
      child: child,
    );
  }
}
