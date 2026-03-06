/// Enum representing different types of IceWM menu entries
enum EntryType { prog, menu, separator, restart, quit }

/// Base class representing any IceWM menu entry
abstract class IceMenuEntry {
  String get label;
  String get icon;
  EntryType get type;
}

/// Represents a program entry in IceWM menu
/// Format: prog "Name" "icon" "command"
class IceProgram implements IceMenuEntry {
  @override
  final String label;
  @override
  final String icon;
  @override
  final EntryType type = EntryType.prog;
  
  /// The command to execute when this program is selected
  final String command;

  IceProgram({
    required this.label,
    required this.icon,
    required this.command,
  });

  /// Create a copy with optional field overrides
  IceProgram copyWith({
    String? label,
    String? icon,
    String? command,
  }) {
    return IceProgram(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      command: command ?? this.command,
    );
  }
}

/// Represents a submenu entry in IceWM menu
/// Format: menu "Name" "icon" { ... }
class IceSubMenu implements IceMenuEntry {
  @override
  final String label;
  @override
  final String icon;
  @override
  final EntryType type = EntryType.menu;
  
  /// Child entries (programs, separators, or nested submenus)
  final List<IceMenuEntry> children;

  IceSubMenu({
    required this.label,
    required this.icon,
    List<IceMenuEntry>? children,
  }) : children = children ?? [];

  /// Add a child entry
  void addChild(IceMenuEntry entry) {
    children.add(entry);
  }

  /// Remove a child entry
  void removeChild(IceMenuEntry entry) {
    children.remove(entry);
  }

  /// Create a copy with optional field overrides
  IceSubMenu copyWith({
    String? label,
    String? icon,
    List<IceMenuEntry>? children,
  }) {
    return IceSubMenu(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      children: children ?? List.from(this.children),
    );
  }
}

/// Represents a separator line in IceWM menu
/// Format: separator
class IceSeparator implements IceMenuEntry {
  @override
  final String label = '';
  @override
  final String icon = '';
  @override
  final EntryType type = EntryType.separator;
}

/// Represents a restart entry in IceWM menu
/// Restarts the IceWM window manager
/// Format: restart
class IceRestart implements IceMenuEntry {
  @override
  final String label = 'Restart';
  @override
  final String icon = '';
  @override
  final EntryType type = EntryType.restart;
}

/// Represents a quit entry in IceWM menu
/// Exits the IceWM window manager
/// Format: quit
class IceQuit implements IceMenuEntry {
  @override
  final String label = 'Quit';
  @override
  final String icon = '';
  @override
  final EntryType type = EntryType.quit;
}
