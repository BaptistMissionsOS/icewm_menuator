# IceWM Menuator - Troubleshooting Guide

This guide helps you diagnose and resolve common issues with IceWM Menuator.

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Runtime Problems](#runtime-problems)
3. [Menu File Issues](#menu-file-issues)
4. [IceWM Integration Problems](#icewm-integration-problems)
5. [Performance Issues](#performance-issues)
6. [Debugging Techniques](#debugging-techniques)
7. [FAQ](#faq)

## Installation Issues

### Flutter Not Found

**Problem**: `flutter: command not found`

**Solutions**:
1. Install Flutter SDK:
   ```bash
   # Download Flutter
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
   tar xf flutter_linux_3.16.0-stable.tar.xz
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

2. Add to PATH permanently:
   ```bash
   echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

### Dependencies Missing

**Problem**: Missing Linux dependencies

**Solution**:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# Fedora
sudo dnf install clang cmake ninja-build pkg-config gtk3-devel xz-devel

# Arch Linux
sudo pacman -S clang cmake ninja pkgconf gtk3 xz
```

### Build Fails

**Problem**: `flutter build linux` fails

**Common fixes**:
```bash
# Clean build
flutter clean
flutter pub get
flutter build linux

# Check Flutter doctor
flutter doctor -v

# Update Flutter
flutter upgrade
```

## Runtime Problems

### Application Won't Start

**Problem**: Double-click does nothing or terminal shows errors

**Diagnosis**:
```bash
# Run from terminal to see errors
./build/linux/x64/release/bundle/icewm_menuator

# Check permissions
ls -la build/linux/x64/release/bundle/icewm_menuator

# Make executable
chmod +x build/linux/x64/release/bundle/icewm_menuator
```

**Common fixes**:
1. Missing shared libraries:
   ```bash
   ldd build/linux/x64/release/bundle/icewm_menuator
   # Install missing libraries based on output
   ```

2. Display issues:
   ```bash
   export DISPLAY=:0
   ./icewm_menuator
   ```

### "Lost Connection to Device" Error

**Problem**: Flutter debugger disconnects unexpectedly

**Causes and Solutions**:

#### 1. Recursive Menu Loop
**Symptoms**: App crashes during save operations

**Check**: Look for circular references in your menu structure
```bash
# Manual inspection
grep -n "menu" ~/.icewm/menu
```

**Fix**: Remove circular references or reset menu

#### 2. Process Suicide (Most Common)
**Symptoms**: App crashes when clicking "Save/Reload"

**Cause**: `pkill -HUP icewm` kills your app too

**Fix**: Ensure `-x` flag is used:
```dart
// Correct
final result = await Process.run('pkill', ['-HUP', '-x', 'icewm']);

// Wrong - kills icewm_menuator too
final result = await Process.run('pkill', ['-HUP', 'icewm']);
```

#### 3. Permissions Issue
**Symptoms**: Crash when writing files

**Fix**:
```bash
# Check permissions
ls -la ~/.icewm/
chmod 755 ~/.icewm/
chmod 644 ~/.icewm/menu
```

### Freezes or Unresponsive UI

**Problem**: Application becomes unresponsive

**Solutions**:
1. Large menu causing performance issues:
   - Disable live updates
   - Reduce menu complexity
   - Use smaller icons

2. Memory leak:
   ```bash
   # Monitor memory usage
   watch -n 1 'ps aux | grep icewm_menuator'
   ```

3. Restart application:
   ```bash
   pkill -x icewm_menuator
   ./icewm_menuator
   ```

## Menu File Issues

### Menu File Not Found

**Problem**: "Menu file not found" error

**Diagnosis**:
```bash
# Check if file exists
ls -la ~/.icewm/menu

# Check directory permissions
ls -la ~/.icewm/
```

**Solutions**:
1. Create directory:
   ```bash
   mkdir -p ~/.icewm
   ```

2. Create default menu:
   ```bash
   cat > ~/.icewm/menu << 'EOF'
   # IceWM Menu
   menu "Applications" "folder" {
     prog "Terminal" "terminal" xterm
     prog "Firefox" "firefox" firefox
   }
   separator
   restart icewm - icewm
   quit
   EOF
   ```

### Menu File Corruption

**Problem**: Menu appears garbled or incomplete

**Diagnosis**:
```bash
# Check file encoding
file ~/.icewm/menu

# Look for binary data
hexdump -C ~/.icewm/menu | head
```

**Solutions**:
1. Restore from backup:
   ```bash
   cp ~/.icewm/menu.bak ~/.icewm/menu
   ```

2. Reset to default:
   ```bash
   rm ~/.icewm/menu
   # Restart IceWM Menuator to create template
   ```

3. Manual repair:
   ```bash
   # Validate syntax
   grep -E "^(prog|menu|separator|restart|quit|#|$)" ~/.icewm/menu
   ```

### Permission Denied

**Problem**: Cannot save menu file

**Diagnosis**:
```bash
# Check ownership
ls -la ~/.icewm/menu

# Check write permissions
touch ~/.icewm/menu.test
rm ~/.icewm/menu.test
```

**Solutions**:
```bash
# Fix ownership
sudo chown $USER:$USER ~/.icewm/menu

# Fix permissions
chmod 644 ~/.icewm/menu
chmod 755 ~/.icewm/
```

## IceWM Integration Problems

### Menu Changes Not Visible

**Problem**: Saved menu but IceWM shows old menu

**Diagnosis**:
```bash
# Check if IceWM is running
pgrep -x icewm

# Check IceWM log
tail -f ~/.icewm/icewm.log

# Manual reload test
pkill -HUP -x icewm
```

**Solutions**:
1. IceWM not running:
   ```bash
   # Start IceWM
   icewm &
   ```

2. Incorrect file location:
   ```bash
   # Find actual menu file
   find ~ -name "menu" -path "*/.icewm/*" 2>/dev/null
   ```

3. IceWM configuration issue:
   ```bash
   # Check IceWM config
   grep -i "menu" ~/.icewm/preferences
   ```

### pkill Command Fails

**Problem**: "pkill: command not found" or reload fails

**Diagnosis**:
```bash
# Check if pkill exists
which pkill

# Test manually
pkill -HUP -x icewm
echo $?
```

**Solutions**:
1. Install procps:
   ```bash
   # Ubuntu/Debian
   sudo apt install procps
   
   # Fedora
   sudo dnf install procps-ng
   ```

2. Use alternative signal:
   ```bash
   # Find IceWM process
   ps aux | grep icewm
   
   # Send signal directly
   kill -HUP <pid>
   ```

### Icon Not Displaying

**Problem**: Menu entries show no icons

**Diagnosis**:
```bash
# Check icon path
ls -la /usr/share/pixmaps/firefox.png

# Test icon format
file /usr/share/pixmaps/firefox.png

# Check icon theme
gtk-icon-theme-list
```

**Solutions**:
1. Use absolute paths:
   ```
   /usr/share/pixmaps/firefox.png
   ```

2. Install icon theme:
   ```bash
   # Ubuntu
   sudo apt install gnome-icon-theme
   
   # Check available themes
   ls /usr/share/icons/
   ```

3. Use fallback icon:
   ```
   prog "Firefox" "!" firefox
   ```

## Performance Issues

### Slow Loading

**Problem**: Application takes long time to start

**Causes**:
1. Large menu file (>100KB)
2. Many icon files to scan
3. Slow storage (HDD vs SSD)

**Solutions**:
```bash
# Check menu file size
du -h ~/.icewm/menu

# Optimize icons
# Use smaller PNG files (22x22 or 32x32)
# Limit to essential icons only

# Disable live updates for large menus
```

### High Memory Usage

**Problem**: Application uses excessive memory

**Diagnosis**:
```bash
# Monitor memory
ps aux | grep icewm_menuator

# Check for memory leaks
valgrind --tool=memcheck ./icewm_menuator
```

**Solutions**:
1. Reduce menu complexity
2. Use smaller icon files
3. Restart application periodically

### UI Lag

**Problem**: Interface becomes sluggish

**Solutions**:
1. Disable live updates
2. Reduce nested menu depth
3. Close unused submenus
4. Use faster storage

## Debugging Techniques

### Enable Debug Mode

**Method 1 - Environment Variable**:
```bash
export ICEMENU_DEBUG=1
./icewm_menuator
```

**Method 2 - Development Mode**:
```bash
flutter run -d linux --debug
```

### Log Files

**Application Logs**:
```bash
# Flutter logs
flutter logs

# System logs
journalctl -f | grep icewm_menuator
```

**IceWM Logs**:
```bash
# IceWM log file
tail -f ~/.icewm/icewm.log

# System logs for IceWM
journalctl -f | grep icewm
```

### Manual Testing

**Test Menu Parser**:
```bash
# Create test menu
cat > test.menu << 'EOF'
menu "Test" "folder" {
  prog "App" "icon" command
}
EOF

# Test parsing
dart -c lib/parser.dart
```

**Test File Operations**:
```bash
# Test file permissions
touch ~/.icewm/test.write
echo "test" > ~/.icewm/test.write
rm ~/.icewm/test.write

# Test process execution
pkill -HUP -x icewm
echo "Exit code: $?"
```

### Common Error Messages

#### "Failed to run pkill"
**Meaning**: pkill command failed
**Fix**: Install procps package or check permissions

#### "Maximum depth exceeded"
**Meaning**: Circular reference in menu
**Fix**: Remove circular menu references

#### "Menu file not found"
**Meaning**: ~/.icewm/menu doesn't exist
**Fix**: Create directory and menu file

#### "Permission denied"
**Meaning**: Cannot write to menu file
**Fix**: Check file permissions and ownership

## FAQ

### Q: Why does my app crash when I click Save?
**A**: Most likely the "suicidal signal" issue. The pkill command is killing your app too. Make sure you're using `pkill -HUP -x icewm` (with the -x flag).

### Q: How do I backup my menu?
**A**: 
```bash
cp ~/.icewm/menu ~/.icewm/menu.backup.$(date +%Y%m%d)
```

### Q: Can I use custom icons?
**A**: Yes! Use absolute paths to PNG files, or use icon theme names.

### Q: Why don't my changes appear in IceWM?
**A**: IceWM needs to be reloaded. Try `pkill -HUP -x icewm` manually.

### Q: The app is very slow with many entries
**A**: Disable live updates, use smaller icons, and consider organizing entries into submenus.

### Q: Can I edit the menu file manually?
**A**: Yes! The menu file is plain text. Just backup first and reload IceWM after changes.

### Q: How do I reset everything?
**A**: 
```bash
rm ~/.icewm/menu
cp ~/.icewm/menu.bak ~/.icewm/menu  # if backup exists
# or just restart the app to create a fresh template
```

### Q: What's the maximum menu size?
**A**: No hard limit, but performance degrades above 1000 entries or 100KB file size.

### Q: Can I sync menus between computers?
**A**: Yes! Copy ~/.icewm/menu and the applications/directories folders.

## Getting Additional Help

1. **Check the logs** - Enable debug mode and review output
2. **Search issues** - Look for similar problems in project issues
3. **Provide details** - Include OS, IceWM version, and error messages
4. **Test minimal case** - Try with a simple menu to isolate the issue

### Report an Issue

When reporting issues, include:
- Operating system and version
- IceWM version
- Flutter version
- Exact error messages
- Steps to reproduce
- Menu file content (if relevant)

### Community Resources

- IceWM documentation: https://ice-wm.org/
- Flutter documentation: https://flutter.dev/docs
- Linux desktop integration guides
