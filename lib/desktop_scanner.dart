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

/// Scanner for desktop files and directories
class DesktopScanner {
  static const List<String> _applicationPaths = [
    '/usr/share/applications',
    '/usr/local/share/applications',
  ];

  static const List<String> _directoryPaths = [
    '/usr/share/desktop-directories',
    '/usr/local/share/desktop-directories',
  ];

  /// Category to directory name mapping
  static const Map<String, String> _categoryToDirectory = {
    'AudioVideo': 'Multimedia',
    'Audio': 'Multimedia',
    'Video': 'Multimedia',
    'Development': 'Development',
    'Education': 'Education',
    'Game': 'Games',
    'Graphics': 'Graphics',
    'Network': 'Internet',
    'Office': 'Office',
    'Science': 'Science',
    'Settings': 'Settings',
    'System': 'System',
    'Utility': 'Accessories',
    'TextEditor': 'Accessories',
    'TerminalEmulator': 'System',
    'FileManager': 'System',
    'WebBrowser': 'Internet',
    'Email': 'Internet',
    'InstantMessaging': 'Internet',
    'IRCClient': 'Internet',
    'Feed': 'Internet',
    'News': 'Internet',
    'P2P': 'Internet',
    'RemoteAccess': 'Internet',
    'Telephony': 'Internet',
    'VideoConference': 'Internet',
    'WebDevelopment': 'Development',
    'IDE': 'Development',
    'RevisionControl': 'Development',
    'Translation': 'Development',
    'Database': 'Development',
    'GUIDesigner': 'Development',
    'Profiling': 'Development',
    'ProjectManagement': 'Office',
    'Calendar': 'Office',
    'ContactManagement': 'Office',
    'Dictionary': 'Office',
    'Finance': 'Office',
    'FlowChart': 'Office',
    'PDA': 'Office',
    'Spreadsheet': 'Office',
    'WordProcessor': 'Office',
    'Presentation': 'Office',
    'Viewer': 'Office',
    'TextTools': 'Office',
    'DesktopPublishing': 'Office',
    'Photography': 'Graphics',
    'Publishing': 'Graphics',
    'RasterGraphics': 'Graphics',
    'VectorGraphics': 'Graphics',
    '2DGraphics': 'Graphics',
    '3DGraphics': 'Graphics',
    'Music': 'Multimedia',
    'Midi': 'Multimedia',
    'Mixer': 'Multimedia',
    'Sequencer': 'Multimedia',
    'Tuner': 'Multimedia',
    'TV': 'Multimedia',
    'AudioVideoEditing': 'Multimedia',
    'Player': 'Multimedia',
    'Recorder': 'Multimedia',
    'DiscBurning': 'Multimedia',
    'ActionGame': 'Games',
    'AdventureGame': 'Games',
    'ArcadeGame': 'Games',
    'BoardGame': 'Games',
    'BlocksGame': 'Games',
    'CardGame': 'Games',
    'KidsGame': 'Games',
    'LogicGame': 'Games',
    'RolePlaying': 'Games',
    'Shooter': 'Games',
    'Simulation': 'Games',
    'SportsGame': 'Games',
    'StrategyGame': 'Games',
    'Art': 'Education',
    'Construction': 'Education',
    'Languages': 'Education',
    'ArtificialIntelligence': 'Education',
    'Astronomy': 'Education',
    'Biology': 'Education',
    'Chemistry': 'Education',
    'ComputerScience': 'Education',
    'DataVisualization': 'Education',
    'Economy': 'Education',
    'Electricity': 'Education',
    'Geography': 'Education',
    'Geology': 'Education',
    'Geoscience': 'Education',
    'History': 'Education',
    'ImageProcessing': 'Education',
    'Literature': 'Education',
    'Maps': 'Education',
    'Math': 'Education',
    'NumericalAnalysis': 'Education',
    'MedicalSoftware': 'Education',
    'Physics': 'Education',
    'Robotics': 'Education',
    'Sports': 'Education',
    'ParallelComputing': 'Education',
    'Amusement': 'Games',
    'Archiving': 'Utilities',
    'Compression': 'Utilities',
    'Electronics': 'Utilities',
    'Emulator': 'Utilities',
    'Engineering': 'Utilities',
    'FileTools': 'Utilities',
    'Filesystem': 'Utilities',
    'Monitor': 'Utilities',
    'Security': 'Utilities',
    'Accessibility': 'Utilities',
    'Calculator': 'Utilities',
    'Clock': 'Utilities',
    'Documentation': 'Utilities',
    'Adult': 'Other',
    'Core': 'Other',
    'KDE': 'Other',
    'GNOME': 'Other',
    'XFCE': 'Other',
    'GTK': 'Other',
    'Qt': 'Other',
    'Motif': 'Other',
    'Java': 'Other',
    'ConsoleOnly': 'Other',
  };

  /// Get the local application and directory paths for the current user
  static List<String> get _localApplicationPaths {
    final home = Platform.environment['HOME'] ?? '';
    return [
      path.join(home, '.local/share/applications'),
    ];
  }

  static List<String> get _localDirectoryPaths {
    final home = Platform.environment['HOME'] ?? '';
    return [
      path.join(home, '.local/share/desktop-directories'),
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

  /// Scan and organize applications into directories based on categories
  static Future<List<IceMenuEntry>> scanAndOrganizeMenu() async {
    final applications = await scanApplications();
    final directories = await scanDirectories();

    // Create a map of directory name to directory object
    final directoryMap = <String, DesktopDirectory>{};
    for (final dir in directories) {
      directoryMap[dir.name] = dir;
    }

    // Create a map of directory name to list of applications
    final organizedApps = <String, List<DesktopApplication>>{};

    // Organize applications by category
    for (final app in applications) {
      String directoryName = 'Other'; // Default directory

      // Find the best matching directory for this application
      for (final category in app.categories) {
        if (_categoryToDirectory.containsKey(category)) {
          final mappedDir = _categoryToDirectory[category]!;
          if (directoryMap.containsKey(mappedDir) || mappedDir == 'Other') {
            directoryName = mappedDir;
            break;
          }
        }
      }

      if (!organizedApps.containsKey(directoryName)) {
        organizedApps[directoryName] = [];
      }
      organizedApps[directoryName]!.add(app);
    }

    // Convert to IceMenuEntry list
    final menuEntries = <IceMenuEntry>[];

    // Add organized directories with their applications
    for (final entry in organizedApps.entries) {
      final directoryName = entry.key;
      final apps = entry.value;

      if (apps.isEmpty) continue;

      // Create submenu for this directory
      final submenu = IceSubMenu(
        label: directoryName,
        icon: directoryMap[directoryName]?.icon ?? '',
        children: apps.map((app) => IceProgram(
          label: app.name,
          icon: app.icon,
          command: app.exec,
        )).toList(),
      );

      menuEntries.add(submenu);
    }

    // Sort menu entries alphabetically
    menuEntries.sort((a, b) => a.label.compareTo(b.label));

    return menuEntries;
  }
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
}