// lib/pages/contacts_page.dart
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:secret_calculator/functions/storage_permission_check.dart';
import 'package:secret_calculator/models/contact_model.dart';
import 'package:secret_calculator/pages/contact_pages/image_picker_contact_page.dart'; // Обновлённый путь
import 'package:secret_calculator/pages/settings_pages/setting_page.dart';
import 'package:secret_calculator/ui/colors.dart';
import 'package:secret_calculator/functions/perminssion_denied_snackbar.dart';
import 'package:secret_calculator/pages/contact_pages/contact_view_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  bool selectionEnabled = false;
  List<int> selectedContactKeys = [];
  final NotchBottomBarController _controller =
      NotchBottomBarController(); // Инициализация контроллера

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Contacts"),
          leading: IconButton(
            icon: const Icon(Icons.lock_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [actionButton()],
        ),
        body: FutureBuilder<Box<Contact>>(
          future: Hive.openBox<Contact>('contacts'),
          builder: (context, contactBoxSnapshot) {
            if (contactBoxSnapshot.hasError) {
              return Center(
                child: Text(contactBoxSnapshot.error.toString()),
              );
            }
            if (contactBoxSnapshot.hasData && contactBoxSnapshot.data != null) {
              return ValueListenableBuilder<Box<Contact>>(
                valueListenable: contactBoxSnapshot.data!.listenable(),
                builder: (context, contactBox, child) {
                  final contacts = contactBox.values.toList();
                  if (contacts.isEmpty) {
                    return const Center(child: Text("Add Contacts Here!"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return contactListItem(context, contact,
                          selectedContactKeys.contains(contact.key));
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 90.0),
          child: FloatingActionButton(
            onPressed: () async {
              storagePermissionCheck(
                onPermissionGranted: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePickerPage(
                        isForContact: true,
                        controller: _controller, // Передача контроллера
                      ),
                    ),
                  );
                },
                onPermissionDenied: () => permissionDeniedSnackBar(context),
              );
            },
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ),
    );
  }

  Widget actionButton() {
    if (selectedContactKeys.isEmpty) {
      return IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        ),
        icon: const Icon(Icons.settings),
      );
    } else {
      return IconButton(
        onPressed: () {
          final box = Hive.box<Contact>('contacts');
          for (var key in selectedContactKeys) {
            box.delete(key);
          }
          selectionEnabled = false;
          selectedContactKeys.clear();
          setState(() {});
        },
        icon: const Icon(Icons.delete),
      );
    }
  }

  Widget contactListItem(BuildContext context, Contact contact, bool selected) {
    return GestureDetector(
      onTap: () {
        if (selectionEnabled) {
          setState(() {
            if (selected) {
              selectedContactKeys.remove(contact.key);
              if (selectedContactKeys.isEmpty) selectionEnabled = false;
            } else {
              selectedContactKeys.add(contact.key as int);
            }
          });
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactViewPage(contact: contact),
          ),
        );
      },
      onLongPress: () {
        HapticFeedback.lightImpact();
        setState(() {
          selectionEnabled = true;
          selectedContactKeys.add(contact.key as int);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              selected ? secondaryColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            contact.photoBytes != null
                ? CircleAvatar(
                    backgroundImage: MemoryImage(contact.photoBytes!),
                    radius: 24,
                  )
                : const CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 24,
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    contact.phoneNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    contact.telegrammLink != null
                        ? '@${contact.telegrammLink}' // Добавляем префикс @, если никнейм существует
                        : 'Telegram not available', // Сообщение, если никнейм отсутствует
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w500, // Немного утолщаем шрифт для красоты
                      color: Colors.blueAccent, // Цвет ссылки или никнейма
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: secondaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    if (selectionEnabled) {
      setState(() {
        selectionEnabled = false;
        selectedContactKeys.clear();
      });
      return false;
    } else {
      return true;
    }
  }
}
