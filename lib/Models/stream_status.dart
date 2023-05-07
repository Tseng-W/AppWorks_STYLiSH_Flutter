import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'logger.dart';

enum Result { success, failure }

// class ResultModel<T> {
//   ResultModel({this.result, required this.model});
//   Result? result;
//   T model;
// }

final steamStatusProvider =
    StateNotifierProvider<StreamStatusNotifier, StreamStatus>(
  (ref) => StreamStatusNotifier(ref),
);

class StreamStatusNotifier extends StateNotifier<StreamStatus> {
  StreamStatusNotifier(this.ref) : super(StreamStatus());
  final Ref ref;

  Future<Result> makeCall() async {
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
      return Result.success;
    } catch (e) {
      ref.read(loggerProvider).e(e.toString());
      return Result.failure;
    }
  }

  Future<Result> hangUp() async {
    try {
      await state.localStream?.dispose();
      state = StreamStatus(localStream: null);
      ref.read(loggerProvider).i('hangUp success');
      return Result.success;
    } catch (e) {
      ref.read(loggerProvider).e(e.toString());
      return Result.failure;
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
