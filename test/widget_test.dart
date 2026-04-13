import 'package:flutter_test/flutter_test.dart';
import 'package:small_goal_app/models/app_stats.dart';
import 'package:small_goal_app/models/income_record.dart';
import 'package:small_goal_app/models/room_visual_state.dart';
import 'package:small_goal_app/services/room_state_service.dart';
import 'package:small_goal_app/services/stats_service.dart';

void main() {
  test('stats and room state react to income growth', () {
    final statsService = StatsService();
    final roomStateService = RoomStateService();
    final now = DateTime(2026, 4, 11, 10, 30);
    final records = <IncomeRecord>[
      IncomeRecord(
        id: '1',
        amount: 120,
        category: '工资',
        note: '上午结算',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      IncomeRecord(
        id: '2',
        amount: 880,
        category: '接单',
        note: '做页面',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      IncomeRecord(
        id: '3',
        amount: 2400,
        category: '副业',
        note: '项目尾款',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    final stats = statsService.calculate(
      records: records,
      dailyGoal: 300,
      now: now,
    );

    expect(stats, isA<AppStats>());
    expect(stats.todayIncome, 120);
    expect(stats.totalIncome, 3400);
    expect(stats.streakDays, 3);

    final roomState = roomStateService.build(
      stats: stats,
      records: records,
      dailyGoal: 300,
      animationNonce: 1,
      lastCelebrationAt: now,
      now: now,
    );

    expect(roomState, isA<RoomVisualState>());
    expect(roomState.avatarState, AvatarState.celebrate);
    expect(roomState.roomUpgradeLevel, greaterThanOrEqualTo(2));
    expect(roomState.cabinetStackCount, greaterThan(0));
    expect(roomState.statusMessage, contains('搬钱'));
  });
}
