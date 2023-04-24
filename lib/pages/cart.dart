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
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: 20),
          Text('Total: \$0'),
          SizedBox(height: 20),
          TapPayView()
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
      const BasicMessageChannel('tapPayResponse', StringCodec());

  String responseMessage = '';

  @override
  void initState() {
    super.initState();

    messageChannel.setMessageHandler((message) async {
      Logger().i(message);
      if (message != null) {
        setState(() {
          responseMessage = message;
        });
      }
      return "Received: $message";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(responseMessage,
              style: Theme.of(context).textTheme.displayMedium),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 450,
            child: const UiKitView(
                viewType: '<TapPayView>',
                layoutDirection: TextDirection.ltr,
                creationParams: {},
                creationParamsCodec: StandardMessageCodec()),
          ),
        ],
      ),
    );
  }
}
