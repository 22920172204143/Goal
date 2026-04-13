import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/income_record.dart';
import '../widgets/income_editor_sheet.dart';
import 'records_page.dart';
import 'room_page.dart';
import 'settings_page.dart';
import 'stats_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      RoomPage(
        controller: widget.controller,
        onAddIncome: _openCreateSheet,
      ),
      RecordsPage(
        controller: widget.controller,
        onEdit: _openEditSheet,
      ),
      StatsPage(controller: widget.controller),
      SettingsPage(controller: widget.controller),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_selectedIndex]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateSheet,
        icon: const Icon(Icons.add),
        label: const Text('记收入'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '房间',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: '明细',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_stats_outlined),
            selectedIcon: Icon(Icons.query_stats),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateSheet() async {
    final result = await showModalBottomSheet<IncomeEditorResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => IncomeEditorSheet(categories: widget.controller.categories),
    );

    if (result == null) {
      return;
    }

    await widget.controller.addIncome(
      amount: result.amount,
      category: result.category,
      note: result.note,
      createdAt: result.createdAt,
    );
  }

  Future<void> _openEditSheet(IncomeRecord record) async {
    final result = await showModalBottomSheet<IncomeEditorResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => IncomeEditorSheet(
        categories: widget.controller.categories,
        initialRecord: record,
      ),
    );

    if (result == null) {
      return;
    }

    await widget.controller.updateIncome(
      record.copyWith(
        amount: result.amount,
        category: result.category,
        note: result.note,
        createdAt: result.createdAt,
      ),
    );
  }
}
