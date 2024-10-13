// lib/pages/contact_view_page.dart
import 'package:flutter/material.dart';
import 'package:secret_calculator/models/contact_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactViewPage extends StatelessWidget {
  final Contact contact;

  const ContactViewPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            contact.photoBytes != null
                ? CircleAvatar(
                    backgroundImage: MemoryImage(contact.photoBytes!),
                    radius: 60,
                  )
                : const CircleAvatar(
                    child: Icon(Icons.person, size: 60),
                    radius: 60,
                  ),
            const SizedBox(height: 24),
            Text(
              contact.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contact.phoneNumber,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            // Если есть телеграмм, показываем ник и ссылку
            if (contact.telegrammLink != null) ...[
              Text(
                '@${contact.telegrammLink}', // Отображаем никнейм с @
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey, // Цвет никнейма
                ),
              ),
              const SizedBox(height: 8),

              // Активная ссылка на профиль в телеграмм
              GestureDetector(
                onTap: () {
                  final telegramUrl = 'https://t.me/${contact.telegrammLink}';
                  launch(
                      telegramUrl); // Открывает ссылку на профиль в браузере или приложении
                },
                child: Text(
                  'Open Telegram Profile',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue, // Цвет активной ссылки
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ] else ...[
              // Если никнейм отсутствует
              const Text(
                'Telegram not available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
