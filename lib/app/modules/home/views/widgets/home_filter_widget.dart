import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/translations/app_language_key_extension.dart';
import 'package:core_flutter/app/widgets/anim_inkwell.dart';
import 'package:core_flutter/app/widgets/app_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeFilterWidget extends StatelessWidget {
  const HomeFilterWidget({super.key, required this.controller});
  final HomeController controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(AppDecoration.defaultSpacing),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppBoxShadow.softShadow,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: LanguageKey.homeSearch.tr,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            AnimInkWell(
              onTap: controller.toggleGrid,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryNormal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() => controller.isGrid.value
                    ? Icon(Icons.list, color: AppColors.white)
                    : Icon(Icons.grid_view, color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
