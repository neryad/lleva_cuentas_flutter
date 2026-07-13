import 'package:upgrader/upgrader.dart';

class CustomUpgraderMessages extends UpgraderMessages {
  CustomUpgraderMessages({String? code}) : super(code: code);

  @override
  String get title => 'Actualización Disponible';

  @override
  String get body =>
      'Una nueva versión de {{appName}} está lista.\n\n'
      'Actual: {{currentInstalledVersion}}\n'
      'Nueva: {{currentAppStoreVersion}}';

  @override
  String get buttonTitleUpdate => 'Actualizar';

  @override
  String get buttonTitleLater => 'Después';
}
