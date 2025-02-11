import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/constants/app_path.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/widgets/anim_list_item.dart';
import 'package:core_flutter/app/widgets/app_anim_switcher.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'custom_state_view.dart';

enum CustomPagingType {
  grid,
  linear,
}

class CustomPagingView<ITEM> extends StatefulWidget {
  final CustomStateViewController<List<ITEM>> controller;

  final ScrollPhysics? physics;
  final bool hasMore;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool isHaveRefreshIndicator;
  final bool isHaveRetryButton;
  final CustomPagingType customPagingType;
  final ViewState<List<ITEM>>? currentState;
  final EdgeInsetsGeometry padding;
  final int crossAxisCount;
  final double childAspectRatio;
  final Function(int index)? onRemove;
  final Widget? loadingWidget;
  final Widget? noInternetWidget;
  final Widget? failedWidget;
  final Widget? emptyWidget;
  final Widget? somethingWentWrongWidget;
  final Widget? timeoutWidget;
  final Widget Function(
    ITEM item,
    int index,
    AnimListItemState? state,
  ) child;

  final Future<ViewState<List<ITEM>>> Function(int offset) onLoadPage;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  const CustomPagingView({
    super.key,
    required this.controller,
    this.physics,
    this.hasMore = true,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.isHaveRefreshIndicator = true,
    this.isHaveRetryButton = true,
    this.customPagingType = CustomPagingType.linear,
    this.currentState,
    this.padding = EdgeInsets.zero,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.loadingWidget,
    this.noInternetWidget,
    this.failedWidget,
    this.emptyWidget,
    this.somethingWentWrongWidget,
    this.timeoutWidget,
    required this.child,
    required this.onLoadPage,
    this.separatorBuilder,
    this.onRemove,
  });

  @override
  State<StatefulWidget> createState() => _CustomPagingViewState<ITEM>();
}

class _CustomPagingViewState<ITEM> extends State<CustomPagingView<ITEM>> {
  CustomStateViewController<List<ITEM>> get controller => widget.controller;
  bool get isHaveRefreshIndicator => widget.isHaveRefreshIndicator;
  CustomPagingType get customPagingType => widget.customPagingType;
  EdgeInsetsGeometry get padding => widget.padding;
  ViewState<List<ITEM>> _currentState = Loading();
  late Widget loadingWidget;
  late Widget noInternetWidget;
  late Widget failedWidget;
  late Widget emptyWidget;
  late Widget somethingWentWrongWidget;
  late Widget timeoutWidget;

  int _offset = 0;
  bool _hasMore = true;
  bool _isLoading = true;
  ViewState _loadingMoreState = Loading();
  var keyLoading = UniqueKey();
  get _gridDelegate => SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: AppDecoration.defaultSpacing,
        mainAxisSpacing: AppDecoration.defaultSpacing,
        childAspectRatio: widget.childAspectRatio,
      );
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void retryCallback(ViewState<List<ITEM>> viewState) {
    if (mounted) {
      setState(() {
        _currentState = viewState;
      });
    }
  }

  void resetCallback() {
    if (mounted) {
      _offset = 0;
      _hasMore = widget.hasMore;
      _loadingMoreState = Loading();
    }
  }

  void refreshLayoutCallback() {
    if (mounted) {
      setState(() {});
    }
  }

  void swipeRefreshCallback(ViewState<List<ITEM>> viewState) {
    if (mounted) {
      setState(() {
        _currentState = viewState;
      });
    }
  }

  Future<ViewState<List<ITEM>>> _setOnLoadCallback() async {
    final result = await widget.onLoadPage(_offset);
    if (mounted) {
      setState(() {
        _currentState = result;
      });
    }

    return result;
  }

  void switchStateCallback(ViewState<List<ITEM>> state) {
    if (mounted) {
      setState(() {
        _currentState = state;
      });
    }
  }

  void currentStateCallback(ViewState<List<ITEM>> viewState) {
    if (mounted) {
      setState(() {
        _currentState = viewState;
        _offset = 0;
        _hasMore = widget.hasMore;
        _loadingMoreState = Loading();
      });
    }
  }

  @override
  void initState() {
    controller.setOnLoadCallback(_setOnLoadCallback);
    controller.addSwitchStateCallback(switchStateCallback);
    controller.addSwipeRefreshCallback(swipeRefreshCallback);
    controller.addRetryCallback(retryCallback);
    controller.addRefreshLayoutCallback(refreshLayoutCallback);
    controller.addResetCallback(resetCallback);
    initStateWidget();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeSwitchStateCallback(switchStateCallback);
    controller.removeSwipeRefreshCallback(swipeRefreshCallback);
    controller.removeRetryCallback(retryCallback);
    controller.removeRefreshLayoutCallback(refreshLayoutCallback);
    controller.removeResetCallback(resetCallback);
    super.dispose();
  }

  void initStateWidget() {
    _hasMore = widget.hasMore;
    if (widget.currentState == null) {
      controller.load();
    } else {
      _currentState = widget.currentState!;
    }
    if (widget.loadingWidget != null) {
      loadingWidget = widget.loadingWidget!;
    } else {
      loadingWidget =  const Padding(
        padding: EdgeInsets.all(AppDecoration.smallSpacing),
        child: CircularProgressIndicator.adaptive(
          strokeCap: StrokeCap.round,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNormal),
        ),
      );
    }

    if (widget.noInternetWidget != null) {
      noInternetWidget = widget.noInternetWidget!;
    } else {
      noInternetWidget = RequestStateView(
        iconPath: AppPath.stateNoConnection,
        title: "No Internet connection",
        descripiton: "No internet connection. Please check your network settings and try again.",
        onPressed: controller.retry,
        isHaveRetryButton: widget.isHaveRetryButton,
      );
    }

    if (widget.failedWidget != null) {
      failedWidget = widget.failedWidget!;
    } else {
      failedWidget = RequestStateView(
        iconPath: AppPath.stateError,
        title: "Error",
        descripiton: "Oops! Something went wrong while processing your request. Please try again later.",
        onPressed: controller.retry,
        isHaveRetryButton: widget.isHaveRetryButton,
      );
    }

    if (widget.emptyWidget != null) {
      emptyWidget = widget.emptyWidget!;
    } else {
      emptyWidget = RequestStateView(
        iconPath: AppPath.stateEmpty,
        title: "No Data",
        descripiton: "No Data Available",
        onPressed: controller.retry,
        isHaveRetryButton: widget.isHaveRetryButton,
      );
    }

    if (widget.somethingWentWrongWidget != null) {
      somethingWentWrongWidget = widget.somethingWentWrongWidget!;
    } else {
      somethingWentWrongWidget = RequestStateView(
        iconPath: AppPath.stateError,
        title: "Something went wrong",
        descripiton: "We apologize for the inconvenience. Please try again later.",
        onPressed: controller.retry,
        isHaveRetryButton: widget.isHaveRetryButton,
      );
    }

    if (widget.timeoutWidget != null) {
      timeoutWidget = widget.timeoutWidget!;
    } else {
      timeoutWidget = RequestStateView(
        iconPath: AppPath.stateError,
        title: "Timeout",
        descripiton: "The server is taking too long to respond. This could be due to poor connectivity or an error with our servers. Please try again later.",
        onPressed: controller.retry,
        isHaveRetryButton: widget.isHaveRetryButton,
      );
    }
  }

  Future<void> _loadMore() async {
    try {
      if (_hasMore) {
        setState(() {
          _loadingMoreState = Loading();
        });

        _offset = controller.data.length;
        var newState = await widget.onLoadPage(_offset);
        if (newState is Success<List<ITEM>>) {
          var newData = newState.data;
          if (newData.isEmpty) {
            if (mounted) {
              setState(() {
                _hasMore = false;
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
    return AppAnimSwitcher(
      child: _getChildForState(),
    );
  }

  Widget _getChildForState() {
    if (_currentState is Loading) {
      return loadingWidget;
    } else if (_currentState is Success) {
      final data = (_currentState as Success).data;
      controller.data = data;
      return _validateChildSuccess(data: data);
    } else if (_currentState is NoInternet) {
      return noInternetWidget;
    } else if (_currentState is SomethingWentWrong) {
      return somethingWentWrongWidget;
    } else if (_currentState is Timeout) {
      return timeoutWidget;
    } else if (_currentState is Failed) {
      return failedWidget;
    } else if (_currentState is Empty) {
      return emptyWidget;
    } else if (_currentState is Nothing) {
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }

  Widget _validateChildSuccess({required List<ITEM> data}) {
    if (isHaveRefreshIndicator) {
      return RefreshIndicator.adaptive(
        backgroundColor: AppColors.white,
        onRefresh: () async {
          await controller.swipeRefresh();
          return Future.value();
        },
        color: AppColors.primaryNormal,
        child: CustomScrollView(
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          scrollDirection: widget.scrollDirection,
          slivers: [
            _validatePagingType(data: data),
            SliverToBoxAdapter(
              child: _loadMoreState(),
            ),
          ],
        ),
      );
    } else {
      return CustomScrollView(
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        slivers: [
          _validatePagingType(data: data),
          SliverToBoxAdapter(
            child: _loadMoreState(),
          ),
        ],
      );
    }
  }

  Widget _validatePagingType({required List<ITEM> data}) {
    switch (customPagingType) {
      case CustomPagingType.grid:
        return SliverPadding(
          padding: data.isNotEmpty ? widget.padding : EdgeInsets.zero,
          sliver: SliverGrid(
            gridDelegate: _gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (widget.onRemove != null) {
                  return AnimListItem(
                    key: UniqueKey(),
                    onRemove: () {
                      widget.onRemove?.call(index);
                    },
                    child: (state) => widget.child(data[index], index, state),
                  );
                } else {
                  return widget.child(data[index], index, null);
                }
              },
              childCount: data.length,
            ),
          ),
        );

      case CustomPagingType.linear:
        return SliverPadding(
          padding: data.isNotEmpty ? widget.padding : EdgeInsets.zero,
          sliver: SliverList.separated(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Widget childWidget;

                if (widget.onRemove != null) {
                  childWidget = AnimListItem(
                    key: UniqueKey(),
                    onRemove: () {
                      widget.onRemove?.call(index);
                    },
                    child: (state) {
                      Widget innerChild =
                          widget.child(data[index], index, state);

                      return innerChild;
                    },
                  );
                } else {
                  childWidget = widget.child(data[index], index, null);
                }
                return childWidget;
              },
              separatorBuilder: (context, index) {
                if (widget.separatorBuilder != null) {
                  return widget.separatorBuilder!.call(context, index);
                }
                return const SizedBox.square(
                  dimension: AppDecoration.defaultSpacing,
                );
              }),
        );
    }
  }

  Widget _loadMoreState() {
    if (!_hasMore) {
      return const SizedBox();
    }
    if (_loadingMoreState is Loading) {
      return Container(
        height: 50,
        alignment: Alignment.center,
        child: VisibilityDetector(
          key: keyLoading,
          child: const CircularProgressIndicator.adaptive(
            strokeCap: StrokeCap.round,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryNormal)),
          onVisibilityChanged: (info) async {
            if (info.visibleFraction > 0.0) {
              if (_isLoading) {
                _isLoading = false;
                await _loadMore();
                _isLoading = true;
              }
            }
          },
        ),
      );
    } else if (_loadingMoreState is Failed ||
        _loadingMoreState is NoInternet ||
        _loadingMoreState is Timeout ||
        _loadingMoreState is SomethingWentWrong) {
      return Container(
        alignment: Alignment.center,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error"),
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
    } else if (_loadingMoreState is Empty) {
      return const SizedBox();
    } else if (_loadingMoreState is Nothing) {
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }
}
