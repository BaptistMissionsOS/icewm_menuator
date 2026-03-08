# Documentation Index

Welcome to the IceWM Menuator documentation. This collection of guides covers everything from basic usage to advanced customization.

## 📚 Available Guides

### [Basic User Guide](basic-guide.md)
**Perfect for new users and everyday use**

- Getting started with the application
- Understanding the interface and top bar actions
- Theme selection and switching
- Adding and editing menu entries
- Common tasks like organizing applications
- Saving and reloading your menu
- Tips for efficient menu management

### [Advanced User Guide](advanced-guide.md)
**For power users and custom setups**

- Advanced menu structures and nesting
- **Theme customization** - Technical details about the theming system
- Custom icons and theme integration
- Command-line options and environment variables
- File structure and format details
- Automation and scripting
- Performance optimization
- API reference for developers

### [Troubleshooting Guide](troubleshooting.md)
**Solve common problems quickly**

- Installation and setup issues
- Runtime problems and crashes
- **Theme issues** - Theme not working, detection problems
- Menu file corruption and recovery
- IceWM integration issues
- Performance troubleshooting
- Debugging techniques
- Frequently asked questions

## 🚀 Quick Navigation

### I'm new to IceWM Menuator...
Start with the **[Basic User Guide](basic-guide.md#getting-started)** to learn the fundamentals.

### I want to change the theme...
Check the **[Basic User Guide → Theme Selection](basic-guide.md#theme-selection)** for simple theme switching, or the **[Advanced User Guide → Theme Customization](advanced-guide.md#theme-customization)** for technical details.

### I'm having problems...
Check the **[Troubleshooting Guide](troubleshooting.md)** for solutions to common issues.

### I want to customize everything...
Read the **[Advanced User Guide](advanced-guide.md)** for power features and customization.

### I need to fix the "Lost connection to device" error...
Go directly to **[Troubleshooting Guide → Lost Connection Error](troubleshooting.md#lost-connection-to-device-error)**.

### My theme isn't working properly...
See **[Troubleshooting Guide → Theme Issues](troubleshooting.md#theme-issues)** for theme-specific problems.

## 📋 Common Tasks

| Task | Guide | Section |
|------|-------|---------|
| Install the application | Basic | Getting Started |
| **Switch themes** | Basic | Theme Selection |
| Add a new program | Basic | Managing Menu Entries |
| Create submenus | Basic | Common Tasks |
| Use custom icons | Advanced | Custom Icons and Themes |
| **Customize theme colors** | Advanced | Theme Customization |
| Automate menu updates | Advanced | Automation and Scripting |
| Fix crash on save | Troubleshooting | Lost Connection Error |
| **Fix theme issues** | Troubleshooting | Theme Issues |
| Backup my menu | Basic | Saving and Reloading |
| Sync between computers | Advanced | Multi-user Setups |

## 🔧 Technical Information

### File Locations Referenced in Guides
- **Menu File**: `~/.icewm/menu`
- **Backup File**: `~/.icewm/menu.bak`
- **Applications**: `~/.icewm/applications/`
- **Directories**: `~/.icewm/directories/`

### Key Commands
```bash
# Manual IceWM reload
pkill -HUP -x icewm

# Backup menu
cp ~/.icewm/menu ~/.icewm/menu.backup.$(date +%Y%m%d)

# Run with debug
export ICEMENU_DEBUG=1
./icewm_menuator
```

## 🤝 Contributing to Documentation

Found an error or want to improve the docs?

1. **Fix typos/errors**: Edit the relevant markdown file
2. **Add examples**: Include real-world use cases
3. **Update screenshots**: Add visual guides for complex procedures
4. **Translate**: Consider contributing translations

### Documentation Style Guide

- Use clear, concise language
- Include code examples for technical content
- Add step-by-step instructions for procedures
- Use tables and lists for easy scanning
- Include troubleshooting tips where relevant

## 📞 Getting Help

If you can't find the answer in these guides:

1. **Check the FAQ** in the Troubleshooting Guide
2. **Enable debug mode** to get detailed error information
3. **Search existing issues** in the project repository
4. **Create a new issue** with details about your problem

When reporting issues, please include:
- Your operating system and version
- IceWM version
- Flutter version (if running from source)
- Exact error messages
- Steps to reproduce the problem

---

**Happy menu editing! 🎉**
