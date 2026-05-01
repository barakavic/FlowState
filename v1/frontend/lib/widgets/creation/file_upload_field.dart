import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadField extends StatefulWidget {
  final String label;
  final List<String> allowedExtensions;
  final Function(PlatformFile) onFileSelected;

  const FileUploadField({
    super.key,
    required this.label,
    required this.allowedExtensions,
    required this.onFileSelected,
  });

  @override
  State<FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.allowedExtensions,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
      widget.onFileSelected(_selectedFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedFile == null ? Icons.upload_file : Icons.check_circle,
                  color: _selectedFile == null ? Colors.blue : Colors.green,
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedFile?.name ?? 'Select File (${widget.allowedExtensions.join(", ")})',
                  style: TextStyle(
                    color: _selectedFile == null ? Colors.white38 : Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
