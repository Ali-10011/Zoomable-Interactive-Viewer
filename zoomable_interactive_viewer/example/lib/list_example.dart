import 'package:flutter/material.dart';
import 'package:zoomable_interactive_viewer/zoomable_interactive_viewer.dart';

class ListExamplePage extends StatefulWidget {
  const ListExamplePage({Key? key}) : super(key: key);

  @override
  State<ListExamplePage> createState() => _ListExamplePageState();
}

class _ListExamplePageState extends State<ListExamplePage> {
  double _minScale = 1.0;
  double _maxScale = 4.0;
  double _doubleTapZoomScale = 2.0;
  double _zoomInMagnifierScale = 1.5;
  double _zoomOutMagnifierScale = 0.75;
  bool _enableAnimation = true;

  // Define the minimum difference between minScale and maxScale
  static const double _minScaleDifference = 0.1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ZoomableInteractiveViewer(
              enableAnimation: _enableAnimation,
              animationCurve: Curves.easeInOut,
              minScale: _minScale,
              maxScale: _maxScale,
              doubleTapZoomScale: _doubleTapZoomScale,
              enableZoomInMagnifier: true,
              zoomInMagnifierScale: _zoomInMagnifierScale,
              zoomOutMagnifierScale: _zoomOutMagnifierScale,
              zoomInMagnifierColor: Colors.black,
              zoomOutMagnifierColor: Colors.black,
              child: ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Item ${index + 1}'),
                    subtitle: const Text('This is a sample list item.'),
                  );
                },
              ),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  // Controls for adjusting zoom parameters
  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Enable Animation'),
            value: _enableAnimation,
            onChanged: (value) {
              setState(() {
                _enableAnimation = value;
              });
            },
          ),
          Row(
            children: [
              const Text('Min Scale:'),
              Expanded(
                child: Slider(
                  value: _minScale,
                  min: 1.0,
                  max: 3.0,
                  divisions: 20,
                  label: _minScale.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _minScale = value;
                      if (_maxScale <= _minScale + _minScaleDifference) {
                        _maxScale = _minScale + _minScaleDifference;
                        if (_maxScale > 5.0) {
                          _maxScale = 5.0;
                          _minScale = _maxScale - _minScaleDifference;
                        }
                      }
                    });
                  },
                ),
              ),
              Text(_minScale.toStringAsFixed(1)),
            ],
          ),
          Row(
            children: [
              const Text('Max Scale:'),
              Expanded(
                child: Slider(
                  value: _maxScale,
                  min: 1.1,
                  max: 5.0,
                  divisions: 29,
                  label: _maxScale.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _maxScale = value;
                      if (_maxScale <= _minScale + _minScaleDifference) {
                        _minScale = _maxScale - _minScaleDifference;
                        if (_minScale < 1.0) {
                          _minScale = 1.0;
                          _maxScale = _minScale + _minScaleDifference;
                        }
                      }
                    });
                  },
                ),
              ),
              Text(_maxScale.toStringAsFixed(1)),
            ],
          ),
          Row(
            children: [
              const Text('Double Tap Zoom Scale:'),
              Expanded(
                child: Slider(
                  value: _doubleTapZoomScale,
                  min: 1.0,
                  max: 5.0,
                  divisions: 40,
                  label: _doubleTapZoomScale.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _doubleTapZoomScale = value;
                    });
                  },
                ),
              ),
              Text(_doubleTapZoomScale.toStringAsFixed(1)),
            ],
          ),
          Row(
            children: [
              const Text('Zoom In Magnifier Scale:'),
              Expanded(
                child: Slider(
                  value: _zoomInMagnifierScale,
                  min: 1.0,
                  max: 3.0,
                  divisions: 20,
                  label: _zoomInMagnifierScale.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _zoomInMagnifierScale = value;
                    });
                  },
                ),
              ),
              Text(_zoomInMagnifierScale.toStringAsFixed(1)),
            ],
          ),
          Row(
            children: [
              const Text('Zoom Out Magnifier Scale:'),
              Expanded(
                child: Slider(
                  value: _zoomOutMagnifierScale,
                  min: 0.5,
                  max: 1.5,
                  divisions: 20,
                  label: _zoomOutMagnifierScale.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _zoomOutMagnifierScale = value;
                    });
                  },
                ),
              ),
              Text(_zoomOutMagnifierScale.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }
}
