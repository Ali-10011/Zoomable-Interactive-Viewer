import 'package:flutter/material.dart';

class ZoomableInteractiveViewer extends StatefulWidget {
  final Widget child;
  final bool enableAnimation;
  final Curve animationCurve;
  final EdgeInsets boundaryMargin;
  final double minScale;
  final double maxScale;
  final double zoomInMagnifierScale;
  final double zoomOutMagnifierScale;
  final bool panEnabled;
  final bool scaleEnabled;
  final bool constrained;
  final Color zoomInMagnifierColor;
  final Color zoomOutMagnifierColor;
  final bool enableZoomInMagnifier;
  const ZoomableInteractiveViewer({
    super.key,
    required this.child,
    this.enableAnimation = true,
    this.animationCurve = Curves.easeInOut, // Default curve for animation
    this.boundaryMargin = const EdgeInsets.all(20), // Default boundary margin
    this.minScale = 1.0, // Default min scale
    this.maxScale = 4.0, // Default max scale
    this.zoomInMagnifierScale = 1.0,
    this.zoomOutMagnifierScale = 1.0, // Default magnifier scale for zooming out
    this.panEnabled = true, // Default for panning
    this.scaleEnabled = true, // Default for scaling
    this.constrained = true, // Default constraint behavior
    this.zoomInMagnifierColor = Colors.white,
    this.zoomOutMagnifierColor = Colors.white,
    this.enableZoomInMagnifier = false,
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
  final GlobalKey _widgetKey = GlobalKey();
  late double _zoomInScale;
  late double _zoomOutScale;
  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _isZoomed = ValueNotifier<bool>(false); // Track zoom status
    _zoomInScale = widget.zoomInMagnifierScale;
    _zoomOutScale = widget.zoomOutMagnifierScale;
    // Listen to transformation controller for scale changes
    _transformationController.addListener(() {
      // Check if the current scale is greater than 1 (zoomed in)
      final currentScale = _transformationController.value.getMaxScaleOnAxis();
      if (currentScale > widget.minScale && !_isZoomed.value) {
        _isZoomed.value = true; // Set zoomed state to true
      } else if (currentScale <= widget.minScale && _isZoomed.value) {
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isZoomed,
      builder: (context, isZoomed, child) {
        return Stack(
          children: [
            GestureDetector(
              onDoubleTapDown: (details) => _doubleTapDetails = details,
              onDoubleTap: _handleDoubleTap,
              child: SizedBox(
                key: _widgetKey,
                height: MediaQuery.of(context).size.height,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  boundaryMargin: widget.boundaryMargin,
                  minScale: widget.minScale,
                  maxScale: widget.maxScale,
                  // Enable panning only if zoomed in
                  panEnabled: _handlePanStatus(isZoomed),
                  scaleEnabled: _handleScaleStatus(),

                  constrained: widget.constrained,
                  child: widget.child,
                ),
              ),
            ),
            if (widget.enableZoomInMagnifier)
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _handleButtonZoomIn();
                      },
                      icon: Padding(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          Icons.zoom_in,
                          color: widget.zoomInMagnifierColor,
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _handleButtonZoomOut();
                      },
                      icon: Padding(
                        padding: EdgeInsets.zero,
                        child: Icon(Icons.zoom_out,
                            color: widget.zoomOutMagnifierColor),
                      ),
                    ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }

  void _handleDoubleTap() {
    final Matrix4 currentMatrix = _transformationController.value;
    double currentScale = currentMatrix.getMaxScaleOnAxis();
    final position = _doubleTapDetails!.localPosition;

    Matrix4 endMatrix;

    if (currentScale == widget.minScale) {
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

  void _handleButtonZoomIn() {
    final Matrix4 currentMatrix = _transformationController.value;
    double currentScale = currentMatrix.getMaxScaleOnAxis();

    // Get the widget's size and calculate its center
    final RenderBox renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset widgetCenter =
        renderBox.localToGlobal(size.center(Offset.zero));

    // Set up the scale for zooming
    if (currentScale + _zoomInScale > widget.maxScale) {
      currentScale = widget.maxScale;
    } else {
      currentScale += _zoomInScale;
    }

    // Update transformation matrix to zoom in at the widget's center
    Matrix4 endMatrix = Matrix4.identity()
      ..translate(-widgetCenter.dx * (currentScale - 1),
          -widgetCenter.dy * (currentScale - 1))
      ..scale(currentScale);

    // Apply animation if enabled
    if (widget.enableAnimation) {
      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: endMatrix,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ));
      _animationController.forward(from: 0);
    } else {
      _transformationController.value = endMatrix;
    }
  }

  void _handleButtonZoomOut() {
    final Matrix4 currentMatrix = _transformationController.value;
    double currentScale = currentMatrix.getMaxScaleOnAxis();

    // Get the widget's size and calculate its center
    final RenderBox renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset widgetCenter =
        renderBox.localToGlobal(size.center(Offset.zero));

    // Set up the scale for zooming out
    if (currentScale - _zoomOutScale < widget.minScale) {
      currentScale = widget.minScale;
    } else {
      currentScale -= _zoomOutScale;
    }

    // Update transformation matrix to zoom out from the widget's center
    Matrix4 endMatrix = Matrix4.identity()
      ..translate(-widgetCenter.dx * (currentScale - 1),
          -widgetCenter.dy * (currentScale - 1))
      ..scale(currentScale);

    // Apply animation if enabled
    if (widget.enableAnimation) {
      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: endMatrix,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ));
      _animationController.forward(from: 0);
    } else {
      _transformationController.value = endMatrix;
    }
  }

  bool _handlePanStatus(bool isZoomed) {
    final Matrix4 currentMatrix = _transformationController.value;
    double currentScale = currentMatrix.getMaxScaleOnAxis();

    if (currentScale == widget.minScale) {
      return false;
    } else {
      return isZoomed ? widget.panEnabled : false;
    }
  }

  bool _handleScaleStatus() {
    final Matrix4 currentMatrix = _transformationController.value;
    double currentScale = currentMatrix.getMaxScaleOnAxis();
    if (currentScale == widget.minScale) {
      return false;
    } else {
      return widget.scaleEnabled;
    }
  }
}
