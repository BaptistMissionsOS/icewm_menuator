import 'package:flutter/material.dart';
import '../models/ice_entry.dart';

/// Displays the IceWM menu structure as an interactive tree with drag-and-drop
class MenuTreeWidget extends StatefulWidget {
  final List<IceMenuEntry> entries;
  final Function(IceMenuEntry) onEntrySelected;
  final Function(IceMenuEntry, IceMenuEntry)? onEntryMoved;
  final Function(IceMenuEntry, IceSubMenu)? onEntryDropped;
  final IceMenuEntry? selectedEntry;
  final Function(IceMenuEntry)? onEntryUpdated;

  const MenuTreeWidget({
    Key? key,
    required this.entries,
    required this.onEntrySelected,
    this.onEntryMoved,
    this.onEntryDropped,
    this.selectedEntry,
    this.onEntryUpdated,
  }) : super(key: key);

  @override
  State<MenuTreeWidget> createState() => _MenuTreeWidgetState();
}

class _MenuTreeWidgetState extends State<MenuTreeWidget> {
  IceMenuEntry? _draggedEntry;
  IceSubMenu? _editingSubmenu;
  late TextEditingController _editController;
  
  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  /// Start inline editing for a submenu
  void _startEditingSubmenu(IceSubMenu submenu) {
    setState(() {
      _editingSubmenu = submenu;
      _editController.text = submenu.label;
    });
  }

  /// Save the inline edit and update the submenu
  void _saveInlineEdit() {
    if (_editingSubmenu != null) {
      final updatedSubmenu = _editingSubmenu!.copyWith(
        label: _editController.text,
      );
      
      // Notify parent of the update
      widget.onEntryUpdated?.call(updatedSubmenu);
      
      setState(() {
        _editingSubmenu = null;
      });
    }
  }

  /// Cancel inline editing
  void _cancelInlineEdit() {
    setState(() {
      _editingSubmenu = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.entries
            .map((entry) => _buildEntryWidget(entry, 0))
            .toList(),
      ),
    );
  }

  /// Build widget for an entry with recursive support for submenus
  Widget _buildEntryWidget(IceMenuEntry entry, int depth) {
    if (entry is IceSubMenu) {
      return _buildSubmenuWidget(entry, depth);
    } else {
      return _buildDraggableEntryWidget(entry, depth);
    }
  }

  /// Build a draggable program/separator entry
  Widget _buildDraggableEntryWidget(IceMenuEntry entry, int depth) {
    return Draggable<IceMenuEntry>(
      data: entry,
      feedback: Material(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEntryIcon(entry),
              const SizedBox(width: 8),
              Text(
                _getEntryLabel(entry),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      onDragStarted: () {
        setState(() => _draggedEntry = entry);
      },
      onDraggableCanceled: (velocity, offset) {
        setState(() => _draggedEntry = null);
      },
      child: Padding(
        padding: EdgeInsets.only(left: depth * 10.0, top: 4, bottom: 4),
        child: GestureDetector(
          onTap: () => widget.onEntrySelected(entry),
          child: Container(
            decoration: BoxDecoration(
              color: _draggedEntry == entry 
                  ? Colors.blue.withOpacity(0.2)
                  : widget.selectedEntry == entry
                      ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                      : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: _getEntryColor(entry),
                  width: 3.0,
                ),
              ),
            ),
            child: ListTile(
              leading: _buildEntryIcon(entry),
              title: Text(_getEntryLabel(entry)),
              tileColor: Colors.transparent,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
        ),
      ),
    );
  }

  /// Build a submenu with expandable children (droppable)
  Widget _buildSubmenuWidget(IceSubMenu menu, int depth) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 10.0),
      child: DragTarget<IceMenuEntry>(
        onAccept: (draggedEntry) {
          setState(() => _draggedEntry = null);
          widget.onEntryDropped?.call(draggedEntry, menu);
        },
        onWillAccept: (draggedEntry) {
          setState(() => _draggedEntry = draggedEntry);
          return draggedEntry != menu;
        },
        onLeave: (draggedEntry) {
          setState(() => _draggedEntry = null);
        },
        builder: (context, candidateData, rejectedData) {
          final isEditing = _editingSubmenu == menu;
          
          return ExpansionTile(
            key: Key(menu.label),
            leading: const Icon(Icons.folder_open, size: 20),
            title: isEditing
                ? TextField(
                    controller: _editController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                    onSubmitted: (_) => _saveInlineEdit(),
                    onEditingComplete: _saveInlineEdit,
                  )
                : GestureDetector(
                    onDoubleTap: () => _startEditingSubmenu(menu),
                    child: Text(menu.label),
                  ),
            backgroundColor: candidateData.isNotEmpty
                ? Colors.green.withOpacity(0.1)
                : widget.selectedEntry == menu
                    ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                    : Colors.transparent,
            collapsedBackgroundColor: candidateData.isNotEmpty
                ? Colors.green.withOpacity(0.1)
                : widget.selectedEntry == menu
                    ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                    : Colors.transparent,
            children: menu.children
                .map((child) => _buildEntryWidget(child, depth + 1))
                .toList(),
          );
        },
      ),
    );
  }

  /// Get the color for this entry type
  Color _getEntryColor(IceMenuEntry entry) {
    switch (entry.type) {
      case EntryType.prog:
        return Colors.blue;
      case EntryType.menu:
        return Colors.green;
      case EntryType.separator:
        return Colors.grey;
      case EntryType.restart:
        return Colors.orange;
      case EntryType.quit:
        return Colors.red;
    }
  }

  /// Build the icon for this entry
  Widget _buildEntryIcon(IceMenuEntry entry) {
    switch (entry.type) {
      case EntryType.prog:
        return const Icon(Icons.terminal, size: 20);
      case EntryType.menu:
        return const Icon(Icons.folder_open, size: 20);
      case EntryType.separator:
        return const Icon(Icons.remove, size: 20);
      case EntryType.restart:
        return const Icon(Icons.restart_alt, size: 20);
      case EntryType.quit:
        return const Icon(Icons.exit_to_app, size: 20);
    }
  }

  /// Get the display label for this entry
  String _getEntryLabel(IceMenuEntry entry) {
    switch (entry.type) {
      case EntryType.prog:
        return (entry as IceProgram).label;
      case EntryType.menu:
        return (entry as IceSubMenu).label;
      case EntryType.separator:
        return '--- Separator ---';
      case EntryType.restart:
        return 'Restart IceWM';
      case EntryType.quit:
        return 'Quit IceWM';
    }
  }
}
