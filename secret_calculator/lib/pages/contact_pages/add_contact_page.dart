// lib/pages/add_contact_page.dart

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:secret_calculator/models/contact_model.dart';
import 'package:photo_manager/photo_manager.dart';

class AddContactPage extends StatefulWidget {
  final AssetEntity selectedAsset;
  final NotchBottomBarController controller; // Добавим контроллер
  const AddContactPage({
    super.key,
    required this.selectedAsset,
    required this.controller,
  });

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _telegrammLinkController =
      TextEditingController();

  Uint8List? _imageBytes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final bytes = await widget.selectedAsset.originBytes;
    setState(() {
      _imageBytes = bytes;
    });
  }

  void _saveContact() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final telegrammLink = _telegrammLinkController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and phone number cannot be empty")),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final contact = Contact(
      name: name,
      phoneNumber: phone,
      telegrammLink: telegrammLink,
      photoBytes: _imageBytes,
    );

    await Hive.box<Contact>('contacts').add(contact);

    setState(() {
      _isSaving = false;
    });
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const ContactsPage()),
    //   );
    // }

    // Navigator.popUntil(
    //     context, (route) => route.isActive); // Возврат к списку контактов
    // Переключаемся на экран контактов
    widget.controller.jumpTo(2);

    // Закрываем текущий экран
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _imageBytes == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  CircleAvatar(
                    backgroundImage: MemoryImage(_imageBytes!),
                    radius: 60,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _telegrammLinkController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9_]')), // Только допустимые символы
                      LengthLimitingTextInputFormatter(
                          32), // Ограничение длины до 32 символов
                    ],
                    decoration: InputDecoration(
                      labelText: "Telegram Nickname",
                      prefixText: '@', // Префикс "@" для никнейма
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveContact,
                    child: _isSaving
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Save Contact"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
