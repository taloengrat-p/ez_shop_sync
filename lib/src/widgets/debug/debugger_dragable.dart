import 'package:ez_shop_sync/src/widgets/debug/hive_viewer_debug.dart';
import 'package:flutter/material.dart';

class DebuggerDragable extends StatelessWidget {
  const DebuggerDragable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: PopupMenuButton<String>(
        itemBuilder: (context) {
          return [
            PopupMenuItem<String>(
              child: Text(
                'Hive Viewer',
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HiveViewerDebug()));
              },
            ),
          ];
        },
        child: CircleAvatar(
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
