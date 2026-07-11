/// Gemini Live API WebSocket constants
library;

const String kGeminiLiveApiBaseUrl =
    'wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent';
const String kDefaultGeminiModel = 'gemini-2.0-flash-live-001';
const String kGeminiApiKeyParam = 'key';
const int kWebSocketPingIntervalSeconds = 20;
const int kSessionTimeoutSeconds = 300;
const String kResponseModalityAudio = 'AUDIO';
const String kMimeTypeInputAudio = 'audio/pcm;rate=16000';
const String kMimeTypeOutputAudio = 'audio/pcm;rate=24000';
