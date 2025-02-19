import 'package:core_flutter/app/constants/app_path.dart';
import 'package:core_flutter/app/data/models/response/message_response.dart';
import 'package:core_flutter/app/theme/app_colors.dart';
import 'package:core_flutter/app/theme/app_text_style.dart';
import 'package:core_flutter/app/widgets/app_anim_switcher.dart';
import 'package:core_flutter/app/widgets/app_outlined_button.dart';
import 'package:core_flutter/app/widgets/space_vertical.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

abstract class ViewState<T> {}

class Loading<T> extends ViewState<T> {}

class Success<T> extends ViewState<T> {
  final T data;

  Success(this.data);
}

class Failed<T> extends ViewState<T> {
  final MessageResponse? messageResponse;

  Failed({this.messageResponse});
}

class Empty<T> extends ViewState<T> {}

class NoInternet<T> extends ViewState<T> {}

class Timeout<T> extends ViewState<T> {}

class SomethingWentWrong<T> extends ViewState<T> {
  final dynamic exception;

  SomethingWentWrong(this.exception);
}

class Nothing<T> extends ViewState<T> {}

class CustomStateViewController<T> {
  final List<void Function(ViewState<T>)> _setSwitchStateCallbacks = [];
  final List<void Function()> _setResetCallbacks = [];
  final List<void Function(ViewState<T>)> _setSwipeRefreshCallbacks = [];
  final List<void Function(ViewState<T>)> _setRetryCallbacks = [];
  final List<void Function()> _setRefreshLayoutCallbacks = [];

  late Future<ViewState<T>> Function() _onLoad;

  late T data;

  void addSwitchStateCallback(void Function(ViewState<T> viewState) callback) {
    _setSwitchStateCallbacks.add(callback);
  }

  void removeSwitchStateCallback(
      void Function(ViewState<T> viewState) callback) {
    _setSwitchStateCallbacks.remove(callback);
  }

  void addResetCallback(void Function() callback) {
    _setResetCallbacks.add(callback);
  }

  void removeResetCallback(void Function() callback) {
    _setResetCallbacks.remove(callback);
  }

  void addSwipeRefreshCallback(void Function(ViewState<T> viewState) callback) {
    _setSwipeRefreshCallbacks.add(callback);
  }

  void removeSwipeRefreshCallback(
      void Function(ViewState<T> viewState) callback) {
    _setSwipeRefreshCallbacks.remove(callback);
  }

  void addRefreshLayoutCallback(void Function() callback) {
    _setRefreshLayoutCallbacks.add(callback);
  }

  void removeRefreshLayoutCallback(void Function() callback) {
    _setRefreshLayoutCallbacks.remove(callback);
  }

  void addRetryCallback(void Function(ViewState<T> viewState) callback) {
    _setRetryCallbacks.add(callback);
  }

  void removeRetryCallback(
    void Function(ViewState<T> viewState) callback,
  ) {
    _setRetryCallbacks.remove(callback);
  }

  ///This is switch state
  void switchState(ViewState<T> state) {
    if (state is Success<T>) {
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

  Future<ViewState<T>>? retry() async {
    reset();
    switchState(Loading());
    final result = await load();
    for (var callback in _setRetryCallbacks) {
      callback(result);
    }
    return result;
  }

  Future<ViewState<T>>? swipeRefresh() async {
    reset();
    final result = await load();
    for (var callback in _setSwipeRefreshCallbacks) {
      callback(result);
    }
    return result;
  }

  void setOnLoadCallback(Future<ViewState<T>> Function() onLoad) {
    _onLoad = onLoad;
  }

  Future<ViewState<T>> load() async {
    final viewState = await _onLoad();
    if (viewState is Success<T>) {
      data = viewState.data;
    }
    switchState(viewState);
    return viewState;
  }

  Future<ViewState<T>> reload() async {
    reset();
    final viewState = await _onLoad();
    if (viewState is Success<T>) {
      data = viewState.data;
    }
    switchState(viewState);
    return viewState;
  }
}

class CustomStateView<T> extends StatefulWidget {
  final CustomStateViewController<T> controller;
  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;
  final Future<ViewState<T>> Function() onLoad;
  final ViewState<T>? currentState;
  final bool isHaveRefreshIndicator;
  final bool isHaveRetryButton;
  final Color backgroundColor;
  final Widget? loadingWidget;
  final Widget? noInternetWidget;
  final Widget? failedWidget;
  final Widget? emptyWidget;
  final Widget? somethingWentWrongWidget;
  final Widget? timeoutWidget;
  final Widget Function(T data) child;

  const CustomStateView(
      {super.key,
      required this.controller,
      this.refreshIndicatorKey,
      required this.onLoad,
      this.currentState,
      this.isHaveRefreshIndicator = false,
      this.isHaveRetryButton = true,
      this.backgroundColor = Colors.transparent,
      this.loadingWidget,
      this.noInternetWidget,
      this.failedWidget,
      this.emptyWidget,
      this.somethingWentWrongWidget,
      this.timeoutWidget,
      required this.child});

  @override
  State<StatefulWidget> createState() => _CustomStateViewState<T>();
}

class _CustomStateViewState<T> extends State<CustomStateView<T>> {
  CustomStateViewController<T> get controller => widget.controller;
  Widget Function(T data) get child => widget.child;
  bool get isHaveRetryButton => widget.isHaveRetryButton;
  bool get isHaveRefreshIndicator => widget.isHaveRefreshIndicator;
  Future<ViewState<T>> Function() get onLoad => widget.onLoad;
  late ViewState<T> _currentState;
  late Widget loadingWidget;
  late Widget noInternetWidget;
  late Widget failedWidget;
  late Widget emptyWidget;
  late Widget somethingWentWrongWidget;
  late Widget timeoutWidget;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<ViewState<T>> _setOnLoadCallback() {
    return onLoad.call();
  }

  void _refreshLayoutCallback() {
    if (mounted) {
      setState(() {});
    }
  }

  void _swipeRefreshCallback(ViewState<T> viewState) {
    if (mounted) {
      setState(() {
        _currentState = viewState;
      });
    }
  }

  void _resetCallback() {
    if (mounted) {
      // setState(() {});
    }
  }

  void _retryCallback(ViewState<T> viewState) {
    if (mounted) {
      setState(() {
        _currentState = viewState;
      });
    }
  }

  void _switchStateCallback(ViewState<T> state) {
    if (mounted) {
      setState(() {
        _currentState = state;
      });
    }
  }

  @override
  void initState() {
    controller.setOnLoadCallback(_setOnLoadCallback);
    controller.addRefreshLayoutCallback(_refreshLayoutCallback);
    controller.addSwipeRefreshCallback(_swipeRefreshCallback);
    controller.addResetCallback(_resetCallback);
    controller.addRetryCallback(_retryCallback);
    controller.addSwitchStateCallback(_switchStateCallback);
    _initStateWidget();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeRefreshLayoutCallback(_refreshLayoutCallback);
    controller.removeSwipeRefreshCallback(_swipeRefreshCallback);
    controller.removeResetCallback(_resetCallback);
    controller.removeRetryCallback(_retryCallback);
    controller.removeSwitchStateCallback(_switchStateCallback);
    super.dispose();
  }

  void _initStateWidget() {
    _currentState = widget.currentState ?? Loading<T>();
    if (widget.currentState == null) {
      controller.load();
    } else {
      _currentState = widget.currentState!;
    }
    if (widget.loadingWidget != null) {
      loadingWidget = widget.loadingWidget!;
    } else {
      loadingWidget = const Center(
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
        title: "No Internet Connection",
        descripiton:
            "No internet connection. Please check your network settings and try again.",
        isHaveRetryButton: isHaveRetryButton,
        backgroundColor: widget.backgroundColor,
        onPressed: _retry,
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
        isHaveRetryButton: isHaveRetryButton,
        backgroundColor: widget.backgroundColor,
        onPressed: _retry,
      );
    }

    if (widget.emptyWidget != null) {
      emptyWidget = widget.emptyWidget!;
    } else {
      emptyWidget = RequestStateView(
        iconPath: AppPath.stateEmpty,
        title: "No Data",
        descripiton: "No Data Available",
        isHaveRetryButton: isHaveRetryButton,
        backgroundColor: widget.backgroundColor,
        onPressed: _retry,
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
        isHaveRetryButton: isHaveRetryButton,
        backgroundColor: widget.backgroundColor,
        onPressed: _retry,
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
        isHaveRetryButton: isHaveRetryButton,
        backgroundColor: widget.backgroundColor,
        onPressed: _retry,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: AppAnimSwitcher(
        child: _getChildForState(),
      ),
    );
  }

  Widget _getChildForState() {
    if (_currentState is Loading) {
      return loadingWidget;
    } else if (_currentState is Success) {
      final data = (_currentState as Success).data;
      return isHaveRefreshIndicator
          ? RefreshIndicator.adaptive(
              key: widget.refreshIndicatorKey,
              color: AppColors.primaryNormal,
              backgroundColor: AppColors.white,
              onRefresh: () async {
                await controller.swipeRefresh();
                return await Future.value();
              },
              child: SizedBox.expand(
                child: child.call(data),
              ),
            )
          : child.call(data);
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

  void _retry() {
    controller.retry();
  }
}

class RequestStateView extends StatelessWidget {
  final String iconPath;
  final String title;
  final String descripiton;
  final bool isHaveRetryButton;
  final String titleRetryButton;
  final Color backgroundColor;
  final Function() onPressed;
  const RequestStateView(
      {super.key,
      required this.iconPath,
      required this.title,
      required this.descripiton,
      this.isHaveRetryButton = true,
      this.titleRetryButton = "",
      required this.onPressed,
      this.backgroundColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: backgroundColor,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          const SpaceVertical(),
          SvgPicture.asset(
            iconPath,
            width: 200,
          ),
          const SpaceVertical(),
          Text(title, style: AppTextStyle.h5Headline),
          const SpaceVertical(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              descripiton,
              style: AppTextStyle.body4.copyWith(color: AppColors.placeholder),
              textAlign: TextAlign.center,
            ),
          ),
          Visibility(visible: isHaveRetryButton, child: const SpaceVertical()),
          Visibility(
            visible: isHaveRetryButton,
            child: AppOutlinedButton(
              onPressed: onPressed,
              text:
                  titleRetryButton.isNotEmpty ? titleRetryButton : "Try Again",
            ),
          ),
          const SpaceVertical(),
        ],
      ),
    );
  }
}
