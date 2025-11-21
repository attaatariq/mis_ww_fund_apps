class NotificationModel {
  String not_id;
  String user_id;
  String not_subject;
  String not_message;
  String not_recipient;
  String not_read;
  String created_at;

  NotificationModel({
    this.not_id = "",
    this.user_id = "",
    this.not_subject = "",
    this.not_message = "",
    this.not_recipient = "",
    this.not_read = "0",
    this.created_at = "",
  });

  bool get isRead {
    return not_read == "1" || not_read == "true";
  }
}