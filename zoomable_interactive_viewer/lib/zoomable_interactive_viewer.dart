import 'package:flutter/material.dart';

class ZoomableInteractiveViewer extends StatefulWidget {
  final Widget child;
  final bool enableAnimation;
  final Curve animationCurve;
  final EdgeInsets boundaryMargin;
  final double minScale;
  final double maxScale;
  final bool panEnabled;
  final bool scaleEnabled;
  final bool constrained;

  const ZoomableInteractiveViewer({
    super.key,
    required this.child,
    this.enableAnimation = true,
    this.animationCurve = Curves.easeInOut, // Default curve for animation
    this.boundaryMargin = const EdgeInsets.all(20), // Default boundary margin
    this.minScale = 1.0, // Default min scale
    this.maxScale = 4.0, // Default max scale
    this.panEnabled = true, // Default for panning
    this.scaleEnabled = true, // Default for scaling
    this.constrained = true, // Default constraint behavior
  });

  @override
  State<ZoomableInteractiveViewer> createState() =>
      _ZoomableInteractiveViewerState();
}

class _ZoomableInteractiveViewerState extends State<ZoomableInteractiveViewer>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late ValueNotifier<bool> _isZoomed;
  TapDownDetails? _doubleTapDetails;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _isZoomed = ValueNotifier<bool>(false); // Track zoom status

    // Listen to transformation controller for scale changes
    _transformationController.addListener(() {
      // Check if the current scale is greater than 1 (zoomed in)
      final currentScale = _transformationController.value.getMaxScaleOnAxis();
      if (currentScale > 1.0 && !_isZoomed.value) {
        _isZoomed.value = true; // Set zoomed state to true
      } else if (currentScale <= 1.0 && _isZoomed.value) {
        _isZoomed.value = false; // Set zoomed state to false
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    _isZoomed.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final Matrix4 currentMatrix = _transformationController.value;
    double currentScale = currentMatrix.getMaxScaleOnAxis();
    final position = _doubleTapDetails!.localPosition;

    Matrix4 endMatrix;

    if (currentScale == 1.0) {
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(2.0);
    } else {
      endMatrix = Matrix4.identity();
    }

    if (widget.enableAnimation) {
      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: endMatrix,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve, // Use the custom curve
      ));
      _animationController.forward(from: 0);
    } else {
      _transformationController.value = endMatrix;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isZoomed,
      builder: (context, isZoomed, child) {
        return GestureDetector(
          onDoubleTapDown: (details) => _doubleTapDetails = details,
          onDoubleTap: _handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _transformationController,
            boundaryMargin: widget.boundaryMargin,
            minScale: widget.minScale,
            maxScale: widget.maxScale,
            // Enable panning only if zoomed in
            panEnabled: isZoomed ? widget.panEnabled : false,
            scaleEnabled: widget.scaleEnabled,
            constrained: widget.constrained,
            child: widget.child,
          ),
        );
      },
    );
  }
}
