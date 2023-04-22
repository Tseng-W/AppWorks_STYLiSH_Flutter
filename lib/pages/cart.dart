import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          height: 300,
          child: const Center(
            child: Text('Cart'),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Total: \$0'),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          height: 200,
          child: UiKitView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          ),
        )
      ])),
    );
  }
}
