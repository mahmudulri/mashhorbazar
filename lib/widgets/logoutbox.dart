import 'package:mashhorbazar/controllers/sign_in_controller.dart';
import 'package:mashhorbazar/global_controller/fcm_device_token_controller.dart';
import 'package:mashhorbazar/global_controller/languages_controller.dart';
import 'package:mashhorbazar/global_controller/page_controller.dart';
import 'package:mashhorbazar/pages/homepages.dart';
import 'package:mashhorbazar/screens/sign_in_screen.dart';
import 'package:mashhorbazar/utils/colors.dart';
import 'package:mashhorbazar/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LogoutDialogBox extends StatelessWidget {
  LogoutDialogBox({super.key});

  final SignInController signInController = Get.find<SignInController>();

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          const SizedBox(height: 18),
          _buildMessage(),
          const SizedBox(height: 20),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 58,
      width: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F2),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE05263).withOpacity(0.12)),
      ),
      child: const Icon(
        Icons.logout_rounded,
        color: Color(0xFFE05263),
        size: 27,
      ),
    );
  }

  Widget _buildMessage() {
    return Column(
      children: [
        NText(
          text: languagesController.tr("DO_YOU_WANT_TO_LOG_OUT"),
          color: AppColors.primaryColor,
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          height: 1.35,
        ),
        const SizedBox(height: 7),
        NText(
          text: languagesController.tr("LOGOUT"),
          color: AppColors.fontColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () async {
              await _logout();
            },
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE05263), Color(0xFFC73C4E)],
                ),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE05263).withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: NText(
                      text: languagesController.tr("YES_IAMGOING_OUT"),
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          flex: 2,
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
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _logout() async {
    signInController.usernameController.clear();
    signInController.passwordController.clear();

    final FcmDeviceTokenController fcmController =
        Get.find<FcmDeviceTokenController>();

    await fcmController.disableTokenBeforeLogout();

    box.remove("userToken");

    mypagecontroller.changePage(const Homepages(), isMainPage: false);

    Get.to(() => SignInScreen());
  }
}
