/// Audio capture and playback constants matching Gemini Live API specifications
library;

// Microphone input (required by Gemini Live API)
const int kMicSampleRate = 16000;
const int kMicChannels = 1;
const int kMicBitDepth = 16;
const int kMicChunkMs = 100;
const int kMicChunkSamples = kMicSampleRate * kMicChunkMs ~/ 1000;
const int kMicChunkBytes = kMicChunkSamples * 2;

// Gemini audio output
const int kGeminiOutputSampleRate = 24000;
const int kGeminiOutputChannels = 1;
const int kGeminiOutputBitDepth = 16;

// Vosk wake word detection
const List<String> kWakeWordKeywords = [
  'gemini',
  '\u0434\u0436\u0435\u043c\u0438\u043d\u0438',
  '\u0433\u0435\u043c\u0438\u043d\u0438',
  '\u0434\u0436\u0435\u043c\u0430\u0439\u043d\u0438',
  '\u0433\u0435\u043c\u0430\u0439\u043d\u0438',
  'джемини',
  'гемини',
];
const double kWakeWordMinScore = 0.6;

// Silence file for iOS background mode keepalive
const String kSilenceAudioAsset = 'assets/audio/silence.mp3';

// Alarm / ringtone
const String kAlarmAudioAsset = 'assets/audio/alarm.mp3';

// Audio ducking during alarm
const double kAlarmDuckVolume = 0.1;
const int kAlarmDuckFadeDurationMs = 300;
