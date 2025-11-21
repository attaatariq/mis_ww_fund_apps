class ComplaintModel {
  String id;
  String type;
  String subject;
  String message;
  String complaintResponse;
  String respondBy;
  String responderName;
  String responderGender;
  String responderImage;
  String responderSectorName;
  String responderRoleName;
  String respondedAt;
  String createdAt;

  ComplaintModel({
    this.id = "",
    this.type = "",
    this.subject = "",
    this.message = "",
    this.complaintResponse = "",
    this.respondBy = "",
    this.responderName = "",
    this.responderGender = "",
    this.responderImage = "",
    this.responderSectorName = "",
    this.responderRoleName = "",
    this.respondedAt = "",
    this.createdAt = "",
  });

  bool get hasResponse {
    return complaintResponse != null &&
           complaintResponse.isNotEmpty &&
           complaintResponse != "null" &&
           complaintResponse != "-";
  }
}