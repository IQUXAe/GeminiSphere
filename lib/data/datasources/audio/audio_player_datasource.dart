import 'dart:async';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import '../../../core/constants/audio_constants.dart';
import '../../../core/errors/exceptions.dart';

/// A custom [StreamAudioSource] that accepts PCM audio chunks
/// and streams them to just_audio for playback.
class PcmStreamAudioSource extends StreamAudioSource {
  final StreamController<List<int>> _controller = StreamController<List<int>>();

  // WAV header prefix for PCM data
  static final Uint8List _wavHeader = _buildWavHeader();
  bool _headerSent = false;

  PcmStreamAudioSource() : super(tag: 'GeminiAudio');

  void addChunk(List<int> pcmData) {
    if (!_controller.isClosed) {
      if (!_headerSent) {
        _controller.add(_wavHeader);
        _headerSent = true;
      }
      _controller.add(pcmData);
    }
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: start ?? 0,
      stream: _controller.stream.map((data) => Uint8List.fromList(data)),
      contentType: 'audio/wav',
    );
  }

  Future<void> close() async {
    await _controller.close();
  }

  static Uint8List _buildWavHeader() {
    // Minimal WAV header for 24kHz 16-bit mono PCM stream
    // Since we don't know the length upfront, we use 0xFFFFFFFF
    final header = ByteData(44);
    // RIFF header
    header.setUint32(0, 0x52494646, Endian.big); // "RIFF"
    header.setUint32(4, 0xFFFFFFFF, Endian.little); // File size (unknown)
    header.setUint32(8, 0x57415645, Endian.big); // "WAVE"
    // fmt chunk
    header.setUint32(12, 0x666D7420, Endian.big); // "fmt "
    header.setUint32(16, 16, Endian.little); // Chunk size
    header.setUint16(20, 1, Endian.little); // PCM format
    header.setUint16(22, kGeminiOutputChannels, Endian.little); // Channels
    header.setUint32(24, kGeminiOutputSampleRate, Endian.little); // Sample rate
    header.setUint32(
      28,
      kGeminiOutputSampleRate * kGeminiOutputChannels * (kGeminiOutputBitDepth ~/ 8),
      Endian.little,
    ); // Byte rate
    header.setUint16(
      32,
      kGeminiOutputChannels * (kGeminiOutputBitDepth ~/ 8),
      Endian.little,
    ); // Block align
    header.setUint16(34, kGeminiOutputBitDepth, Endian.little); // Bits per sample
    // data chunk
    header.setUint32(36, 0x64617461, Endian.big); // "data"
    header.setUint32(40, 0xFFFFFFFF, Endian.little); // Data size (unknown)
    return header.buffer.asUint8List();
  }
}

class AudioPlayerDataSource {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _silencePlayer = AudioPlayer();
  PcmStreamAudioSource? _audioSource;
  double _volume = 1.0;
  bool _isPlaying = false;
  bool _silenceLooping = false;

  bool get isPlaying => _isPlaying;

  Future<void> initialize() async {
    _player.playingStream.listen((playing) {
      _isPlaying = playing;
    });
  }

  Future<void> feedChunk(List<int> pcmData) async {
    if (_audioSource == null) {
      _audioSource = PcmStreamAudioSource();
      try {
        await _player.setAudioSource(_audioSource!);
        await _player.play();
        _isPlaying = true;
      } catch (e) {
        throw AudioException('Failed to start audio playback: $e');
      }
    }
    _audioSource!.addChunk(pcmData);
  }

  Future<void> stopPlayback() async {
    await _player.stop();
    await _audioSource?.close();
    _audioSource = null;
    _isPlaying = false;
  }

  Future<void> duckVolume() async {
    _volume = kAlarmDuckVolume;
    await _player.setVolume(_volume);
  }

  Future<void> restoreVolume() async {
    _volume = 1.0;
    await _player.setVolume(_volume);
  }

  Future<void> startSilenceLoop(String assetPath) async {
    if (_silenceLooping) return;
    try {
      await _silencePlayer.setAsset(assetPath);
      await _silencePlayer.setLoopMode(LoopMode.one);
      await _silencePlayer.setVolume(0.0);
      await _silencePlayer.play();
      _silenceLooping = true;
    } catch (e) {
      // Non-critical: silence loop failure doesn't break the app
    }
  }

  Future<void> stopSilenceLoop() async {
    await _silencePlayer.stop();
    _silenceLooping = false;
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _silencePlayer.dispose();
    await _audioSource?.close();
  }
}
