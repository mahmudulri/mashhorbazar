import 'package:mashhorbazar/controllers/help_controller.dart';
import 'package:mashhorbazar/global_controller/languages_controller.dart';
import 'package:mashhorbazar/global_controller/page_controller.dart';
import 'package:mashhorbazar/utils/colors.dart';
import 'package:mashhorbazar/widgets/custom_text.dart';
import 'package:mashhorbazar/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Helpscreen extends StatefulWidget {
  const Helpscreen({super.key});

  @override
  State<Helpscreen> createState() => _HelpscreenState();
}

class _HelpscreenState extends State<Helpscreen> {
  final HelpController helpController = Get.find<HelpController>();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

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

    helpController.helpService();
  }

  Future<void> _refreshHelp() async {
    helpController.helpService();

    await Future<void>.delayed(const Duration(milliseconds: 450));
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
            const SizedBox(height: 10),
            Expanded(child: _buildHelpContent()),
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
                onTap: () {
                  mypagecontroller.goBack();
                },
                icon: Icons.arrow_back_rounded,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    NText(
                      text: languagesController.tr("GUIDE"),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    NText(
                      text: languagesController.tr("GUIDE"),
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

  Widget _buildHelpContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (helpController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final articles = helpController.helpdata.value.data?.articles ?? [];

        if (articles.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshHelp,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 70),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 38,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.06),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF153C68).withOpacity(0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.help_outline_rounded,
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 13),
                      NText(
                        text: languagesController.tr("NO_DATA_FOUND"),
                        color: AppColors.fontColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: Colors.white,
          onRefresh: _refreshHelp,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: articles.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              final data = articles[index];

              return _buildHelpCard(
                title: data.title?.toString() ?? "",
                description: data.description?.toString() ?? "",
                index: index,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildHelpCard({
    required String title,
    required String description,
    required int index,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.035),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(10, 6, 9, 6),
          childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          leading: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          title: NText(
            text: title,
            color: const Color(0xFF172D49),
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            height: 1.25,
          ),
          trailing: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFE8EEF5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.question_answer_outlined,
                      color: AppColors.primaryColor,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: NText(
                      text: description,
                      color: const Color(0xFF42556D),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
