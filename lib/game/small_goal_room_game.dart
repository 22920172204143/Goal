import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/animation.dart';

import '../models/app_settings.dart';
import '../models/app_stats.dart';
import '../models/room_visual_state.dart';

class SmallGoalRoomGame extends FlameGame {
  static const double _worldWidth = 360;
  static const double _worldHeight = 228;

  final TextPaint _labelPaint = TextPaint(
    style: const TextStyle(
      color: Color(0xFFF9F5E7),
      fontSize: 11,
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
  Color backgroundColor() => const Color(0xFF0A111C);

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

    _drawBackdrop(canvas);
    _drawLeftLibraryZone(canvas);
    _drawCenterLoungeZone(canvas);
    _drawRightBedroomZone(canvas);
    _drawPropsAndDecor(canvas);
    _drawMoney(canvas);
    _drawAvatar(canvas);
    _drawLightOverlays(canvas);
    _drawAmbientParticles(canvas);
    _drawFloatingMoney(canvas);
    _drawSceneLabels(canvas);

    canvas.restore();
  }

  void _drawBackdrop(Canvas canvas) {
    final wallTop = switch (_roomState.roomUpgradeLevel) {
      3 => const Color(0xFF2C3652),
      2 => const Color(0xFF27344D),
      1 => const Color(0xFF243049),
      _ => const Color(0xFF202A41),
    };
    final wallBottom = switch (_roomState.roomUpgradeLevel) {
      3 => const Color(0xFF50546D),
      2 => const Color(0xFF4B4E67),
      1 => const Color(0xFF454962),
      _ => const Color(0xFF40445B),
    };
    final floorBase = switch (_roomState.roomUpgradeLevel) {
      3 => const Color(0xFF6B4C39),
      2 => const Color(0xFF614634),
      1 => const Color(0xFF5A422F),
      _ => const Color(0xFF533C2B),
    };

    _fillRect(canvas, 0, 0, _worldWidth, 104, wallTop);
    _fillRect(canvas, 0, 104, _worldWidth, 36, wallBottom);
    _fillRect(canvas, 0, 140, _worldWidth, _worldHeight - 140, floorBase);

    _fillRect(canvas, 0, 0, _worldWidth, 8, const Color(0xFF1C2238));
    _fillRect(canvas, 0, 8, _worldWidth, 5, const Color(0xFFCFBF95));
    _fillRect(canvas, 0, 98, _worldWidth, 6, const Color(0xFF7B6C57));
    _fillRect(canvas, 0, 104, _worldWidth, 3, const Color(0xFF958977));

    for (var x = 16.0; x < _worldWidth; x += 34) {
      _fillRect(canvas, x, 14, 2, 84, const Color(0x22E8DAB0));
    }
    for (var x = 0.0; x < _worldWidth; x += 30) {
      _fillRect(canvas, x, 140, 2, _worldHeight - 140, const Color(0xFF483224));
    }
    for (var y = 140.0; y < _worldHeight; y += 18) {
      _fillRect(canvas, 0, y, _worldWidth, 2, const Color(0x332E1D14));
    }

    _fillRect(canvas, 110, 18, 76, 54, const Color(0xFFD9CC9D));
    _fillRect(canvas, 114, 22, 68, 46, const Color(0xFF92A6B3));
    _fillRect(canvas, 120, 28, 24, 16, const Color(0xFFC4E3F0));
    _fillRect(canvas, 146, 28, 30, 16, const Color(0xFFA4C7D4));
    _fillRect(canvas, 120, 46, 56, 16, const Color(0xFF6C8C97));
    _fillRect(canvas, 144, 22, 2, 40, const Color(0xFF506978));
    _fillRect(canvas, 114, 44, 68, 2, const Color(0xFF506978));
    _fillRect(canvas, 102, 12, 92, 6, const Color(0xFFC7A765));
    _fillRect(canvas, 96, 10, 12, 2, const Color(0xFFEAD8A4));
    _fillRect(canvas, 182, 10, 12, 2, const Color(0xFFEAD8A4));
    _fillRect(canvas, 106, 18, 8, 48, const Color(0xFF7A5E48));
    _fillRect(canvas, 182, 18, 8, 48, const Color(0xFF7A5E48));
    _fillRect(canvas, 98, 18, 8, 50, const Color(0xFF4B5779));
    _fillRect(canvas, 186, 18, 8, 50, const Color(0xFF4B5779));
    _fillRect(canvas, 96, 68, 12, 4, const Color(0xFF27344D));
    _fillRect(canvas, 184, 68, 12, 4, const Color(0xFF27344D));
    _fillRect(canvas, 102, 18, 6, 38, const Color(0xFF7082A3));
    _fillRect(canvas, 182, 18, 6, 38, const Color(0xFF7082A3));
    _fillRect(canvas, 102, 18, 6, 8, const Color(0xFFD6C18B));
    _fillRect(canvas, 182, 18, 6, 8, const Color(0xFFD6C18B));

    _fillRect(canvas, 74, 12, 22, 36, const Color(0xFF7B5B6A));
    _fillRect(canvas, 74, 16, 18, 28, const Color(0xFFC88592));
    _fillRect(canvas, 194, 12, 22, 36, const Color(0xFF7B5B6A));
    _fillRect(canvas, 198, 16, 18, 28, const Color(0xFFC88592));
    _fillRect(canvas, 86, 14, 4, 10, const Color(0xFFF4D9CF));
    _fillRect(canvas, 202, 14, 4, 10, const Color(0xFFF4D9CF));

    for (var bulb = 114.0; bulb <= 178; bulb += 10) {
      _fillRect(canvas, bulb, 18, 2, 2, const Color(0xFFF7DE90));
      _fillRect(canvas, bulb, 20, 2, 1, const Color(0x337FDE8F));
    }

    _fillRect(canvas, 10, 72, 88, 68, const Color(0xFF293956));
    _fillRect(canvas, 262, 68, 88, 72, const Color(0xFF2A3B57));
    _fillRect(canvas, 98, 66, 14, 74, const Color(0xFF6F6457));
    _fillRect(canvas, 248, 66, 14, 74, const Color(0xFF6F6457));
    _fillRect(canvas, 102, 66, 8, 74, const Color(0xFF8E7D6C));
    _fillRect(canvas, 252, 66, 8, 74, const Color(0xFF8E7D6C));

    _fillRect(canvas, 78, 136, 204, 64, const Color(0xFF365576));
    _fillRect(canvas, 88, 144, 184, 48, const Color(0xFF426887));
    _fillRect(canvas, 96, 150, 168, 36, const Color(0xFF4F7692));

    for (final lily in <Offset>[
      const Offset(92, 146),
      const Offset(124, 180),
      const Offset(170, 150),
      const Offset(222, 178),
      const Offset(248, 150),
    ]) {
      _drawLilyPad(canvas, lily.dx, lily.dy);
    }
  }

  void _drawLeftLibraryZone(Canvas canvas) {
    _drawGroundShadow(canvas, 20, 102, 80, 10);
    _drawBookshelf(canvas, 22, 42, 40, 62);
    _drawBookshelf(canvas, 68, 42, 30, 54);
    _drawLamp(canvas, 86, 74, lit: true);
    _drawSideConsole(canvas, 54, 96, 44, 24);
    _drawFrame(canvas, 60, 78, 16, 12, const Color(0xFF8F7AD4));
    _drawPlant(canvas, 68, 90, lush: true);
    _drawPetCushion(canvas, 22, 170);
  }

  void _drawCenterLoungeZone(Canvas canvas) {
    _drawGroundShadow(canvas, 106, 176, 80, 10);
    _drawGroundShadow(canvas, 152, 178, 54, 8);
    _drawGroundShadow(canvas, 194, 158, 56, 10);
    _drawDesk(canvas, 110, 140);
    _drawDeskChair(canvas, 138, 172);
    _drawCouch(canvas, 196, 118);
    _drawCoffeeTable(canvas, 156, 154);
    _drawBookshelf(canvas, 134, 54, 32, 52);
    _drawPlant(canvas, 146, 108, lush: true);
    _drawLamp(canvas, 118, 144, lit: true);
    _drawFrame(canvas, 182, 46, 28, 18, const Color(0xFF7CB7D9));
  }

  void _drawRightBedroomZone(Canvas canvas) {
    _drawGroundShadow(canvas, 252, 100, 70, 10);
    _drawGroundShadow(canvas, 270, 168, 70, 10);
    _drawServerRack(canvas, 256, 40);
    _drawCabinet(canvas, 312, 36);
    _drawBedNook(canvas, 272, 118);
    _drawPlant(canvas, 292, 110);
    _drawLamp(canvas, 328, 146, lit: true);
    _drawFrame(canvas, 300, 76, 22, 12, const Color(0xFFB68CE8));
  }

  void _drawPropsAndDecor(Canvas canvas) {
    _drawPinnedPoster(canvas, 40, 22);
    _drawPinnedPoster(canvas, 294, 24);
    _drawStatusBoard(canvas, 202, 28);
    _drawDeskPlaque(canvas, 152, 184);
    _drawTinyCrate(canvas, 230, 164);
    _drawTinyCrate(canvas, 116, 164);
    _drawPetals(canvas);
    _drawGoalLamp(canvas);
  }

  void _drawPinnedPoster(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 24, 16, const Color(0xFF433454));
    _fillRect(canvas, x + 2, y + 2, 20, 12, const Color(0xFFE7D8AE));
    _fillRect(canvas, x + 4, y + 4, 16, 2, const Color(0xFF4B5875));
    _fillRect(canvas, x + 4, y + 8, 10, 2, const Color(0xFF6E7EA0));
    _fillRect(canvas, x + 17, y + 8, 3, 3, const Color(0xFFE48B74));
  }

  void _drawStatusBoard(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 42, 28, const Color(0xFF3C2A29));
    _fillRect(canvas, x + 2, y + 2, 38, 24, const Color(0xFF5B3C39));
    _fillRect(canvas, x + 6, y + 6, 8, 8, const Color(0xFF99B8CC));
    _fillRect(canvas, x + 18, y + 6, 8, 8, const Color(0xFFE7D38E));
    _fillRect(canvas, x + 30, y + 6, 4, 4, const Color(0xFFE78974));
    _fillRect(canvas, x + 6, y + 18, 18, 2, const Color(0xFFC6B58B));
    _fillRect(canvas, x + 28, y + 18, 8, 2, const Color(0xFFA1D492));
  }

  void _drawBookshelf(Canvas canvas, double x, double y, double width, double height) {
    _fillRect(canvas, x, y, width, height, const Color(0xFF6E4D37));
    _fillRect(canvas, x + 2, y + 2, width - 4, height - 4, const Color(0xFF835E45));
    for (var shelfY = y + 16; shelfY < y + height - 6; shelfY += 16) {
      _fillRect(canvas, x + 2, shelfY, width - 4, 2, const Color(0xFF5A3E2D));
    }
    for (var column = 0.0; column < width - 8; column += 8) {
      final accent = (column ~/ 8).isEven
          ? const Color(0xFF7DA2D9)
          : const Color(0xFFD9BF74);
      _fillRect(canvas, x + 4 + column, y + 6, 5, 10, accent);
      _fillRect(canvas, x + 4 + column, y + 22, 5, 10, const Color(0xFFA6D193));
      _fillRect(canvas, x + 4 + column, y + 38, 5, 10, const Color(0xFFE39A76));
    }
    _fillRect(canvas, x + width - 10, y + 10, 4, 6, const Color(0xFFEAD3A7));
    _fillRect(canvas, x + width - 12, y + 26, 6, 6, const Color(0xFF90C7E8));
    _fillRect(canvas, x + width - 10, y + 42, 4, 4, const Color(0xFFD68EA6));
  }

  void _drawSideConsole(Canvas canvas, double x, double y, double width, double height) {
    _fillRect(canvas, x, y, width, height, const Color(0xFF7A5C46));
    _fillRect(canvas, x + 4, y + 4, width - 8, height - 8, const Color(0xFF9C7A5B));
    _fillRect(canvas, x + 8, y + 8, 12, 8, const Color(0xFF89B8D6));
    _fillRect(canvas, x + 24, y + 8, 10, 8, const Color(0xFFE6CC8E));
  }

  void _drawFrame(Canvas canvas, double x, double y, double width, double height, Color color) {
    _fillRect(canvas, x, y, width, height, const Color(0xFF5D4838));
    _fillRect(canvas, x + 2, y + 2, width - 4, height - 4, color);
  }

  void _drawLamp(Canvas canvas, double x, double y, {required bool lit}) {
    _fillRect(canvas, x + 4, y, 4, 20, const Color(0xFF6A4B37));
    _fillRect(canvas, x, y - 6, 12, 8, lit ? const Color(0xFFF1CF85) : const Color(0xFF6A6772));
    _fillRect(
      canvas,
      x - 6,
      y + 16,
      20,
      4,
      lit ? const Color(0x33F1CF85) : const Color(0x22181818),
    );
  }

  void _drawPlant(Canvas canvas, double x, double y, {bool lush = false}) {
    _fillRect(canvas, x + 6, y + 18, 12, 12, const Color(0xFF7A5B46));
    _fillRect(canvas, x + 2, y + 8, 20, 14, const Color(0xFF5D9B6F));
    _fillRect(canvas, x, y + 2, 10, 12, lush ? const Color(0xFF8FD282) : const Color(0xFF75BB6D));
    _fillRect(canvas, x + 14, y + 2, 10, 12, lush ? const Color(0xFF8FD282) : const Color(0xFF75BB6D));
  }

  void _drawPetCushion(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 34, 14, const Color(0xFFE8D5B0));
    _fillRect(canvas, x + 4, y + 3, 26, 8, const Color(0xFFF4E8CB));
    _fillRect(canvas, x + 11, y + 1, 12, 10, const Color(0xFF8A877D));
    _fillRect(canvas, x + 13, y - 1, 3, 4, const Color(0xFF8A877D));
    _fillRect(canvas, x + 18, y - 1, 3, 4, const Color(0xFF8A877D));
    _fillRect(canvas, x + 14, y + 3, 6, 5, const Color(0xFFA8A397));
    _fillRect(canvas, x + 14, y + 4, 1, 1, const Color(0xFF3C342E));
    _fillRect(canvas, x + 18, y + 4, 1, 1, const Color(0xFF3C342E));
  }

  void _drawDesk(Canvas canvas, double x, double y) {
    final deskColor = _roomState.roomUpgradeLevel >= 2
        ? const Color(0xFF7D5A44)
        : const Color(0xFF765340);
    _fillRect(canvas, x, y, 76, 14, deskColor);
    _fillRect(canvas, x + 6, y + 14, 6, 24, const Color(0xFF5A3D2B));
    _fillRect(canvas, x + 60, y + 14, 6, 24, const Color(0xFF5A3D2B));
    _fillRect(canvas, x + 14, y - 18, 34, 18, const Color(0xFF2C3141));
    _fillRect(canvas, x + 18, y - 14, 26, 10, const Color(0xFF7FD2D9));
    _fillRect(canvas, x + 46, y - 8, 8, 8, const Color(0xFFE4C06C));
    _fillRect(canvas, x + 50, y - 4, 3, 4, const Color(0xFF5A7F66));
    _fillRect(canvas, x + 16, y + 2, 16, 6, const Color(0xFFE0D0A5));
    _fillRect(canvas, x + 34, y + 4, 9, 4, const Color(0xFFB9BED9));
    _fillRect(canvas, x + 48, y + 2, 14, 6, const Color(0xFFE58D78));
    _fillRect(canvas, x + 24, y + 18, 24, 18, const Color(0xFF587A9C));
    _fillRect(canvas, x + 30, y + 36, 12, 8, const Color(0xFF425E7A));
    _fillRect(canvas, x + 56, y - 14, 8, 8, const Color(0xFF8FC4E1));
    _fillRect(canvas, x + 58, y - 18, 4, 4, const Color(0xFFE7E0CF));
    _drawSteam(canvas, x + 58, y - 22);
  }

  void _drawCouch(Canvas canvas, double x, double y) {
    final couchColor = switch (_roomState.roomUpgradeLevel) {
      3 => const Color(0xFFE7DDC1),
      2 => const Color(0xFFD7CCAD),
      _ => const Color(0xFFCCBE9F),
    };
    _fillRect(canvas, x, y + 16, 50, 22, couchColor);
    _fillRect(canvas, x + 6, y, 38, 22, couchColor);
    _fillRect(canvas, x + 4, y + 6, 10, 24, const Color(0xFFF1E7CA));
    _fillRect(canvas, x + 36, y + 6, 10, 24, const Color(0xFFF1E7CA));
    _fillRect(canvas, x + 10, y + 40, 6, 6, const Color(0xFF6A503C));
    _fillRect(canvas, x + 34, y + 40, 6, 6, const Color(0xFF6A503C));
    _fillRect(canvas, x + 14, y + 8, 10, 8, const Color(0xFFE8DABF));
    _fillRect(canvas, x + 26, y + 8, 10, 8, const Color(0xFFE8DABF));
  }

  void _drawCoffeeTable(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 44, 12, const Color(0xFF7C5B44));
    _fillRect(canvas, x + 4, y + 12, 5, 16, const Color(0xFF5F4432));
    _fillRect(canvas, x + 35, y + 12, 5, 16, const Color(0xFF5F4432));
    _fillRect(canvas, x + 6, y + 2, 14, 8, const Color(0xFF4E6B86));
    _fillRect(canvas, x + 24, y + 2, 10, 8, const Color(0xFFE8D49A));
    _fillRect(canvas, x + 27, y - 9, 4, 11, const Color(0xFF5F4432));
    _fillRect(canvas, x + 22, y - 13, 14, 6, const Color(0xFF90715B));
    _fillRect(canvas, x + 9, y - 6, 8, 6, const Color(0xFFD6C4B0));
    _fillRect(canvas, x + 11, y - 10, 4, 4, const Color(0xFF7FBF91));
  }

  void _drawServerRack(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 48, 62, const Color(0xFF5B4F58));
    _fillRect(canvas, x + 6, y + 4, 14, 54, const Color(0xFF404250));
    _fillRect(canvas, x + 28, y + 4, 14, 54, const Color(0xFF404250));
    for (var row = 0.0; row < 48; row += 8) {
      _fillRect(canvas, x + 8, y + 6 + row, 10, 2, const Color(0xFF90D88E));
      _fillRect(canvas, x + 30, y + 8 + row, 10, 2, const Color(0xFF8FC6F2));
    }
  }

  void _drawCabinet(Canvas canvas, double x, double y) {
    final bodyColor = switch (_roomState.roomUpgradeLevel) {
      3 => const Color(0xFF81624B),
      2 => const Color(0xFF745844),
      _ => const Color(0xFF694F3D),
    };
    _fillRect(canvas, x, y, 26, 68, bodyColor);
    _fillRect(canvas, x + 4, y + 4, 18, 18, const Color(0xFF9C7C5B));
    _fillRect(canvas, x + 4, y + 26, 18, 18, const Color(0xFF9C7C5B));
    _fillRect(canvas, x + 4, y + 48, 18, 16, const Color(0xFF9C7C5B));
    _fillRect(canvas, x + 18, y + 54, 3, 3, const Color(0xFFD9CB9B));
    _fillRect(canvas, x + 7, y + 8, 6, 10, const Color(0xFF7FDE8F));
    _fillRect(canvas, x + 15, y + 10, 5, 7, const Color(0xFF7FDE8F));
  }

  void _drawBedNook(Canvas canvas, double x, double y) {
    final blanketColor = switch (_roomState.roomUpgradeLevel) {
      3 => const Color(0xFFDDD3BF),
      2 => const Color(0xFFD2C6AF),
      _ => const Color(0xFFC6B99E),
    };
    _fillRect(canvas, x, y, 64, 14, const Color(0xFF5A4E60));
    _fillRect(canvas, x + 6, y + 10, 54, 36, blanketColor);
    _fillRect(canvas, x + 14, y + 14, 18, 12, const Color(0xFFF3E7CD));
    _fillRect(canvas, x + 36, y + 14, 18, 24, const Color(0xFFE6DABF));
    _fillRect(canvas, x + 8, y, 4, 46, const Color(0xFF755A47));
    _fillRect(canvas, x + 54, y, 4, 46, const Color(0xFF755A47));
    _fillRect(canvas, x + 18, y + 28, 28, 8, const Color(0xFFEFE7D4));
  }

  void _drawDeskChair(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 18, 10, const Color(0xFF567B9A));
    _fillRect(canvas, x + 4, y - 10, 10, 10, const Color(0xFF7096B7));
    _fillRect(canvas, x + 8, y + 10, 2, 7, const Color(0xFF4D596F));
    _fillRect(canvas, x + 3, y + 16, 12, 2, const Color(0xFF4D596F));
  }

  void _drawTinyCrate(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 14, 12, const Color(0xFF896749));
    _fillRect(canvas, x + 2, y + 2, 10, 8, const Color(0xFFAA835A));
  }

  void _drawDeskPlaque(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 58, 12, const Color(0xFF5B382A));
    _fillRect(canvas, x + 2, y + 2, 54, 8, const Color(0xFF8E623E));
    _fillRect(canvas, x + 8, y + 4, 4, 4, const Color(0xFFF2D26E));
    _fillRect(canvas, x + 46, y + 4, 4, 4, const Color(0xFFF2D26E));
  }

  void _drawPetals(Canvas canvas) {
    for (final petal in <Offset>[
      const Offset(100, 164),
      const Offset(132, 188),
      const Offset(196, 162),
      const Offset(244, 188),
      const Offset(288, 160),
    ]) {
      _fillRect(canvas, petal.dx, petal.dy, 3, 2, const Color(0xFFF4D6E4));
      _fillRect(canvas, petal.dx + 1, petal.dy - 1, 1, 1, const Color(0xFFEAA3C4));
    }
  }

  void _drawLilyPad(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 12, 6, const Color(0xFF7EAB7B));
    _fillRect(canvas, x + 3, y - 2, 6, 2, const Color(0xFF9BD290));
    _fillRect(canvas, x + 4, y + 1, 4, 4, const Color(0xFFF4D9E7));
    _fillRect(canvas, x + 5, y, 2, 2, const Color(0xFFEAA6C2));
  }

  void _drawMoney(Canvas canvas) {
    for (var index = 0; index < _roomState.deskStackCount; index++) {
      final column = index % 3;
      final row = index ~/ 3;
      _drawMoneyStack(canvas, 126 + column * 13, 132 - row * 5, 1);
    }

    for (var index = 0; index < _roomState.cabinetStackCount; index++) {
      final column = index % 2;
      final row = index ~/ 2;
      _drawMoneyStack(canvas, 315 + column * 11, 93 - row * 7, 2);
    }

    for (var index = 0; index < _roomState.floorCashCount; index++) {
      _drawMoneyStack(canvas, 252 + index * 14, 188 + (index.isEven ? 0 : 3), 1);
    }

    if (_roomState.moneyTier >= 2) {
      _drawCoinJar(canvas, 168, 150);
    }
  }

  void _drawCoinJar(Canvas canvas, double x, double y) {
    _fillRect(canvas, x, y, 12, 16, const Color(0xFF86B8D0));
    _fillRect(canvas, x + 2, y + 2, 8, 10, const Color(0xFFE5C977));
    _fillRect(canvas, x + 2, y - 3, 8, 4, const Color(0xFFC7B18D));
  }

  void _drawMoneyStack(Canvas canvas, double x, double y, int height) {
    for (var level = 0; level < height; level++) {
      _fillRect(canvas, x, y - level * 4, 11, 5, const Color(0xFF7FDE8F));
      _fillRect(canvas, x + 1, y + 1 - level * 4, 9, 1, const Color(0xFFC2F4C4));
      _fillRect(canvas, x + 3, y - 1 - level * 4, 3, 5, const Color(0xFF2E9A5E));
    }
  }

  void _drawAvatar(Canvas canvas) {
    final bob = math.sin(_elapsed * 3) * 1.4;
    final wave = math.sin(_elapsed * 8) * 1.6;
    final sway = math.sin(_elapsed * 1.2) * 6;

    double x = 176;
    double y = 158;

    switch (_roomState.avatarState) {
      case AvatarState.work:
        x = 142;
        y = 154 + wave * 0.3;
      case AvatarState.read:
        x = 168;
        y = 162 + bob * 0.4;
      case AvatarState.phone:
        x = 86;
        y = 165 + bob * 0.3;
      case AvatarState.idle:
        x = 176 + sway;
        y = 162 + bob * 0.3;
      case AvatarState.sleep:
        x = 292;
        y = 162;
      case AvatarState.celebrate:
        x = 244;
        y = 154 - math.sin(_elapsed * 10).abs() * 8;
    }

    final outfitColor = switch (_roomState.avatarState) {
      AvatarState.sleep => const Color(0xFF90A2F6),
      AvatarState.read => const Color(0xFF6FCA90),
      AvatarState.phone => const Color(0xFFF0A072),
      AvatarState.celebrate => const Color(0xFFF3D576),
      _ => const Color(0xFFE88374),
    };

    if (_roomState.avatarState == AvatarState.sleep) {
      _fillRect(canvas, x, y, 24, 8, outfitColor);
      _fillRect(canvas, x + 3, y - 5, 10, 6, const Color(0xFFF4D2B4));
      _fillRect(canvas, x + 16, y + 1, 8, 3, const Color(0xFFF3E7CD));
      _labelPaint.render(
        canvas,
        'Z',
        Vector2(x + 26, y - 8 + math.sin(_elapsed * 2) * 2),
      );
      return;
    }

    _fillRect(canvas, x + 4, y - 15, 9, 8, const Color(0xFFF4D2B4));
    _fillRect(canvas, x + 2, y - 7, 13, 13, outfitColor);
    _fillRect(canvas, x + 4, y + 6, 3, 8, const Color(0xFF433228));
    _fillRect(canvas, x + 10, y + 6, 3, 8, const Color(0xFF433228));
    _fillRect(canvas, x + 6, y - 13, 2, 2, const Color(0xFF332019));
    _fillRect(canvas, x + 10, y - 13, 2, 2, const Color(0xFF332019));

    if (_roomState.avatarState == AvatarState.read) {
      _fillRect(canvas, x - 1, y - 1, 15, 5, const Color(0xFF89C7DA));
    } else if (_roomState.avatarState == AvatarState.phone) {
      _fillRect(canvas, x + 14, y - 3, 4, 8, const Color(0xFFACBED4));
      _fillRect(canvas, x + 15, y - 2, 2, 5, const Color(0xFF26324A));
    } else {
      _fillRect(canvas, x - 1, y - 1, 4, 6 + wave.abs(), const Color(0xFFF4D2B4));
      _fillRect(canvas, x + 13, y - 1, 4, 5, const Color(0xFFF4D2B4));
    }

    if (_roomState.avatarState == AvatarState.celebrate) {
      _fillRect(canvas, x + 16, y - 8, 8, 6, const Color(0xFF7FDE8F));
    }

    _drawSpeechBubble(canvas, x, y);
  }

  void _drawGoalLamp(Canvas canvas) {
    final reached = _stats.goalProgress >= 1;
    _fillRect(canvas, 226, 130, 4, 20, const Color(0xFF6B4A35));
    _fillRect(
      canvas,
      220,
      124,
      16,
      8,
      reached ? const Color(0xFFF3D576) : const Color(0xFF6B6777),
    );
  }

  void _drawLightOverlays(Canvas canvas) {
    _fillRect(canvas, 92, 84, 40, 24, const Color(0x22F4D28B));
    _fillRect(canvas, 122, 154, 52, 22, const Color(0x18F1C77B));
    _fillRect(canvas, 78, 154, 56, 18, const Color(0x18F1C77B));
    _fillRect(canvas, 320, 152, 28, 18, const Color(0x18F1C77B));

    if (_stats.goalProgress >= 1) {
      _fillRect(canvas, 208, 120, 40, 18, const Color(0x33F2D06A));
      _fillRect(canvas, 202, 136, 52, 10, const Color(0x22F2D06A));
    }
  }

  void _drawAmbientParticles(Canvas canvas) {
    final drift = math.sin(_elapsed * 0.9) * 2;
    for (final mote in <Offset>[
      Offset(92 + drift, 32),
      Offset(154 - drift, 58),
      Offset(238 + drift, 42),
      Offset(320 - drift, 92),
      Offset(58 + drift, 122),
    ]) {
      _fillRect(canvas, mote.dx, mote.dy, 2, 2, const Color(0x44FFF3C7));
    }

    final shimmer = (math.sin(_elapsed * 3) + 1) / 2;
    _fillRect(canvas, 112, 154, 26 * shimmer + 12, 2, const Color(0x228AD3E3));
    _fillRect(canvas, 184, 178, 22 * (1 - shimmer) + 10, 2, const Color(0x228AD3E3));

    final twinkle = ((math.sin(_elapsed * 4) + 1) / 2 * 3).floorToDouble();
    for (var bulb = 114.0; bulb <= 178; bulb += 10) {
      _fillRect(canvas, bulb, 18, 2 + twinkle, 2, const Color(0x33FFF3B0));
    }
  }

  void _drawSpeechBubble(Canvas canvas, double x, double y) {
    String text;
    switch (_roomState.avatarState) {
      case AvatarState.work:
        text = '赶进度';
      case AvatarState.read:
        text = '充电中';
      case AvatarState.phone:
        text = '偷摸鱼';
      case AvatarState.idle:
        text = '发会呆';
      case AvatarState.sleep:
        return;
      case AvatarState.celebrate:
        text = '进账啦';
    }

    final bubbleX = (x - 4).clamp(20, _worldWidth - 62).toDouble();
    final bubbleY = y - 28;
    _fillRect(canvas, bubbleX, bubbleY, 34, 12, const Color(0xFFEFE3BF));
    _fillRect(canvas, bubbleX + 2, bubbleY + 2, 30, 8, const Color(0xFFF9F2D8));
    _fillRect(canvas, bubbleX + 10, bubbleY + 12, 6, 4, const Color(0xFFEFE3BF));
    _labelPaint.render(canvas, text, Vector2(bubbleX + 5, bubbleY + 1));
  }

  void _drawGroundShadow(Canvas canvas, double x, double y, double width, double height) {
    _fillRect(canvas, x, y, width, height, const Color(0x22141517));
    _fillRect(canvas, x + 6, y + 2, width - 12, height - 3, const Color(0x18141517));
  }

  void _drawSteam(Canvas canvas, double x, double y) {
    final sway = math.sin(_elapsed * 2.6) * 2;
    _fillRect(canvas, x + sway, y, 2, 6, const Color(0x55F6F0E4));
    _fillRect(canvas, x + 4 - sway, y + 2, 2, 6, const Color(0x44F6F0E4));
  }

  void _drawFloatingMoney(Canvas canvas) {
    for (final effect in _floatingMoney) {
      final t = Curves.easeOutCubic.transform(effect.progress.clamp(0, 1));
      final x = lerpDouble(effect.startX, effect.endX, t)!;
      final arc = math.sin(t * math.pi) * 22;
      final y = lerpDouble(effect.startY, effect.endY, t)! - arc;
      _drawMoneyStack(canvas, x, y, 1);
    }
  }

  void _drawSceneLabels(Canvas canvas) {
    _labelPaint.render(
      canvas,
      '今日收入 ${_settings.currencySymbol}${_stats.todayIncome.toStringAsFixed(0)}',
      Vector2(18, 194),
    );
    _labelPaint.render(canvas, '连续 ${_stats.streakDays} 天', Vector2(18, 208));
  }

  void _spawnMoneyBurst() {
    final targetY = _roomState.cabinetStackCount > 0 ? 92 : 130;
    final targetX = _roomState.cabinetStackCount > 0 ? 315 : 130;

    _floatingMoney.addAll(<_FloatingMoney>[
      _FloatingMoney(
        startX: 210,
        startY: 24,
        endX: targetX.toDouble(),
        endY: targetY.toDouble(),
      ),
      _FloatingMoney(
        startX: 226,
        startY: 28,
        endX: targetX + 14,
        endY: targetY + 8,
      ),
      _FloatingMoney(
        startX: 194,
        startY: 30,
        endX: targetX - 10,
        endY: targetY + 2,
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
  final double duration = 0.95;
  double progress = 0;
}
