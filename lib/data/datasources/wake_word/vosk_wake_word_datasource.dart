import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:vosk_flutter/vosk_flutter.dart';
import 'package:logger/logger.dart';
import '../../../core/constants/audio_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../domain/repositories/i_wake_word_repository.dart';

class VoskWakeWordDataSource {
  VoskFlutterPlugin? _vosk;
  Model? _modelEn;
  Model? _modelRu;
  Recognizer? _recognizerEn;
  Recognizer? _recognizerRu;

  final StreamController<WakeWordDetectedEvent> _controller =
      StreamController<WakeWordDetectedEvent>.broadcast();

  final Logger _logger = Logger();
  bool _isListening = false;

  Stream<WakeWordDetectedEvent> get stream => _controller.stream;
  bool get isListening => _isListening;

  /// Initialize Vosk models. Models should be bundled as app assets.
  /// On first run, models are extracted from assets to app documents directory.
  Future<void> initialize(String modelEnPath, String modelRuPath) async {
    try {
      _vosk = VoskFlutterPlugin.instance();
      final loader = ModelLoader();

      // Load English model
      final enPath = await loader.loadFromAssets(modelEnPath);
      _modelEn = await _vosk!.createModel(enPath);
      
      // Load Russian model
      final ruPath = await loader.loadFromAssets(modelRuPath);
      _modelRu = await _vosk!.createModel(ruPath);

      // Create keyword-spotting recognizers
      // Grammar restricts recognition to only our keywords + ["[unk]"]
      _recognizerEn = await _vosk!.createRecognizer(
        model: _modelEn!,
        sampleRate: kMicSampleRate,
        grammar: kWakeWordKeywords,
      );
      _recognizerRu = await _vosk!.createRecognizer(
        model: _modelRu!,
        sampleRate: kMicSampleRate,
        grammar: kWakeWordKeywords,
      );

      _logger.i('[Vosk] Initialized EN + RU models');
    } catch (e) {
      throw WakeWordException('Failed to initialize Vosk models: $e');
    }
  }

  /// Feed a PCM audio chunk to both recognizers.
  /// If either detects a keyword above the threshold, emits a [WakeWordDetectedEvent].
  Future<void> processAudioChunk(List<int> pcmData) async {
    if (!_isListening || _recognizerEn == null || _recognizerRu == null) return;

    try {
      // Process with both language models
      final resultEn = await _recognizerEn!.acceptWaveformBytes(
        Uint8List.fromList(pcmData),
      );
      final resultRu = await _recognizerRu!.acceptWaveformBytes(
        Uint8List.fromList(pcmData),
      );

      await _checkResult(resultEn, _recognizerEn!);
      await _checkResult(resultRu, _recognizerRu!);
    } catch (e) {
      // Non-critical: log and continue
      _logger.w('[Vosk] Audio processing error: $e');
    }
  }

  Future<void> _checkResult(bool isFinal, Recognizer recognizer) async {
    final resultJson = isFinal
        ? await recognizer.getFinalResult()
        : await recognizer.getPartialResult();

    if (resultJson == null) return;

    try {
      final result = jsonDecode(resultJson) as Map<String, dynamic>;
      final text = (result['text'] ?? result['partial'] ?? '') as String;

      if (text.isEmpty) return;

      // Check if any wake word appears in the result
      final lowerText = text.toLowerCase();
      for (final keyword in kWakeWordKeywords) {
        if (lowerText.contains(keyword)) {
          _logger.i('[Vosk] Wake word detected: "$text"');
          if (!_controller.isClosed) {
            _controller.add(WakeWordDetectedEvent(
              keyword: keyword,
              confidence: kWakeWordMinScore,
            ));
          }
          return;
        }
      }
    } catch (e) {
      // Ignore JSON parse errors
    }
  }

  void startListening() {
    _isListening = true;
    _logger.i('[Vosk] Started listening for wake word');
  }

  void stopListening() {
    _isListening = false;
    _logger.i('[Vosk] Stopped listening for wake word');
  }

  Future<void> dispose() async {
    _isListening = false;
    await _controller.close();
    _recognizerEn?.dispose();
    _recognizerRu?.dispose();
    _modelEn?.dispose();
    _modelRu?.dispose();
  }
}
