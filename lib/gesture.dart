import 'package:flutter/widgets.dart';
import 'package:signature/drawing_board.dart';

///   author : liuduo
///   e-mail : liuduo@gyenno.com
///   time   : 2023/03/07
///   desc   :
///   version: 1.0

///手势管理器
class GestureManager {
  /// 工厂构造函数返回单例实例
  GestureManager(this.state);

  DrawingBoardState state;

  ///当前手势类型
  GestureType? activeGestureType;

  ///平移开始点
  ScaleStartDetails? panStartDetails;

  void onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount == 1 && activeGestureType == null) {
      panStartDetails = details;
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 2) {
      activeGestureType ??= GestureType.scale;
    } else if (details.pointerCount == 1) {
      activeGestureType ??= GestureType.pan;
    }

    if (details.pointerCount == 2 && activeGestureType == GestureType.scale) {
      //双指
      state.draw(() {
        state.widget.controller.scaleUpdate = details.scale;
        state.widget.controller.translation += details.focalPointDelta;
        // state.widget.controller.translation += details.focalPointDelta +
        //     Offset(-details.scale * state.widget.controller.width / 2,
        //         -details.scale * state.widget.controller.height / 2);
      });
    } else if (details.pointerCount == 1 &&
        activeGestureType == GestureType.pan) {
      //单指
      final ScaleStartDetails? startDetails = panStartDetails;
      if (startDetails != null) {
        state.addPoint(startDetails.localFocalPoint, PointType.tap);
        panStartDetails = null;
      }
      state.addPoint(details.localFocalPoint, PointType.move);
      state.widget.controller.onDrawMove?.call();
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (details.pointerCount == 1 && activeGestureType == GestureType.scale) {
      state.widget.controller.scale *= state.widget.controller.scaleUpdate;
      state.widget.controller.scaleUpdate = 1.0;
    } else if (details.pointerCount == 0 &&
        activeGestureType == GestureType.pan) {
      state.widget.controller.pushCurrentStateToUndoStack();
      state.widget.controller.onDrawEnd?.call();
    }

    activeGestureType = null;
  }
}

enum GestureType implements GestureController {
  pan(PanGestureController()),
  scale(ScaleGestureController());

  const GestureType(this.controller);

  final GestureController controller;

  @override
  void onGestureUpdate() => controller.onGestureUpdate();

  @override
  void onGestureEnd() => controller.onGestureEnd();
}

class PanGestureController implements GestureController {
  const PanGestureController();

  @override
  void onGestureEnd() {
    // TODO: implement onGestureEnd
  }

  @override
  void onGestureUpdate() {
    // TODO: implement onGestureUpdate
  }
}

class ScaleGestureController implements GestureController {
  const ScaleGestureController();

  @override
  void onGestureEnd() {
    // TODO: implement onGestureEnd
  }

  @override
  void onGestureUpdate() {
    // TODO: implement onGestureUpdate
  }
}

///手势控制
abstract class GestureController {
  //手势更新
  void onGestureUpdate();

  //手势结束
  void onGestureEnd();
}
