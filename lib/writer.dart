import 'models/ice_entry.dart';

/// Serializer for converting IceMenuEntry tree back to IceWM menu format
class IceMenuWriter {
  /// Default indentation (2 spaces per level)
  static const String _defaultIndent = '  ';

  /// Serialize a list of menu entries back to IceWM format
  /// Returns a string ready to be written to ~/.icewm/menu
  static String serialize(
    List<IceMenuEntry> entries, {
    String indent = _defaultIndent,
  }) {
    final buffer = StringBuffer();
    _serializeEntries(entries, buffer, indent, 0);
    return buffer.toString();
  }

  /// Recursively serialize entries with proper indentation
  static void _serializeEntries(
    List<IceMenuEntry> entries,
    StringBuffer buffer,
    String indent,
    int depth,
  ) {
    for (final entry in entries) {
      // Skip invisible entries
      if (!entry.isVisible) continue;

      final currentIndent = indent * depth;

      switch (entry.type) {
        case EntryType.prog:
          final prog = entry as IceProgram;
          // Quote the label if it contains spaces
          final quotedLabel = prog.label.contains(' ')
              ? '"${_escapeQuotes(prog.label)}"'
              : prog.label;

          // Use proper icon format
          String iconPart = '';
          if (prog.icon.isEmpty) {
            iconPart = '!';
          } else if (prog.icon == '!') {
            iconPart = '!';
          } else {
            iconPart = prog.icon;
          }

          buffer.writeln(
            '$currentIndent prog $quotedLabel $iconPart ${prog.command}',
          );
          break;

        case EntryType.menu:
          final menu = entry as IceSubMenu;
          // Quote the label if it contains spaces
          final quotedLabel = menu.label.contains(' ')
              ? '"${_escapeQuotes(menu.label)}"'
              : menu.label;
          final quotedIcon = menu.icon.isEmpty ? 'folder' : menu.icon;

          buffer.writeln(
            '$currentIndent menu $quotedLabel $quotedIcon {',
          );

          // Recursively serialize children
          _serializeEntries(
            menu.children,
            buffer,
            indent,
            depth + 1,
          );

          buffer.writeln('$currentIndent }');
          break;

        case EntryType.separator:
          buffer.writeln('$currentIndent separator');
          break;

        case EntryType.restart:
          buffer.writeln('$currentIndent restart icewm - icewm');
          break;

        case EntryType.quit:
          buffer.writeln('$currentIndent quit');
          break;
      }
    }
  }

  /// Escape quotes in strings to be written to IceWM menu
  static String _escapeQuotes(String text) {
    // In IceWM, quotes are typically escaped with backslash
    return text.replaceAll('"', r'\"');
  }
}
