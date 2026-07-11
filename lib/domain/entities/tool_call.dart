import 'package:freezed_annotation/freezed_annotation.dart';
part 'tool_call.freezed.dart';

enum ToolCallStatus { pending, executing, completed, failed }

@freezed
class ToolCall with _$ToolCall {
  const factory ToolCall({
    required String id,
    required String name,
    required Map<String, dynamic> args,
    @Default(ToolCallStatus.pending) ToolCallStatus status,
    dynamic result,
    String? errorMessage,
  }) = _ToolCall;
}
