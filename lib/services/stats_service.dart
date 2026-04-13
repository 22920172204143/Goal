import '../models/app_stats.dart';
import '../models/income_record.dart';

class StatsService {
  AppStats calculate({
    required List<IncomeRecord> records,
    required double dailyGoal,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final startOfToday = DateTime(current.year, current.month, current.day);
    final startOfWeek = startOfToday.subtract(Duration(days: current.weekday - 1));
    final startOfMonth = DateTime(current.year, current.month);

    double todayIncome = 0;
    double weekIncome = 0;
    double monthIncome = 0;
    double totalIncome = 0;

    for (final record in records) {
      totalIncome += record.amount;
      if (!record.createdAt.isBefore(startOfMonth)) {
        monthIncome += record.amount;
      }
      if (!record.createdAt.isBefore(startOfWeek)) {
        weekIncome += record.amount;
      }
      if (!record.createdAt.isBefore(startOfToday)) {
        todayIncome += record.amount;
      }
    }

    final goalProgress = dailyGoal <= 0
        ? 0.0
        : (todayIncome / dailyGoal).clamp(0, 1.6).toDouble();
    final remaining = dailyGoal <= 0
        ? 0.0
        : (dailyGoal - todayIncome).clamp(0, dailyGoal).toDouble();

    return AppStats(
      todayIncome: todayIncome,
      weekIncome: weekIncome,
      monthIncome: monthIncome,
      totalIncome: totalIncome,
      streakDays: _calculateStreak(records, current),
      recordCount: records.length,
      goalProgress: goalProgress,
      remainingToGoal: remaining,
    );
  }

  int _calculateStreak(List<IncomeRecord> records, DateTime now) {
    final days = <DateTime>{};
    for (final record in records) {
      days.add(DateTime(record.createdAt.year, record.createdAt.month, record.createdAt.day));
    }

    var streak = 0;
    var cursor = DateTime(now.year, now.month, now.day);
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
