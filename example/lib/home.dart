import 'dart:developer';

import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature/drawing_board.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
// State<Home> createState() => _GestureTestState();
// State<Home> createState() => _PointerMoveIndicatorState();
// State<Home> createState() => _HomeState();
}

// class _PointerMoveIndicatorState extends State<Home> {
//   PointerEvent? _event;
//
//   @override
//   Widget build(BuildContext context) {
//     return Listener(
//       child: Container(
//         alignment: Alignment.center,
//         color: Colors.blue,
//         width: 300.0,
//         height: 150.0,
//         child: Text(
//           '${_event?.localPosition ?? ''}',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       onPointerDown: (PointerDownEvent event) => setState(() => _event = event),
//       onPointerMove: (PointerMoveEvent event) => setState(() => _event = event),
//       onPointerUp: (PointerUpEvent event) => setState(() => _event = event),
//     );
//   }
// }

// class _GestureTestState extends State<Home> {
//   String _operation = "No Gesture detected!"; //保存事件名
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         child: Container(
//           alignment: Alignment.center,
//           color: Colors.blue,
//           width: 200.0,
//           height: 100.0,
//           child: Text(
//             _operation,
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         onTap: () => updateText("Tap"), //点击
//         onDoubleTap: () => updateText("DoubleTap"), //双击
//         onLongPress: () => updateText("LongPress"), //长按
//       ),
//     );
//   }
//
//   void updateText(String text) {
//     //更新显示的事件名
//     setState(() {
//       _operation = text;
//     });
//   }
// }

// class _DragState extends State<Home> with SingleTickerProviderStateMixin {
//   double _top = 0.0; //距顶部的偏移
//   double _left = 0.0; //距左边的偏移
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           top: _top,
//           child: GestureDetector(
//             child: const CircleAvatar(child: Text("A")),
//             //垂直方向拖动事件
//             onVerticalDragUpdate: (DragUpdateDetails details) {
//               setState(() {
//                 _top += details.delta.dy;
//               });
//             },
//           ),
//           // top: _top,
//           // left: _left,
//           // child: GestureDetector(
//           //   child: CircleAvatar(child: Text("A")),
//           //   //手指按下时会触发此回调
//           //   onPanDown: (DragDownDetails e) {
//           //     //打印手指按下的位置(相对于屏幕)
//           //     print("用户手指按下：${e.globalPosition}");
//           //   },
//           //   //手指滑动时会触发此回调
//           //   onPanUpdate: (DragUpdateDetails e) {
//           //     //用户手指滑动时，更新偏移，重新构建
//           //     setState(() {
//           //       _left += e.delta.dx;
//           //       _top += e.delta.dy;
//           //     });
//           //   },
//           //   onPanEnd: (DragEndDetails e){
//           //     //打印滑动结束时在x、y轴上的速度
//           //     print(e.velocity);
//           //   },
//           // ),
//         )
//       ],
//     );
//   }
// }

// class _ScaleState extends State<Home> {
//   double _width = 200.0; //通过修改图片宽度来达到缩放效果
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         //指定宽度，高度自适应
//         child: Icon(Icons.construction_outlined,size: _width,color: Colors.white,),
//         onScaleUpdate: (ScaleUpdateDetails details) {
//           setState(() {
//             //缩放倍数在0.8到10倍之间
//             _width=200*details.scale.clamp(.8, 10.0);
//           });
//         },
//       ),
//     );
//   }
// }

class _HomeState extends State<Home> {
  // initialize the signature controller
  final DrawingBoardController _controller = DrawingBoardController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
    exportPenColor: Colors.black,
    // onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    // _controller.addListener(() => log('Value changed'));
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    super.dispose();
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data =
        await _controller.toPngBytes(height: 1000, width: 1000);
    if (data == null) {
      return;
    }

    if (!mounted) return;

    await push(
      context,
      Scaffold(
        appBar: AppBar(
          title: const Text('PNG Image'),
        ),
        body: Center(
          child: Container(
            color: Colors.grey[300],
            child: Image.memory(data),
          ),
        ),
      ),
    );
  }

  Future<void> exportSVG(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarSVG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final SvgPicture data = _controller.toSVG()!;

    if (!mounted) return;

    await push(
      context,
      Scaffold(
        appBar: AppBar(
          title: const Text('SVG Image'),
        ),
        body: Center(
          child: Container(
            color: Colors.grey[300],
            child: data,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature Demo'),
      ),
      body: DrawingBoard(
         key: const Key('signature'),
        controller: _controller,
        backgroundColor: Colors.grey[300]!,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              //SHOW EXPORTED IMAGE IN NEW ROUTE
              IconButton(
                key: const Key('exportPNG'),
                icon: const Icon(Icons.image),
                color: Colors.blue,
                onPressed: () => exportImage(context),
                tooltip: 'Export Image',
              ),
              IconButton(
                key: const Key('exportSVG'),
                icon: const Icon(Icons.share),
                color: Colors.blue,
                onPressed: () => exportSVG(context),
                tooltip: 'Export SVG',
              ),
              IconButton(
                icon: const Icon(Icons.undo),
                color: Colors.blue,
                onPressed: () {
                  setState(() => _controller.undo());
                },
                tooltip: 'Undo',
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                color: Colors.blue,
                onPressed: () {
                  setState(() => _controller.redo());
                },
                tooltip: 'Redo',
              ),
              //CLEAR CANVAS
              IconButton(
                key: const Key('clear'),
                icon: const Icon(Icons.clear),
                color: Colors.blue,
                onPressed: () {
                  setState(() => _controller.clear());
                },
                tooltip: 'Clear',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
