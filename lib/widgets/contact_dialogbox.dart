import 'dart:io';

import 'package:mashhorbazar/global_controller/languages_controller.dart';
import 'package:mashhorbazar/utils/colors.dart';
import 'package:mashhorbazar/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDialogBox extends StatelessWidget {
  const ContactDialogBox({super.key});

  static const String _contactNumber = "+93796321768";
  static const String _defaultMessage = "Hi, I need some help";

  @override
  Widget build(BuildContext context) {
    final LanguagesController languagesController = Get.put(
      LanguagesController(),
    );

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 430),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.10),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWhatsAppIcon(),
          const SizedBox(height: 16),
          NText(
            text: languagesController.tr("WHATSAPP_TITLE"),
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            textAlign: TextAlign.center,
            height: 1.4,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          _buildActions(context, languagesController),
        ],
      ),
    );
  }

  Widget _buildWhatsAppIcon() {
    return Container(
      height: 72,
      width: 72,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF25D366).withOpacity(0.10),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF25D366).withOpacity(0.14)),
      ),
      child: Image.asset("assets/icons/whatsapp2.png", fit: BoxFit.contain),
    );
  }

  Widget _buildActions(
    BuildContext context,
    LanguagesController languagesController,
  ) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              Navigator.pop(context);

              await whatsapp();
            },
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF25D366), Color(0xFF1EBE5D)],
                ),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF25D366).withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 7),
                  NText(
                    text: languagesController.tr("YES"),
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.055),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.06),
                ),
              ),
              child: NText(
                text: languagesController.tr("CANCEL"),
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> whatsapp() async {
    final encodedMessage = Uri.encodeComponent(_defaultMessage);

    final androidUri = Uri.parse(
      "whatsapp://send?phone=$_contactNumber&text=$encodedMessage",
    );

    final iosUri = Uri.parse(
      "https://wa.me/$_contactNumber?text=$encodedMessage",
    );

    final targetUri = Platform.isIOS ? iosUri : androidUri;

    try {
      final launched = await launchUrl(
        targetUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && !Platform.isIOS) {
        await launchUrl(iosUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(iosUri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
  }
}
