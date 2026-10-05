import 'package:mashhorbazar/controllers/service_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'social_bundles.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceController serviceController = Get.find<ServiceController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GetStorage box = GetStorage();

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

    serviceController.fetchservices();
  }

  Future<void> _refreshServices() async {
    serviceController.fetchservices();

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
            Expanded(child: _buildServiceGrid()),
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
        borderRadius: BorderRadius.circular(25),
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
      child: Row(
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
                  text: languagesController.tr("SERVICES"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("SERVICES"),
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
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

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),

        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.045),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: AppColors.primaryColor.withOpacity(0.08)),
        ),

        child: Row(
          children: [
            Container(
              height: 42,

              width: 42,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primarycolor2,

                    AppColors.mashhorbazarTurquoise,
                  ],
                ),

                borderRadius: BorderRadius.circular(13),
              ),

              child: const Icon(
                Icons.apps_rounded,

                color: Colors.white,

                size: 21,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: NText(
                text: languagesController.tr("SERVICES"),

                color: AppColors.primaryColor,

                fontSize: 14,

                fontWeight: FontWeight.w700,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,
              ),
            ),

            GestureDetector(
              onTap: () {
                serviceController.fetchservices();
              },

              child: Container(
                height: 34,

                width: 34,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: AppColors.mashhorbazarTurquoise.withOpacity(0.08),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: const Icon(
                  Icons.refresh_rounded,

                  color: AppColors.mashhorbazarTurquoise,

                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (serviceController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final services =
            serviceController.allserviceslist.value.data?.services ?? [];

        if (services.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshServices,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 70),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.06),
                    ),
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
                          Icons.apps_outlined,
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

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 520
                ? 4
                : constraints.maxWidth >= 340
                ? 3
                : 2;

            return RefreshIndicator(
              color: AppColors.primaryColor,
              backgroundColor: Colors.white,
              onRefresh: _refreshServices,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 110),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 9,
                  mainAxisSpacing: 9,
                  mainAxisExtent: 112,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return _buildServiceCard(services[index]);
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildServiceCard(dynamic data) {
    final companyName = data.company?.companyName?.toString() ?? "";

    final logo = data.company?.companyLogo?.toString() ?? "";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          box.write("company_id", data.companyId);

          mypagecontroller.changePage(const SocialBundles(), isMainPage: false);
        },
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(7, 8, 7, 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFE9EEF5)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF153C68).withOpacity(0.04),
                blurRadius: 9,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    height: 58,
                    width: 58,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: logo,
                        fit: BoxFit.contain,
                        placeholder: (_, __) {
                          return const Center(
                            child: SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.2,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        },
                        errorWidget: (_, __, ___) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.primaryColor,
                            size: 23,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              NText(
                text: companyName,
                color: const Color(0xFF172D49),
                fontSize: 9.8,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
