import 'package:core_flutter/app/constants/app_decoration.dart';
import 'package:core_flutter/app/constants/app_path.dart';
import 'package:core_flutter/app/widgets/anim_list_item.dart';
import 'package:flutter/material.dart';
import 'custom_state_view.dart';

enum CustomSliverPagingType {
  grid,
  linear,
}

class CustomSliverPagingView<ITEM> extends StatefulWidget {
  final CustomSliverPagingViewController<ITEM> controller;
  final bool hasMore;
  final Axis scrollDirection;
  final bool isHaveRetryButton;
  final CustomSliverPagingType customPagingType;
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

  const CustomSliverPagingView({
    super.key,
    required this.controller,
    this.hasMore = true,
    this.scrollDirection = Axis.vertical,
    this.isHaveRetryButton = true,
    this.customPagingType = CustomSliverPagingType.linear,
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
  State<StatefulWidget> createState() => _CustomSliverPagingViewState<ITEM>();
}

class _CustomSliverPagingViewState<ITEM>
    extends State<CustomSliverPagingView<ITEM>> {
  CustomSliverPagingViewController<ITEM> get controller => widget.controller;
  CustomSliverPagingType get customPagingType => widget.customPagingType;
  EdgeInsetsGeometry get padding => widget.padding;
  ViewState<List<ITEM>> _currentState = Loading();
  late Widget loadingWidget;
  late Widget noInternetWidget;
  late Widget failedWidget;
  late Widget emptyWidget;
  late Widget somethingWentWrongWidget;
  late Widget timeoutWidget;

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
      controller.offset = 0;
      controller.hasMore = widget.hasMore;
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
    final result = await widget.onLoadPage(controller.offset);
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
        controller.offset = 0;
        controller.hasMore = widget.hasMore;
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
    controller.hasMore = widget.hasMore;
    if (widget.currentState == null) {
      controller.load();
    } else {
      _currentState = widget.currentState!;
    }
    if (widget.loadingWidget != null) {
      loadingWidget = widget.loadingWidget!;
    } else {
      loadingWidget = const SizedBox();
    }

    if (widget.noInternetWidget != null) {
      noInternetWidget = widget.noInternetWidget!;
    } else {
      noInternetWidget = RequestStateView(
        iconPath: AppPath.stateNoConnection,
        title: "No Internet Connection",
        descripiton:
            "No internet connection. Please check your network settings and try again.",
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
        descripiton:
            "Oops! Something went wrong while processing your request. Please try again later.",
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
        descripiton:
            "We apologize for the inconvenience. Please try again later.",
        onPressed: controller.retry,
        isHaveRetryButton: widget.isHaveRetryButton,
      );
    }

    if (widget.timeoutWidget != null) {
      timeoutWidget = widget.timeoutWidget!;
    } else {
      timeoutWidget = RequestStateView(
        iconPath: AppPath.stateError,
        title: "Timeout!",
        descripiton:
            "The server is taking too long to respond. This could be due to poor connectivity or an error with our servers. Please try again later.",
        onPressed: controller.retry,
        isHaveRetryButton: widget.isHaveRetryButton,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getChildForState();
  }

  Widget _getChildForState() {
    if (_currentState is Loading) {
      return SliverToBoxAdapter(child: loadingWidget);
    } else if (_currentState is Success) {
      final data = (_currentState as Success).data;
      controller.data = data;
      return _validateChildSuccess(data: data);
    } else if (_currentState is NoInternet) {
      return SliverToBoxAdapter(child: noInternetWidget);
    } else if (_currentState is SomethingWentWrong) {
      return SliverToBoxAdapter(child: somethingWentWrongWidget);
    } else if (_currentState is Timeout) {
      return SliverToBoxAdapter(child: timeoutWidget);
    } else if (_currentState is Failed) {
      return SliverToBoxAdapter(child: failedWidget);
    } else if (_currentState is Empty) {
      return SliverToBoxAdapter(child: emptyWidget);
    } else if (_currentState is Nothing) {
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }

  Widget _validateChildSuccess({required List<ITEM> data}) {
    return _validatePagingType(data: data);
  }

  Widget _validatePagingType({required List<ITEM> data}) {
    switch (customPagingType) {
      case CustomSliverPagingType.grid:
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

      case CustomSliverPagingType.linear:
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
}

class CustomSliverPagingViewController<ITEM> {
  final List<void Function(ViewState<List<ITEM>>)> _setSwitchStateCallbacks =
      [];
  final List<void Function()> _setResetCallbacks = [];
  final List<void Function(ViewState<List<ITEM>>)> _setSwipeRefreshCallbacks =
      [];
  final List<void Function(ViewState<List<ITEM>>)> _setRetryCallbacks = [];
  final List<void Function()> _setRefreshLayoutCallbacks = [];

  late Future<ViewState<List<ITEM>>> Function() _onLoad;

  var data = List<ITEM>.empty();

  bool isFetching = false;
  bool hasMore = true;
  int offset = 0;

  void addSwitchStateCallback(
      void Function(ViewState<List<ITEM>> viewState) callback) {
    _setSwitchStateCallbacks.add(callback);
  }

  void removeSwitchStateCallback(
      void Function(ViewState<List<ITEM>> viewState) callback) {
    _setSwitchStateCallbacks.remove(callback);
  }

  void addResetCallback(void Function() callback) {
    _setResetCallbacks.add(callback);
  }

  void removeResetCallback(void Function() callback) {
    _setResetCallbacks.remove(callback);
  }

  void addSwipeRefreshCallback(
      void Function(ViewState<List<ITEM>> viewState) callback) {
    _setSwipeRefreshCallbacks.add(callback);
  }

  void removeSwipeRefreshCallback(
      void Function(ViewState<List<ITEM>> viewState) callback) {
    _setSwipeRefreshCallbacks.remove(callback);
  }

  void addRefreshLayoutCallback(void Function() callback) {
    _setRefreshLayoutCallbacks.add(callback);
  }

  void removeRefreshLayoutCallback(void Function() callback) {
    _setRefreshLayoutCallbacks.remove(callback);
  }

  void addRetryCallback(
      void Function(ViewState<List<ITEM>> viewState) callback) {
    _setRetryCallbacks.add(callback);
  }

  void removeRetryCallback(
    void Function(ViewState<List<ITEM>> viewState) callback,
  ) {
    _setRetryCallbacks.remove(callback);
  }

  ///This is switch state
  void switchState(ViewState<List<ITEM>> state) {
    if (state is Success<List<ITEM>>) {
      data = state.data;
    }
    for (var callback in _setSwitchStateCallbacks) {
      callback(state);
    }
  }

  void refreshLayout() {
    for (var callback in _setRefreshLayoutCallbacks) {
      callback();
    }
  }

  void reset() {
    for (var callback in _setResetCallbacks) {
      callback();
    }
  }

  Future<ViewState<List<ITEM>>>? retry() async {
    reset();
    switchState(Loading());
    final result = await load();
    for (var callback in _setRetryCallbacks) {
      callback(result);
    }
    return result;
  }

  Future<ViewState<List<ITEM>>>? swipeRefresh() async {
    reset();
    final result = await load();
    for (var callback in _setSwipeRefreshCallbacks) {
      callback(result);
    }
    return result;
  }

  void setOnLoadCallback(Future<ViewState<List<ITEM>>> Function() onLoad) {
    _onLoad = onLoad;
  }

  Future<ViewState<List<ITEM>>> load() async {
    isFetching = true;
    final viewState = await _onLoad();
    if (viewState is Success<List<ITEM>>) {
      data = viewState.data;
    }
    switchState(viewState);
    isFetching = false;
    return viewState;
  }

  Future<ViewState<List<ITEM>>> reload() async {
    reset();
    final viewState = await _onLoad();
    if (viewState is Success<List<ITEM>>) {
      data = viewState.data;
    }
    switchState(viewState);
    return viewState;
  }
}
