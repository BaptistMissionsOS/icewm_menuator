# Documentation Index

Welcome to the IceWM Menuator documentation. This collection of guides covers everything from basic usage to advanced customization.

## 📚 Available Guides

### [Basic User Guide](basic-guide.md)
**Perfect for new users and everyday use**

- Getting started with the application
- Understanding the interface
- Adding and editing menu entries
- Common tasks like organizing applications
- Saving and reloading your menu
- Tips for efficient menu management

### [Advanced User Guide](advanced-guide.md)
**For power users and custom setups**

- Advanced menu structures and nesting
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
- Menu file corruption and recovery
- IceWM integration issues
- Performance troubleshooting
- Debugging techniques
- Frequently asked questions

## 🚀 Quick Navigation

### I'm new to IceWM Menuator...
Start with the **[Basic User Guide](basic-guide.md#getting-started)** to learn the fundamentals.

### I'm having problems...
Check the **[Troubleshooting Guide](troubleshooting.md)** for solutions to common issues.

### I want to customize everything...
Read the **[Advanced User Guide](advanced-guide.md)** for power features and customization.

### I need to fix the "Lost connection to device" error...
Go directly to **[Troubleshooting Guide → Lost Connection Error](troubleshooting.md#lost-connection-to-device-error)**.

## 📋 Common Tasks

| Task | Guide | Section |
|------|-------|---------|
| Install the application | Basic | Getting Started |
| Add a new program | Basic | Managing Menu Entries |
| Create submenus | Basic | Common Tasks |
| Use custom icons | Advanced | Custom Icons and Themes |
| Automate menu updates | Advanced | Automation and Scripting |
| Fix crash on save | Troubleshooting | Lost Connection Error |
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
