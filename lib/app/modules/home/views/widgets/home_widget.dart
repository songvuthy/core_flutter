import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({super.key, required this.controller});
  final HomeController controller;
  final List<String> items = List.generate(8, (index) => 'Item ${index + 1}');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          color: AppColors.errorDark,
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppDecoration.isTablet ? 2 : 1,
              mainAxisSpacing: AppDecoration.defaultSpacing,
              crossAxisSpacing: AppDecoration.defaultSpacing,
              childAspectRatio: 16 / 9,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryNormal,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  items[index],
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
