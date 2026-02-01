import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tugas_akhir_pemob2/note_form_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'NoteFormPage shows validation errors when fields are empty',
    (WidgetTester tester) async {
      // Render halaman form
      await tester.pumpWidget(
        const MaterialApp(
          home: NoteFormPage(),
        ),
      );

      // Tekan tombol Simpan tanpa input
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      // Validasi error muncul
      expect(
        find.text('Judul tidak boleh kosong'),
        findsOneWidget,
      );
      expect(
        find.text('Isi tidak boleh kosong'),
        findsOneWidget,
      );
    },
  );
}
