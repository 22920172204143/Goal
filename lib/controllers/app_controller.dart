import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../models/app_stats.dart';
import '../models/income_record.dart';
import '../models/room_visual_state.dart';
import '../repositories/local_app_repository.dart';
import '../services/room_state_service.dart';
import '../services/stats_service.dart';

class AppController extends ChangeNotifier {
  AppController({
    LocalAppRepository? repository,
    StatsService? statsService,
    RoomStateService? roomStateService,
  })  : _repository = repository ?? LocalAppRepository(),
        _statsService = statsService ?? StatsService(),
        _roomStateService = roomStateService ?? RoomStateService();

  final LocalAppRepository _repository;
  final StatsService _statsService;
  final RoomStateService _roomStateService;

  List<IncomeRecord> _records = <IncomeRecord>[];
  AppSettings _settings = AppSettings.defaults();
  AppStats _stats = AppStats.empty();
  RoomVisualState _roomState = RoomVisualState.initial();
  bool _isLoading = true;
  DateTime? _lastCelebrationAt;
  int _animationNonce = 0;

  List<IncomeRecord> get records => List<IncomeRecord>.unmodifiable(_records);
  AppSettings get settings => _settings;
  AppStats get stats => _stats;
  RoomVisualState get roomState => _roomState;
  bool get isLoading => _isLoading;

  List<String> get categories => const <String>[
        '工资',
        '副业',
        '奖金',
        '接单',
        '理财',
        '其他',
      ];

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _records = await _repository.loadRecords();
    _settings = await _repository.loadSettings();
    _sortRecords();
    _recalculate();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addIncome({
    required double amount,
    required String category,
    required String note,
    required DateTime createdAt,
  }) async {
    final now = DateTime.now();
    _records.insert(
      0,
      IncomeRecord(
        id: now.microsecondsSinceEpoch.toString(),
        amount: amount,
        category: category,
        note: note,
        createdAt: createdAt,
      ),
    );
    _lastCelebrationAt = now;
    _animationNonce++;
    await _repository.saveRecords(_records);
    _sortRecords();
    _recalculate();
    notifyListeners();
  }

  Future<void> updateIncome(IncomeRecord updatedRecord) async {
    _records = _records
        .map((record) => record.id == updatedRecord.id ? updatedRecord : record)
        .toList();
    await _repository.saveRecords(_records);
    _sortRecords();
    _recalculate();
    notifyListeners();
  }

  Future<void> deleteIncome(String id) async {
    _records.removeWhere((record) => record.id == id);
    await _repository.saveRecords(_records);
    _recalculate();
    notifyListeners();
  }

  Future<void> updateDailyGoal(double value) async {
    _settings = _settings.copyWith(dailyGoal: value);
    await _repository.saveSettings(_settings);
    _recalculate();
    notifyListeners();
  }

  Future<void> seedDemoData() async {
    if (_records.isNotEmpty) {
      return;
    }
    final now = DateTime.now();
    _records = <IncomeRecord>[
      IncomeRecord(
        id: 'demo-1',
        amount: 88,
        category: '副业',
        note: '帮朋友修图',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      IncomeRecord(
        id: 'demo-2',
        amount: 168,
        category: '工资',
        note: '今日结算',
        createdAt: now.subtract(const Duration(days: 1, hours: 1)),
      ),
      IncomeRecord(
        id: 'demo-3',
        amount: 260,
        category: '接单',
        note: '做了个页面',
        createdAt: now.subtract(const Duration(days: 2, hours: 4)),
      ),
    ];
    _lastCelebrationAt = now;
    _animationNonce++;
    await _repository.saveRecords(_records);
    _sortRecords();
    _recalculate();
    notifyListeners();
  }

  void _sortRecords() {
    _records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _recalculate() {
    _stats = _statsService.calculate(
      records: _records,
      dailyGoal: _settings.dailyGoal,
    );
    _roomState = _roomStateService.build(
      stats: _stats,
      records: _records,
      dailyGoal: _settings.dailyGoal,
      animationNonce: _animationNonce,
      lastCelebrationAt: _lastCelebrationAt,
    );
  }
}
