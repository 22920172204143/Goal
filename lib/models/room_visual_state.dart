enum AvatarState {
  work,
  read,
  phone,
  idle,
  sleep,
  celebrate,
}

class RoomVisualState {
  const RoomVisualState({
    required this.moneyTier,
    required this.deskStackCount,
    required this.cabinetStackCount,
    required this.floorCashCount,
    required this.roomUpgradeLevel,
    required this.avatarState,
    required this.goalProgress,
    required this.statusMessage,
    required this.animationNonce,
  });

  final int moneyTier;
  final int deskStackCount;
  final int cabinetStackCount;
  final int floorCashCount;
  final int roomUpgradeLevel;
  final AvatarState avatarState;
  final double goalProgress;
  final String statusMessage;
  final int animationNonce;

  factory RoomVisualState.initial() {
    return const RoomVisualState(
      moneyTier: 0,
      deskStackCount: 0,
      cabinetStackCount: 0,
      floorCashCount: 0,
      roomUpgradeLevel: 0,
      avatarState: AvatarState.idle,
      goalProgress: 0,
      statusMessage: '先记下第一笔收入，让房间开始变富。',
      animationNonce: 0,
    );
  }
}
