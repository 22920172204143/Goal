import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../utils/formatters.dart';
import '../widgets/metric_card.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final stats = controller.stats;
    final settings = controller.settings;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: <Widget>[
        Text(
          '统计',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.25,
          children: <Widget>[
            MetricCard(
              label: '今日',
              value: formatCurrency(stats.todayIncome, symbol: settings.currencySymbol),
              highlight: true,
              icon: Icons.today_outlined,
            ),
            MetricCard(
              label: '本周',
              value: formatCurrency(stats.weekIncome, symbol: settings.currencySymbol),
              icon: Icons.calendar_view_week_outlined,
            ),
            MetricCard(
              label: '本月',
              value: formatCurrency(stats.monthIncome, symbol: settings.currencySymbol),
              icon: Icons.calendar_month_outlined,
            ),
            MetricCard(
              label: '累计',
              value: formatCurrency(stats.totalIncome, symbol: settings.currencySymbol),
              icon: Icons.account_balance_wallet_outlined,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '目标追踪',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: stats.goalProgress.clamp(0, 1),
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(16),
                  backgroundColor: Colors.white10,
                ),
                const SizedBox(height: 10),
                Text(
                  stats.goalProgress >= 1
                      ? '今天已完成目标 ${formatCurrency(controller.settings.dailyGoal, symbol: settings.currencySymbol)}'
                      : '距离目标还差 ${formatCurrency(stats.remainingToGoal, symbol: settings.currencySymbol)}',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    _StatTag(label: '连续 ${stats.streakDays} 天'),
                    _StatTag(label: '共 ${stats.recordCount} 笔记录'),
                    _StatTag(label: '今日目标 ${formatCurrency(controller.settings.dailyGoal, symbol: settings.currencySymbol)}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTag extends StatelessWidget {
  const _StatTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }
}
