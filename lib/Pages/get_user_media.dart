import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

final loggerProvider = Provider((_) => Logger());

final steamStatusProvider =
    StateNotifierProvider<StreamStatusNotifier, StreamStatus>(
  (ref) => StreamStatusNotifier(ref),
);

class StreamStatusNotifier extends StateNotifier<StreamStatus> {
  StreamStatusNotifier(this.ref) : super(StreamStatus());
  final Ref ref;

  void makeCall() async {
    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      final localStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      state = StreamStatus(localStream: localStream, isCalling: true);
      ref.read(loggerProvider).i('makeCall success');
    } catch (e) {
      ref.read(loggerProvider).e(e.toString());
    }
  }

  void hangUp() async {
    try {
      await state.localStream?.dispose();
      state = StreamStatus(localStream: null);
      ref.read(loggerProvider).i('hangUp success');
    } catch (e) {
      ref.read(loggerProvider).e(e.toString());
    }
  }
}

class StreamStatus extends Equatable {
  StreamStatus({this.localStream, this.isCalling = false});

  MediaStream? localStream;
  bool isCalling = false;

  @override
  List<Object?> get props => [localStream, isCalling];
}

class GetUserMediaPage extends ConsumerStatefulWidget {
  const GetUserMediaPage({Key? key}) : super(key: key);

  @override
  GetUserMediaPageState createState() => GetUserMediaPageState();
}

class GetUserMediaPageState extends ConsumerState<GetUserMediaPage> {
  final _localRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenderer.dispose();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  Widget build(BuildContext context) {
    MediaStream? localStream = ref.watch(steamStatusProvider).localStream;
    if (localStream != null) {
      _localRenderer.srcObject = localStream;
    } else if (_localRenderer.srcObject != null) {
      _localRenderer.srcObject = null;
    }

    bool isCalling = ref.watch(steamStatusProvider).isCalling;
    StreamStatusNotifier notifier = ref.read(steamStatusProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetUserMediaPage'),
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.black54),
            child: RTCVideoView(
              _localRenderer,
              mirror: true,
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => isCalling ? notifier.hangUp() : notifier.makeCall(),
        tooltip: isCalling ? 'Hangup' : 'Call',
        child: Icon(isCalling ? Icons.call_end : Icons.phone),
      ),
    );
  }
}
