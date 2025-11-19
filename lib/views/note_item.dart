import 'package:flutter/material.dart';
import 'package:wwf_apps/models/Note.dart';

import '../colors/app_colors.dart';

class NoteItem extends StatelessWidget {
  Note note;

  NoteItem(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(note.para_no+". "+ note.remarks,
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: AppTheme.colors.colorExelentDark,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal
          ),
        ),
      ),
    );
  }
}
