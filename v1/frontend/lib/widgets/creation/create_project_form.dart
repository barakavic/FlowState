import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'file_upload_field.dart';
import 'markdown_input.dart';

class CreateProjectForm extends StatefulWidget {
  final Function(String title, String? text, PlatformFile? file) onSubmit;

  const CreateProjectForm({super.key, required this.onSubmit});

  @override
  State<CreateProjectForm> createState() => _CreateProjectFormState();
}

class _CreateProjectFormState extends State<CreateProjectForm> {
  final _titleController = TextEditingController();
  final _mdController = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PROJECT DETAILS',
          style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Project Title',
            hintStyle: const TextStyle(color: Colors.white10),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 32),
        FileUploadField(
          label: 'UPLOAD ROADMAP (MD)',
          allowedExtensions: const ['md'],
          onFileSelected: (file) => setState(() => _selectedFile = file),
        ),
        const SizedBox(height: 24),
        const Center(child: Text('OR', style: TextStyle(color: Colors.white10, fontWeight: FontWeight.bold))),
        const SizedBox(height: 24),
        MarkdownInput(
          controller: _mdController,
          label: 'PASTE MARKDOWN',
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a project title'), backgroundColor: Colors.redAccent),
                );
                return;
              }
              if (_mdController.text.isEmpty && _selectedFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please upload a file or paste markdown'), backgroundColor: Colors.redAccent),
                );
                return;
              }
              
              widget.onSubmit(
                _titleController.text,
                _mdController.text.isNotEmpty ? _mdController.text : null,
                _selectedFile,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('PARSE ROADMAP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
