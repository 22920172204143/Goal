import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../utils/formatters.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.controller});

  final AppController controller;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    _goalController = TextEditingController(
      text: widget.controller.settings.dailyGoal.toStringAsFixed(0),
    );
  }

  @override
  void didUpdateWidget(covariant SettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _goalController.text = widget.controller.settings.dailyGoal.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.controller.settings;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: <Widget>[
        Text(
          '设置',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '每日目标',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _goalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '目标金额',
                    helperText: '保存后会立即影响房间反馈和达成进度。',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveGoal,
                    child: const Text('保存目标'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '当前策略',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                _SettingRow(label: '货币符号', value: settings.currencySymbol),
                _SettingRow(label: '素材策略', value: settings.assetStrategy),
                _SettingRow(
                  label: '今日目标',
                  value: formatCurrency(settings.dailyGoal, symbol: settings.currencySymbol),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  '开源参考',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 12),
                _ReferenceTile(
                  title: 'Pixel Agents',
                  subtitle: '参考“状态 -> 像素角色动作”的表达方式',
                  url: 'https://github.com/pablodelucca/pixel-agents',
                ),
                _ReferenceTile(
                  title: 'Lobster Lounge',
                  subtitle: '参考像素场景作为主界面的空间组织方式',
                  url: 'https://github.com/tsconfigdotjson/lobster-lounge',
                ),
                _ReferenceTile(
                  title: 'Universal LPC Generator',
                  subtitle: '后续可接入开源人物 spritesheet 资源',
                  url: 'https://github.com/LiberatedPixelCup/Universal-LPC-Spritesheet-Character-Generator',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveGoal() async {
    final value = double.tryParse(_goalController.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入大于 0 的目标金额')),
      );
      return;
    }
    await widget.controller.updateDailyGoal(value);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('每日目标已更新')),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({
    required this.title,
    required this.subtitle,
    required this.url,
  });

  final String title;
  final String subtitle;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 2),
          SelectableText(url, style: const TextStyle(color: Color(0xFF8DD6FF))),
        ],
      ),
    );
  }
}
