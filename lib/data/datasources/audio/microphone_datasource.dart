import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/audio_constants.dart';
import '../../../core/errors/exceptions.dart';

class MicrophoneDataSource {
  final AudioRecorder _recorder = AudioRecorder();
  StreamController<List<int>>? _controller;
  StreamSubscription<Uint8List>? _recordSub;
  bool _isActive = false;

  bool get isActive => _isActive;

  Stream<List<int>>? get stream => _controller?.stream;

  Future<void> start() async {
    // Check and request mic permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw const PermissionException('Microphone permission denied');
    }

    if (_isActive) await stop();

    _controller = StreamController<List<int>>.broadcast();

    final recordStream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: kMicSampleRate,
        numChannels: kMicChannels,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
      ),
    );

    _recordSub = recordStream.listen(
      (chunk) {
        if (!(_controller?.isClosed ?? true)) {
          _controller!.add(chunk);
        }
      },
      onError: (Object error) {
        _controller?.addError(AudioException('Microphone stream error: $error'));
      },
    );

    _isActive = true;
  }

  Future<void> stop() async {
    _isActive = false;
    await _recordSub?.cancel();
    _recordSub = null;
    await _recorder.stop();
    await _controller?.close();
    _controller = null;
  }

  Future<void> dispose() async {
    await stop();
    _recorder.dispose();
  }
}
