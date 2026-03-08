# IceWM Menuator

A Flutter desktop application for managing IceWM menu files with drag-and-drop organization and live updates.

## Features

- **Visual Menu Editor**: Interactive tree view for organizing menu entries
- **Drag & Drop**: Move menu entries between menus with visual feedback
- **Live Updates**: Changes appear immediately in IceWM without manual reloading
- **Inline Editing**: Double-click submenu names to edit them directly
- **Smart Application Scanning**: Automatically discovers and organizes desktop applications into categorized directories
- **Intelligent Organization**: Applications are automatically placed in appropriate directories based on their categories (Multimedia, Development, Office, etc.)
- **Duplicate Prevention**: Smart scanning that avoids adding items already in your menu
- **Entry Types**: Support for programs, submenus, separators, restart, and quit entries
- **Backup System**: Automatic backup creation before modifications

## Dependencies

### System Requirements
- **IceWM**: The window manager this tool manages

### Flutter Dependencies
- `flutter` (framework)
- `interactive_tree_view` (for hierarchical menu display)
- `flutter_svg` (for icon support)
- `path_provider` (for file system access)

## Installation

1. Ensure Flutter is installed and configured for desktop development
2. Install system dependencies:
   ```bash
   sudo apt install psmisc
   ```
3. Clone this repository
4. Run the application:
   ```bash
   flutter run
   ```

## Usage

1. The app automatically loads your `~/.icewm/menu` file
2. Use the tree view on the left to navigate and select menu entries
3. Edit entry properties in the right panel
4. **Inline Editing**: Double-click on submenu names in the tree view to edit them directly
5. **Smart Scanning**: Click the sparkle icon (✨) to automatically scan and organize all desktop applications into categorized directories
6. Drag entries to reorganize them between menus
7. Changes are automatically saved and IceWM is reloaded immediately (when live updates are enabled)
8. **Selection**: Click an entry to select it, click the selected entry again to deselect and return to the "Select an entry to edit" panel
9. **Clear Selection**: Use the "Clear Selection" button in the editor panel to deselect the current entry
10. Use the toolbar buttons to manually save, backup, or reload if needed

## Scanning

The application scans for desktop files in standard locations and organizes them intelligently:
- **Applications**: `/usr/share/applications`, `/usr/local/share/applications`, `~/.local/share/applications`
- **Directories**: `/usr/share/desktop-directories`, `/usr/local/share/desktop-directories`, `~/.local/share/desktop-directories`

**Smart Organization**: Applications are automatically categorized and placed in appropriate directories:
- **Multimedia**: Audio/Video applications
- **Development**: Programming tools and IDEs
- **Office**: Productivity applications
- **Internet**: Web browsers, email clients, etc.
- **Graphics**: Image editors and viewers
- **Games**: Gaming applications
- **System**: System utilities and tools
- **Accessories**: General utilities and tools

Scanning automatically avoids duplicates by checking existing menu entries before adding new ones.

## Development

This project uses Flutter for desktop Linux applications. To contribute:

1. Set up Flutter desktop development environment
2. Run tests: `flutter test`
3. Build for Linux: `flutter build linux`
