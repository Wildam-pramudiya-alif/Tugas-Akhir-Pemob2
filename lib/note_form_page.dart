import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'note.dart';
import 'note_db.dart';

class NoteFormPage extends StatefulWidget {
  final Note? note;
  const NoteFormPage({super.key, this.note});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _contentC = TextEditingController();

  DateTime? _deadline;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();

    // Jika edit note → isi data lama
    if (_isEdit) {
      _titleC.text = widget.note!.title;
      _contentC.text = widget.note!.content;
      _deadline = widget.note!.deadline;
    }
  }

  @override
  void dispose() {
    _titleC.dispose();
    _contentC.dispose();
    super.dispose();
  }

  // =====================
  // SIMPAN NOTE
  // =====================
  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final note = Note(
      id: widget.note?.id,
      title: _titleC.text.trim(),
      content: _contentC.text.trim(),
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      deadline: _deadline,
    );

    await NoteDb.instance.insert(note);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // =====================
  // HAPUS NOTE
  // =====================
  Future<void> _onDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && widget.note?.id != null) {
      await NoteDb.instance.delete(widget.note!.id!);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deadlineText = _deadline == null
        ? 'Tanpa deadline (Non-priority)'
        : DateFormat('dd MMM yyyy').format(_deadline!);

    final previewColor = noteColorByDeadline(_deadline);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Note' : 'Tambah Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // PREVIEW WARNA
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: previewColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Preview warna (berdasarkan deadline)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              // JUDUL
              TextFormField(
                controller: _titleC,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Judul tidak boleh kosong'
                        : null,
              ),
              const SizedBox(height: 12),

              // ISI
              TextFormField(
                controller: _contentC,
                decoration: const InputDecoration(
                  labelText: 'Isi',
                  border: OutlineInputBorder(),
                ),
                minLines: 4,
                maxLines: 8,
                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Isi tidak boleh kosong'
                        : null,
              ),
              const SizedBox(height: 16),

              // DEADLINE TEXT
              Text('Deadline: $deadlineText'),
              const SizedBox(height: 8),

              // DEADLINE BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _deadline ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setState(() {
                            _deadline = picked;
                          });
                        }
                      },
                      child: const Text('Pilih Deadline'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _deadline = null;
                        });
                      },
                      child: const Text('Hapus Deadline'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // SIMPAN
              ElevatedButton(
                onPressed: _onSave,
                child: const Text('Simpan'),
              ),

              // HAPUS (HANYA SAAT EDIT)
              if (_isEdit) ...[
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: _onDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Hapus Catatan'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}