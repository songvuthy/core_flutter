import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/translations/app_language_key_extension.dart';
import 'package:core_flutter/app/widgets/anim_inkwell.dart';
import 'package:core_flutter/app/widgets/app_anim_switcher.dart';
import 'package:core_flutter/app/widgets/app_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget({super.key, required this.controller});
  final HomeController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isGrid.value ? _grid() : _list());
  }

  Widget _list() {
    return AppAnimSwitcher(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDecoration.defaultSpacing),
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppDecoration.defaultSpacing / 2),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: AnimInkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: AppBoxShadow.softShadow,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${LanguageKey.homeItem.tr} ${controller.items[index]}",
                    style: TextStyle(color: AppColors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _grid() {
    return AppAnimSwitcher(
      child: GridView.builder(
        padding: EdgeInsets.only(
          left: AppDecoration.defaultSpacing,
          right: AppDecoration.defaultSpacing,
          top: AppDecoration.defaultSpacing / 2,
          bottom: AppDecoration.defaultSpacing / 2,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppDecoration.defaultSpacing,
          crossAxisSpacing: AppDecoration.defaultSpacing,
          childAspectRatio: 4 / 3,
        ),
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return AnimInkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: AppBoxShadow.softShadow,
              ),
              alignment: Alignment.center,
              child: Text(
                "${LanguageKey.homeItem.tr} ${controller.items[index]}",
                style: TextStyle(color: AppColors.black, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
