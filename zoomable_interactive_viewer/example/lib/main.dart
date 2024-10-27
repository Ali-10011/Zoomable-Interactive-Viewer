// example/lib/main.dart
import 'package:flutter/material.dart';
import 'image_example.dart';
import 'list_example.dart';

void main() {
  runApp(const ZoomableInteractiveViewerApp());
}

class ZoomableInteractiveViewerApp extends StatelessWidget {
  const ZoomableInteractiveViewerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoomable Interactive Viewer Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ZoomDemoHomePage(),
    );
  }
}

class ZoomDemoHomePage extends StatefulWidget {
  const ZoomDemoHomePage({Key? key}) : super(key: key);

  @override
  State<ZoomDemoHomePage> createState() => _ZoomDemoHomePageState();
}

class _ZoomDemoHomePageState extends State<ZoomDemoHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ImageExamplePage(),
    ListExamplePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Optional: Titles for the AppBar based on selected page
  static const List<String> _titles = <String>[
    'Image Zoom Example',
    'List Zoom Example',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Highlight color
        onTap: _onItemTapped,
      ),
    );
  }
}
