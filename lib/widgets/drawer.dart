import 'package:mashhorbazar/controllers/dashboard_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/screens/change_password_screen.dart';

import 'package:mashhorbazar/screens/change_pin.dart';

import 'package:mashhorbazar/screens/commission_group_screen.dart';

import 'package:mashhorbazar/screens/helpscreen.dart';

import 'package:mashhorbazar/screens/profile_screen.dart';

import 'package:mashhorbazar/screens/selling_price_screen.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'contact_dialogbox.dart';

import 'language_number_dialog.dart';

import 'logoutbox.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GetStorage box = GetStorage();

  String _version = "";

  @override
  void initState() {
    super.initState();

    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    if (!mounted) {
      return;
    }

    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isRtl = box.read("direction")?.toString().toLowerCase() == "rtl";

    return Container(
      height: screenHeight,
      width: 310,
      decoration: BoxDecoration(
        color: AppColors.mashhorbazarBackground,
        borderRadius: isRtl
            ? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(() {
        final bool deactivated =
            dashboardController.deactiveStatus.value.trim().toLowerCase() ==
            "deactivated";

        if (deactivated) {
          return _buildDeactivatedState();
        }

        return Column(
          children: [
            _buildDrawerHeader(isRtl: isRtl, screenHeight: screenHeight),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
                children: [
                  DrawerMenu(
                    imageLink: "assets/icons/drawerprofile.png",
                    menuName: languagesController.tr("PROFILE"),
                    onPressed: () {
                      _openPage(ProfileScreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  DrawerMenu(
                    imageLink: "assets/icons/faq.png",
                    menuName: languagesController.tr("SET_SALE_PRICE"),
                    onPressed: () {
                      _openPage(SellingPriceScreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  DrawerMenu(
                    imageLink: "assets/icons/discount.png",
                    menuName: languagesController.tr("COMMISSION_GROUP"),
                    onPressed: () {
                      _openPage(CommissionGroupScreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  DrawerMenu(
                    imageLink: "assets/icons/key.png",
                    menuName: languagesController.tr("CHANGE_PIN"),
                    onPressed: () {
                      _openPage(ChangePinScreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  DrawerMenu(
                    imageLink: "assets/icons/padlock.png",
                    menuName: languagesController.tr("CHANGE_PASSWORD"),
                    onPressed: () {
                      _openPage(ChangePasswordScreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  DrawerMenu(
                    imageLink: "assets/icons/drawerguide.png",
                    menuName: languagesController.tr("HELP"),
                    onPressed: () {
                      _openPage(Helpscreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  DrawerMenu(
                    imageLink: "assets/icons/whatsapp.png",
                    menuName: languagesController.tr("CONTACTUS"),
                    onPressed: () {
                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            contentPadding: EdgeInsets.zero,
                            content: const ContactDialogBox(),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  DrawerMenu(
                    imageLink: "assets/icons/global.png",
                    menuName: languagesController.tr("LANGUAGES"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return LanguageNumberDialog(
                            languagesController: languagesController,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  DrawerMenu(
                    imageLink: "assets/icons/logout.png",
                    menuName: languagesController.tr("LOGOUT"),
                    isDanger: true,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            content: LogoutDialogBox(),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.06),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 15,
                          color: AppColors.fontColor,
                        ),
                        const SizedBox(width: 6),
                        NText(
                          text:
                              "${languagesController.tr("VERSION")} ${_version.isEmpty ? "..." : _version}",
                          color: AppColors.fontColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDrawerHeader({
    required bool isRtl,
    required double screenHeight,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 46, 18, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C78E8),
            AppColors.primaryColor,
            Color(0xFF004494),
          ],
        ),
        borderRadius: isRtl
            ? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(26),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(26),
              ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -55,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: 74,
                width: 74,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withOpacity(0.24)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Image.asset(
                    "assets/icons/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Obx(() {
                  final userInfo =
                      dashboardController.alldashboardData.value.data?.userInfo;

                  final resellerName = userInfo?.resellerName?.toString() ?? "";

                  final contactName = userInfo?.contactName?.toString() ?? "";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NText(
                        text: resellerName.isNotEmpty
                            ? resellerName
                            : contactName,
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (contactName.isNotEmpty &&
                          contactName != resellerName) ...[
                        const SizedBox(height: 4),
                        NText(
                          text: contactName,
                          color: Colors.white.withOpacity(0.68),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: NText(
                          text: languagesController.tr("PROFILE"),
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openPage(Widget page) {
    mypagecontroller.changePage(page, isMainPage: false);

    Navigator.pop(context);
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        final screenWidth = MediaQuery.of(dialogContext).size.width;

        return AlertDialog(
          title: NText(
            text: languagesController.tr("LANGUAGES"),

            color: AppColors.primaryColor,

            fontSize: 17,

            fontWeight: FontWeight.w700,
          ),

          content: SizedBox(
            height: 350,

            width: screenWidth,

            child: ListView.builder(
              shrinkWrap: true,

              itemCount: languagesController.alllanguagedata.length,

              itemBuilder: (context, index) {
                final data = languagesController.alllanguagedata[index];

                return GestureDetector(
                  onTap: () async {
                    await _changeLanguage(data, dialogContext);
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),

                    height: 45,

                    width: screenWidth,

                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,

                        color: AppColors.primaryColor.withOpacity(0.08),
                      ),

                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      child: Align(
                        alignment: Alignment.centerLeft,

                        child: NText(
                          text: data["fullname"].toString(),

                          color: AppColors.primaryColor,

                          fontSize: 13,

                          fontWeight: FontWeight.w600,

                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _changeLanguage(
    Map<String, dynamic> data,

    BuildContext dialogContext,
  ) async {
    final String languageName = data["name"]?.toString() ?? "En";

    final matched = languagesController.alllanguagedata.firstWhere(
      (language) => language["name"] == languageName,

      orElse: () => {
        "name": "En",

        "isoCode": "en",

        "region": "US",

        "direction": "ltr",
      },
    );

    final String languageISO = matched["isoCode"]?.toString() ?? "en";

    final String languageRegion = matched["region"]?.toString() ?? "US";

    final String languageDirection = matched["direction"]?.toString() ?? "ltr";

    /// Save selected language information

    await box.write("language", languageName);

    await box.write("language_iso", languageISO);

    await box.write("language_region", languageRegion);

    await box.write("direction", languageDirection);

    /// Change app internal language

    languagesController.changeLanguage(languageName);

    /// EasyLocalization locale

    final Locale locale = Locale(languageISO, languageRegion);

    if (!dialogContext.mounted) return;

    await EasyLocalization.of(dialogContext)?.setLocale(locale);

    if (dialogContext.mounted) {
      Navigator.pop(dialogContext);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildDeactivatedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE9EEF5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: const Icon(
                  Icons.block_rounded,
                  color: Colors.redAccent,
                  size: 35,
                ),
              ),
              const SizedBox(height: 16),
              NText(
                text: dashboardController.deactivateMessage.value.toString(),
                color: const Color(0xFF263B54),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                height: 1.45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    super.key,
    required this.menuName,
    required this.imageLink,
    required this.onPressed,
    this.isDanger = false,
  });

  final String menuName;
  final String imageLink;
  final VoidCallback onPressed;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isDanger
        ? const Color(0xFFE05263)
        : const Color(0xFF263B54);

    final Color iconColor = isDanger
        ? const Color(0xFFE05263)
        : AppColors.primaryColor;

    final Color iconBackground = isDanger
        ? const Color(0xFFFFECEF)
        : AppColors.secondaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDanger
                  ? const Color(0xFFE05263).withOpacity(0.08)
                  : AppColors.primaryColor.withOpacity(0.055),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Image.asset(
                  imageLink,
                  color: iconColor,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.circle_outlined,
                      color: iconColor,
                      size: 20,
                    );
                  },
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: NText(
                  text: menuName,
                  color: foreground,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: foreground.withOpacity(0.34),
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
