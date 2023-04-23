import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String viewType = '<TapPayView>';
    final Map<String, dynamic> creationParams = {};

    return Scaffold(
      appBar: AppBar(
          title: Text(
        '購物車',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 300,
            child: Center(
              child: Text('Cart'),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Total: \$0'),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 500,
            child: IgnorePointer(
              child: UiKitView(
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
              ),
            ),
          )
        ])),
      ),
    );
  }
}
