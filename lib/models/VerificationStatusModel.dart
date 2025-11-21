class VerificationStatusModel {
  String user_name;
  String emp_check;
  String emp_remarks_1;
  String emp_remarks_2;
  String emp_remarks_3;
  String emp_remarks_4;
  String checked_at_1;
  String checked_at_2;
  String checked_at_3;
  String checked_at_4;
  String emp_medium;
  String created_at;

  VerificationStatusModel({
    this.user_name = "",
    this.emp_check = "",
    this.emp_remarks_1 = "",
    this.emp_remarks_2 = "",
    this.emp_remarks_3 = "",
    this.emp_remarks_4 = "",
    this.checked_at_1 = "",
    this.checked_at_2 = "",
    this.checked_at_3 = "",
    this.checked_at_4 = "",
    this.emp_medium = "",
    this.created_at = "",
  });

  static VerificationStatusModel fromJson(Map<String, dynamic> json) {
    return VerificationStatusModel(
      user_name: json["user_name"]?.toString() ?? "",
      emp_check: json["emp_check"]?.toString() ?? "",
      emp_remarks_1: json["emp_remarks_1"]?.toString() ?? "",
      emp_remarks_2: json["emp_remarks_2"]?.toString() ?? "",
      emp_remarks_3: json["emp_remarks_3"]?.toString() ?? "",
      emp_remarks_4: json["emp_remarks_4"]?.toString() ?? "",
      checked_at_1: json["checked_at_1"]?.toString() ?? "",
      checked_at_2: json["checked_at_2"]?.toString() ?? "",
      checked_at_3: json["checked_at_3"]?.toString() ?? "",
      checked_at_4: json["checked_at_4"]?.toString() ?? "",
      emp_medium: json["emp_medium"]?.toString() ?? "",
      created_at: json["created_at"]?.toString() ?? "",
    );
  }

  bool get isScrutinized {
    return emp_check == "Scrutinized";
  }

  bool get isUnsuccessful {
    return emp_check == "Unidentified" ||
           emp_check == "Unassessed" ||
           emp_check == "Unverified" ||
           emp_check == "Unscrutinized";
  }
}

