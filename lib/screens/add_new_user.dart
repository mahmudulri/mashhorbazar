import 'dart:io';

import 'package:mashhorbazar/controllers/add_sub_reseller_controller.dart';

import 'package:mashhorbazar/controllers/commission_group_controller.dart';

import 'package:mashhorbazar/controllers/country_list_controller.dart';

import 'package:mashhorbazar/controllers/district_controller.dart';

import 'package:mashhorbazar/controllers/province_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/authtextfield.dart';

import 'package:mashhorbazar/widgets/bottomsheet.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  final GetStorage box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final AddSubResellerController addSubResellerController = Get.put(
    AddSubResellerController(),
  );

  final CountryListController countryListController = Get.put(
    CountryListController(),
  );

  final ProvinceController provinceController = Get.put(ProvinceController());

  final DistrictController districtController = Get.put(DistrictController());

  final CommissionGroupController commissionlistController = Get.put(
    CommissionGroupController(),
  );

  String selectedCommissionGroup = "";

  String selectedCountry = "";

  String selectedProvince = "";

  String selectedDistrict = "";

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

    _resetDataFields();

    commissionlistController.fetchGrouplist();
  }

  void _resetDataFields() {
    addSubResellerController.groupId.value = "";

    selectedCommissionGroup = "";

    addSubResellerController.countryId.value = "";

    selectedCountry = "";

    addSubResellerController.provinceId.value = "";

    selectedProvince = "";

    addSubResellerController.districtID.value = "";

    selectedDistrict = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                children: [
                  _buildProfileSection(),
                  const SizedBox(height: 12),
                  _buildPersonalInformationSection(),
                  const SizedBox(height: 12),
                  _buildLocationSection(),
                  const SizedBox(height: 12),
                  _buildDocumentsSection(),
                  const SizedBox(height: 16),
                  _buildSubmitButton(),
                  const SizedBox(height: 14),
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
      child: Row(
        children: [
          _headerAction(
            icon: Icons.arrow_back_rounded,
            onTap: mypagecontroller.goBack,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                NText(
                  text: languagesController.tr("ADD_USER"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("COMMISSION_GROUP"),
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _headerAction(
            icon: Icons.menu_rounded,
            onTap: () {
              CustomFullScreenSheet.show(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _headerAction({required IconData icon, required VoidCallback onTap}) {
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

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.055),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(
            () => GestureDetector(
              onTap: () async {
                await addSubResellerController.uploadImage();

                if (mounted) {
                  setState(() {});
                }
              },
              child: DottedBorder(
                color: AppColors.primaryColor.withOpacity(0.28),
                strokeWidth: 1.4,
                dashPattern: const [6, 4],
                borderType: BorderType.Circle,
                child: Container(
                  height: 104,
                  width: 104,
                  padding: const EdgeInsets.all(5),
                  child: ClipOval(
                    child:
                        addSubResellerController.selectedImagePath.value.isEmpty
                        ? Container(
                            color: AppColors.secondaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: NText(
                                    text: languagesController.tr(
                                      "UPLOAD_PHOTO",
                                    ),
                                    color: AppColors.fontColor,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Image.file(
                            addSubResellerController.imageFile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          NText(
            text: languagesController.tr("ADD_USER"),
            color: const Color(0xFF172D49),
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 4),
          NText(
            text: languagesController.tr("UPLOAD_PHOTO"),
            color: AppColors.fontColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationSection() {
    return _sectionCard(
      icon: Icons.person_outline_rounded,

      title: languagesController.tr("FULL_NAME"),

      children: [
        _fieldLabel(languagesController.tr("FULL_NAME")),

        const SizedBox(height: 6),

        Authtextfield(
          hinttext: languagesController.tr("ADD_FIRST_AND_LAST_NAME"),

          controller: addSubResellerController.resellerNameController,
        ),

        const SizedBox(height: 12),

        _fieldLabel(languagesController.tr("CONTACT_NAME")),

        const SizedBox(height: 6),

        Authtextfield(
          hinttext: languagesController.tr("CONTACT_NAME"),

          controller: addSubResellerController.contactNameController,
        ),

        const SizedBox(height: 12),

        _fieldLabel(languagesController.tr("PHONENUMBER")),

        const SizedBox(height: 6),

        Authtextfield(
          hinttext: languagesController.tr("ENTER_PHONE_NUMBER"),

          controller: addSubResellerController.phoneController,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            NText(
              text: languagesController.tr("EMAIL"),

              color: AppColors.primaryColor,

              fontSize: 12.5,

              fontWeight: FontWeight.w600,
            ),

            const SizedBox(width: 7),

            NText(
              text: "(${languagesController.tr("OPTIONAL")})",

              color: AppColors.fontColor,

              fontSize: 10.5,

              fontWeight: FontWeight.w500,
            ),
          ],
        ),

        const SizedBox(height: 6),

        Authtextfield(
          hinttext: languagesController.tr("ENTER_EMAIL_ADDRESS"),

          controller: addSubResellerController.emailController,
        ),

        const SizedBox(height: 12),

        _fieldLabel(languagesController.tr("COMMISSION_GROUP")),

        const SizedBox(height: 6),

        _buildCommissionDropdown(),
      ],
    );
  }

  Widget _buildLocationSection() {
    return _sectionCard(
      icon: Icons.location_on_outlined,

      title: languagesController.tr("COUNTRY_OF_RESIDENCE"),

      children: [
        _fieldLabel(languagesController.tr("COUNTRY_OF_RESIDENCE")),

        const SizedBox(height: 6),

        _buildCountryDropdown(),

        const SizedBox(height: 12),

        _fieldLabel(languagesController.tr("PROVINCE")),

        const SizedBox(height: 6),

        _buildProvinceDropdown(),

        const SizedBox(height: 12),

        _fieldLabel(languagesController.tr("DISTRICT")),

        const SizedBox(height: 6),

        _buildDistrictDropdown(),

        const SizedBox(height: 12),

        _fieldLabel(languagesController.tr("DESIRED_CURRENCY")),

        const SizedBox(height: 6),

        Container(
          height: 50,

          width: double.infinity,

          padding: const EdgeInsets.symmetric(horizontal: 12),

          decoration: _fieldDecoration(),

          alignment: Alignment.centerLeft,

          child: NText(
            text: box.read("currency_code")?.toString() ?? "",

            color: AppColors.primaryColor,

            fontSize: 13.5,

            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return _sectionCard(
      icon: Icons.description_outlined,

      title: languagesController.tr("IDENTITY_ATTACHMENT"),

      children: [
        Row(
          children: [
            Expanded(
              child: NText(
                text: languagesController.tr("IDENTITY_ATTACHMENT"),

                color: AppColors.primaryColor,

                fontSize: 12.5,

                fontWeight: FontWeight.w600,
              ),
            ),

            NText(
              text: "(${languagesController.tr("OPTIONAL")})",

              color: AppColors.fontColor,

              fontSize: 10.5,

              fontWeight: FontWeight.w500,
            ),
          ],
        ),

        const SizedBox(height: 7),

        Obx(() {
          final hasImage =
              addSubResellerController.selectedIdentityPath.value.isNotEmpty;

          return _documentUploadBox(
            hasImage: hasImage,

            imagePath: addSubResellerController.selectedIdentityPath.value,

            emptyText: languagesController.tr("TAP_TO_UPLOAD_IDENTITY_IMAGE"),

            onTap: () async {
              await addSubResellerController.uploadIdentityAttachment();

              if (mounted) {
                setState(() {});
              }
            },

            onRemove: () {
              addSubResellerController.selectedIdentityPath.value = "";

              setState(() {});
            },
          );
        }),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: NText(
                text: languagesController.tr("EXTRA_PROOF"),

                color: AppColors.primaryColor,

                fontSize: 12.5,

                fontWeight: FontWeight.w600,
              ),
            ),

            NText(
              text: "(${languagesController.tr("OPTIONAL")})",

              color: AppColors.fontColor,

              fontSize: 10.5,

              fontWeight: FontWeight.w500,
            ),
          ],
        ),

        const SizedBox(height: 7),

        Obx(() {
          final hasImage =
              addSubResellerController.selectedExtraProofPath.value.isNotEmpty;

          return _documentUploadBox(
            hasImage: hasImage,

            imagePath: addSubResellerController.selectedExtraProofPath.value,

            emptyText: languagesController.tr("TAP_TO_UPLOAD_EXTRA_PROOF"),

            onTap: () async {
              await addSubResellerController.uploadExtraOptionalProof();

              if (mounted) {
                setState(() {});
              }
            },

            onRemove: () {
              addSubResellerController.selectedExtraProofPath.value = "";

              setState(() {});
            },
          );
        }),
      ],
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
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
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NText(
                  text: title,
                  color: const Color(0xFF172D49),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return NText(
      text: text,
      color: const Color(0xFF42556D),
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );
  }

  BoxDecoration _fieldDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF8FAFD),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0xFFE2E9F1)),
    );
  }

  Widget _dropdownIcon() {
    return Container(
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
    );
  }

  Widget _buildCommissionDropdown() {
    return Container(
      height: 50,

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 11),

      decoration: _fieldDecoration(),

      child: Obx(() {
        final List<dynamic> groups =
            (commissionlistController.allgrouplist.value.data?.groups
                as List?) ??
            <dynamic>[];

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: addSubResellerController.groupId.value.isEmpty
                ? null
                : addSubResellerController.groupId.value,

            dropdownColor: Colors.white,

            borderRadius: BorderRadius.circular(13),

            icon: _dropdownIcon(),

            hint: NText(
              text: selectedCommissionGroup,

              color: AppColors.fontColor,

              fontSize: 13,
            ),

            items: groups.map<DropdownMenuItem<String>>((group) {
              final id = ((group?.id) ?? "").toString();

              final name = ((group?.groupName) ?? "").toString();

              return DropdownMenuItem<String>(
                value: id,

                child: NText(
                  text: name,

                  color: AppColors.primaryColor,

                  fontSize: 13,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),

            onChanged: (value) {
              if (value == null) {
                return;
              }

              dynamic picked;

              for (final group in groups) {
                if (((group?.id) ?? "").toString() == value) {
                  picked = group;

                  break;
                }
              }

              picked ??= groups.isNotEmpty ? groups.first : null;

              addSubResellerController.groupId.value = value;

              selectedCommissionGroup = ((picked?.groupName) ?? "").toString();

              setState(() {});
            },
          ),
        );
      }),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      height: 50,

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 11),

      decoration: _fieldDecoration(),

      child: Obx(() {
        final countries =
            countryListController.allcountryListData.value.data?.countries ??
            <dynamic>[];

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: addSubResellerController.countryId.value.isEmpty
                ? null
                : addSubResellerController.countryId.value,

            dropdownColor: Colors.white,

            borderRadius: BorderRadius.circular(13),

            icon: _dropdownIcon(),

            hint: NText(
              text: selectedCountry,

              color: AppColors.fontColor,

              fontSize: 13,
            ),

            items: countries.map<DropdownMenuItem<String>>((country) {
              final id = ((country?.id) ?? "").toString();

              final name = ((country?.countryName) ?? "").toString();

              return DropdownMenuItem<String>(
                value: id,

                child: NText(
                  text: name,

                  color: AppColors.primaryColor,

                  fontSize: 13,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),

            selectedItemBuilder: (context) {
              return countries.map<Widget>((country) {
                final name = ((country?.countryName) ?? "").toString();

                return Align(
                  alignment: Alignment.centerLeft,

                  child: NText(
                    text: name,

                    color: AppColors.primaryColor,

                    fontSize: 13,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },

            onChanged: (value) {
              if (value == null) {
                return;
              }

              dynamic picked;

              for (final country in countries) {
                if (((country?.id) ?? "").toString() == value) {
                  picked = country;

                  break;
                }
              }

              picked ??= countries.isNotEmpty ? countries.first : null;

              addSubResellerController.countryId.value = value;

              selectedCountry = ((picked?.countryName) ?? "").toString();

              setState(() {});
            },
          ),
        );
      }),
    );
  }

  Widget _buildProvinceDropdown() {
    return Container(
      height: 50,

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 11),

      decoration: _fieldDecoration(),

      child: Obx(() {
        final provinces =
            provinceController.allprovincelist.value.data?.provinces ??
            <dynamic>[];

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: addSubResellerController.provinceId.value.isEmpty
                ? null
                : addSubResellerController.provinceId.value,

            dropdownColor: Colors.white,

            borderRadius: BorderRadius.circular(13),

            icon: _dropdownIcon(),

            hint: NText(
              text: selectedProvince,

              color: AppColors.fontColor,

              fontSize: 13,
            ),

            items: provinces.map<DropdownMenuItem<String>>((province) {
              final id = ((province?.id) ?? "").toString();

              final name = ((province?.provinceName) ?? "").toString();

              return DropdownMenuItem<String>(
                value: id,

                child: NText(
                  text: name,

                  color: AppColors.primaryColor,

                  fontSize: 13,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),

            selectedItemBuilder: (context) {
              return provinces.map<Widget>((province) {
                final name = ((province?.provinceName) ?? "").toString();

                return Align(
                  alignment: Alignment.centerLeft,

                  child: NText(
                    text: name,

                    color: AppColors.primaryColor,

                    fontSize: 13,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },

            onChanged: (value) {
              if (value == null) {
                return;
              }

              dynamic picked;

              for (final province in provinces) {
                if (((province?.id) ?? "").toString() == value) {
                  picked = province;

                  break;
                }
              }

              picked ??= provinces.isNotEmpty ? provinces.first : null;

              addSubResellerController.provinceId.value = value;

              selectedProvince = ((picked?.provinceName) ?? "").toString();

              setState(() {});
            },
          ),
        );
      }),
    );
  }

  Widget _buildDistrictDropdown() {
    return Container(
      height: 50,

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 11),

      decoration: _fieldDecoration(),

      child: Obx(() {
        final districts =
            districtController.alldistrictList.value.data?.districts ??
            <dynamic>[];

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: addSubResellerController.districtID.value.isEmpty
                ? null
                : addSubResellerController.districtID.value,

            dropdownColor: Colors.white,

            borderRadius: BorderRadius.circular(13),

            icon: _dropdownIcon(),

            hint: NText(
              text: selectedDistrict,

              color: AppColors.fontColor,

              fontSize: 13,
            ),

            items: districts.map<DropdownMenuItem<String>>((district) {
              final id = ((district?.id) ?? "").toString();

              final name = ((district?.districtName) ?? "").toString();

              return DropdownMenuItem<String>(
                value: id,

                child: NText(
                  text: name,

                  color: AppColors.primaryColor,

                  fontSize: 13,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),

            selectedItemBuilder: (context) {
              return districts.map<Widget>((district) {
                final name = ((district?.districtName) ?? "").toString();

                return Align(
                  alignment: Alignment.centerLeft,

                  child: NText(
                    text: name,

                    color: AppColors.primaryColor,

                    fontSize: 13,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },

            onChanged: (value) {
              if (value == null) {
                return;
              }

              dynamic picked;

              for (final district in districts) {
                if (((district?.id) ?? "").toString() == value) {
                  picked = district;

                  break;
                }
              }

              picked ??= districts.isNotEmpty ? districts.first : null;

              addSubResellerController.districtID.value = value;

              selectedDistrict = ((picked?.districtName) ?? "").toString();

              setState(() {});
            },
          ),
        );
      }),
    );
  }

  Widget _documentUploadBox({
    required bool hasImage,
    required String imagePath,
    required String emptyText,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: AppColors.primaryColor.withOpacity(0.24),
        strokeWidth: 1.4,
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(14),
        child: Container(
          height: 118,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(14),
          ),
          child: hasImage
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.file(File(imagePath), fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          height: 31,
                          width: 31,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.58),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        color: AppColors.primaryColor,
                        size: 23,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NText(
                        text: emptyText,
                        color: AppColors.fontColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => GestureDetector(
        onTap: addSubResellerController.isLoading.value ? null : _submitUser,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            color: addSubResellerController.isLoading.value
                ? AppColors.fontColor.withOpacity(0.30)
                : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: addSubResellerController.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.20),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: addSubResellerController.isLoading.value
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
                    const SizedBox(width: 10),
                    NText(
                      text: languagesController.tr("PLEASE_WAIT"),
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                    const SizedBox(width: 7),
                    NText(
                      text: languagesController.tr("ADD_NOW"),
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _submitUser() {
    if (addSubResellerController.resellerNameController.text.isEmpty ||
        addSubResellerController.contactNameController.text.isEmpty ||
        addSubResellerController.phoneController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: languagesController.tr("FILL_DATA_CORRECTLY"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.BOTTOM,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.black,

        textColor: Colors.white,

        fontSize: 16.0,
      );

      return;
    }

    addSubResellerController.addNow();
  }
}
