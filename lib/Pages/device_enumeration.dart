import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../Models/stream_status.dart';

// MARK: - For remote stream
final remoteSteamStatusProvider =
    StateNotifierProvider<StreamStatusNotifier, StreamStatus>(
  (ref) => StreamStatusNotifier(ref),
);

class DeviceEnumerationView extends ConsumerStatefulWidget {
  const DeviceEnumerationView({Key? key}) : super(key: key);

  @override
  DeviceEnumerationViewState createState() => DeviceEnumerationViewState();
}

class DeviceEnumerationViewState extends ConsumerState<DeviceEnumerationView> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  RTCPeerConnection? pc1;
  RTCPeerConnection? pc2;
  var senders = <RTCRtpSender>[];

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _start() async {
    var callResult = await ref.read(steamStatusProvider.notifier).makeCall();
    if (callResult == Result.failure) {
      return;
    }
    await initPCs();

    final localStream = ref.read(steamStatusProvider).localStream;
    localStream?.getTracks().forEach((track) async {
      var rtpSender = await pc1?.addTrack(track, localStream);
      print('track.settings ' + track.getSettings().toString());
      senders.add(rtpSender!);
    });

    await _negotiate();
  }

  Future<void> _negotiate() async {
    var offer = await pc1?.createOffer();
    await pc1?.setLocalDescription(offer!);
    await pc2?.setRemoteDescription(offer!);
    var answer = await pc2?.createAnswer();
    await pc2?.setLocalDescription(answer!);
    await pc1?.setRemoteDescription(answer!);
  }

  Future<void> initPCs() async {
    pc2 ??= await createPeerConnection({});
    pc1 ??= await createPeerConnection({});

    pc2?.onTrack = (event) {
      if (event.track.kind == 'video') {
        _remoteRenderer.srcObject = event.streams[0];
        setState(() {});
      }
    };

    pc2?.onConnectionState = (state) {
      print('connectionState $state');
    };

    pc2?.onIceConnectionState = (state) {
      print('iceConnectionState $state');
    };

    await pc2?.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly));
    await pc2?.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly));

    pc1!.onIceCandidate = (candidate) => pc2!.addCandidate(candidate);
    pc2!.onIceCandidate = (candidate) => pc1!.addCandidate(candidate);
  }

  void _hangup() async {
    ref.read(steamStatusProvider.notifier).hangUp();
  }

  @override
  Widget build(BuildContext context) {
    final isCalling = ref.watch(steamStatusProvider).isCalling;
    final stream = ref.watch(steamStatusProvider).localStream;
    if (stream != null) {
      _localRenderer.srcObject = stream;
    } else if (_localRenderer.srcObject != null) {
      _localRenderer.srcObject = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('DeviceEnumerationView'),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.black54),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: const BoxDecoration(color: Colors.black54),
                    child: RTCVideoView(_localRenderer),
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: RTCVideoView(_remoteRenderer),
                )),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => isCalling ? _hangup() : _start(),
        tooltip: isCalling ? 'Hangup' : 'Call',
        child: Icon(isCalling ? Icons.call_end : Icons.phone),
      ),
    );
  }
}
