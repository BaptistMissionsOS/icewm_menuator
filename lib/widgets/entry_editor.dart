import 'package:flutter/material.dart';
import '../models/ice_entry.dart';

/// Widget for editing properties of a selected menu entry
class EntryEditorWidget extends StatefulWidget {
  final IceMenuEntry? selectedEntry;
  final Function(IceMenuEntry) onEntryUpdated;
  final Function(IceMenuEntry) onEntryDeleted;
  final Function(EntryType) onAddEntry;
  final Function(IceMenuEntry)? onMoveUp;
  final Function(IceMenuEntry)? onMoveDown;
  final Function()? onClearSelection;

  const EntryEditorWidget({
    Key? key,
    this.selectedEntry,
    required this.onEntryUpdated,
    required this.onEntryDeleted,
    required this.onAddEntry,
    this.onMoveUp,
    this.onMoveDown,
    this.onClearSelection,
  }) : super(key: key);

  @override
  State<EntryEditorWidget> createState() => _EntryEditorWidgetState();
}

class _EntryEditorWidgetState extends State<EntryEditorWidget> {
  late TextEditingController _labelController;
  late TextEditingController _iconController;
  late TextEditingController _commandController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(EntryEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedEntry != widget.selectedEntry) {
      _initializeControllers();
    }
  }

  /// Initialize text controllers based on selected entry
  void _initializeControllers() {
    String label = '';
    String icon = '';
    String command = '';

    if (widget.selectedEntry is IceProgram) {
      final prog = widget.selectedEntry as IceProgram;
      label = prog.label;
      icon = prog.icon;
      command = prog.command;
    } else if (widget.selectedEntry is IceSubMenu) {
      final menu = widget.selectedEntry as IceSubMenu;
      label = menu.label;
      icon = menu.icon;
    }

    _labelController = TextEditingController(text: label);
    _iconController = TextEditingController(text: icon);
    _commandController = TextEditingController(text: command);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _iconController.dispose();
    _commandController.dispose();
    super.dispose();
  }

  /// Save changes to the selected entry
  void _saveChanges() {
    if (widget.selectedEntry == null) return;

    if (widget.selectedEntry is IceProgram) {
      final updated = (widget.selectedEntry as IceProgram).copyWith(
        label: _labelController.text,
        icon: _iconController.text,
        command: _commandController.text,
      );
      widget.onEntryUpdated(updated);
    } else if (widget.selectedEntry is IceSubMenu) {
      final updated = (widget.selectedEntry as IceSubMenu).copyWith(
        label: _labelController.text,
        icon: _iconController.text,
      );
      widget.onEntryUpdated(updated);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedEntry == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Select an entry to edit'),
            const SizedBox(height: 32),
            const Text('Add a new entry:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => widget.onAddEntry(EntryType.prog),
                  icon: const Icon(Icons.terminal),
                  label: const Text('Program'),
                ),
                ElevatedButton.icon(
                  onPressed: () => widget.onAddEntry(EntryType.menu),
                  icon: const Icon(Icons.folder),
                  label: const Text('Submenu'),
                ),
                ElevatedButton.icon(
                  onPressed: () => widget.onAddEntry(EntryType.separator),
                  icon: const Icon(Icons.remove),
                  label: const Text('Separator'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Editing: ${_getEntryType()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Name/Label',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _iconController,
              decoration: const InputDecoration(
                labelText: 'Icon Path',
                border: OutlineInputBorder(),
                hintText: '/usr/share/pixmaps/icon.png',
              ),
            ),
            const SizedBox(height: 16),
            if (widget.selectedEntry is IceProgram)
              TextField(
                controller: _commandController,
                decoration: const InputDecoration(
                  labelText: 'Command',
                  border: OutlineInputBorder(),
                  hintText: 'firefox',
                ),
              ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
                if (widget.onClearSelection != null)
                  OutlinedButton.icon(
                    onPressed: widget.onClearSelection,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Selection'),
                  ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    if (widget.selectedEntry != null) {
                      widget.onEntryDeleted(widget.selectedEntry!);
                      _initializeControllers();
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: widget.selectedEntry != null
                      ? () => widget.onMoveUp?.call(widget.selectedEntry!)
                      : null,
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Move Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: widget.selectedEntry != null
                      ? () => widget.onMoveDown?.call(widget.selectedEntry!)
                      : null,
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('Move Down'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Tip: Drag entries to folders to move them',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Get a display string for the entry type
  String _getEntryType() {
    if (widget.selectedEntry is IceProgram) {
      return 'Program';
    } else if (widget.selectedEntry is IceSubMenu) {
      return 'Submenu';
    } else if (widget.selectedEntry is IceSeparator) {
      return 'Separator';
    } else if (widget.selectedEntry is IceRestart) {
      return 'Restart';
    } else if (widget.selectedEntry is IceQuit) {
      return 'Quit';
    }
    return 'Unknown';
  }
}
