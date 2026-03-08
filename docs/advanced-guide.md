# IceWM Menuator - Advanced User Guide

This guide covers advanced features, customization options, and technical details for power users.

## Table of Contents

1. [Advanced Menu Structure](#advanced-menu-structure)
2. [Theme Customization](#theme-customization)
3. [Custom Icons and Themes](#custom-icons-and-themes)
4. [Command Line Options](#command-line-options)
5. [File Structure and Formats](#file-structure-and-formats)
6. [Automation and Scripting](#automation-and-scripting)
7. [Performance Optimization](#performance-optimization)
8. [Advanced Troubleshooting](#advanced-troubleshooting)

## Advanced Menu Structure

### Nested Menus

Create deeply nested menu structures for complex organization:

```
Applications
├── Development
│   ├── Web Development
│   │   ├── VS Code
│   │   └── Firefox Developer
│   └── System Programming
├── Office
│   ├── Documents
│   └── Spreadsheets
```

### Special IceWM Entries

#### Restart Entry
```bash
restart icewm - icewm
```
Restarts IceWM with current settings.

#### Quit Entry
```bash
quit
```
Exits IceWM completely.

#### Separator Entry
```bash
separator
```
Adds a visual divider line.

### Conditional Menus

While not directly supported in the GUI, you can manually edit the menu file to include conditional logic:

```bash
# Only show if the program exists
prog "GIMP" "/usr/share/pixmaps/gimp.png" gimp
```

## Theme Customization

### Theme System Overview

IceWM Menuator uses Flutter's built-in theming system with Material 3 design:

- **Automatic Detection**: Detects system theme preference on startup
- **Manual Toggle**: Users can switch between themes via the UI
- **Material 3**: Both themes follow modern Material 3 guidelines
- **Real-time Switching**: Themes change instantly without app restart

### Theme Technical Details

#### Theme Configuration
```dart
// Light Theme
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
)

// Dark Theme
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
)
```

#### Theme Detection
The app uses `WidgetsBinding.instance.platformDispatcher.platformBrightness` to detect the system theme preference on startup.

#### Theme Persistence
Currently, theme preference is maintained during the session. Future versions may include persistent storage using `shared_preferences`.

### Custom Theme Colors

The application uses a blue seed color for both themes. You can modify the theme by changing the `seedColor` in the source code:

```dart
seedColor: Colors.blue,  // Change to any Material color
```

Available Material colors include:
- `Colors.red`, `Colors.green`, `Colors.blue`
- `Colors.purple`, `Colors.orange`, `Colors.teal`
- And many more - see Flutter's Colors class

### Future Theme Features

Planned enhancements for theme support:
- **Persistent Storage**: Save theme preference across sessions
- **Custom Colors**: User-selectable accent colors
- **High Contrast**: Additional high-contrast themes
- **System Integration**: Better integration with desktop theme settings

## Custom Icons and Themes

### Icon Formats

IceWM Menuator supports various icon formats:
- **PNG**: Preferred format with transparency
- **XPM**: Legacy format, still supported
- **SVG**: Vector format (limited support)

### Icon Paths

Icons can be specified using:
- **Absolute paths**: `/usr/share/pixmaps/firefox.png`
- **Relative paths**: `firefox.png` (searches standard paths)
- **Theme icons**: `firefox` (uses current icon theme)

### Icon Discovery

The application scans these directories for icons:
- `/usr/share/pixmaps/`
- `/usr/share/icons/`
- `~/.icons/`
- Current icon theme directories

### Custom Icon Themes

1. Create your icon directory: `~/.local/share/icons/mytheme/`
2. Add icons in standard sizes (16x16, 22x22, 32x32, 48x48)
3. Set your theme in IceWM preferences:

```bash
# In ~/.icewm/preference
IconTheme="mytheme"
```

## Command Line Options

### Running the Application

```bash
# Development mode with hot reload
flutter run -d linux

# Release build
flutter build linux
./build/linux/x64/release/bundle/icewm_menuator

# With custom menu file
ICEMENU_MENU_FILE="/path/to/custom/menu" ./icewm_menuator

# Debug mode
flutter run -d linux --debug
```

### Environment Variables

- `ICEMENU_MENU_FILE`: Override default menu file location
- `ICEMENU_DEBUG`: Enable debug logging
- `ICEMENU_NO_RELOAD`: Disable automatic IceWM reloading

Example:
```bash
export ICEMENU_DEBUG=1
export ICEMENU_MENU_FILE="/home/user/custom_menu"
./icewm_menuator
```

## File Structure and Formats

### Menu File Format

The IceWM menu file uses a simple text format:

```bash
# Comment lines start with #
menu "Applications" "folder" {
  prog "Firefox" "firefox" firefox
  prog "Terminal" "terminal" xterm
  separator
  menu "Development" "dev" {
    prog "VS Code" "code" code
  }
}
separator
restart icewm - icewm
quit
```

### Entry Types

#### Program Entry
```bash
prog "Label" "icon" command
```

#### Menu Entry
```bash
menu "Label" "icon" {
  # nested entries
}
```

#### Special Entries
```bash
separator
restart icewm - icewm
quit
```

### Applications Directory

Structure: `~/.icewm/applications/`

```
applications/
├── web_browsers.menu
├── development.menu
├── office.menu
└── multimedia.menu
```

Each file contains menu entries for that category:

```bash
# web_browsers.menu
prog "Firefox" "firefox" firefox
prog "Chrome" "chrome" google-chrome
```

### Directories Directory

Structure: `~/.icewm/directories/`

```
directories/
├── Development.menu
├── Office.menu
└── Games.menu
```

## Automation and Scripting

### Batch Operations

Create scripts for common operations:

```bash
#!/bin/bash
# backup_menu.sh
cp ~/.icewm/menu ~/.icewm/menu.backup.$(date +%Y%m%d)
echo "Menu backed up"
```

```bash
#!/bin/bash
# restore_menu.sh
if [ -f "$1" ]; then
    cp "$1" ~/.icewm/menu
    pkill -HUP -x icewm
    echo "Menu restored from $1"
else
    echo "Usage: $0 <menu_file>"
fi
```

### Integration with Other Tools

#### Using with dmenu
```bash
# Quick launcher using dmenu
#!/bin/bash
APP=$(grep "prog " ~/.icewm/menu | awk '{print $2}' | tr -d '"' | dmenu)
if [ -n "$APP" ]; then
    grep "$APP" ~/.icewm/menu | awk '{for(i=4;i<=NF;i++) printf "%s ", $i; print ""}' | sh
fi
```

#### Synchronization with Other WMs
```bash
# Sync with Openbox menu
#!/bin/bash
python3 << EOF
import re
with open('/home/user/.icewm/menu') as f:
    content = f.read()
# Convert to Openbox format and save
EOF
```

### Custom Scanners

Create your own application scanners:

```python
#!/usr/bin/env python3
# custom_scanner.py
import os
import json

def scan_custom_apps():
    apps = []
    for app_dir in ['/opt', '/usr/local/bin']:
        for item in os.listdir(app_dir):
            if os.path.isfile(os.path.join(app_dir, item)):
                apps.append({
                    'name': item.capitalize(),
                    'command': item,
                    'icon': ''
                })
    return apps

if __name__ == '__main__':
    print(json.dumps(scan_custom_apps()))
```

## Performance Optimization

### Large Menus

For menus with hundreds of entries:

1. **Disable Live Updates** for better performance
2. **Use Categories** to organize entries
3. **Limit Icon Scanning** by using specific icon paths

### Memory Usage

Monitor memory usage with:
```bash
ps aux | grep icewm_menuator
```

Optimize by:
- Closing unused submenus
- Using smaller icon files
- Limiting nested menu depth

### File I/O Optimization

- Use SSD storage for menu files
- Keep menu file under 100KB for optimal performance
- Avoid excessive symbolic links in icon paths

## Advanced Troubleshooting

### Debug Mode

Enable detailed logging:

```bash
flutter run -d linux --debug
# or
export ICEMENU_DEBUG=1
./icewm_menuator
```

### Common Issues

#### Menu Not Reloading
```bash
# Check if IceWM is running
pgrep -x icewm

# Manual reload
pkill -HUP -x icewm

# Check IceWM log
tail -f ~/.icewm/icewm.log
```

#### Icon Not Displaying
```bash
# Check icon path
ls -la /usr/share/pixmaps/firefox.png

# Test icon format
file /usr/share/pixmaps/firefox.png

# Check icon theme
gtk-icon-theme-list
```

#### Permission Issues
```bash
# Check file permissions
ls -la ~/.icewm/menu

# Fix permissions
chmod 644 ~/.icewm/menu
chown $USER:$USER ~/.icewm/menu
```

### Manual Menu Editing

When the GUI isn't available, edit the menu file directly:

```bash
# Backup first
cp ~/.icewm/menu ~/.icewm/menu.backup

# Edit with your favorite editor
nano ~/.icewm/menu

# Validate syntax
icewm-menu-check ~/.icewm/menu  # if available

# Reload
pkill -HUP -x icewm
```

### Recovery from Corruption

If your menu file becomes corrupted:

```bash
# Reset to template
rm ~/.icewm/menu
icewm_menuator

# Or restore from backup
cp ~/.icewm/menu.bak ~/.icewm/menu
pkill -HUP -x icewm
```

## Advanced Configuration

### Custom File Locations

Edit the source code or use environment variables to change default paths:

```dart
// In main.dart
final menuFile = File(Platform.environment['ICEMENU_MENU_FILE'] ?? 
    '${homeDir.path}/.icewm/menu');
```

### Integration with Version Control

Track your menu changes:

```bash
cd ~/.icewm
git init
git add menu
git commit -m "Initial menu setup"

# Track changes
git diff menu
git commit -am "Updated applications"
```

### Multi-user Setups

For system-wide menu templates:

```bash
# System template
sudo mkdir -p /etc/icewm/templates
sudo cp /home/user/.icewm/menu /etc/icewm/templates/default.menu

# User setup
cp /etc/icewm/templates/default.menu ~/.icewm/menu
```

## Contributing

### Development Setup

```bash
git clone https://github.com/your-repo/icewm_menuator
cd icewm_menuator
flutter pub get
flutter run -d linux
```

### Code Style

- Follow Dart formatting conventions
- Use meaningful variable names
- Add comments for complex logic
- Include error handling for user operations

### Testing

```bash
# Run tests
flutter test

# Test specific features
flutter test test/menu_parser_test.dart
flutter test test/menu_writer_test.dart
```

## API Reference

### Core Classes

- `IceMenuEntry`: Base class for all menu items
- `IceProgram`: Application launcher entry
- `IceSubMenu`: Directory/submenu entry
- `IceMenuParser`: Parses menu file format
- `IceMenuWriter`: Serializes menu to file format

### Key Methods

```dart
// Parse menu file
List<IceMenuEntry> entries = IceMenuParser.parse(content);

// Serialize to string
String output = IceMenuWriter.serialize(entries);

// Reload IceWM
await Process.run('pkill', ['-HUP', '-x', 'icewm']);
```

For more technical details, see the source code documentation.
