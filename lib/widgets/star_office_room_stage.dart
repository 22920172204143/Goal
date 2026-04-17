import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/app_stats.dart';
import '../models/room_visual_state.dart';

class StarOfficeRoomStage extends StatefulWidget {
  const StarOfficeRoomStage({
    super.key,
    required this.roomState,
    required this.stats,
    required this.settings,
  });

  final RoomVisualState roomState;
  final AppStats stats;
  final AppSettings settings;

  @override
  State<StarOfficeRoomStage> createState() => _StarOfficeRoomStageState();
}

class _StarOfficeRoomStageState extends State<StarOfficeRoomStage>
    with SingleTickerProviderStateMixin {
  static const double _stageWidth = 1280;
  static const double _stageHeight = 720;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final tick =
            (_controller.lastElapsedDuration?.inMilliseconds ?? 0) ~/ 180;
        final glow = 0.08 + widget.roomState.goalProgress.clamp(0, 1) * 0.18;

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _stageWidth,
                height: _stageHeight,
                child: Stack(
                  children: <Widget>[
                    const Positioned.fill(
                      child: Image(
                        image: AssetImage('assets/star_office/office_bg.webp'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(-0.15, -0.1),
                            radius: 1.0,
                            colors: <Color>[
                              const Color(0xFFF8EFB7).withValues(alpha: glow),
                              const Color(0x00000000),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.roomState.roomUpgradeLevel >= 1)
                      _stageAsset(
                        left: 252,
                        top: 66,
                        width: 68,
                        height: 68,
                        child: _AssetFrame(
                          assetPath:
                              'assets/star_office/poster_${widget.roomState.roomUpgradeLevel * 4}.png',
                        ),
                      ),
                    if (widget.roomState.roomUpgradeLevel >= 1)
                      _stageAsset(
                        left: 1021 - 150,
                        top: 142 - 105,
                        width: 300,
                        height: 210,
                        child: _AssetFrame(
                          assetPath:
                              'assets/star_office/serverroom_${tick % 6}.png',
                        ),
                      ),
                    _stageAsset(
                      left: 670,
                      top: 144,
                      width: 165,
                      height: 165,
                      child: const Image(
                        image:
                            AssetImage('assets/star_office/sofa-idle-v3.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    _stageAsset(
                      left: 218 - 166,
                      top: 417 - 128,
                      width: 332,
                      height: 258,
                      child: const Image(
                        image: AssetImage('assets/star_office/desk-v3.webp'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (widget.roomState.roomUpgradeLevel >= 2)
                      _stageAsset(
                        left: 294,
                        top: 406,
                        width: 78,
                        height: 78,
                        child: _AssetFrame(
                          assetPath:
                              'assets/star_office/${_flowerAssetForLevel(widget.roomState.roomUpgradeLevel)}',
                        ),
                      ),
                    ..._buildDeskProps(),
                    ..._buildStashProps(),
                    ..._buildStateMood(),
                    ..._buildAvatar(tick),
                    ..._buildPet(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDeskProps() {
    final deskCount = widget.roomState.deskStackCount.clamp(0, 8);
    final tier = widget.roomState.moneyTier;
    final widgets = <Widget>[];

    if (tier >= 3) {
      widgets.add(
        _ambientGlow(
          left: 110,
          top: 395,
          width: 200,
          height: 80,
          color: const Color(0xFFF5D66A),
          opacity: 0.12,
        ),
      );
    }

    widgets.add(
      _stageAsset(
        left: 148,
        top: 412,
        width: 34,
        height: 22,
        child: const _PaperStack(
          sheetColor: Color(0xFFF0E5BA),
          accentColor: Color(0xFF7B6850),
        ),
      ),
    );

    if (widget.roomState.goalProgress > 0.16) {
      widgets.add(
        _stageAsset(
          left: 252,
          top: 417,
          width: 30,
          height: 34,
          child: const _CoinJar(),
        ),
      );
    }

    final bundleSize = tier >= 3 ? 40.0 : (tier >= 2 ? 36.0 : 32.0);
    final bundleHeight = tier >= 3 ? 26.0 : (tier >= 2 ? 23.0 : 20.0);

    for (var index = 0; index < deskCount.clamp(0, 4); index++) {
      widgets.add(
        _stageAsset(
          left: 188 + index * 18,
          top: 419 - (index.isOdd ? 5 : 0),
          width: bundleSize,
          height: bundleHeight,
          child: _MoneyBundle(
            level: tier,
            compact: index.isOdd,
          ),
        ),
      );
    }

    if (deskCount >= 5) {
      for (var index = 0; index < (deskCount - 4).clamp(0, 4); index++) {
        widgets.add(
          _stageAsset(
            left: 108 + index * 16,
            top: 432 - (index.isOdd ? 3 : 0),
            width: bundleSize - 4,
            height: bundleHeight - 2,
            child: _MoneyBundle(
              level: tier,
              compact: true,
            ),
          ),
        );
      }
    }

    if (deskCount >= 5) {
      widgets.add(
        _stageAsset(
          left: 118,
          top: 430,
          width: 20,
          height: 16,
          child: const _CoinPile(),
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildStashProps() {
    final cabinetCount = widget.roomState.cabinetStackCount.clamp(0, 9);
    final floorCount = widget.roomState.floorCashCount.clamp(0, 8);
    final tier = widget.roomState.moneyTier;
    final widgets = <Widget>[];

    if (cabinetCount >= 4) {
      widgets.add(
        _ambientGlow(
          left: 1080,
          top: 310,
          width: 120,
          height: 120,
          color: const Color(0xFFF5D66A),
          opacity: 0.10,
        ),
      );
    }

    final cabinetBundleW = cabinetCount >= 6 ? 34.0 : 28.0;
    final cabinetBundleH = cabinetCount >= 6 ? 22.0 : 18.0;

    for (var index = 0; index < cabinetCount.clamp(0, 6); index++) {
      widgets.add(
        _stageAsset(
          left: 1108 + (index % 2) * 28,
          top: 332 + (index ~/ 2) * 24,
          width: cabinetBundleW,
          height: cabinetBundleH,
          child: _MoneyBundle(
            level: tier + 1,
            compact: true,
          ),
        ),
      );
    }

    if (cabinetCount >= 7) {
      for (var index = 0; index < (cabinetCount - 6).clamp(0, 3); index++) {
        widgets.add(
          _stageAsset(
            left: 1092 + index * 30,
            top: 410,
            width: 30,
            height: 20,
            child: _MoneyBundle(
              level: tier + 1,
              compact: false,
            ),
          ),
        );
      }
    }

    if (floorCount > 0) {
      widgets.add(
        _stageAsset(
          left: 935,
          top: 540,
          width: 40,
          height: 28,
          child: _MoneyEnvelope(
            accent: floorCount >= 4
                ? const Color(0xFFE0C46A)
                : const Color(0xFF9CC7E7),
          ),
        ),
      );
    }

    if (floorCount >= 2) {
      widgets.add(
        _stageAsset(
          left: 820,
          top: 560,
          width: 36,
          height: 24,
          child: _MoneyEnvelope(
            accent: floorCount >= 4
                ? const Color(0xFFE0C46A)
                : const Color(0xFFB5D4A8),
          ),
        ),
      );
    }

    if (floorCount >= 3) {
      widgets.add(
        _stageAsset(
          left: 725,
          top: 244,
          width: 28,
          height: 18,
          child: _MoneyBundle(
            level: tier,
            compact: true,
          ),
        ),
      );
    }

    if (floorCount >= 4) {
      widgets.add(
        _stageAsset(
          left: 680,
          top: 540,
          width: 44,
          height: 30,
          child: const _MoneyBag(),
        ),
      );
    }

    if (floorCount >= 5) {
      widgets.add(
        _stageAsset(
          left: 560,
          top: 555,
          width: 20,
          height: 16,
          child: const _CoinPile(),
        ),
      );
      widgets.add(
        _stageAsset(
          left: 480,
          top: 560,
          width: 32,
          height: 20,
          child: _MoneyBundle(
            level: tier,
            compact: false,
          ),
        ),
      );
    }

    if (widget.roomState.roomUpgradeLevel >= 3) {
      widgets.add(
        _stageAsset(
          left: 1046,
          top: 95,
          width: 22,
          height: 22,
          child: const _SmallPlantProp(),
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildStateMood() {
    final state = widget.roomState.avatarState;
    return switch (state) {
      AvatarState.work => <Widget>[
          _ambientGlow(
            left: 42,
            top: 286,
            width: 312,
            height: 210,
            color: const Color(0xFF83DCC2),
            opacity: 0.13,
          ),
        ],
      AvatarState.read => <Widget>[
          _ambientGlow(
            left: 560,
            top: 100,
            width: 260,
            height: 210,
            color: const Color(0xFFF2D48B),
            opacity: 0.14,
          ),
        ],
      AvatarState.phone => <Widget>[
          _ambientGlow(
            left: 592,
            top: 104,
            width: 250,
            height: 210,
            color: const Color(0xFFF5C38D),
            opacity: 0.13,
          ),
        ],
      AvatarState.idle => <Widget>[
          _ambientGlow(
            left: 592,
            top: 108,
            width: 250,
            height: 210,
            color: const Color(0xFFF6E5A4),
            opacity: 0.11,
          ),
        ],
      AvatarState.sleep => <Widget>[
          _ambientGlow(
            left: 932,
            top: 380,
            width: 250,
            height: 210,
            color: const Color(0xFFB1C8F8),
            opacity: 0.16,
          ),
        ],
      AvatarState.celebrate => <Widget>[
          _ambientGlow(
            left: 70,
            top: 268,
            width: 320,
            height: 228,
            color: const Color(0xFFF5D66A),
            opacity: 0.18,
          ),
        ],
    };
  }

  List<Widget> _buildAvatar(int tick) {
    final idleBob = math.sin(_controller.value * math.pi * 2) * 6;
    final hypeBob = math.sin(_controller.value * math.pi * 6) * 10;
    final state = widget.roomState.avatarState;

    switch (state) {
      case AvatarState.work:
        return <Widget>[
          _stageShadow(left: 167, top: 430, width: 112, height: 24),
          _stageAsset(
            left: 134,
            top: 250 + idleBob,
            width: 160,
            height: 160,
            child: _AssetFrame(
              assetPath: 'assets/star_office/star_work_${tick % 8}.png',
            ),
          ),
          _stageAsset(
            left: 140,
            top: 232,
            width: 28,
            height: 12,
            child: const _FocusDots(),
          ),
          _stageAsset(
            left: 320,
            top: 385,
            width: 64,
            height: 64,
            child: _AssetFrame(
              assetPath: 'assets/star_office/coffee_${tick % 8}.png',
            ),
          ),
        ];
      case AvatarState.read:
        return <Widget>[
          _stageShadow(left: 652, top: 282, width: 112, height: 24),
          _stageAsset(
            left: 634,
            top: 166 + idleBob,
            width: 150,
            height: 150,
            child: _AssetFrame(
              assetPath: 'assets/star_office/star_read_${16 + tick % 8}.png',
            ),
          ),
          _stageAsset(
            left: 628,
            top: 194,
            width: 20,
            height: 16,
            child: const _BookBadge(),
          ),
        ];
      case AvatarState.phone:
        return <Widget>[
          _stageShadow(left: 666, top: 282, width: 112, height: 24),
          _stageAsset(
            left: 648,
            top: 166 + idleBob,
            width: 150,
            height: 150,
            child: _AssetFrame(
              assetPath: 'assets/star_office/star_phone_${8 + tick % 8}.png',
            ),
          ),
          _stageAsset(
            left: 780,
            top: 220,
            width: 16,
            height: 16,
            child: _Sparkle(
              color: const Color(0xFFF7D67B),
              angle: _controller.value * math.pi * 1.5,
            ),
          ),
        ];
      case AvatarState.idle:
        return <Widget>[
          _stageShadow(left: 666, top: 282, width: 112, height: 24),
          _stageAsset(
            left: 650,
            top: 160 + idleBob,
            width: 152,
            height: 152,
            child: _AssetFrame(
              assetPath: 'assets/star_office/star_idle_${tick % 8}.png',
            ),
          ),
        ];
      case AvatarState.sleep:
        return <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF19233B).withValues(alpha: 0.12),
              ),
            ),
          ),
          _stageShadow(left: 1048, top: 558, width: 102, height: 18),
          _stageAsset(
            left: 1026,
            top: 470 + idleBob * 0.3,
            width: 120,
            height: 120,
            child: const _AssetFrame(
              assetPath: 'assets/star_office/cat_15.png',
            ),
          ),
          _stageAsset(
            left: 1128,
            top: 456,
            width: 42,
            height: 42,
            child: const _SleepMarks(),
          ),
        ];
      case AvatarState.celebrate:
        return <Widget>[
          _stageShadow(left: 170, top: 432, width: 120, height: 24),
          _stageAsset(
            left: 144,
            top: 246 + hypeBob,
            width: 168,
            height: 168,
            child: _AssetFrame(
              assetPath:
                  'assets/star_office/star_celebrate_${32 + tick % 6}.png',
            ),
          ),
          _stageAsset(
            left: 160,
            top: 232,
            width: 22,
            height: 22,
            child: _Sparkle(
              color: const Color(0xFFF7D67B),
              angle: _controller.value * math.pi * 2,
            ),
          ),
          _stageAsset(
            left: 280,
            top: 250,
            width: 16,
            height: 16,
            child: _Sparkle(
              color: const Color(0xFF9AE59A),
              angle: -_controller.value * math.pi * 2,
            ),
          ),
          _stageAsset(
            left: 108,
            top: 244,
            width: 18,
            height: 18,
            child: _Sparkle(
              color: const Color(0xFFF5D66A),
              angle: _controller.value * math.pi * 3,
            ),
          ),
        ];
    }
  }

  List<Widget> _buildPet() {
    if (widget.roomState.roomUpgradeLevel < 1) {
      return const <Widget>[];
    }

    return <Widget>[
      _stageAsset(
        left: 98,
        top: 548,
        width: 96,
        height: 96,
        child: _AssetFrame(
          assetPath:
              'assets/star_office/${_petAssetForLevel(widget.roomState.roomUpgradeLevel)}',
        ),
      ),
    ];
  }

  String _flowerAssetForLevel(int level) {
    return switch (level) {
      >= 3 => 'flower_15.png',
      2 => 'flower_10.png',
      1 => 'flower_5.png',
      _ => 'flower_2.png',
    };
  }

  String _petAssetForLevel(int level) {
    return switch (level) {
      >= 3 => 'cat_15.png',
      2 => 'cat_14.png',
      _ => 'cat_13.png',
    };
  }

  Widget _stageAsset({
    required double left,
    required double top,
    required double width,
    required double height,
    required Widget child,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: child,
    );
  }

  Widget _stageShadow({
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          gradient: RadialGradient(
            colors: <Color>[
              Colors.black.withValues(alpha: 0.22),
              Colors.black.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ambientGlow({
    required double left,
    required double top,
    required double width,
    required double height,
    required Color color,
    required double opacity,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AssetFrame extends StatelessWidget {
  const _AssetFrame({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(assetPath),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none,
    );
  }
}

class _MoneyBundle extends StatelessWidget {
  const _MoneyBundle({
    required this.level,
    this.compact = false,
  });

  final int level;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bandColor = switch (level) {
      >= 3 => const Color(0xFFF7D27B),
      2 => const Color(0xFF93D889),
      1 => const Color(0xFF8CD5F7),
      _ => const Color(0xFF86CE91),
    };

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFE4AE),
        borderRadius: BorderRadius.circular(compact ? 3 : 4),
        border: Border.all(color: const Color(0x995B4736)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          if (!compact)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.26),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: compact ? 6 : 8,
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: bandColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinJar extends StatelessWidget {
  const _CoinJar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 22,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0x88B7DAF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF7E9FB6)),
            ),
          ),
        ),
        Positioned(
          left: 8,
          top: 7,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFF1CD67),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: 7,
          top: 10,
          child: Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFF7D67B),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _CoinPile extends StatelessWidget {
  const _CoinPile();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 1,
          bottom: 2,
          child: _coin(10),
        ),
        Positioned(
          left: 7,
          bottom: 5,
          child: _coin(9),
        ),
        Positioned(
          left: 12,
          bottom: 1,
          child: _coin(8),
        ),
      ],
    );
  }

  Widget _coin(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF3CF6A),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF9B7C2B)),
      ),
    );
  }
}

class _MoneyEnvelope extends StatelessWidget {
  const _MoneyEnvelope({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 32,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFEFE1C2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF8B7555)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 22,
            height: 4,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaperStack extends StatelessWidget {
  const _PaperStack({
    required this.sheetColor,
    required this.accentColor,
  });

  final Color sheetColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 4,
          top: 6,
          child: _sheet(24, 12, sheetColor.withValues(alpha: 0.82)),
        ),
        Positioned(
          left: 8,
          top: 3,
          child: _sheet(24, 12, sheetColor),
        ),
        Positioned(
          left: 12,
          top: 0,
          child: Container(
            width: 12,
            height: 4,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sheet(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xAA8B7555)),
      ),
    );
  }
}

class _SmallPlantProp extends StatelessWidget {
  const _SmallPlantProp();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 12,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF8C6749),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Positioned(
          left: 2,
          top: 1,
          child: Container(
            width: 7,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFF69AE6A),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Positioned(
          right: 2,
          top: 0,
          child: Container(
            width: 7,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFF86C77E),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}

class _MoneyBag extends StatelessWidget {
  const _MoneyBag();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 32,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A853),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF8B6F28)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          child: Container(
            width: 12,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFB88B2D),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Positioned(
          left: 13,
          top: 12,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFF7D67B),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _FocusDots extends StatelessWidget {
  const _FocusDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(
        3,
        (_) => Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF7ED9B2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _BookBadge extends StatelessWidget {
  const _BookBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8D7AE),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xAA7B6850)),
      ),
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 12,
          color: Color(0xFF795A2B),
        ),
      ),
    );
  }
}

class _SleepMarks extends StatelessWidget {
  const _SleepMarks();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Z',
          style: TextStyle(
            color: Color(0xFFF8EFB7),
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'z',
            style: TextStyle(
              color: Color(0xFFD7E1F6),
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({
    required this.color,
    required this.angle,
  });

  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        painter: _SparklePainter(color),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(
        Offset(center.dx, 0), Offset(center.dx, size.height), paint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
