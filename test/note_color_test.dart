import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_akhir_pemob2/note.dart';

void main() {
  test(
    'noteColorByDeadline returns correct color by deadline range',
    () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final overdue = today.subtract(const Duration(days: 1));
      expect(
        noteColorByDeadline(overdue),
        Colors.red.shade900,
      );

      final dueTomorrow = today.add(const Duration(days: 1));
      expect(
        noteColorByDeadline(dueTomorrow),
        Colors.red.shade400,
      );

      expect(
        noteColorByDeadline(null),
        Colors.yellow.shade300,
      );
    },
  );
}
