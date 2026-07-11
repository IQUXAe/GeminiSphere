import 'package:equatable/equatable.dart';
import '../../../domain/entities/app_settings.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

final class LoadSettingsEvent extends SettingsEvent { const LoadSettingsEvent(); }
final class UpdateSettingsEvent extends SettingsEvent {
  final AppSettings settings;
  const UpdateSettingsEvent(this.settings);
  @override List<Object?> get props => [settings];
}
final class ResetSettingsEvent extends SettingsEvent { const ResetSettingsEvent(); }
