class UserScriptModel {
  final String name;
  final String script;
  bool enabled;

  UserScriptModel({
    required this.name,
    required this.script,
    this.enabled = true,
  });

  factory UserScriptModel.fromStorage(String storageString) {
    final parts = storageString.split('|||');
    return UserScriptModel(
      name: parts[0],
      script: parts[1],
      enabled: parts[2] == 'true',
    );
  }

  String toStorage() {
    return '$name|||$script|||$enabled';
  }
}
