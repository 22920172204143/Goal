import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../game/small_goal_room_game.dart';
import '../models/room_visual_state.dart';
import '../utils/formatters.dart';
import '../widgets/metric_card.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({
    super.key,
    required this.controller,
    required this.onAddIncome,
  });

  final AppController controller;
  final VoidCallback onAddIncome;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late final SmallGoalRoomGame _game;

  @override
  void initState() {
    super.initState();
    _game = SmallGoalRoomGame();
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.controller.stats;
    final roomState = widget.controller.roomState;
    final settings = widget.controller.settings;
    _game.applySnapshot(
      roomState: roomState,
      stats: stats,
      settings: settings,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: <Widget>[
        Text(
          '小目标',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          '把现实收入堆进你的像素房间里。',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: MetricCard(
                label: '今日进账',
                value: formatCurrency(
                  stats.todayIncome,
                  symbol: settings.currencySymbol,
                ),
                highlight: true,
                icon: Icons.savings,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: '连续记录',
                value: '${stats.streakDays} 天',
                icon: Icons.local_fire_department_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 11,
                    child: GameWidget(game: _game),
                  ),
                ),
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: roomState.goalProgress.clamp(0, 1),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.white12,
                ),
                const SizedBox(height: 10),
                Text(
                  roomState.statusMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _RoomChip(
                      label: '桌面现金 ${roomState.deskStackCount} 沓',
                    ),
                    _RoomChip(
                      label: '储物柜 ${roomState.cabinetStackCount} 组',
                    ),
                    _RoomChip(
                      label: '房间等级 ${roomState.roomUpgradeLevel + 1}',
                    ),
                    _RoomChip(
                      label: _avatarLabel(roomState.avatarState),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (widget.controller.records.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '房间还很空',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '先记下第一笔收入，或者直接填充一组演示数据，看看现金和小人如何在房间里变化。',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.controller.seedDemoData,
                          child: const Text('填充演示数据'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: widget.onAddIncome,
                          child: const Text('马上记一笔'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '最近进账',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  for (final record in widget.controller.records.take(3))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  record.note.isEmpty ? record.category : record.note,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${record.category} · ${formatDateTime(record.createdAt)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatCurrency(
                              record.amount,
                              symbol: settings.currencySymbol,
                            ),
                            style: const TextStyle(
                              color: Color(0xFF67E391),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _avatarLabel(AvatarState state) {
    return switch (state) {
      AvatarState.work => '正在干活',
      AvatarState.read => '正在看书',
      AvatarState.phone => '正在刷手机',
      AvatarState.sleep => '已经睡了',
      AvatarState.celebrate => '正在搬钱',
      AvatarState.idle => '正在闲逛',
    };
  }
}

class _RoomChip extends StatelessWidget {
  const _RoomChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }
}
