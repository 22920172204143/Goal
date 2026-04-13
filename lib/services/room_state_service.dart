import '../models/app_stats.dart';
import '../models/income_record.dart';
import '../models/room_visual_state.dart';

class RoomStateService {
  RoomVisualState build({
    required AppStats stats,
    required List<IncomeRecord> records,
    required double dailyGoal,
    required int animationNonce,
    required DateTime? lastCelebrationAt,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final total = stats.totalIncome;
    final today = stats.todayIncome;

    final moneyTier = _moneyTier(total);
    final deskStacks = _deskStacks(total);
    final cabinetStacks = _cabinetStacks(total);
    final floorStacks = _floorStacks(total);
    final roomUpgradeLevel = _roomLevel(total);
    final avatarState = _avatarState(
      now: current,
      stats: stats,
      records: records,
      lastCelebrationAt: lastCelebrationAt,
      dailyGoal: dailyGoal,
    );

    return RoomVisualState(
      moneyTier: moneyTier,
      deskStackCount: deskStacks,
      cabinetStackCount: cabinetStacks,
      floorCashCount: floorStacks,
      roomUpgradeLevel: roomUpgradeLevel,
      avatarState: avatarState,
      goalProgress: stats.goalProgress,
      statusMessage: _statusMessage(
        todayIncome: today,
        dailyGoal: dailyGoal,
        avatarState: avatarState,
        roomUpgradeLevel: roomUpgradeLevel,
      ),
      animationNonce: animationNonce,
    );
  }

  int _moneyTier(double totalIncome) {
    if (totalIncome >= 5000) {
      return 4;
    }
    if (totalIncome >= 2000) {
      return 3;
    }
    if (totalIncome >= 800) {
      return 2;
    }
    if (totalIncome >= 200) {
      return 1;
    }
    return 0;
  }

  int _deskStacks(double totalIncome) {
    return switch (_moneyTier(totalIncome)) {
      4 => 8,
      3 => 6,
      2 => 4,
      1 => 2,
      _ => totalIncome > 0 ? 1 : 0,
    };
  }

  int _cabinetStacks(double totalIncome) {
    if (totalIncome >= 5000) {
      return 9;
    }
    if (totalIncome >= 3000) {
      return 6;
    }
    if (totalIncome >= 1200) {
      return 3;
    }
    return 0;
  }

  int _floorStacks(double totalIncome) {
    if (totalIncome >= 8000) {
      return 5;
    }
    if (totalIncome >= 5000) {
      return 3;
    }
    if (totalIncome >= 2500) {
      return 1;
    }
    return 0;
  }

  int _roomLevel(double totalIncome) {
    if (totalIncome >= 10000) {
      return 3;
    }
    if (totalIncome >= 3000) {
      return 2;
    }
    if (totalIncome >= 800) {
      return 1;
    }
    return 0;
  }

  AvatarState _avatarState({
    required DateTime now,
    required AppStats stats,
    required List<IncomeRecord> records,
    required DateTime? lastCelebrationAt,
    required double dailyGoal,
  }) {
    if (lastCelebrationAt != null &&
        now.difference(lastCelebrationAt).inSeconds < 8) {
      return AvatarState.celebrate;
    }
    if (now.hour >= 23 || now.hour < 6) {
      return AvatarState.sleep;
    }
    if (dailyGoal > 0 && stats.todayIncome < dailyGoal * 0.6) {
      return AvatarState.work;
    }

    final cycle = (now.minute ~/ 6 + records.length) % 4;
    return switch (cycle) {
      0 => AvatarState.read,
      1 => AvatarState.phone,
      2 => AvatarState.idle,
      _ => AvatarState.work,
    };
  }

  String _statusMessage({
    required double todayIncome,
    required double dailyGoal,
    required AvatarState avatarState,
    required int roomUpgradeLevel,
  }) {
    final progressText = dailyGoal <= 0
        ? '今天先随手记一笔。'
        : todayIncome >= dailyGoal
            ? '今天的小目标已经达成。'
            : '距离今日目标还差 ${(dailyGoal - todayIncome).clamp(0, dailyGoal).toStringAsFixed(0)}。';

    final stateText = switch (avatarState) {
      AvatarState.work => '小人正在努力干活。',
      AvatarState.read => '小人正在看书提升自己。',
      AvatarState.phone => '小人正在短暂刷手机放松。',
      AvatarState.sleep => '小人已经睡下了。',
      AvatarState.celebrate => '新收入到账，小人正在搬钱入柜。',
      AvatarState.idle => '小人正在房间里闲逛。',
    };

    final roomText = switch (roomUpgradeLevel) {
      3 => '房间已经有了明显的富足感。',
      2 => '储物柜和地面都开始堆出现金。',
      1 => '桌面开始慢慢堆起收入反馈。',
      _ => '房间还很朴素，等你继续把钱攒起来。',
    };

    return '$stateText $progressText $roomText';
  }
}
