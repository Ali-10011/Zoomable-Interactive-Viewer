// example/lib/list_example.dart
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
  bool _enableAnimation = true;

  // Define the minimum difference between minScale and maxScale
  static const double _minScaleDifference = 0.1;

  // Generate a list of items

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
                      // Ensure maxScale is always greater than minScale
                      if (_maxScale <= _minScale + _minScaleDifference) {
                        _maxScale = _minScale + _minScaleDifference;
                        // Optional: Clamp maxScale to a reasonable upper limit
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
                  min: 1.1, // Minimum maxScale is minScale + 0.1
                  max: 5.0,
                  divisions: 29, // (5.0 - 1.1) / 0.1 = 29
                  label: _maxScale.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _maxScale = value;
                      // Ensure maxScale is always greater than minScale
                      if (_maxScale <= _minScale + _minScaleDifference) {
                        _minScale = _maxScale - _minScaleDifference;
                        // Optional: Clamp minScale to a reasonable lower limit
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
        ],
      ),
    );
  }
}
