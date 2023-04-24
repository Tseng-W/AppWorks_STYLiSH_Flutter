import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 20),
          const Text('Total: \$0'),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: const TapPayView(),
          )
        ])),
      ),
    );
  }
}

class TapPayView extends StatefulWidget {
  const TapPayView({super.key});

  @override
  State<TapPayView> createState() => _TapPayViewState();
}

class _TapPayViewState extends State<TapPayView> {
  final messageChannel =
      const BasicMessageChannel('TapPayView/message', StandardMessageCodec());

  @override
  void initState() {
    super.initState();

    messageChannel.setMessageHandler((message) async {
      Logger().i(message);
      return "Received: $message";
    });
  }

  @override
  Widget build(BuildContext context) {
    return const UiKitView(
        viewType: '<TapPayView>',
        layoutDirection: TextDirection.ltr,
        creationParams: {},
        creationParamsCodec: StandardMessageCodec());
  }
}
