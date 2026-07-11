import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/audio_constants.dart';
import '../../../core/errors/exceptions.dart';

class MicrophoneDataSource {
  final AudioRecorder _recorder = AudioRecorder();
  final StreamController<List<int>> _controller = StreamController<List<int>>.broadcast();
  StreamSubscription<Uint8List>? _recordSub;
  int _refCount = 0;
  bool _isActive = false;

  bool get isActive => _isActive;

  Stream<List<int>> get stream => _controller.stream;

  Future<void> start() async {
    _refCount++;
    if (_isActive) return;

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      _refCount--;
      throw const PermissionException('Microphone permission denied');
    }

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
        if (!_controller.isClosed) {
          _controller.add(chunk);
        }
      },
      onError: (Object error) {
        if (!_controller.isClosed) {
          _controller.addError(AudioException('Microphone stream error: $error'));
        }
      },
    );

    _isActive = true;
  }

  Future<void> stop() async {
    if (_refCount > 0) _refCount--;
    if (_refCount > 0) return;

    _isActive = false;
    await _recordSub?.cancel();
    _recordSub = null;
    await _recorder.stop();
  }

  Future<void> dispose() async {
    _refCount = 0;
    await stop();
    await _controller.close();
    _recorder.dispose();
  }
}
