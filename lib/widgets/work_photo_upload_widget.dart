import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkPhotoUploadWidget extends StatefulWidget {
  final Function(List<File>) onImageSelected;
  final List<File>? initialImages;
  final bool isEditable; // 편집 가능 여부
  final String mode; // "register" or "complete"

  const WorkPhotoUploadWidget({
    super.key,
    required this.onImageSelected,
    this.initialImages,
    this.isEditable = true,
    required this.mode, // 모드 추가
  });

  @override
  State<WorkPhotoUploadWidget> createState() => _WorkPhotoUploadWidgetState();
}

class _WorkPhotoUploadWidgetState extends State<WorkPhotoUploadWidget> {
  List<File> imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialImages != null) {
      imageFiles = List.from(widget.initialImages!);
    }
  }

  Future<void> _pickImage() async {
    if (!widget.isEditable) return; // 편집 불가능하면 동작 X

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        imageFiles.insert(0, File(pickedFile.path));
      });
      widget.onImageSelected(imageFiles);
    }
  }

  void _removeImage(File file) {
    if (!widget.isEditable) return; // 편집 불가능하면 동작 X

    setState(() {
      imageFiles.remove(file);
    });
    widget.onImageSelected(imageFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: widget.mode == "register" ? const Color(0xFFF2994A) : Colors.green),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mode == "register" ? "작업 사진" : "작업 완료 사진",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.mode == "register" ? const Color(0xFFF2994A) : Colors.green,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.camera_alt, size: 16, color: Colors.orange),
                  const SizedBox(width: 5),
                  Text(widget.mode == "register" ? "작업 사진 등록" : "완료 사진 등록", style: const TextStyle(fontSize: 14)),
                ],
              ),
              Text("${imageFiles.length} 장", style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (widget.isEditable)
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.shade100,
                    ),
                    child: const Center(
                      child: Text(
                        "+",
                        style: TextStyle(fontSize: 28, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: imageFiles.map((file) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.file(file, width: 70, height: 70, fit: BoxFit.cover),
                            ),
                            if (widget.isEditable)
                              GestureDetector(
                                onTap: () => _removeImage(file),
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}