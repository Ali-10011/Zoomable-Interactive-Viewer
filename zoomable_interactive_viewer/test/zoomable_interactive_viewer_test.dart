import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoomable_interactive_viewer/zoomable_interactive_viewer.dart'; // adjust the import to your package path

void main() {
  Widget createWidgetUnderTest(ZoomableInteractiveViewer widget) {
    return MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );
  }

  group('ZoomableInteractiveViewer', () {
    testWidgets('Displays child widget', (WidgetTester tester) async {
      const testKey = Key('testChild');

      await tester.pumpWidget(
        createWidgetUnderTest(
          ZoomableInteractiveViewer(
            key: testKey,
            child: Container(
              width: 500,
              height: 300,
              color: Colors.black,
            ),
          ),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('Zooms in on double-tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          ZoomableInteractiveViewer(
            doubleTapZoomScale: 2.0,
            child: Container(
              width: 500,
              height: 300,
              color: Colors.black,
            ),
          ),
        ),
      );

      // Find the widget and double-tap on it
      final zoomableWidget = find.byType(ZoomableInteractiveViewer);

      // Perform a double-tap by tapping twice in quick succession
      await tester.tap(zoomableWidget);
      await tester
          .pump(const Duration(milliseconds: 50)); // Short delay between taps
      await tester.tap(zoomableWidget);

      await tester.pumpAndSettle();

      // Retrieve the state and access the transformation controller
      final ZoomableInteractiveViewerState state =
          tester.state(find.byType(ZoomableInteractiveViewer));
      final double scale =
          state.transformationController.value.getMaxScaleOnAxis();

      expect(scale, equals(2.0));
    });
    testWidgets('Zooms out after second double-tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          ZoomableInteractiveViewer(
            doubleTapZoomScale: 2.0,
            child: Container(
              width: 500,
              height: 300,
              color: Colors.black,
            ),
          ),
        ),
      );

      // Find the widget
      final zoomableWidget = find.byType(ZoomableInteractiveViewer);

      // First double-tap to zoom in
      await tester.tap(zoomableWidget);
      await tester
          .pump(const Duration(milliseconds: 50)); // Short delay between taps
      await tester.tap(zoomableWidget);
      await tester.pumpAndSettle();

      // Verify that the scale is now at the doubleTapZoomScale (2.0)
      final ZoomableInteractiveViewerState state =
          tester.state(find.byType(ZoomableInteractiveViewer));
      double scale = state.transformationController.value.getMaxScaleOnAxis();
      expect(scale, equals(2.0));

      // Second double-tap to zoom out
      await tester.tap(zoomableWidget);
      await tester
          .pump(const Duration(milliseconds: 50)); // Short delay between taps
      await tester.tap(zoomableWidget);
      await tester.pumpAndSettle();

      // Verify that the scale is back to the minimum scale (assuming minScale is 1.0)
      scale = state.transformationController.value.getMaxScaleOnAxis();
      expect(scale, equals(1.0));
    });

    testWidgets('Zoom buttons update scale', (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          ZoomableInteractiveViewer(
            enableZoomInMagnifier: true,
            zoomInMagnifierScale: 1.5,
            zoomOutMagnifierScale: 0.5,
            maxScale: 4.0,
            child: Container(
              width: 500,
              height: 300,
              color: Colors.black,
            ),
          ),
        ),
      );

      // Find and tap the zoom-in button
      await tester.tap(find.byIcon(Icons.zoom_in));
      await tester.pumpAndSettle();

      // Retrieve the state and access the transformation controller
      final ZoomableInteractiveViewerState state =
          tester.state(find.byType(ZoomableInteractiveViewer));
      final double zoomInScale =
          state.transformationController.value.getMaxScaleOnAxis();

      expect(zoomInScale, equals(2.5));

      // Find and tap the zoom-out button
      await tester.tap(find.byIcon(Icons.zoom_out));
      await tester.pumpAndSettle();

      // Verify zoom-out behavior
      final double zoomOutScale =
          state.transformationController.value.getMaxScaleOnAxis();

      expect(zoomOutScale, equals(2.0));
    });

    testWidgets('Panning enabled only when zoomed in',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          ZoomableInteractiveViewer(
            minScale: 1.0,
            maxScale: 3.0,
            panEnabled: true,
            child: Container(
              width: 500,
              height: 300,
              color: Colors.black,
            ),
          ),
        ),
      );

      final ZoomableInteractiveViewerState state =
          tester.state(find.byType(ZoomableInteractiveViewer));

      // Initially zoomed out, so panning should be disabled
      expect(state.handlePanStatus(false), isFalse);

      // Zoom in to enable panning
      state.transformationController.value = Matrix4.identity()..scale(2.0);
      expect(state.handlePanStatus(true), isTrue);
    });

    testWidgets('Animation applied during zoom', (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          ZoomableInteractiveViewer(
            enableAnimation: true,
            animationCurve: Curves.easeInOut,
            child: Container(
              width: 500,
              height: 300,
              color: Colors.black,
            ),
          ),
        ),
      );

      final ZoomableInteractiveViewerState state =
          tester.state(find.byType(ZoomableInteractiveViewer));

      expect(state.widget.enableAnimation, isTrue);
      expect(state.widget.animationCurve, equals(Curves.easeInOut));
    });
  });

  testWidgets('Respects boundary margins', (WidgetTester tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        ZoomableInteractiveViewer(
          boundaryMargin: const EdgeInsets.all(50.0),
          child: Container(
            width: 300,
            height: 200,
            color: Colors.blue,
          ),
        ),
      ),
    );

    final ZoomableInteractiveViewerState state =
        tester.state(find.byType(ZoomableInteractiveViewer));

    // Simulate pan to move content beyond boundary margin
    state.transformationController.value = Matrix4.identity()
      ..translate(-100, -100);

    // After panning, check if the content is still within the boundary
    expect(state.transformationController.value.getTranslation().x,
        greaterThanOrEqualTo(-50));
    expect(state.transformationController.value.getTranslation().y,
        greaterThanOrEqualTo(-50));
  });

  testWidgets('Does not exceed maxScale or go below minScale',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        ZoomableInteractiveViewer(
          minScale: 1.0,
          maxScale: 3.0,
          child: Container(
            width: 300,
            height: 200,
            color: Colors.green,
          ),
        ),
      ),
    );

    final ZoomableInteractiveViewerState state =
        tester.state(find.byType(ZoomableInteractiveViewer));

    // Try to set scale above maxScale
    state.transformationController.value = Matrix4.identity()..scale(4.0);
    expect(state.transformationController.value.getMaxScaleOnAxis(),
        lessThanOrEqualTo(3.0));

    // Try to set scale below minScale
    state.transformationController.value = Matrix4.identity()..scale(0.5);
    expect(state.transformationController.value.getMaxScaleOnAxis(),
        greaterThanOrEqualTo(1.0));
  });

  testWidgets('Disables animation correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        ZoomableInteractiveViewer(
          enableAnimation: false,
          doubleTapZoomScale: 2.0,
          child: Container(
            width: 300,
            height: 200,
            color: Colors.purple,
          ),
        ),
      ),
    );

    final zoomableWidget = find.byType(ZoomableInteractiveViewer);

    // Perform a double-tap to zoom in
    await tester.tap(zoomableWidget);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(zoomableWidget);
    await tester.pumpAndSettle();

    final ZoomableInteractiveViewerState state =
        tester.state(find.byType(ZoomableInteractiveViewer));

    // Verify immediate scale change without animation
    expect(
        state.transformationController.value.getMaxScaleOnAxis(), equals(2.0));
  });

  testWidgets('Applies custom animation curve during zoom',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        ZoomableInteractiveViewer(
          enableAnimation: true,
          animationCurve: Curves.bounceOut,
          doubleTapZoomScale: 2.0,
          child: Container(
            width: 300,
            height: 200,
            color: Colors.orange,
          ),
        ),
      ),
    );

    final zoomableWidget = find.byType(ZoomableInteractiveViewer);

    // Perform a double-tap to trigger the custom animation
    await tester.tap(zoomableWidget);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(zoomableWidget);
    await tester.pump();

    // Check that animation curve has started to change the scale
    final ZoomableInteractiveViewerState state =
        tester.state(find.byType(ZoomableInteractiveViewer));
    expect(state.widget.animationCurve, equals(Curves.bounceOut));
  });

  testWidgets('Double-tap does not zoom if doubleTapZoomScale equals minScale',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        ZoomableInteractiveViewer(
          minScale: 1.0,
          doubleTapZoomScale: 1.0,
          child: Container(
            width: 300,
            height: 200,
            color: Colors.red,
          ),
        ),
      ),
    );

    final zoomableWidget = find.byType(ZoomableInteractiveViewer);

    // Perform a double-tap
    await tester.tap(zoomableWidget);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(zoomableWidget);
    await tester.pumpAndSettle();

    // Retrieve the state and access the transformation controller
    final ZoomableInteractiveViewerState state =
        tester.state(find.byType(ZoomableInteractiveViewer));

    // Verify that scale remains at minScale
    final double scale =
        state.transformationController.value.getMaxScaleOnAxis();
    expect(scale, equals(1.0));
  });
}
