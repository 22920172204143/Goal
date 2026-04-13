import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';

import '../models/app_settings.dart';
import '../models/app_stats.dart';
import '../models/room_visual_state.dart';

class SmallGoalRoomGame extends FlameGame {
  static const _worldWidth = 320.0;
  static const _worldHeight = 220.0;

  final TextPaint _labelPaint = TextPaint(
    style: const TextStyle(
      color: Color(0xFFF9F5E7),
      fontSize: 10,
      fontWeight: FontWeight.w700,
    ),
  );

  RoomVisualState _roomState = RoomVisualState.initial();
  AppStats _stats = AppStats.empty();
  AppSettings _settings = AppSettings.defaults();
  int _seenAnimationNonce = 0;
  double _elapsed = 0;
  final List<_FloatingMoney> _floatingMoney = <_FloatingMoney>[];

  void applySnapshot({
    required RoomVisualState roomState,
    required AppStats stats,
    required AppSettings settings,
  }) {
    _roomState = roomState;
    _stats = stats;
    _settings = settings;

    if (roomState.animationNonce != _seenAnimationNonce) {
      _seenAnimationNonce = roomState.animationNonce;
      _spawnMoneyBurst();
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF0B1320);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    for (final effect in _floatingMoney) {
      effect.progress += dt / effect.duration;
    }
    _floatingMoney.removeWhere((effect) => effect.progress >= 1);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final scale = math.min(size.x / _worldWidth, size.y / _worldHeight);
    final dx = (size.x - _worldWidth * scale) / 2;
    final dy = (size.y - _worldHeight * scale) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    _drawWalls(canvas);
    _drawWindow(canvas);
    _drawFloor(canvas);
    _drawFurniture(canvas);
    _drawMoney(canvas);
    _drawAvatar(canvas);
    _drawGoalLamp(canvas);
    _drawFloatingMoney(canvas);
    _drawSceneLabels(canvas);

    canvas.restore();
  }

  void _drawWalls(Canvas canvas) {
    _fillRect(canvas, 0, 0, _worldWidth, 90, const Color(0xFF203145));
    _fillRect(canvas, 0, 0, _worldWidth, 8, const Color(0xFF2E4968));
    _fillRect(canvas, 0, 82, _worldWidth, 8, const Color(0xFF172536));
  }

  void _drawWindow(Canvas canvas) {
    _fillRect(canvas, 24, 18, 62, 42, const Color(0xFF4B7CB0));
    _fillRect(canvas, 30, 24, 50, 30, const Color(0xFFA4D8FF));
    _fillRect(canvas, 53, 24, 4, 30, const Color(0xFF4B7CB0));
    _fillRect(canvas, 30, 37, 50, 4, const Color(0xFF4B7CB0));
    _fillRect(canvas, 18, 14, 74, 6, const Color(0xFFDFBE74));
  }

  void _drawFloor(Canvas canvas) {
    final floorColor = switch (_roomState.roomUpgradeLevel) {
      3 => const Color(0xFF81613A),
      2 => const Color(0xFF74573B),
      1 => const Color(0xFF6A5038),
      _ => const Color(0xFF5B4632),
    };
    _fillRect(canvas, 0, 90, _worldWidth, 130, floorColor);

    for (var x = 0.0; x < _worldWidth; x += 32) {
      _fillRect(canvas, x, 90, 2, 130, const Color(0xFF4B3A28));
    }
    for (var y = 90.0; y < _worldHeight; y += 22) {
      _fillRect(canvas, 0, y, _worldWidth, 2, const Color(0xFF4B3A28));
    }

    _fillRect(canvas, 128, 132, 72, 42, const Color(0xFF395064));
    _fillRect(canvas, 134, 138, 60, 30, const Color(0xFF49708C));
  }

  void _drawFurniture(Canvas canvas) {
    _drawBed(canvas);
    _drawDesk(canvas);
    _drawCabinet(canvas);
    _drawShelf(canvas);
    _drawPlant(canvas);
  }

  void _drawBed(Canvas canvas) {
    _fillRect(canvas, 26, 138, 84, 42, const Color(0xFF7D5A4C));
    _fillRect(canvas, 32, 144, 72, 30, const Color(0xFFE0D8D2));
    _fillRect(canvas, 32, 144, 24, 12, const Color(0xFFA7D3F2));
    if (_roomState.roomUpgradeLevel >= 2) {
      _fillRect(canvas, 86, 150, 10, 18, const Color(0xFFD6B264));
    }
  }

  void _drawDesk(Canvas canvas) {
    _fillRect(canvas, 198, 132, 80, 16, const Color(0xFF8E653F));
    _fillRect(canvas, 204, 148, 6, 26, const Color(0xFF65452B));
    _fillRect(canvas, 266, 148, 6, 26, const Color(0xFF65452B));
    _fillRect(canvas, 216, 118, 28, 14, const Color(0xFF2C313A));
    _fillRect(canvas, 220, 122, 20, 10, const Color(0xFF79D6D6));
    _fillRect(canvas, 220, 148, 22, 18, const Color(0xFF4D6787));
  }

  void _drawCabinet(Canvas canvas) {
    final bodyColor = switch (_roomState.roomUpgradeLevel) {
      3 => const Color(0xFF8A663D),
      2 => const Color(0xFF74522D),
      _ => const Color(0xFF654728),
    };
    _fillRect(canvas, 242, 76, 54, 48, bodyColor);
    _fillRect(canvas, 246, 80, 20, 18, const Color(0xFF9A7548));
    _fillRect(canvas, 272, 80, 20, 18, const Color(0xFF9A7548));
    _fillRect(canvas, 246, 102, 20, 18, const Color(0xFF9A7548));
    _fillRect(canvas, 272, 102, 20, 18, const Color(0xFF9A7548));
  }

  void _drawShelf(Canvas canvas) {
    _fillRect(canvas, 116, 44, 52, 8, const Color(0xFF8E653F));
    _fillRect(canvas, 118, 28, 12, 16, const Color(0xFF7EC37A));
    _fillRect(canvas, 132, 22, 10, 22, const Color(0xFFEA8C6A));
    _fillRect(canvas, 144, 26, 12, 18, const Color(0xFF7AB6F1));
  }

  void _drawPlant(Canvas canvas) {
    _fillRect(canvas, 176, 56, 12, 18, const Color(0xFF7D5A4C));
    _fillRect(canvas, 172, 46, 20, 12, const Color(0xFF5FAE64));
    _fillRect(canvas, 168, 38, 10, 14, const Color(0xFF77C56F));
    _fillRect(canvas, 186, 38, 10, 14, const Color(0xFF77C56F));
  }

  void _drawMoney(Canvas canvas) {
    for (var index = 0; index < _roomState.deskStackCount; index++) {
      final column = index % 4;
      final row = index ~/ 4;
      _drawMoneyStack(canvas, 205 + column * 14, 124 - row * 6, 1);
    }

    for (var index = 0; index < _roomState.cabinetStackCount; index++) {
      final column = index % 3;
      final row = index ~/ 3;
      _drawMoneyStack(canvas, 248 + column * 15, 114 - row * 8, 2);
    }

    for (var index = 0; index < _roomState.floorCashCount; index++) {
      _drawMoneyStack(canvas, 215 + index * 18, 178, 2);
    }
  }

  void _drawMoneyStack(Canvas canvas, double x, double y, int height) {
    for (var level = 0; level < height; level++) {
      _fillRect(canvas, x, y - level * 4, 12, 6, const Color(0xFF67E391));
      _fillRect(canvas, x + 2, y + 1 - level * 4, 8, 2, const Color(0xFFB5F9CB));
      _fillRect(canvas, x + 4, y - 1 - level * 4, 4, 6, const Color(0xFF2DA15C));
    }
  }

  void _drawAvatar(Canvas canvas) {
    final bob = math.sin(_elapsed * 3.2) * 1.8;
    final step = math.sin(_elapsed * 7) * 1.6;

    double x = 154;
    double y = 150;

    switch (_roomState.avatarState) {
      case AvatarState.work:
        x = 228;
        y = 150 + step * 0.3;
      case AvatarState.read:
        x = 146;
        y = 148 + bob * 0.5;
      case AvatarState.phone:
        x = 80;
        y = 158 + bob * 0.4;
      case AvatarState.idle:
        x = 154 + math.sin(_elapsed * 1.3) * 18;
        y = 154 + bob * 0.5;
      case AvatarState.sleep:
        x = 70;
        y = 157;
      case AvatarState.celebrate:
        x = 190;
        y = 146 - (math.sin(_elapsed * 11).abs() * 8);
    }

    final bodyColor = switch (_roomState.avatarState) {
      AvatarState.sleep => const Color(0xFF7997FF),
      AvatarState.phone => const Color(0xFFFFA364),
      AvatarState.read => const Color(0xFF68C887),
      AvatarState.celebrate => const Color(0xFFF2C96B),
      _ => const Color(0xFFEF7E61),
    };

    if (_roomState.avatarState == AvatarState.sleep) {
      _fillRect(canvas, x, y, 22, 8, bodyColor);
      _fillRect(canvas, x + 3, y - 5, 10, 6, const Color(0xFFF5CBA7));
      _fillRect(canvas, x + 15, y + 1, 8, 3, const Color(0xFFEADFD5));
      _labelPaint.render(
        canvas,
        'Z',
        Vector2(x + 26, y - 10 + math.sin(_elapsed * 2) * 3),
      );
      return;
    }

    _fillRect(canvas, x + 4, y - 14, 8, 8, const Color(0xFFF2C7A6));
    _fillRect(canvas, x + 2, y - 6, 12, 12, bodyColor);
    _fillRect(canvas, x + 3, y + 6, 3, 8, const Color(0xFF3F2D26));
    _fillRect(canvas, x + 10, y + 6, 3, 8, const Color(0xFF3F2D26));

    if (_roomState.avatarState == AvatarState.work) {
      _fillRect(canvas, x - 2, y - 2, 4, 3 + step.abs(), const Color(0xFFF2C7A6));
      _fillRect(canvas, x + 14, y - 2, 5, 4, const Color(0xFFF2C7A6));
    } else if (_roomState.avatarState == AvatarState.read) {
      _fillRect(canvas, x - 1, y - 1, 14, 4, const Color(0xFF79D6D6));
    } else if (_roomState.avatarState == AvatarState.phone) {
      _fillRect(canvas, x + 13, y - 3, 4, 8, const Color(0xFFB0C1DB));
      _fillRect(canvas, x + 15, y - 2, 2, 5, const Color(0xFF203145));
    } else {
      _fillRect(canvas, x - 1, y - 1, 4, 6 + step.abs(), const Color(0xFFF2C7A6));
      _fillRect(canvas, x + 13, y - 1, 4, 5, const Color(0xFFF2C7A6));
    }
  }

  void _drawGoalLamp(Canvas canvas) {
    final isGoalReached = _stats.goalProgress >= 1;
    final lampColor = isGoalReached ? const Color(0xFFF2C96B) : const Color(0xFF5C6E84);
    _fillRect(canvas, 272, 126, 4, 16, const Color(0xFF4F3828));
    _fillRect(canvas, 266, 120, 16, 8, lampColor);
    if (isGoalReached) {
      _fillRect(canvas, 262, 128, 24, 6, const Color(0x44F2C96B));
    }
  }

  void _drawFloatingMoney(Canvas canvas) {
    for (final effect in _floatingMoney) {
      final t = Curves.easeOut.transform(effect.progress.clamp(0, 1));
      final x = lerpDouble(effect.startX, effect.endX, t)!;
      final arc = math.sin(t * math.pi) * 20;
      final y = lerpDouble(effect.startY, effect.endY, t)! - arc;
      _drawMoneyStack(canvas, x, y, 1);
    }
  }

  void _drawSceneLabels(Canvas canvas) {
    _labelPaint.render(canvas, '今日收入 ${_settings.currencySymbol}${_stats.todayIncome.toStringAsFixed(0)}', Vector2(16, 194));
    _labelPaint.render(canvas, '连续 ${_stats.streakDays} 天', Vector2(16, 206));
  }

  void _spawnMoneyBurst() {
    final targetY = _roomState.cabinetStackCount > 0 ? 102 : 126;
    final targetX = _roomState.cabinetStackCount > 0 ? 258 : 216;

    _floatingMoney.addAll(<_FloatingMoney>[
      _FloatingMoney(
        startX: 274,
        startY: 30,
        endX: targetX.toDouble(),
        endY: targetY.toDouble(),
      ),
      _FloatingMoney(
        startX: 284,
        startY: 40,
        endX: targetX + 16,
        endY: targetY + 6,
      ),
    ]);
  }

  void _fillRect(
    Canvas canvas,
    double x,
    double y,
    double width,
    double height,
    Color color,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(x.floorToDouble(), y.floorToDouble(), width, height),
      Paint()
        ..color = color
        ..isAntiAlias = false,
    );
  }
}

class _FloatingMoney {
  _FloatingMoney({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });

  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double duration = 0.9;
  double progress = 0;
}
