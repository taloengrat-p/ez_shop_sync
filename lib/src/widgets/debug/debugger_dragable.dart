import 'package:ez_shop_sync/src/widgets/debug/hive_viewer_debug.dart';
import 'package:flutter/material.dart';

class DebuggerDragable extends StatelessWidget {
  const DebuggerDragable({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: PopupMenuButton<String>(
        itemBuilder: (context) {
          return [
            PopupMenuItem<String>(
              child: const Text(
                'Hive Viewer',
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HiveViewerDebug()));
              },
            ),
          ];
        },
        child: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.bug_report,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
