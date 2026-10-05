import 'package:mashhorbazar/controllers/change_pin_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final ChangePinController changePinController = Get.put(
    ChangePinController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.mashhorbazarBackground,

        statusBarIconBrightness: Brightness.dark,

        statusBarBrightness: Brightness.light,

        systemNavigationBarColor: AppColors.mashhorbazarBackground,

        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.mashhorbazarBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 28),
                children: [
                  _buildSecurityCard(),
                  const SizedBox(height: 12),
                  _buildChangePinForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C78E8),
            AppColors.primaryColor,
            Color(0xFF004494),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -58,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Row(
            children: [
              _headerButton(
                onTap: mypagecontroller.goBack,
                icon: Icons.arrow_back_rounded,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    NText(
                      text: languagesController.tr("CHANGE_PIN"),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    NText(
                      text: languagesController.tr("SECURITY"),
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _headerButton(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Icons.menu_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerButton({required VoidCallback onTap, required IconData icon}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppColors.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NText(
                  text: languagesController.tr("CHANGE_PIN"),
                  color: const Color(0xFF172D49),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                NText(
                  text: languagesController.tr("SECURITY"),
                  color: AppColors.fontColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.security_rounded,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePinForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(languagesController.tr("OLD_PIN")),
          const SizedBox(height: 7),
          ChangePinBox(
            hintText: languagesController.tr("ENTER_YOUR_OLD_PIN"),
            controller: changePinController.oldPinController,
            icon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: 14),
          _fieldLabel(languagesController.tr("NEW_PIN")),
          const SizedBox(height: 7),
          ChangePinBox(
            hintText: languagesController.tr("ENTER_YOUR_NEW_PIN"),
            controller: changePinController.newPinController,
            icon: Icons.key_rounded,
          ),
          const SizedBox(height: 20),
          Obx(
            () => GestureDetector(
              onTap: changePinController.isLoading.value ? null : _changePin,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: changePinController.isLoading.value
                      ? AppColors.primaryColor.withOpacity(0.45)
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: changePinController.isLoading.value
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                ),
                alignment: Alignment.center,
                child: changePinController.isLoading.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 9),
                          NText(
                            text: languagesController.tr("PLEASE_WAIT"),
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 7),
                          NText(
                            text: languagesController.tr("CHANGE_NOW"),
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return NText(
      text: label,
      color: const Color(0xFF42556D),
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );
  }

  void _changePin() {
    if (changePinController.oldPinController.text.isEmpty ||
        changePinController.newPinController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: languagesController.tr("FILL_DATA_CORRECTLY"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.BOTTOM,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.black,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    changePinController.change();
  }
}

class ChangePinBox extends StatelessWidget {
  const ChangePinBox({
    super.key,

    required this.hintText,

    required this.controller,

    required this.icon,
  });

  final String hintText;

  final TextEditingController controller;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 11),
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF263B54),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.72),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
