import 'models/ice_entry.dart';

/// Parser for IceWM menu files
/// Converts raw IceWM menu string into a tree of IceMenuEntry objects
class IceMenuParser {
  /// Regular expression to match prog entries (flexible format)
  /// Formats: prog "Name" icon command
  ///          prog Name icon command
  ///          prog "Name" ! command
  static final RegExp _progRegex = RegExp(
    r'^\s*prog\s+(?:"([^"]*)"|(\S+))\s+(.+)$',
    multiLine: false,
  );

  /// Regular expression to match menu opening
  /// Format: menu "Name" icon {  OR  menu Name icon {
  static final RegExp _menuOpenRegex = RegExp(
    r'^\s*menu\s+(?:"([^"]*)"|(\S+))\s+(\S+)\s*\{',
  );

  /// Regular expression to match closing brace
  static final RegExp _closeBraceRegex = RegExp(r'^\s*\}');

  /// Regular expression to match separator
  static final RegExp _separatorRegex = RegExp(r'^\s*separator\s*$');

  /// Regular expression to match restart
  static final RegExp _restartRegex = RegExp(r'^\s*restart\s+(\S+)');

  /// Regular expression to match quit
  static final RegExp _quitRegex = RegExp(r'^\s*quit\s*$');

  /// Regular expression to match includeprog, menuprog, menufile
  static final RegExp _specialRegex =
      RegExp(r'^\s*(?:includeprog|menuprog|menufile)\s+(.+)$');

  /// Parse raw IceWM menu string into tree of entries
  static List<IceMenuEntry> parse(String content) {
    final lines = content.split('\n');
    final parser = _IceMenuParserState(lines);
    return parser.parseLines(0, lines.length);
  }
}

/// Internal parser state to handle recursive parsing
class _IceMenuParserState {
  final List<String> lines;
  int currentLineIndex = 0;

  _IceMenuParserState(this.lines);

  /// Parse lines from startIndex to endIndex
  List<IceMenuEntry> parseLines(int startIndex, int endIndex) {
    final entries = <IceMenuEntry>[];
    currentLineIndex = startIndex;

    while (currentLineIndex < endIndex && currentLineIndex < lines.length) {
      final line = lines[currentLineIndex].trim();

      // Skip empty lines and comments
      if (line.isEmpty || line.startsWith('#')) {
        currentLineIndex++;
        continue;
      }

      // Check for closing brace
      if (IceMenuParser._closeBraceRegex.hasMatch(line)) {
        break;
      }

      // Try to parse each type of entry
      final entry = _parseLine(line);
      if (entry != null) {
        entries.add(entry);
      }

      currentLineIndex++;
    }

    return entries;
  }

  /// Parse a single line into an IceMenuEntry
  IceMenuEntry? _parseLine(String line) {
    // Match prog entry (flexible format)
    final progMatch = IceMenuParser._progRegex.firstMatch(line);
    if (progMatch != null) {
      // Group 1: quoted name, Group 2: unquoted name, Group 3: rest
      final label = progMatch.group(1) ?? progMatch.group(2) ?? '';
      final rest = progMatch.group(3)?.trim() ?? '';

      // Parse the rest: either "! command" or "icon command"
      String icon = '';
      String command = '';

      if (rest.startsWith('!')) {
        // Format: ! command
        icon = '';
        command = rest.substring(1).trim();
      } else {
        // Format: icon command (split on first space)
        final spaceIndex = rest.indexOf(' ');
        if (spaceIndex >= 0) {
          icon = rest.substring(0, spaceIndex);
          command = rest.substring(spaceIndex + 1).trim();
        } else {
          icon = rest;
          command = '';
        }
      }

      return IceProgram(
        label: label,
        icon: icon,
        command: command,
      );
    }

    // Match menu entry (with nested children)
    final menuMatch = IceMenuParser._menuOpenRegex.firstMatch(line);
    if (menuMatch != null) {
      // Group 1: quoted name, Group 2: unquoted name, Group 3: icon
      final label = menuMatch.group(1) ?? menuMatch.group(2) ?? '';
      final icon = menuMatch.group(3) ?? '';

      // Find the matching closing brace
      currentLineIndex++;
      final children = parseLines(currentLineIndex, lines.length);
      
      // currentLineIndex is now at the closing brace. 
      // The parent loop will increment it to move to the next line.

      return IceSubMenu(
        label: label,
        icon: icon,
        children: children,
      );
    }

    // Match separator
    if (IceMenuParser._separatorRegex.hasMatch(line)) {
      return IceSeparator();
    }

    // Match restart
    final restartMatch = IceMenuParser._restartRegex.firstMatch(line);
    if (restartMatch != null) {
      final name = restartMatch.group(1) ?? 'Restart';
      return IceRestart();
    }

    // Match quit
    if (IceMenuParser._quitRegex.hasMatch(line)) {
      return IceQuit();
    }

    // Skip special entries (includeprog, menuprog, menufile) for now
    if (IceMenuParser._specialRegex.hasMatch(line)) {
      // These could be implemented in the future
      return null;
    }

    return null;
  }
}
