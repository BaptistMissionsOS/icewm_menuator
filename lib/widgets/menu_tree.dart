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
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  /// Check if an entry is a descendant of a potential ancestor
  bool _isDescendant(IceMenuEntry entry, IceSubMenu ancestor) {
    if (ancestor.children.contains(entry)) return true;
    for (var child in ancestor.children) {
      if (child is IceSubMenu) {
        if (_isDescendant(entry, child)) return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Show all entries (both visible and hidden) in the editor
    debugPrint('MenuTreeWidget building with ${widget.entries.length} total entries');
    for (final entry in widget.entries) {
      if (entry is IceSubMenu) {
        debugPrint('MenuTreeWidget submenu: ${entry.label} with ${entry.children.length} children');
        for (final child in entry.children) {
          debugPrint('  Child: ${child.label}');
        }
      } else if (entry is IceProgram) {
        debugPrint('MenuTreeWidget program: ${entry.label}');
      }
    }
    
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
    final isHidden = !entry.isVisible;
    
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
              title: Text(
                _getEntryLabel(entry),
                style: TextStyle(
                  decoration: isHidden ? TextDecoration.lineThrough : TextDecoration.none,
                  color: isHidden ? Colors.grey : null,
                  fontStyle: isHidden ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              subtitle: isHidden ? const Text('(Hidden)') : null,
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
    debugPrint('Building submenu widget: ${menu.label} with ${menu.children.length} children at depth $depth');
    
    // Show all children (both visible and hidden) in the editor
    final allChildren = menu.children;
    final visibleCount = menu.children.where((child) => child.isVisible).length;
    
    return Padding(
      padding: EdgeInsets.only(left: depth * 10.0),
      child: DragTarget<IceMenuEntry>(
        onAccept: (draggedEntry) {
          setState(() => _draggedEntry = null);
          widget.onEntryDropped?.call(draggedEntry, menu);
        },
        onWillAccept: (draggedEntry) {
          setState(() => _draggedEntry = draggedEntry);
          if (draggedEntry == null) return false;
          if (draggedEntry == menu) return false;
          
          // Check if target menu is already a child of draggedEntry (if draggedEntry is a submenu)
          if (draggedEntry is IceSubMenu) {
            return !_isDescendant(menu, draggedEntry);
          }
          return true;
        },
        onLeave: (draggedEntry) {
          setState(() => _draggedEntry = null);
        },
        builder: (context, candidateData, rejectedData) {
          return Draggable<IceMenuEntry>(
            data: menu,
            feedback: Material(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.folder_open, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      menu.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            onDragStarted: () {
              setState(() => _draggedEntry = menu);
            },
            onDraggableCanceled: (velocity, offset) {
              setState(() => _draggedEntry = null);
            },
            child: ExpansionTile(
              key: Key(menu.label),
              leading: const Icon(Icons.folder_open, size: 20),
              initiallyExpanded: true, // Start expanded so submenus are visible
              title: GestureDetector(
                onTap: () => widget.onEntrySelected(menu),
                onDoubleTap: () {
                  widget.onEntrySelected(menu);
                  // We could potentially focus the editor here if we had a way
                },
                child: Text('${menu.label} (${visibleCount}/${allChildren.length} items)'),
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
              children: allChildren
                  .map((child) => _buildEntryWidget(child, depth + 1))
                  .toList(),
            ),
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
