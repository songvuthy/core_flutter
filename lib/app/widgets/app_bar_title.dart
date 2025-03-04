import 'package:core_flutter/app/theme/app_text_style.dart';
import 'package:flutter/widgets.dart';

class AppBarTitle extends StatelessWidget {
  final String title;

  const AppBarTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.subtitle1,
    );
  }
}
