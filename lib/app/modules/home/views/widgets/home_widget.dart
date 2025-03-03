import 'package:core_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:core_flutter/app/modules/home/views/widgets/home_filter_widget.dart';
import 'package:core_flutter/app/modules/home/views/widgets/home_item_widget.dart';
import 'package:flutter/widgets.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeFilterWidget(controller: controller),
        Expanded(child: HomeItemWidget(controller: controller)),
      ],
    );
  }
}
