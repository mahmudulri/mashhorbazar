import 'dart:async';

import 'package:mashhorbazar/controllers/bundle_controller.dart';

import 'package:mashhorbazar/controllers/confirm_pin_controller.dart';

import 'package:mashhorbazar/controllers/service_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/helpers/price.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:mashhorbazar/widgets/number_textfield.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:lottie/lottie.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key, required this.enableOperatorLookup});

  final bool enableOperatorLookup;

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final ConfirmPinController confirmPinController =
      Get.find<ConfirmPinController>();

  final ServiceController serviceController = Get.find<ServiceController>();

  final BundleController bundleController = Get.find<BundleController>();

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GetStorage box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController scrollController = ScrollController();

  int selectedIndex = -1;

  int durationSelectedIndex = 0;

  List<Map<String, String>> duration = [];

  String inputNumber = "";

  String _lastProcessedNumber = "";

  bool isOperatorLookupConfirmed = false;

  Timer? _lookupDebounce;

  String? originalCompanyId;

  String? detectedCompanyId;

  bool get isOperatorLookupEnabled {
    final dynamic storedValue = box.read("enable_operator_lookup");

    if (storedValue is bool) {
      return storedValue;
    }

    if (storedValue is int) {
      return storedValue == 1;
    }

    final normalizedValue = storedValue?.toString().trim().toLowerCase() ?? "";

    if (normalizedValue == "true" ||
        normalizedValue == "1" ||
        normalizedValue == "yes") {
      return true;
    }

    if (normalizedValue == "false" ||
        normalizedValue == "0" ||
        normalizedValue == "no") {
      return false;
    }

    return widget.enableOperatorLookup;
  }

  int get _maximumPhoneLength {
    final storedLength = box.read("maxlength");

    return int.tryParse(storedLength?.toString() ?? "") ?? 0;
  }

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

    _initializeDuration();

    bundleController.resetBundles();

    confirmPinController.pinController.clear();

    confirmPinController.numberController.clear();

    box.write("company_id", "");

    serviceController.fetchservices();

    bundleController.fetchallbundles();

    confirmPinController.numberController.addListener(_onTextChanged);

    scrollController.addListener(_loadMoreBundles);
  }

  @override
  void dispose() {
    _lookupDebounce?.cancel();

    confirmPinController.numberController.removeListener(_onTextChanged);

    scrollController.removeListener(_loadMoreBundles);

    scrollController.dispose();

    super.dispose();
  }

  void _initializeDuration() {
    duration = [
      {"Name": languagesController.tr("All"), "Value": ""},

      {"Name": languagesController.tr("UNLIMITED"), "Value": "unlimited"},

      {"Name": languagesController.tr("MONTHLY"), "Value": "monthly"},

      {"Name": languagesController.tr("WEEKLY"), "Value": "weekly"},

      {"Name": languagesController.tr("DAILY"), "Value": "daily"},

      {"Name": languagesController.tr("HOURLY"), "Value": "hourly"},

      {"Name": languagesController.tr("NIGHTLY"), "Value": "nightly"},
    ];
  }

  Future<void> _loadMoreBundles() async {
    if (bundleController.isLoading.value ||
        bundleController.isLookupLoading.value) {
      return;
    }

    if (!scrollController.hasClients) {
      return;
    }

    final reachedBottom =
        scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 80;

    if (!reachedBottom) {
      return;
    }

    final phoneNumber = confirmPinController.numberController.text.trim();

    final requiredLength = _maximumPhoneLength;

    final isLookupModeActive =
        isOperatorLookupEnabled &&
        requiredLength > 0 &&
        phoneNumber.length == requiredLength;

    if (isLookupModeActive) {
      return;
    }

    final totalPages =
        bundleController.allbundleslist.value.payload?.pagination.totalPages ??
        0;

    if (bundleController.initialpage >= totalPages) {
      return;
    }

    bundleController.initialpage++;

    await bundleController.fetchallbundles();
  }

  Future<void> _pullRefresh() async {
    final phoneNumber = confirmPinController.numberController.text.trim();

    final requiredLength = _maximumPhoneLength;

    bundleController.initialpage = 1;

    bundleController.finalList.clear();

    if (isOperatorLookupEnabled &&
        requiredLength > 0 &&
        phoneNumber.length == requiredLength) {
      await bundleController.fetchlookupbundles(phoneNumber);

      return;
    }

    await bundleController.fetchallbundles();
  }

  void _onTextChanged() {
    if (!mounted) {
      return;
    }

    final number = confirmPinController.numberController.text.trim();

    if (number == _lastProcessedNumber) {
      return;
    }

    _lastProcessedNumber = number;

    final requiredLength = _maximumPhoneLength;

    final services =
        serviceController.allserviceslist.value.data?.services ?? [];

    String? matchedOriginalCompanyId;

    for (final service in services) {
      final companyCodes = service.company?.companycodes ?? [];

      for (final code in companyCodes) {
        final reservedDigit = code.reservedDigit?.toString().trim() ?? "";

        if (reservedDigit.isEmpty) {
          continue;
        }

        final normalizedNumber = number.startsWith("0")
            ? number.substring(1)
            : number;

        final normalizedReservedDigit = reservedDigit.startsWith("0")
            ? reservedDigit.substring(1)
            : reservedDigit;

        final prefixMatched =
            number.startsWith(reservedDigit) ||
            normalizedNumber.startsWith(normalizedReservedDigit);

        if (prefixMatched) {
          matchedOriginalCompanyId = service.companyId?.toString();

          break;
        }
      }

      if (matchedOriginalCompanyId != null) {
        break;
      }
    }

    _lookupDebounce?.cancel();

    setState(() {
      inputNumber = number;

      originalCompanyId = matchedOriginalCompanyId;

      detectedCompanyId = null;

      isOperatorLookupConfirmed = false;
    });

    if (!isOperatorLookupEnabled) {
      _handleNormalNumber(number);

      return;
    }

    if (number.isEmpty) {
      setState(() {
        originalCompanyId = null;

        detectedCompanyId = null;

        isOperatorLookupConfirmed = false;

        selectedIndex = -1;
      });

      bundleController.initialpage = 1;

      bundleController.finalList.clear();

      bundleController.fetchallbundles();

      return;
    }

    if (requiredLength <= 0 || number.length != requiredLength) {
      return;
    }

    _lookupDebounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) {
        return;
      }

      final requestedNumber = confirmPinController.numberController.text.trim();

      if (requestedNumber != number) {
        return;
      }

      if (requestedNumber.length != requiredLength) {
        return;
      }

      bundleController.initialpage = 1;

      bundleController.finalList.clear();

      try {
        await bundleController.fetchlookupbundles(requestedNumber);

        if (!mounted) {
          return;
        }

        final latestNumber = confirmPinController.numberController.text.trim();

        if (latestNumber != requestedNumber) {
          return;
        }

        String? lookupCompanyId;

        if (bundleController.finalList.isNotEmpty) {
          final firstBundle = bundleController.finalList.first;

          lookupCompanyId = firstBundle.service?.company?.id?.toString();
        }

        setState(() {
          detectedCompanyId = lookupCompanyId;

          isOperatorLookupConfirmed = lookupCompanyId != null;
        });
      } catch (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          detectedCompanyId = null;

          isOperatorLookupConfirmed = false;
        });
      }
    });
  }

  Future<void> _handleNormalNumber(String number) async {
    _lookupDebounce?.cancel();

    final cleanNumber = number.trim();

    if (cleanNumber.isEmpty) {
      box.write("company_id", "");

      setState(() {
        selectedIndex = -1;
      });

      bundleController.initialpage = 1;

      bundleController.finalList.clear();

      await bundleController.fetchallbundles();

      return;
    }

    final services =
        serviceController.allserviceslist.value.data?.services ?? [];

    String? matchedCompanyId;

    for (final service in services) {
      final companyCodes = service.company?.companycodes ?? [];

      for (final code in companyCodes) {
        final reservedDigit = code.reservedDigit?.toString().trim() ?? "";

        if (reservedDigit.isEmpty) {
          continue;
        }

        final normalizedNumber = cleanNumber.startsWith("0")
            ? cleanNumber.substring(1)
            : cleanNumber;

        final normalizedReservedDigit = reservedDigit.startsWith("0")
            ? reservedDigit.substring(1)
            : reservedDigit;

        final matched =
            cleanNumber.startsWith(reservedDigit) ||
            normalizedNumber.startsWith(normalizedReservedDigit);

        if (matched) {
          matchedCompanyId = service.companyId?.toString();

          break;
        }
      }

      if (matchedCompanyId != null) {
        break;
      }
    }

    if (matchedCompanyId == null) {
      return;
    }

    final currentCompanyId = box.read("company_id")?.toString() ?? "";

    if (currentCompanyId == matchedCompanyId) {
      return;
    }

    await box.write("company_id", matchedCompanyId);

    bundleController.initialpage = 1;

    bundleController.finalList.clear();

    await bundleController.fetchallbundles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,

      child: Scaffold(
        key: _scaffoldKey,

        drawer: const DrawerWidget(),

        resizeToAvoidBottomInset: false,

        backgroundColor: AppColors.mashhorbazarBackground,

        body: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 14),

            _buildControlPanel(),

            const SizedBox(height: 12),

            Expanded(child: _buildBundleList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final countryName = box.read("countryName")?.toString() ?? "";

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.fromLTRB(15, 8, 15, 0),

      padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),

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
                  confirmPinController.numberController.clear();

                  mypagecontroller.goBack();
                },

                icon: Icons.arrow_back_rounded,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  children: [
                    NText(
                      text:
                          "$countryName ${languagesController.tr("INTERNET_PACKAGE")}",

                      color: Colors.white,

                      fontSize: 17,

                      fontWeight: FontWeight.w800,

                      textAlign: TextAlign.center,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 3),

                    NText(
                      text: languagesController.tr("ENTER_PHONE_NUMBER"),

                      color: Colors.white.withOpacity(0.66),

                      fontSize: 8.5,

                      fontWeight: FontWeight.w500,

                      textAlign: TextAlign.center,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,
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

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFF153C68).withOpacity(0.055),

              blurRadius: 19,

              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),

                borderRadius: BorderRadius.circular(10),

                border: Border.all(color: const Color(0xFFE2E9F1)),
              ),

              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),

              child: Obx(
                () => CustomTextField(
                  confirmPinController: confirmPinController.numberController,

                  languageData: languagesController.tr("ENTER_PHONE_NUMBER"),
                ),
              ),
            ),

            const SizedBox(height: 13),

            _buildOperators(),

            const SizedBox(height: 13),

            _buildDurationFilters(),
          ],
        ),
      ),
    );
  }

  Widget _buildOperators() {
    return SizedBox(
      height: 66,

      child: Obx(() {
        final services =
            serviceController.allserviceslist.value.data?.services ?? [];

        final isFullNumber =
            _maximumPhoneLength > 0 &&
            inputNumber.length == _maximumPhoneLength;

        final filteredServices = inputNumber.isEmpty
            ? services
            : isOperatorLookupEnabled
            ? services.where((service) {
                final currentCompanyId = service.companyId?.toString() ?? "";

                final isOriginal =
                    originalCompanyId != null &&
                    currentCompanyId == originalCompanyId;

                final isDetected =
                    isFullNumber &&
                    isOperatorLookupConfirmed &&
                    detectedCompanyId != null &&
                    currentCompanyId == detectedCompanyId;

                return isOriginal || isDetected;
              }).toList()
            : services.where((service) {
                return service.company?.companycodes?.any((code) {
                      final reservedDigit =
                          code.reservedDigit?.toString() ?? "";

                      return reservedDigit.isNotEmpty &&
                          inputNumber.startsWith(reservedDigit);
                    }) ??
                    false;
              }).toList();

        if (serviceController.isLoading.value) {
          return const Center(
            child: SizedBox(
              height: 20,

              width: 20,

              child: CircularProgressIndicator(
                strokeWidth: 1.5,

                color: AppColors.mashhorbazarTurquoise,
              ),
            ),
          );
        }

        if (filteredServices.isEmpty) {
          return Center(
            child: NText(
              text: languagesController.tr("NO_DATA_FOUND"),

              color: AppColors.fontColor,

              fontSize: 11,

              fontWeight: FontWeight.w600,
            ),
          );
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,

          physics: const BouncingScrollPhysics(),

          itemCount: filteredServices.length,

          separatorBuilder: (context, index) {
            return const SizedBox(width: 8);
          },

          itemBuilder: (context, index) {
            final data = filteredServices[index];

            final currentCompanyId = data.companyId?.toString() ?? "";

            final isDetectedOperator =
                isOperatorLookupEnabled &&
                isOperatorLookupConfirmed &&
                inputNumber.length == _maximumPhoneLength &&
                detectedCompanyId != null &&
                currentCompanyId == detectedCompanyId;

            final isPorted =
                isOperatorLookupConfirmed &&
                inputNumber.length == _maximumPhoneLength &&
                originalCompanyId != null &&
                detectedCompanyId != null &&
                originalCompanyId != detectedCompanyId;

            final showPortedBadge = isDetectedOperator && isPorted;

            final isSelected =
                isOperatorLookupEnabled &&
                    isOperatorLookupConfirmed &&
                    inputNumber.length == _maximumPhoneLength
                ? isDetectedOperator
                : selectedIndex == index;

            return _operatorCard(
              data: data,

              index: index,

              isSelected: isSelected,

              showPortedBadge: showPortedBadge,
            );
          },
        );
      }),
    );
  }

  Widget _operatorCard({
    required dynamic data,

    required int index,

    required bool isSelected,

    required bool showPortedBadge,
  }) {
    return GestureDetector(
      onTap: () async {
        final isFullNumber =
            _maximumPhoneLength > 0 &&
            inputNumber.length == _maximumPhoneLength;

        final shouldLockOperatorSelection =
            isOperatorLookupEnabled &&
            isFullNumber &&
            isOperatorLookupConfirmed;

        if (shouldLockOperatorSelection) {
          return;
        }

        setState(() {
          bundleController.initialpage = 1;

          bundleController.finalList.clear();

          selectedIndex = index;

          box.write("company_id", data.companyId);
        });

        await bundleController.fetchallbundles();
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        width: showPortedBadge ? 76 : 62,

        height: 66,

        padding: const EdgeInsets.all(5),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryColor
              : const Color(0xFFF8FAFD),

          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: showPortedBadge
                ? const Color(0xFFE0A51B)
                : isSelected
                ? AppColors.primaryColor
                : const Color(0xFFE5EBF2),

            width: showPortedBadge || isSelected ? 1.4 : 1,
          ),
        ),

        child: Stack(
          clipBehavior: Clip.none,

          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: data.company?.companyLogo ?? "",

                fit: BoxFit.contain,

                placeholder: (_, __) {
                  return const Center(
                    child: SizedBox(
                      height: 16,

                      width: 16,

                      child: CircularProgressIndicator(
                        strokeWidth: 1,

                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                },

                errorWidget: (_, __, ___) {
                  return const Icon(
                    Icons.image_not_supported_outlined,

                    color: AppColors.primaryColor,

                    size: 15,
                  );
                },
              ),
            ),

            if (isSelected)
              Positioned(
                left: -2,

                bottom: -2,

                child: Container(
                  height: 16,

                  width: 16,

                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.check_rounded,

                    color: Colors.white,

                    size: 11,
                  ),
                ),
              ),

            if (showPortedBadge)
              Positioned(
                right: -6,

                top: -8,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,

                    vertical: 2,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE0A51B),

                    borderRadius: BorderRadius.circular(6),
                  ),

                  child: NText(
                    text: languagesController.tr("PORTED"),

                    color: Colors.white,

                    fontSize: 7,

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationFilters() {
    return SizedBox(
      height: 38,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        physics: const BouncingScrollPhysics(),

        itemCount: duration.length,

        separatorBuilder: (context, index) {
          return const SizedBox(width: 7);
        },

        itemBuilder: (context, index) {
          final selected = durationSelectedIndex == index;

          return GestureDetector(
            onTap: () async {
              setState(() {
                durationSelectedIndex = index;
              });

              box.write("validity_type", duration[index]["Value"]);

              bundleController.initialpage = 1;

              bundleController.finalList.clear();

              if (isOperatorLookupEnabled) {
                final phoneNumber = confirmPinController.numberController.text
                    .trim();

                final requiredLength = _maximumPhoneLength;

                if (requiredLength > 0 &&
                    phoneNumber.length == requiredLength) {
                  await bundleController.fetchlookupbundles(phoneNumber);
                }

                return;
              }

              await bundleController.fetchallbundles();
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              padding: const EdgeInsets.symmetric(horizontal: 14),

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryColor
                    : const Color(0xFFF8FAFD),

                borderRadius: BorderRadius.circular(9),

                border: Border.all(
                  color: selected
                      ? AppColors.primaryColor
                      : const Color(0xFFE2E9F1),
                ),
              ),

              child: NText(
                text: duration[index]["Name"] ?? "",

                color: selected ? Colors.white : const Color(0xFF4A5E77),

                fontSize: 8.5,

                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBundleList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),

      child: Obx(() {
        final bundles = bundleController.finalList;

        final loading =
            bundleController.isLoading.value ||
            bundleController.isLookupLoading.value;

        if (loading && bundles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (bundles.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,

            backgroundColor: Colors.white,

            onRefresh: _pullRefresh,

            child: ListView(
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

                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: const Icon(
                          Icons.inventory_2_outlined,

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
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,

          backgroundColor: Colors.white,

          onRefresh: _pullRefresh,

          child: ListView.separated(
            controller: scrollController,

            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),

            padding: const EdgeInsets.only(bottom: 90),

            itemCount: bundles.length,

            separatorBuilder: (context, index) {
              return const SizedBox(height: 5);
            },

            itemBuilder: (context, index) {
              return _buildBundleCard(bundles[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildBundleCard(dynamic data) {
    final logo = data.service?.company?.companyLogo?.toString() ?? "";

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          _validateAndOpenBundle(data);
        },

        borderRadius: BorderRadius.circular(15),

        child: Ink(
          width: double.infinity,

          padding: const EdgeInsets.fromLTRB(9, 7, 9, 7),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(15),

            border: Border.all(color: const Color(0xFFE9EEF5)),

            boxShadow: [
              BoxShadow(
                color: const Color(0xFF153C68).withOpacity(0.045),

                blurRadius: 14,

                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                height: 52,

                width: 52,

                padding: const EdgeInsets.all(7),

                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,

                  borderRadius: BorderRadius.circular(10),
                ),

                child: CachedNetworkImage(
                  imageUrl: logo,

                  fit: BoxFit.contain,

                  errorWidget: (_, __, ___) {
                    return const Icon(
                      Icons.business_outlined,

                      color: AppColors.primaryColor,

                      size: 22,
                    );
                  },
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    NText(
                      text: data.bundleTitle?.toString() ?? "",

                      color: const Color(0xFF172D49),

                      fontSize: 12.5,

                      fontWeight: FontWeight.w800,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,

                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0F2),

                            borderRadius: BorderRadius.circular(7),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              NText(
                                text: languagesController.tr("BUY"),

                                color: const Color(0xFFE05263),

                                fontSize: 8.5,

                                fontWeight: FontWeight.w700,
                              ),

                              const SizedBox(width: 4),

                              PriceTextView(
                                price: data.buyingPrice.toString(),

                                textStyle: const TextStyle(
                                  color: Color(0xFFE05263),

                                  fontSize: 8.5,

                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(width: 3),

                              NText(
                                text:
                                    box.read("currency_code")?.toString() ?? "",

                                color: const Color(0xFFE05263),

                                fontSize: 8.5,

                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,

                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,

                      borderRadius: BorderRadius.circular(9),
                    ),

                    child: NText(
                      text: _validityText(data.validityType?.toString()),

                      color: AppColors.primaryColor,

                      fontSize: 8.5,

                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      NText(
                        text: languagesController.tr("SALE"),

                        color: const Color(0xFF19A766),

                        fontSize: 8.8,

                        fontWeight: FontWeight.w700,
                      ),

                      const SizedBox(width: 4),

                      PriceTextView(
                        price: data.sellingPrice.toString(),

                        textStyle: const TextStyle(
                          color: Color(0xFF19A766),

                          fontSize: 10.3,

                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(width: 3),

                      NText(
                        text: box.read("currency_code")?.toString() ?? "",

                        color: const Color(0xFF19A766),

                        fontSize: 8.8,

                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  const Icon(
                    Icons.arrow_forward_rounded,

                    color: AppColors.primaryColor,

                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndOpenBundle(dynamic data) {
    final number = confirmPinController.numberController.text.trim();

    if (number.isEmpty) {
      Fluttertoast.showToast(
        msg: languagesController.tr("ENTER_PHONE_NUMBER"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.BOTTOM,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.black,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    if (box.read("permission") == "no" ||
        number.length.toString() != box.read("maxlength").toString()) {
      Fluttertoast.showToast(
        msg: languagesController.tr("ENTER_CORRECT_NUMBER"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.BOTTOM,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.black,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    box.write("bundleID", data.id.toString());

    _showBundleConfirmationDialog(data);
  }

  void _showBundleConfirmationDialog(dynamic data) {
    showDialog(
      context: context,

      barrierColor: Colors.black.withOpacity(0.38),

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,

            vertical: 28,
          ),

          child: Container(
            width: double.infinity,

            constraints: const BoxConstraints(maxHeight: 650),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(26),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10233F).withOpacity(0.16),

                  blurRadius: 30,

                  offset: const Offset(0, 14),
                ),
              ],
            ),

            clipBehavior: Clip.antiAlias,

            child: Obx(
              () => confirmPinController.isLoading.value
                  ? Center(
                      child: SizedBox(
                        height: 220,

                        width: 220,

                        child: Lottie.asset("assets/loties/recharge.json"),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      child: Column(
                        children: [
                          _buildDialogHeader(data, dialogContext),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),

                            child: Column(
                              children: [
                                _buildPriceBlock(data),

                                const SizedBox(height: 12),

                                _buildPhoneBlock(),

                                const SizedBox(height: 12),

                                _buildPinField(),

                                const SizedBox(height: 18),

                                _buildDialogActions(dialogContext),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(dynamic data, BuildContext dialogContext) {
    final logo = data.service?.company?.companyLogo?.toString() ?? "";

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 18, 13, 17),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [
            Color(0xFF0C78E8),

            AppColors.primaryColor,

            Color(0xFF004494),
          ],
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            height: 54,

            width: 54,

            padding: const EdgeInsets.all(7),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(16),
            ),

            child: CachedNetworkImage(
              imageUrl: logo,

              fit: BoxFit.contain,

              errorWidget: (_, __, ___) {
                return const Icon(
                  Icons.business_outlined,

                  color: AppColors.primaryColor,

                  size: 24,
                );
              },
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                NText(
                  text: data.bundleTitle?.toString() ?? "",

                  color: Colors.white,

                  fontSize: 12.5,

                  fontWeight: FontWeight.w800,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,

                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),

                    borderRadius: BorderRadius.circular(7),
                  ),

                  child: NText(
                    text: _validityText(data.validityType?.toString()),

                    color: Colors.white,

                    fontSize: 10,

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pop(dialogContext);
            },

            child: Container(
              height: 34,

              width: 34,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.13),

                borderRadius: BorderRadius.circular(10),
              ),

              child: const Icon(
                Icons.close_rounded,

                color: Colors.white,

                size: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBlock(dynamic data) {
    final currency = box.read("currency_code")?.toString() ?? "";

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),

      child: Column(
        children: [
          _dialogPriceRow(
            icon: Icons.shopping_bag_outlined,

            label: languagesController.tr("BUY"),

            price: data.buyingPrice.toString(),

            currency: currency,

            accent: const Color(0xFFE05263),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),

            child: Divider(height: 1, color: Color(0xFFE8EEF3)),
          ),

          _dialogPriceRow(
            icon: Icons.sell_outlined,

            label: languagesController.tr("SELL"),

            price: data.sellingPrice.toString(),

            currency: currency,

            accent: const Color(0xFF19A766),
          ),
        ],
      ),
    );
  }

  Widget _dialogPriceRow({
    required IconData icon,

    required String label,

    required String price,

    required String currency,

    required Color accent,
  }) {
    return Row(
      children: [
        Container(
          height: 32,

          width: 32,

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: accent.withOpacity(0.08),

            borderRadius: BorderRadius.circular(9),
          ),

          child: Icon(icon, color: accent, size: 17),
        ),

        const SizedBox(width: 9),

        NText(
          text: label,

          color: AppColors.fontColor,

          fontSize: 10.3,

          fontWeight: FontWeight.w600,
        ),

        const Spacer(),

        PriceTextView(
          price: price,

          textStyle: TextStyle(
            color: accent,

            fontSize: 14,

            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(width: 4),

        NText(
          text: currency,

          color: accent,

          fontSize: 8.5,

          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildPhoneBlock() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),

      decoration: BoxDecoration(
        color: AppColors.secondaryColor,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
      ),

      child: Row(
        children: [
          Container(
            height: 32,

            width: 32,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(9),
            ),

            child: const Icon(
              Icons.phone_android_rounded,

              color: AppColors.primaryColor,

              size: 18,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: NText(
              text: languagesController.tr("PHONENUMBER"),

              color: AppColors.fontColor,

              fontSize: 11,

              fontWeight: FontWeight.w500,
            ),
          ),

          NText(
            text: confirmPinController.numberController.text,

            color: const Color(0xFF172D49),

            fontSize: 12.5,

            fontWeight: FontWeight.w800,
          ),
        ],
      ),
    );
  }

  Widget _buildPinField() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(13, 11, 13, 10),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),

      child: Row(
        children: [
          Container(
            height: 34,

            width: 34,

            decoration: BoxDecoration(
              color: AppColors.secondaryColor,

              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.lock_outline_rounded,

              color: AppColors.primaryColor,

              size: 18,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: TextField(
              maxLength: 4,

              controller: confirmPinController.pinController,

              keyboardType: TextInputType.number,

              textAlign: TextAlign.start,

              obscureText: true,

              cursorColor: AppColors.primaryColor,

              style: const TextStyle(
                color: Color(0xFF172D49),

                fontSize: 17,

                fontWeight: FontWeight.w800,

                letterSpacing: 4,
              ),

              decoration: InputDecoration(
                counterText: "",

                hintText: languagesController.tr("PIN"),

                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.65),

                  fontSize: 12,

                  letterSpacing: 0,
                ),

                border: InputBorder.none,

                enabledBorder: InputBorder.none,

                focusedBorder: InputBorder.none,

                isDense: true,

                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogActions(BuildContext dialogContext) {
    return Row(
      children: [
        Expanded(
          flex: 3,

          child: GestureDetector(
            onTap: () async {
              if (confirmPinController.isLoading.value) {
                return;
              }

              if (confirmPinController.pinController.text.length != 4) {
                Fluttertoast.showToast(
                  msg: languagesController.tr("ENTER_YOUR_PIN"),

                  toastLength: Toast.LENGTH_SHORT,

                  gravity: ToastGravity.BOTTOM,

                  timeInSecForIosWeb: 1,

                  backgroundColor: Colors.black,

                  textColor: Colors.white,

                  fontSize: 16,
                );

                return;
              }

              await confirmPinController.placeOrder(dialogContext);
            },

            child: Container(
              height: 50,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: AppColors.primaryColor,

                borderRadius: BorderRadius.circular(14),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.20),

                    blurRadius: 14,

                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Icon(
                    Icons.check_circle_rounded,

                    color: Colors.white,

                    size: 19,
                  ),

                  const SizedBox(width: 7),

                  NText(
                    text: languagesController.tr("CONFIRMATION"),

                    color: Colors.white,

                    fontSize: 12.5,

                    fontWeight: FontWeight.w800,
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
              Navigator.pop(dialogContext);
            },

            child: Container(
              height: 50,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: AppColors.secondaryColor,

                borderRadius: BorderRadius.circular(14),
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

  String _validityText(String? value) {
    switch (value?.toLowerCase()) {
      case "unlimited":
        return languagesController.tr("UNLIMITED");

      case "monthly":
        return languagesController.tr("MONTHLY");

      case "weekly":
        return languagesController.tr("WEEKLY");

      case "daily":
        return languagesController.tr("DAILY");

      case "hourly":
        return languagesController.tr("HOURLY");

      case "nightly":
        return languagesController.tr("NIGHTLY");

      default:
        return "";
    }
  }
}
