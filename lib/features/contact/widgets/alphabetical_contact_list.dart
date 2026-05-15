import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/constants/app_images.dart';

class AlphabeticalContactList extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;
  final ScrollController? scrollController;

  const AlphabeticalContactList({
    super.key,
    required this.contacts,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Sort contacts alphabetically
    final sortedContacts = List<Map<String, dynamic>>.from(contacts)
      ..sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));

    // Group by first letter
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var contact in sortedContacts) {
      String firstLetter = contact['name'][0].toString().toUpperCase();
      if (!grouped.containsKey(firstLetter)) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(contact);
    }

    final letters = grouped.keys.toList()..sort();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        String letter = letters[index];
        List<Map<String, dynamic>> letterContacts = grouped[letter]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alphabet Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                letter,
                style: AppTypography.subtitle1.copyWith(
                  color: isDark ? AppColors.darkTextHint : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            // Contacts for this letter
            ...letterContacts.map((contact) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                leading: ClipOval(
                  child:
                      contact['avatar'] != null &&
                          contact['avatar'].toString().isNotEmpty
                      ? Image.network(
                          contact['avatar'],
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          AppImages.image,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                ),
                title: Text(
                  contact['name'],
                  style: AppTypography.bodyLarge.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  contact['status'] ?? 'Hey there! I am using Mini Chat.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.chatDetailPage,
                    arguments: {
                      'name': contact['name'] ?? '',
                      'avatar': contact['avatar'] ?? '',
                      'status': contact['status'] ?? 'Online',
                      'otherUserId': contact['uid'] ?? '',
                      'conversationId': '',
                    },
                  );
                },
              );
            }),
            const Divider(height: 1),
          ],
        );
      },
    );
  }
}
