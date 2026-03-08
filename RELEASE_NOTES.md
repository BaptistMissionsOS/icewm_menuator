# Release Notes

## [1.0.0] - Initial Release

### 🎉 First Public Release

IceWM Menuator is now available as a stable desktop application for managing IceWM menu files with an intuitive graphical interface.

### ✨ Key Features

- **Visual Menu Editor**: Interactive tree view for organizing menu entries
- **Drag & Drop Support**: Move menu entries between menus with visual feedback
- **Live Updates**: Changes appear immediately in IceWM without manual reloading
- **Smart Application Scanning**: Automatically discovers and categorizes desktop applications
- **Theme Support**: Toggle between light and dark modes with automatic system theme detection
- **Backup System**: Automatic backup creation before modifications
- **Modern UI**: Material 3 design with menu-themed application icon

### 🔧 Core Functionality

- **Entry Management**: Support for programs, submenus, separators, restart, and quit entries
- **Context Menu Access**: Double-click submenu names to open options menu
- **Intelligent Organization**: Applications automatically placed in appropriate directories (Multimedia, Development, Office, etc.)
- **Duplicate Prevention**: Smart scanning that avoids adding items already in your menu
- **Selection Controls**: Click to select, click again to deselect, with clear selection button

### 🛠️ Technical Specifications

- **Framework**: Flutter 3.11.1+
- **Platform**: Linux desktop, AppImage packaging

- **Dependencies**:
  - `interactive_tree_view` (v0.10.4) - Hierarchical menu display
  - `flutter_svg` (v2.2.3) - Icon support
  - `path_provider` (v2.1.0) - File system access
- **Target**: IceWM window manager

### 📚 Documentation

- Complete user guides in `/docs/` directory
- Basic and advanced usage documentation
- Comprehensive troubleshooting guide
- Installation and setup instructions

### 🎯 Use Cases

- **System Administrators**: Efficiently manage IceWM menus across multiple systems
- **Linux Users**: Simplify IceWM menu customization without manual file editing
- **Developers**: Test menu configurations with live updates
- **Power Users**: Organize applications intelligently with automatic categorization

### 🔒 Safety Features

- **Automatic Backups**: Creates backups before any menu modifications
- **Live Update Toggle**: Option to disable automatic saving for testing
- **Manual Controls**: Save, backup, and reload buttons for full control
- **Reset Function**: Clear all entries and start fresh when needed

### 🚀 Installation

1. Ensure Flutter is installed and configured for desktop development
2. Clone this repository
3. Run: `flutter run`

### 📱 Interface Overview

**Top Bar Actions**:
- Theme toggle (🌙/☀️)
- Application/directory scanning (✨)
- Menu reset function
- Live updates toggle
- Backup creation (💾)
- Manual save
- File reload
- IceWM reload

### 🎨 User Experience

- **Material 3 Design**: Modern, consistent interface
- **Responsive Layout**: Adapts to different screen sizes
- **Visual Feedback**: Drag-and-drop with clear indicators
- **Accessibility**: Keyboard navigation and screen reader support
- **Performance**: Fast loading and smooth interactions

---

## Upcoming Features

### 🔄 Planned Enhancements

- **Export/Import**: Share menu configurations between systems
- **Template System**: Pre-built menu layouts for different use cases
- **Batch Operations**: Multiple selection and bulk editing
- **Menu Validation**: Check for broken links and missing applications
- **Custom Icons**: Support for custom application icons
- **Search Functionality**: Quick search through menu entries
- **Undo/Redo**: Full history of changes with rollback capability

### 🔮 Future Roadmap

- **Multi-language Support**: Internationalization for non-English users
- **Plugin System**: Extend functionality with community plugins
- **Cloud Sync**: Synchronize menu settings across devices
- **Advanced Filtering**: Complex search and filtering options
- **Menu Analytics**: Usage statistics and optimization suggestions

---

## Known Issues

### ⚠️ Current Limitations

- Requires manual Flutter installation for development
- Limited to Linux desktop environments with IceWM
- Large menus may experience performance issues on older hardware
- Some exotic desktop file formats may not be fully supported

### 🐛 Bug Reports

Please report issues through the project's issue tracker with:
- System information (distribution, IceWM version)
- Steps to reproduce
- Expected vs actual behavior
- Any error messages or logs

---

## Contributing

### 👥 Development

1. Set up Flutter desktop development environment
2. Run tests: `flutter test`
3. Build for Linux: `flutter build linux`
4. Follow existing code style and documentation patterns

### 🤝 Community

- Contributions welcome for features, bug fixes, and documentation
- Please follow the project's code of conduct
- Submit pull requests with clear descriptions and testing

---

## Support

### 📞 Getting Help

- **Documentation**: Check `/docs/` directory first
- **Troubleshooting**: See `docs/troubleshooting.md`
- **Community**: Report issues and request features
- **Guides**: Available for basic and advanced usage

### 🔧 Technical Support

For technical issues, please provide:
- Flutter version and system information
- IceWM configuration details
- Steps to reproduce the problem
- Any relevant log files or error messages

---

*Last updated: Initial Release*
