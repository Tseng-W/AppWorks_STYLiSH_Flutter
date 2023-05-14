import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class BodyTrackerView extends StatefulWidget {
  const BodyTrackerView({super.key});

  @override
  State<BodyTrackerView> createState() => _BodyTrackerViewState();
}

class _BodyTrackerViewState extends State<BodyTrackerView> {
  late ARKitController arkitController;

  List<Rect> rects = [Rect.fromPoints(Offset(0, 0), Offset(100, 100))];

  final nodePositions = [
    ARKitSkeletonJointName.leftHand,
    ARKitSkeletonJointName.rightHand,
    ARKitSkeletonJointName.leftFoot,
    ARKitSkeletonJointName.rightFoot,
    ARKitSkeletonJointName.leftShoulder,
    ARKitSkeletonJointName.rightShoulder,
    ARKitSkeletonJointName.head,
  ];

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  _onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onUpdateNodeForAnchor =
        (anchor) => _onUpdateNodeForAnchor(anchor);
    this.arkitController.onAddNodeForAnchor =
        (anchor) => _onAddNodeForAnchor(anchor);
  }

  _onUpdateNodeForAnchor(ARKitAnchor anchor) {
    if ((anchor is ARKitBodyAnchor && mounted) == false) {
      return;
    }

    final vectors = nodePositions
        .map((e) => _anchorToVector(anchor as ARKitBodyAnchor, e, true)!)
        .toList();
    _worldToScreenTransform(vectors);
  }

  Future<void> _worldToScreenTransform(List<vector.Vector3> vectors) async {
    // final pointsViewportSpaceResults = await Future.wait(pointsViewportSpace);

    // setState(() {
    //   x = pointsViewportSpaceResults[2]!.x;
    //   y = pointsViewportSpaceResults[2]!.y;
    //   this.width = pointsViewportSpaceResults[0]!
    //       .distanceTo(pointsViewportSpaceResults[3]!);
    //   this.height = pointsViewportSpaceResults[1]!
    //       .distanceTo(pointsViewportSpaceResults[2]!);
    // });
    print('_worldToScreenTransform start');
    print('origin vectors: ${vectors}');
    List<Future<vector.Vector3?>> futures = vectors.map((e) {
      return arkitController.projectPoint(e);
    }).toList();
    List<vector.Vector3?> results = await Future.wait(futures);
    print('_worldToScreenTransform transform ended');

    results.forEach((element) {
      if (element != null) {
        print('new: $element');
      }
    });

    setState(() {
      rects = results
          .map((e) => Rect.fromCenter(
              center: Offset(e!.x, e.y), width: 100, height: 100))
          .toList();
    });
    print('_worldToScreenTransform end');
  }

  _onAddNodeForAnchor(ARKitAnchor anchor) {
    if (anchor is! ARKitBodyAnchor) {
      return;
    }

    final nodePositions = [
      ARKitSkeletonJointName.leftHand,
      ARKitSkeletonJointName.rightHand,
      ARKitSkeletonJointName.leftFoot,
      ARKitSkeletonJointName.rightFoot,
      ARKitSkeletonJointName.leftShoulder,
      ARKitSkeletonJointName.rightShoulder,
      ARKitSkeletonJointName.head,
    ];

    nodePositions
        .map((e) => _anchorToVector(anchor, e, false))
        .forEach((element) {
      arkitController.add(_createSphere(element),
          parentNodeName: anchor.nodeName);
    });
  }

  vector.Vector3? _anchorToVector(
      ARKitBodyAnchor anchor, ARKitSkeletonJointName name, bool isLocal) {
// final transform = anchor.transform;
    // final width = anchor.referenceImagePhysicalSize.x / 2;
    // final height = anchor.referenceImagePhysicalSize.y / 2;

    // final topRight = vector.Vector4(width, 0, -height, 1)
    //   ..applyMatrix4(transform);
    // final bottomRight = vector.Vector4(width, 0, height, 1)
    //   ..applyMatrix4(transform);
    // final bottomLeft = vector.Vector4(-width, 0, -height, 1)
    //   ..applyMatrix4(transform);
    // final topLeft = vector.Vector4(-width, 0, height, 1)
    //   ..applyMatrix4(transform);

    // final pointsWorldSpace = [topRight, bottomRight, bottomLeft, topLeft];

    // final pointsViewportSpace = pointsWorldSpace.map(
    //     (p) => arkitController.projectPoint(vector.Vector3(p.x, p.y, p.z)));

    if (anchor.isTracked == false) {
      setState(() {
        rects = [];
      });
      return null;
    }

    if (isLocal) {
      final transform = anchor.skeleton.localTransformsFor(name)!;
      final center = vector.Vector4(0, 0, 0, 1)..applyMatrix4(transform);
      final centerVector3 = vector.Vector3(center.x, center.y, center.z);
      final transformVector3 = vector.Vector3(
        transform.getColumn(3).x,
        transform.getColumn(3).y,
        transform.getColumn(3).z,
      );
      print('center: $center');
      print('centerVector3: $centerVector3');
      print('transformVector3: $transformVector3');
      return centerVector3;
    } else {
      final transform = anchor.skeleton.modelTransformsFor(name)!;
      return vector.Vector3(
        transform.getColumn(3).x,
        transform.getColumn(3).y,
        transform.getColumn(3).z,
      );
    }
  }

  ARKitNode _createSphere(vector.Vector3? position) {
    return ARKitReferenceNode(
      url: 'models.scnassets/dash.dae',
      scale: vector.Vector3.all(0.5),
      position: position,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Tracker'),
      ),
      body: Stack(
        children: [
          ARKitSceneView(
              configuration: ARKitConfiguration.bodyTracking,
              onARKitViewCreated: _onARKitViewCreated),
          CustomPaint(
            size: MediaQuery.sizeOf(context),
            painter: MyPainter(rects: rects),
          )
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({required this.rects});

  List<Rect> rects;

  @override
  void paint(Canvas canvas, Size size) {
    print('Start drawing in canvas with size: $size');
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // canvas.drawRRect(RRect.fromRectAndRadius(, radius), paint)
    rects.forEach((rect) {
      print('painting rect: $rect');
      canvas.drawRect(rect, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}