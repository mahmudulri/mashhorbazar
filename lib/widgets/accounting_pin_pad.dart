import 'package:mashhorbazar/accounting/accounting_base.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/verify_pin_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

LanguagesController languagesController = Get.put(LanguagesController());

class AccountingPinPad {
  static void show(BuildContext context) {
    String enteredNumber = '';

    final VerifyPinController verifyPinController =
        Get.isRegistered<VerifyPinController>()
        ? Get.find<VerifyPinController>()
        : Get.put(VerifyPinController());

    verifyPinController.clearError();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.50),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setState) {
            void addNumber(String number) {
              if (enteredNumber.length >= 4) {
                return;
              }

              verifyPinController.clearError();

              setState(() {
                enteredNumber += number;
              });
            }

            void removeNumber() {
              verifyPinController.clearError();

              if (enteredNumber.isEmpty) {
                return;
              }

              setState(() {
                enteredNumber = enteredNumber.substring(
                  0,
                  enteredNumber.length - 1,
                );
              });
            }

            void clearNumber() {
              verifyPinController.clearError();

              if (enteredNumber.isEmpty) {
                return;
              }

              setState(() {
                enteredNumber = '';
              });
            }

            Future<void> submitPin() async {
              if (enteredNumber.length != 4) {
                Get.snackbar(
                  languagesController.tr('INVALID_PIN'),
                  languagesController.tr('PIN_MUST_BE_4_DIGITS'),
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(15),
                );
                return;
              }

              final pin = enteredNumber;

              final isCorrect = await verifyPinController.verifyPin(pin);

              if (!sheetContext.mounted) {
                return;
              }

              if (isCorrect) {
                Navigator.of(bottomSheetContext).pop();
                Get.to(() => AccountingBaseScreen());
              } else {
                setState(() {
                  enteredNumber = '';
                });
              }
            }

            return Obx(() {
              final isLoading = verifyPinController.isLoading.value;

              final errorMessage = verifyPinController.errorMessage.value;

              return SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(sheetContext).size.height * 0.90,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.mashhorbazarBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        15,
                        10,
                        15,
                        14 + MediaQuery.of(sheetContext).viewInsets.bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 4,
                            width: 42,
                            decoration: BoxDecoration(
                              color: AppColors.fontColor.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildHeader(
                            isLoading: isLoading,
                            onClose: () {
                              if (isLoading) {
                                return;
                              }

                              verifyPinController.clearError();

                              Navigator.of(bottomSheetContext).pop();
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildSecurityCard(
                            enteredNumber: enteredNumber,
                            errorMessage: errorMessage,
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: errorMessage.isNotEmpty
                                ? Padding(
                                    key: ValueKey(errorMessage),
                                    padding: const EdgeInsets.only(top: 9),
                                    child: _buildErrorBanner(errorMessage),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 12),
                          _buildKeypad(
                            enabled: !isLoading,
                            onNumberTap: addNumber,
                            onBackspace: removeNumber,
                            onClear: clearNumber,
                          ),
                          const SizedBox(height: 13),
                          _buildSubmitButton(
                            isLoading: isLoading,
                            enabled: enteredNumber.length == 4,
                            onTap: submitPin,
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: isLoading
                                ? null
                                : () {
                                    verifyPinController.clearError();

                                    Navigator.of(bottomSheetContext).pop();
                                  },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: NText(
                                text: languagesController.tr('CANCEL'),
                                color: isLoading
                                    ? AppColors.fontColor.withOpacity(0.55)
                                    : AppColors.fontColor,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }

  static Widget _buildHeader({
    required bool isLoading,
    required VoidCallback onClose,
  }) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NText(
                text: languagesController.tr('ENTER_PIN'),
                color: const Color(0xFF172D49),
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              NText(
                text: languagesController.tr('ENTER_YOUR_ACCOUNTING_PIN'),
                color: AppColors.fontColor,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onClose,
            borderRadius: BorderRadius.circular(11),
            child: Ink(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: const Color(0xFFE3EAF2)),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: isLoading
                    ? AppColors.fontColor.withOpacity(0.45)
                    : AppColors.fontColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildSecurityCard({
    required String enteredNumber,
    required String errorMessage,
  }) {
    final hasError = errorMessage.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.16),
            blurRadius: 17,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NText(
                  text: languagesController.tr('ENTER_YOUR_ACCOUNTING_PIN'),
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: NText(
                  text: '${enteredNumber.length}/4',
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final filled = index < enteredNumber.length;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 44,
                width: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: hasError
                      ? Colors.white.withOpacity(0.09)
                      : filled
                      ? Colors.white
                      : Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: hasError
                        ? const Color(0xFFFF7D88)
                        : filled
                        ? Colors.white
                        : Colors.white.withOpacity(0.14),
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: filled ? 11 : 7,
                  width: filled ? 11 : 7,
                  decoration: BoxDecoration(
                    color: hasError
                        ? const Color(0xFFFF7D88)
                        : filled
                        ? AppColors.primaryColor
                        : Colors.white.withOpacity(0.38),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static Widget _buildErrorBanner(String errorMessage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F2),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE05263).withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE2E6),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 16,
              color: Color(0xFFE05263),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: NText(
              text: errorMessage,
              color: const Color(0xFFE05263),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildKeypad({
    required bool enabled,
    required ValueChanged<String> onNumberTap,
    required VoidCallback onBackspace,
    required VoidCallback onClear,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFE7EDF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.04),
            blurRadius: 11,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _keypadRow(
            enabled: enabled,
            values: const ['1', '2', '3'],
            onNumberTap: onNumberTap,
          ),
          const SizedBox(height: 7),
          _keypadRow(
            enabled: enabled,
            values: const ['4', '5', '6'],
            onNumberTap: onNumberTap,
          ),
          const SizedBox(height: 7),
          _keypadRow(
            enabled: enabled,
            values: const ['7', '8', '9'],
            onNumberTap: onNumberTap,
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: _actionKey(
                  icon: Icons.refresh_rounded,
                  enabled: enabled,
                  onTap: onClear,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _numberKey(
                  number: '0',
                  enabled: enabled,
                  onTap: () => onNumberTap('0'),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _actionKey(
                  icon: Icons.backspace_outlined,
                  enabled: enabled,
                  onTap: onBackspace,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _keypadRow({
    required bool enabled,

    required List<String> values,

    required ValueChanged<String> onNumberTap,
  }) {
    return Row(
      children: [
        for (int index = 0; index < values.length; index++) ...[
          Expanded(
            child: _numberKey(
              number: values[index],

              enabled: enabled,

              onTap: () => onNumberTap(values[index]),
            ),
          ),

          if (index != values.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }

  static Widget _numberKey({
    required String number,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          height: 49,
          decoration: BoxDecoration(
            color: enabled
                ? const Color(0xFFF7FAFD)
                : const Color(0xFFF7FAFD).withOpacity(0.55),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE8EEF5)),
          ),
          child: Center(
            child: NText(
              text: number,
              color: enabled
                  ? const Color(0xFF172D49)
                  : AppColors.fontColor.withOpacity(0.55),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _actionKey({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          height: 49,
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.secondaryColor
                : AppColors.secondaryColor.withOpacity(0.45),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.05)),
          ),
          child: Icon(
            icon,
            size: 19,
            color: enabled
                ? AppColors.primaryColor
                : AppColors.fontColor.withOpacity(0.45),
          ),
        ),
      ),
    );
  }

  static Widget _buildSubmitButton({
    required bool isLoading,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final canSubmit = !isLoading && enabled;

    return GestureDetector(
      onTap: canSubmit ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: canSubmit
              ? AppColors.primaryColor
              : AppColors.primaryColor.withOpacity(0.42),
          borderRadius: BorderRadius.circular(14),
          boxShadow: canSubmit
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.20),
                    blurRadius: 13,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_open_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                  const SizedBox(width: 6),
                  NText(
                    text: languagesController.tr('SUBMIT'),
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
      ),
    );
  }
}
