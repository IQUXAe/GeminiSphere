import 'package:freezed_annotation/freezed_annotation.dart';
part 'conversation_session.freezed.dart';

enum SessionStatus { idle, listening, processing, speaking, error }

@freezed
class ConversationSession with _$ConversationSession {
  const factory ConversationSession({
    required String id,
    required DateTime startedAt,
    @Default(SessionStatus.idle) SessionStatus status,
    DateTime? endedAt,
    @Default([]) List<String> audioChunkIds,
  }) = _ConversationSession;

  const ConversationSession._();

  bool get isActive => endedAt == null;
}
