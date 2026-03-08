# IceWM Menuator - Basic User Guide

Welcome to IceWM Menuator! This guide will help you get started with editing your IceWM menu using this user-friendly desktop application.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Basic Operations](#basic-operations)
3. [Managing Menu Entries](#managing-menu-entries)
4. [Theme Selection](#theme-selection)
5. [Saving and Reloading](#saving-and-reloading)
6. [Common Tasks](#common-tasks)

## Getting Started

### ⚠️ Important: Backup First

Before making any changes to your menu, **always create a backup**:

1. **Manual Backup**: Click the backup button (💾) in the top toolbar
2. **Automatic Backup**: The app automatically creates backups when resetting the menu
3. **Backup Location**: Backups are saved as `~/.icewm/menu.bak`

**Why backup?**
- Prevent accidental loss of your custom menu configuration
- Allow quick recovery if something goes wrong
- Maintain a restore point before major changes

### Launching the Application

1. **From Terminal**: Navigate to the IceWM Menuator directory and run:
   ```bash
   flutter run -d linux
   ```

2. **Built Application**: If you have a built version, simply run the executable from your application menu.

### First Run

When you first launch IceWM Menuator, it will:
- Automatically locate your `~/.icewm/menu` file
- Create the file if it doesn't exist with a basic template
- Load your current menu structure

## Basic Operations

### Understanding the Interface

The application window is divided into two main panels:

- **Left Panel (Menu Tree)**: Shows your menu structure in a hierarchical view
- **Right Panel (Entry Editor)**: Allows you to edit the selected menu entry

### Navigation

- **Click on any menu entry** to select it and see its details in the editor
- **Click the same entry again** to deselect it
- **Use the arrow buttons** in the editor to move entries up or down

### Top Bar Actions

The top bar contains several useful buttons (left to right):

1. **Theme Toggle** (🌙/☀️): Switch between dark and light modes
2. **Scan Options** (✨): Scan for applications or directories
3. **Reset Menu** (🔄): Clear all entries and start fresh
4. **Live Updates** (⚡): Enable/disable automatic saving and IceWM reloading
5. **Create Backup** (💾): Backup current menu
6. **Save Menu** (💾): Manually save changes
7. **Reload File** (📁): Reload menu from disk
8. **Reload IceWM** (🔄): Force IceWM to reload its menu

## Managing Menu Entries

### Adding New Entries

1. Click the **Add Entry** button in the editor panel
2. Choose the entry type:
   - **Program**: An application launcher
   - **Directory**: A submenu container
   - **Separator**: A visual divider line
   - **Restart**: IceWM restart option
   - **Quit**: IceWM quit option

### Editing Programs

For program entries, you can set:
- **Label**: The name displayed in the menu
- **Icon**: Path to icon file (or leave empty for default)
- **Command**: The actual command to execute

**Example Program Entry:**
- Label: `Firefox`
- Icon: `/usr/share/pixmaps/firefox.png`
- Command: `firefox`

### Editing Directories

For directory entries (submenus), you can set:
- **Label**: The directory name shown in the menu
- **Icon**: Path to icon file (defaults to folder icon)

### Deleting Entries

1. Select the entry you want to delete
2. Click the **Delete** button in the editor panel
3. Confirm the deletion

**Note**: Generated entries (from scanning) will be hidden rather than deleted.

## Theme Selection

### Switching Themes

IceWM Menuator supports both light and dark themes:

1. **Automatic Detection**: The app automatically detects your system theme preference on startup
2. **Manual Toggle**: Click the theme toggle button (🌙/☀️) in the top bar:
   - **🌙 Dark Mode**: Click when in light mode to switch to dark theme
   - **☀️ Light Mode**: Click when in dark mode to switch to light theme

### Theme Features

- **Material 3 Design**: Both themes follow modern Material 3 design guidelines
- **Instant Switching**: Themes change immediately without restarting the app
- **System Integration**: Automatically matches your system theme preference
- **Eye Comfort**: Choose dark mode for reduced eye strain in low light

### Theme Persistence

Your theme preference is maintained during your current session. The app will remember your choice until you close it.

## Saving and Reloading

### Manual Save

1. Click the **Save** button (floppy disk icon) in the toolbar
2. The application will:
   - Save your menu to `~/.icewm/menu`
   - Automatically reload IceWM to apply changes
   - Show a success message

### Live Updates

Enable **Live Updates** (lightning bolt icon) to:
- Automatically save changes as you make them
- Instantly reload IceWM menu
- See changes immediately in your IceWM menu

### Backup

**🔄 Always Backup Before Major Changes**

The application provides multiple ways to protect your menu configuration:

1. **Manual Backup**: Click the backup button (💾) in the toolbar anytime
2. **Automatic Backup**: Created automatically when:
   - Resetting the menu
   - Making major structural changes
3. **Backup File Location**: `~/.icewm/menu.bak`

**Restoring from Backup**:
If something goes wrong, you can restore:
- **Via App**: Use the "Reload File" button after manually copying the backup
- **Via Terminal**: `cp ~/.icewm/menu.bak ~/.icewm/menu` then restart IceWM

**Best Practices**:
- Create a backup before scanning applications (in case of duplicates)
- Backup before major reorganization
- Keep multiple backups by renaming them with dates

## Common Tasks

### Adding a New Application

1. Click **Add Entry** → **Program**
2. Fill in the details:
   - Label: Application name
   - Icon: Path to icon (optional)
   - Command: Command to run the application
3. Click **Save**

### Creating a Submenu

1. Click **Add Entry** → **Directory**
2. Set the directory name and icon
3. Add entries to this directory by:
   - Selecting the directory
   - Clicking **Add Sub-Directory** in the editor
   - Or dragging existing entries into the directory

### Organizing with Drag & Drop

1. Click and hold any menu entry
2. Drag it to:
   - Another directory to move it inside
   - The root level to make it a top-level entry
3. Release to drop the entry in its new location

### Reordering Entries

1. Select any entry
2. Use the **Up/Down** arrows in the editor panel
3. Changes are saved automatically if Live Updates is enabled

### Scanning for Applications

1. Click the **scan icon** (auto-awesome) in the toolbar
2. Select **Scan Applications** to find all desktop applications
3. New applications will be added to an "Other" directory
4. Review and organize them as needed

## Tips

- **Use Live Updates** for immediate feedback
- **Create backups** before making major changes
- **Scan applications** to quickly populate your menu
- **Use separators** to organize related items
- **Test commands** in terminal first if unsure
- **Choose your theme** based on lighting conditions and personal preference
- **Use dark mode** for reduced eye strain in low-light environments

## Getting Help

If you run into issues:
1. Check the [Troubleshooting Guide](troubleshooting.md)
2. Look at the [Advanced User Guide](advanced.md) for complex features
3. Enable debug output by running from terminal to see detailed logs

## Keyboard Shortcuts

- **Ctrl+S**: Save menu
- **Ctrl+R**: Reload IceWM menu
- **Delete**: Delete selected entry
- **Escape**: Clear selection

## File Locations

- **Menu File**: `~/.icewm/menu`
- **Backup File**: `~/.icewm/menu.bak`
- **Applications**: Stored in `~/.icewm/applications/`
- **Directories**: Stored in `~/.icewm/directories/`
