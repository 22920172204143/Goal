import 'package:flutter/material.dart';

import '../models/income_record.dart';
import '../utils/formatters.dart';

class IncomeEditorResult {
  const IncomeEditorResult({
    required this.amount,
    required this.category,
    required this.note,
    required this.createdAt,
  });

  final double amount;
  final String category;
  final String note;
  final DateTime createdAt;
}

class IncomeEditorSheet extends StatefulWidget {
  const IncomeEditorSheet({
    super.key,
    required this.categories,
    this.initialRecord,
  });

  final List<String> categories;
  final IncomeRecord? initialRecord;

  @override
  State<IncomeEditorSheet> createState() => _IncomeEditorSheetState();
}

class _IncomeEditorSheetState extends State<IncomeEditorSheet> {
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  late String _selectedCategory;
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.initialRecord != null;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialRecord?.amount.toStringAsFixed(
        widget.initialRecord!.amount % 1 == 0 ? 0 : 2,
      ) ??
          '',
    );
    _noteController = TextEditingController(text: widget.initialRecord?.note ?? '');
    _selectedCategory = widget.initialRecord?.category ?? widget.categories.first;
    _selectedDate = widget.initialRecord?.createdAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: mediaQuery.viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _isEditing ? '编辑收入' : '记一笔收入',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '金额',
                hintText: '例如 88 或 188.5',
              ),
              validator: (value) {
                final amount = double.tryParse(value ?? '');
                if (amount == null || amount <= 0) {
                  return '请输入大于 0 的金额';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: widget.categories
                  .map(
                    (category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              decoration: const InputDecoration(labelText: '来源分类'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: '备注',
                hintText: '例如：今天接了个小单',
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('记录时间：${formatDateTime(_selectedDate)}'),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: Text(_isEditing ? '保存修改' : '加入房间'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate == null || !mounted) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        _selectedDate.hour,
        _selectedDate.minute,
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(
      IncomeEditorResult(
        amount: double.parse(_amountController.text.trim()),
        category: _selectedCategory,
        note: _noteController.text.trim(),
        createdAt: _selectedDate,
      ),
    );
  }
}
