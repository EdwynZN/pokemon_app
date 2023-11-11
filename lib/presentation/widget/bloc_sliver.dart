import 'package:flutter/material.dart';
import 'package:pokemon_go/presentation/widget/sliver_divider.dart';
import 'package:sliver_tools/sliver_tools.dart';

class BlockSliver extends StatelessWidget {
  final Widget sliver;
  final String title;

  const BlockSliver({
    // ignore: unused_element
    super.key,
    required this.title,
    required this.sliver,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverToBoxAdapter(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              height: 1.3,
              letterSpacing: 0.25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SliverDivider(height: 16.0, thickness: 0.5, color: Colors.black),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          sliver: sliver,
        ),
      ],
    );
  }
}