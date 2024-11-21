
## Features

# ZoomableInteractiveViewer

`ZoomableInteractiveViewer` is a customizable Flutter widget that provides interactive zoom and pan functionality. It allows users to smoothly zoom in, zoom out, and pan large content such as images or detailed graphics, with optional zoom buttons and double-tap zoom. This package is ideal for applications that need detailed content viewing, such as image galleries, maps, or diagrams.

## Previews

## Previews

<table style="border-collapse: collapse; border: none;">
  <tr>
     <td align="center" style="border: none;">
      <h4>Media Preview</h4>
      <img src="https://github.com/user-attachments/assets/7d679141-5b46-428a-abf9-5dea455dbfe2" alt="Media Preview" width="320">
    </td>
      <td align="center" style="border: none;">
      <h4>Listing Preview</h4>
      <img src="https://github.com/user-attachments/assets/3ce9b632-a3a1-484d-8635-ef04e3be0deb" alt="Listing Preview" width="320">
    </td>
  </tr>
</table>


## Getting started

### Prerequisites

To use `ZoomableInteractiveViewer` in your Flutter project, ensure you have:

```yaml
environment:
  sdk: '>=3.1.5 <4.0.0'
  flutter: ">=1.17.0"

```

### Installation

Add `zoomable_interactive_viewer` to your `pubspec.yaml` file under dependencies:

```yaml
dependencies:
  zoomable_interactive_viewer: ^0.0.1
```

## Usage

To use the `ZoomableInteractiveViewer` widget, wrap any widget you’d like to be zoomable in `ZoomableInteractiveViewer`. This widget provides double-tap zoom functionality and supports panning gestures.

### Example

Here’s a quick example to get started:

```dart
import 'package:flutter/material.dart';
import 'package:zoomable_interactive_viewer/zoomable_interactive_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Zoomable Viewer Example')),
        body: Center(
          child: ZoomableInteractiveViewer(
            child: Image.network('https://example.com/sample-image.jpg'),
          ),
        ),
      ),
    );
  }
}
```
## Additional Information

### Where to Find More Information

For more information about the `zoomable_interactive_viewer` package, you can visit the following resources:

- **Package Documentation**: [pub.dev - zoomable_interactive_viewer](https://pub.dev/packages/zoomable_interactive_viewer)
- **Flutter Documentation**: [Flutter Docs](https://flutter.dev/docs)

### How to Contribute

We welcome contributions! If you'd like to contribute to the development of this package, please follow the steps below:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Write clear and concise commit messages.
4. Test your changes.
5. Submit a pull request.

Make sure to adhere to the coding standards and ensure that all tests pass before submitting your PR.

### How to File Issues

If you encounter any issues or bugs while using the package, please file an issue on the GitHub repository:

- **Issue Tracker**: [GitHub Issues](https://github.com/Ali-10011/Zoomable-Interactive-Viewer/issues)

Please include the following information when filing an issue:
- A description of the problem.
- Steps to reproduce the issue.
- Any relevant error messages or logs.

### Response Time

We try to respond to issues and pull requests as quickly as possible, typically within 1-2 business days. However, response times may vary depending on the complexity of the issue or request.

### License

This package is open-source and licensed under the [BSD-3 License](https://opensource.org/license/bsd-3-clause).

Feel free to reach out if you have any questions or need further assistance. We appreciate your support and contributions!


### Example

You can find the example of this package from [here](https://github.com/Ali-10011/Zoomable-Interactive-Viewer/tree/main/zoomable_interactive_viewer/example).



---

### Support

If you appreciate the work done on this package and would like to support its development, consider buying me a coffee!

[![Buy Me a Coffee](https://www.buymeacoffee.com/assets/img/custom_images/yellow_img.png)](https://buymeacoffee.com/art0/e/335030)


