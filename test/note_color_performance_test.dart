import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_akhir_pemob2/note.dart';

// Versi optimized (contoh): "today" dihitung sekali
Color noteColorByDeadlineOptimized(DateTime? deadline, DateTime today) {
  if (deadline == null) return Colors.yellow.shade300;

  final dl = DateTime(deadline.year, deadline.month, deadline.day);
  final diffDays = dl.difference(today).inDays;

  if (diffDays < 0) return Colors.red.shade900;
  if (diffDays <= 1) return Colors.red.shade400;
  if (diffDays <= 3) return Colors.orange.shade400;
  if (diffDays <= 7) return Colors.lightGreen.shade400;
  return Colors.green.shade400;
}


void main() {
  test(
    'Performance compare: original vs optimized noteColorByDeadline',
    () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final deadlines = List<DateTime?>.generate(200000, (i) {
        if (i % 10 == 0) return null;
        return today.add(Duration(days: (i % 30) - 10));
      }); // List.generate

      final swOriginal = Stopwatch()..start();
      for (final d in deadlines) {
        noteColorByDeadline(d);
      }
      swOriginal.stop();
      final swOptimized = Stopwatch()..start();
for (final d in deadlines) {
  noteColorByDeadlineOptimized(d, today);
}
swOptimized.stop();

// Output untuk laporan praktikum
// ignore: avoid_print
print('Original ms: ${swOriginal.elapsedMilliseconds}');
// ignore: avoid_print
print('Optimized ms: ${swOptimized.elapsedMilliseconds}');

// sanity check
expect(noteColorByDeadline(null), Colors.yellow.shade300);

    },
  );
}

