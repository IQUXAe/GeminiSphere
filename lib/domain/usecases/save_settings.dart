import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/app_settings.dart';
import '../repositories/i_settings_repository.dart';
import '../../core/errors/failures.dart';

@injectable
class SaveSettings {
  final ISettingsRepository _repository;
  const SaveSettings(this._repository);
  Future<Either<Failure, void>> call(AppSettings settings) => _repository.saveSettings(settings);
}
