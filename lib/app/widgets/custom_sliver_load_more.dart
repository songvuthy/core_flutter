import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/widgets/custom_sliver_paging_view.dart';
import 'package:core_flutter/app/widgets/custom_state_view.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomSliverLoadMore<ITEM> extends StatefulWidget {
  final CustomSliverPagingViewController<ITEM> controller;
  final Future<ViewState<List<ITEM>>> Function(int offset) onLoadPage;
  const CustomSliverLoadMore({
    super.key,
    required this.controller,
    required this.onLoadPage,
  });

  @override
  State<CustomSliverLoadMore> createState() =>
      _CustomSliverLoadMoreState<ITEM>();
}

class _CustomSliverLoadMoreState<ITEM>
    extends State<CustomSliverLoadMore<ITEM>> {
  CustomSliverPagingViewController<ITEM> get controller => widget.controller;

  bool _isLoading = true;
  ViewState _loadingMoreState = Loading();
  var keyLoading = UniqueKey();

  @override
  void initState() {
    controller.addSwitchStateCallback(switchStateCallback);
    controller.addResetCallback(resetCallback);
    super.initState();
  }

  void switchStateCallback(ViewState<List<ITEM>> state) {
    if (mounted) {
      setState(() {
        keyLoading = UniqueKey();
        if (state is Empty && controller.offset == 0) {
          _loadingMoreState = Empty();
        }
      });
    }
  }

  void resetCallback() {
    if (mounted) {
      setState(() {
        keyLoading = UniqueKey();
        controller.offset = 0;
        _loadingMoreState = Loading();
      });
    }
  }

  Widget _loadingWidget() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: VisibilityDetector(
        key: keyLoading,
        child: const CircularProgressIndicator.adaptive(
          strokeCap: StrokeCap.round,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNormal),
        ),
        onVisibilityChanged: (info) async {
          if (info.visibleFraction > 0.0) {
            if (_isLoading && controller.isFetching == false) {
              _isLoading = false;
              await _loadMore();
              _isLoading = true;
            }
          }
        },
      ),
    );
  }

  Widget _statusWidget(String message) {
    if (controller.data.isEmpty) {
      return const SizedBox();
    }
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () => _loadMore(),
            child: Text("TryAgain"),
          ),
        ],
      ),
    );
  }

  Widget _loadMoreState() {
    if (_loadingMoreState is Loading) {
      return _loadingWidget();
    } else if (_loadingMoreState is NoInternet) {
      return _statusWidget("No Internet Connection");
    } else if (_loadingMoreState is Failed) {
      return _statusWidget("Error");
    } else if (_loadingMoreState is Timeout) {
      return _statusWidget("Timeout");
    } else if (_loadingMoreState is SomethingWentWrong) {
      return _statusWidget("Error");
    } else if (_loadingMoreState is Empty) {
      return const SizedBox();
    } else if (_loadingMoreState is Nothing) {
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }

  Future<void> _loadMore() async {
    try {
      if (controller.hasMore) {
        setState(() {
          _loadingMoreState = Loading();
        });

        controller.offset = controller.data.length;
        var newState = await widget.onLoadPage(controller.offset);
        if (newState is Success<List<ITEM>>) {
          var newData = newState.data;
          if (newData.isEmpty) {
            if (mounted) {
              setState(() {
                controller.hasMore = false;
                _loadingMoreState = Empty();
              });
            }
          } else {
            controller.data.addAll(newData);
            controller.switchState(Success(controller.data));
          }
        } else {
          if (mounted) {
            setState(() {
              _loadingMoreState = newState;
            });
          }
        }
        keyLoading = UniqueKey();
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: _loadMoreState());
  }
}
