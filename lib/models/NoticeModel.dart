class NoticeModel {
  String alert_id;
  String alert_heading;
  String alert_subject;
  String alert_message;
  String alert_recipient;
  String created_by;
  String created_at;
  String deleted_by;
  String deleted_at;

  NoticeModel({
    this.alert_id = "",
    this.alert_heading = "",
    this.alert_subject = "",
    this.alert_message = "",
    this.alert_recipient = "",
    this.created_by = "",
    this.created_at = "",
    this.deleted_by = "",
    this.deleted_at = "",
  });

  bool get isDeleted {
    return deleted_at != null &&
           deleted_at.isNotEmpty &&
           deleted_at != "null" &&
           deleted_at != "-";
  }
}

