import 'package:flutter/material.dart';

class HotProductsList extends StatelessWidget {
  const HotProductsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return const Padding(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
            child: HotProduct(),
          );
        },
      ),
    );
  }
}

class HotProduct extends StatelessWidget {
  const HotProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0), child: const Placeholder());
  }
}
