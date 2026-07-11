import 'package:equatable/equatable.dart';
import '../../../domain/entities/app_settings.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
  @override List<Object?> get props => [];
}

final class SettingsInitial extends SettingsState { const SettingsInitial(); }
final class SettingsLoading extends SettingsState { const SettingsLoading(); }
final class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  const SettingsLoaded(this.settings);
  @override List<Object?> get props => [settings];
}
final class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
  @override List<Object?> get props => [message];
}
final class SettingsSaved extends SettingsState {
  final AppSettings settings;
  const SettingsSaved(this.settings);
  @override List<Object?> get props => [settings];
}
