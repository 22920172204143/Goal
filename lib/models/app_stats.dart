class AppStats {
  const AppStats({
    required this.todayIncome,
    required this.weekIncome,
    required this.monthIncome,
    required this.totalIncome,
    required this.streakDays,
    required this.recordCount,
    required this.goalProgress,
    required this.remainingToGoal,
  });

  final double todayIncome;
  final double weekIncome;
  final double monthIncome;
  final double totalIncome;
  final int streakDays;
  final int recordCount;
  final double goalProgress;
  final double remainingToGoal;

  factory AppStats.empty() {
    return const AppStats(
      todayIncome: 0,
      weekIncome: 0,
      monthIncome: 0,
      totalIncome: 0,
      streakDays: 0,
      recordCount: 0,
      goalProgress: 0,
      remainingToGoal: 0,
    );
  }
}
