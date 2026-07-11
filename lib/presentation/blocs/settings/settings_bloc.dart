import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/load_settings.dart';
import '../../../domain/usecases/save_settings.dart';
import '../../../domain/entities/app_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LoadSettings _loadSettings;
  final SaveSettings _saveSettings;

  SettingsBloc(this._loadSettings, this._saveSettings)
      : super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoad);
    on<UpdateSettingsEvent>(_onUpdate);
    on<ResetSettingsEvent>(_onReset);
  }

  Future<void> _onLoad(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(const SettingsLoading());
    final result = await _loadSettings();
    result.fold(
      (f) => emit(SettingsError(f.message)),
      (s) => emit(SettingsLoaded(s)),
    );
  }

  Future<void> _onUpdate(UpdateSettingsEvent event, Emitter<SettingsState> emit) async {
    final result = await _saveSettings(event.settings);
    result.fold(
      (f) => emit(SettingsError(f.message)),
      (_) => emit(SettingsSaved(event.settings)),
    );
  }

  Future<void> _onReset(ResetSettingsEvent event, Emitter<SettingsState> emit) async {
    final result = await _saveSettings(AppSettings.defaults);
    result.fold(
      (f) => emit(SettingsError(f.message)),
      (_) => emit(SettingsSaved(AppSettings.defaults)),
    );
  }
}
