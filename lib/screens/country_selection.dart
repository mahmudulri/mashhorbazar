import 'package:mashhorbazar/controllers/bundle_controller.dart';

import 'package:mashhorbazar/controllers/country_list_controller.dart';

import 'package:mashhorbazar/controllers/service_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/models/country_list_model.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'recharge_screen.dart';

class InternetPack extends StatefulWidget {
  const InternetPack({super.key});

  @override
  State<InternetPack> createState() => _InternetPackState();
}

class _InternetPackState extends State<InternetPack> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  final BundleController bundleController = Get.put(BundleController());

  final ServiceController serviceController = Get.put(ServiceController());

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
            const SizedBox(height: 14),
            _buildBookingHeader(),
            const SizedBox(height: 14),
            Expanded(child: _buildCountryList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
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
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -65,
            right: -55,
            child: Container(
              height: 160,
              width: 160,
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    NText(
                      text: languagesController.tr("COUNTRY_SELECTION"),
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    NText(
                      text: languagesController.tr("BOOKING_FOR"),
                      color: Colors.white.withOpacity(0.66),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildBookingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF153C68).withOpacity(0.055),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.public_rounded,
                color: AppColors.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NText(
                    text: languagesController.tr("BOOKING_FOR"),
                    color: AppColors.fontColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 3),
                  NText(
                    text: languagesController.tr("COUNTRY_SELECTION"),
                    color: const Color(0xFF172D49),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: AppColors.mashhorbazarBackground,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryColor,
                size: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (countrylistController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final countries = countrylistController.finalCountryList;

        if (countries.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 70),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 42,
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
                      height: 66,
                      width: 66,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.public_off_outlined,
                        color: AppColors.primaryColor,
                        size: 31,
                      ),
                    ),
                    const SizedBox(height: 14),
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
          );
        }

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 110),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 11,
            mainAxisSpacing: 11,
            mainAxisExtent: 170,
          ),
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final Country data = countries[index];
            return _buildCountryCard(data);
          },
        );
      }),
    );
  }

  Widget _buildCountryCard(Country data) {
    final flagUrl = data.countryFlagImageUrl?.toString() ?? "";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _selectCountry(data);
        },
        borderRadius: BorderRadius.circular(21),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(12, 13, 12, 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: const Color(0xFFE9EEF5)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF153C68).withOpacity(0.045),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 68,
                width: 68,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: flagUrl.isEmpty
                      ? const Icon(
                          Icons.flag_outlined,
                          color: AppColors.primaryColor,
                          size: 27,
                        )
                      : Image.network(
                          flagUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.flag_outlined,
                              color: AppColors.primaryColor,
                              size: 27,
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 10),
              NText(
                text: data.countryName ?? "",
                color: const Color(0xFF172D49),
                fontSize: 12.8,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Container(
                height: 29,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primaryColor,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectCountry(Country selectedCountry) {
    final enableOperatorLookup = selectedCountry.enableOperatorLookup;

    box.write("country_id", selectedCountry.id);

    box.write("countryName", selectedCountry.countryName ?? "");

    box.write("maxlength", selectedCountry.phoneNumberLength ?? "");

    box.write("enable_operator_lookup", enableOperatorLookup);

    box.write("validity_type", "");

    box.write("company_id", "");

    box.write("search_tag", "");

    serviceController.reserveDigit.clear();

    bundleController.resetBundles();

    mypagecontroller.changePage(
      RechargeScreen(enableOperatorLookup: enableOperatorLookup),

      isMainPage: false,
    );
  }
}
