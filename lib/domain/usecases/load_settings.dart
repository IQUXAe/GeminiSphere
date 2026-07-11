import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/app_settings.dart';
import '../repositories/i_settings_repository.dart';
import '../../core/errors/failures.dart';

@injectable
class LoadSettings {
  final ISettingsRepository _repository;
  const LoadSettings(this._repository);
  Future<Either<Failure, AppSettings>> call() => _repository.loadSettings();
}
