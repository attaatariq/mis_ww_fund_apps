import 'Note.dart';

class NoteModel{
  String user_name_to, role_name_to, sector_name_to, user_name_by, role_name_by, sector_name_by, created_at;
  List<Note> noteList;

  NoteModel(
      this.user_name_to,
      this.role_name_to,
      this.sector_name_to,
      this.user_name_by,
      this.role_name_by,
      this.sector_name_by,
      this.created_at,
      this.noteList);
}