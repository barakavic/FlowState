import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'file_upload_field.dart';

class CreateBookForm extends StatefulWidget {
  final Function(String title, PlatformFile file) onSubmit;

  const CreateBookForm({super.key, required this.onSubmit});

  @override
  State<CreateBookForm> createState() => _CreateBookFormState();
}

class _CreateBookFormState extends State<CreateBookForm> {
  final _titleController = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BOOK DETAILS',
          style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Book Title',
            hintStyle: const TextStyle(color: Colors.white10),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 32),
        FileUploadField(
          label: 'UPLOAD PDF',
          allowedExtensions: const ['pdf'],
          onFileSelected: (file) => setState(() => _selectedFile = file),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a book title'), backgroundColor: Colors.redAccent),
                );
                return;
              }
              if (_selectedFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a PDF file'), backgroundColor: Colors.redAccent),
                );
                return;
              }
              widget.onSubmit(_titleController.text, _selectedFile!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('EXTRACT CHAPTERS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
