import 'dart:io';
import 'package:path/path.dart' as path;
import 'models/ice_entry.dart';

/// Represents a discovered desktop directory
class DesktopDirectory {
  final String name;
  final String icon;
  final String filePath;
  final Map<String, String> additionalFields;

  DesktopDirectory({
    required this.name,
    required this.icon,
    required this.filePath,
    this.additionalFields = const {},
  });

  @override
  String toString() => 'DesktopDirectory(name: $name)';
}

/// Scanner for desktop directories
class DirectoriesScanner {

  /// Get the local desktop directories for writing new .directory files
  static Directory get _localDirectoriesDirectory {
    final home = Platform.environment["HOME"] ?? "";
    return Directory(path.join(home, ".local/share/desktop-directories"));
  }

  /// Save user-created directories from menu entries as .directory files
  static Future<void> saveDirectories(List<IceMenuEntry> menuEntries) async {
    final dirDir = _localDirectoriesDirectory;
    if (!await dirDir.exists()) {
      await dirDir.create(recursive: true);
    }

    final existingDirectoryFiles = <String>{};
    await for (final entity in dirDir.list()) {
      if (entity is File && entity.path.endsWith(".directory")) {
        existingDirectoryFiles.add(path.basename(entity.path));
      }
    }

    await _saveDirectoriesRecursive(menuEntries, dirDir, existingDirectoryFiles);
  }

  static Future<void> _saveDirectoriesRecursive(
    List<IceMenuEntry> entries,
    Directory dirDir,
    Set<String> existingDirectoryFiles,
  ) async {
    for (final entry in entries) {
      if (entry is IceSubMenu) {
        // Sanitize label for filename
        final fileName = entry.label.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_').toLowerCase();
        final directoryFileName = ";$fileName.directory";
        final filePath = path.join(dirDir.path, directoryFileName);

          final content = """
[Desktop Entry]
Version=1.0
Type=Directory
Name=${entry.label}
Icon=${entry.icon}
""";
          await File(filePath).writeAsString(content);
      } else if (entry is IceSubMenu) {
        await _saveDirectoriesRecursive(entry.children, dirDir, existingDirectoryFiles);
      }
    }
  }


  static const List<String> _directoryPaths = [
    '/usr/share/desktop-directories',
    '/usr/local/share/desktop-directories',
  ];

  /// Get the local directory paths for the current user
  static List<String> get _localDirectoryPaths {
    final home = Platform.environment['HOME'] ?? '';
    return [
      path.join(home, '.local/share/desktop-directories'),
    ];
  }

  /// Scan for desktop directories
  static Future<List<DesktopDirectory>> scanDirectories() async {
    final directories = <DesktopDirectory>[];
    final allPaths = [..._directoryPaths, ..._localDirectoryPaths];

    for (final scanPath in allPaths) {
      final dir = Directory(scanPath);
      if (!await dir.exists()) continue;

      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.directory')) {
          final dir = await _parseDirectoryFile(entity.path);
          if (dir != null) {
            directories.add(dir);
          }
        }
      }
    }

    return directories;
  }

  /// Parse a .directory file
  static Future<DesktopDirectory?> _parseDirectoryFile(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final lines = content.split('\n');

      String? name;
      String? icon;
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
              default:
                additionalFields[key] = value;
            }
          }
        }
      }

      // Only return if we have the required fields
      if (name != null) {
        return DesktopDirectory(
          name: name,
          icon: icon ?? '',
          filePath: filePath,
          additionalFields: additionalFields,
        );
      }
    } catch (e) {
      // Skip files that can't be parsed
    }

    return null;
  }

  /// Scan directories and create IceSubMenu entries for each directory
  static Future<List<IceSubMenu>> scanAndCreateDirectories() async {
    final directories = await scanDirectories();

    return directories.map((dir) => IceSubMenu(
      label: dir.name,
      icon: dir.icon,
      isGenerated: true,
      children: [], // Empty initially, users can drag apps here
    )).toList();
  }
}