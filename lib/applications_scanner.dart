import 'dart:io';
import 'package:path/path.dart' as path;
import 'models/ice_entry.dart';

/// Represents a discovered desktop application
class DesktopApplication {
  final String name;
  final String icon;
  final String exec;
  final String filePath;
  final List<String> categories;
  final Map<String, String> additionalFields;

  DesktopApplication({
    required this.name,
    required this.icon,
    required this.exec,
    required this.filePath,
    this.categories = const [],
    this.additionalFields = const {},
  });

  @override
  String toString() => 'DesktopApplication(name: $name, exec: $exec, categories: $categories)';
}

/// Scanner for desktop applications
class ApplicationsScanner {
  static const List<String> _applicationPaths = [
    '/usr/share/applications',
    '/usr/local/share/applications',
  ];

  /// Get the local application paths for the current user
  static List<String> get _localApplicationPaths {
    final home = Platform.environment['HOME'] ?? '';
    return [
      path.join(home, '.local/share/applications'),
    ];
  }

  /// Scan for desktop applications
  static Future<List<DesktopApplication>> scanApplications() async {
    final applications = <DesktopApplication>[];
    final allPaths = [..._applicationPaths, ..._localApplicationPaths];

    for (final scanPath in allPaths) {
      final dir = Directory(scanPath);
      if (!await dir.exists()) continue;

      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.desktop')) {
          final app = await _parseDesktopFile(entity.path);
          if (app != null) {
            applications.add(app);
          }
        }
      }
    }

    return applications;
  }

  /// Parse a .desktop file
  static Future<DesktopApplication?> _parseDesktopFile(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final lines = content.split('\n');

      String? name;
      String? icon;
      String? exec;
      List<String> categories = [];
      bool inDesktopEntry = false;
      final additionalFields = <String, String>{};

      for (final line in lines) {
        final trimmed = line.trim();

        // Skip comments and empty lines
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

        // Check for section headers
        if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
          inDesktopEntry = trimmed == '[Desktop Entry]';
          continue;
        }

        // Parse key-value pairs in Desktop Entry section
        if (inDesktopEntry && trimmed.contains('=')) {
          final parts = trimmed.split('=');
          if (parts.length >= 2) {
            final key = parts[0].trim();
            final value = parts.sublist(1).join('=').trim();

            switch (key) {
              case 'Name':
                name = value;
                break;
              case 'Icon':
                icon = value;
                break;
              case 'Exec':
                exec = value;
                break;
              case 'Categories':
                // Categories are semicolon-separated
                categories = value.split(';').where((cat) => cat.isNotEmpty).toList();
                break;
              default:
                additionalFields[key] = value;
            }
          }
        }
      }

      // Only return if we have the required fields
      if (name != null && exec != null) {
        return DesktopApplication(
          name: name,
          icon: icon ?? '',
          exec: exec,
          filePath: filePath,
          categories: categories,
          additionalFields: additionalFields,
        );
      }
    } catch (e) {
      // Skip files that can't be parsed
    }

    return null;
  }

  /// Scan applications and create an "Other" directory with all applications
  static Future<IceSubMenu> scanAndCreateOtherDirectory() async {
    final applications = await scanApplications();

    final otherMenu = IceSubMenu(
      label: 'Other',
      icon: '',
      isGenerated: true,
      children: applications.map((app) => IceProgram(
        label: app.name,
        icon: app.icon,
        command: app.exec,
        isGenerated: true,
      )).toList(),
    );

    return otherMenu;
  }
}