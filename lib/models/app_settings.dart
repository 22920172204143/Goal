class AppSettings {
  const AppSettings({
    required this.dailyGoal,
    required this.currencySymbol,
    required this.assetStrategy,
  });

  final double dailyGoal;
  final String currencySymbol;
  final String assetStrategy;

  factory AppSettings.defaults() {
    return const AppSettings(
      dailyGoal: 300,
      currencySymbol: '¥',
      assetStrategy: '开源素材 + 代码动画',
    );
  }

  AppSettings copyWith({
    double? dailyGoal,
    String? currencySymbol,
    String? assetStrategy,
  }) {
    return AppSettings(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      assetStrategy: assetStrategy ?? this.assetStrategy,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dailyGoal': dailyGoal,
      'currencySymbol': currencySymbol,
      'assetStrategy': assetStrategy,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      dailyGoal: (json['dailyGoal'] as num?)?.toDouble() ?? 300,
      currencySymbol: json['currencySymbol'] as String? ?? '¥',
      assetStrategy: json['assetStrategy'] as String? ?? '开源素材 + 代码动画',
    );
  }
}
