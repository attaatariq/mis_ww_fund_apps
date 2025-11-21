class ProofStageModel {
  String heading;
  String message;
  String percent;
  String status; // pending, identified, unidentified, etc.

  ProofStageModel({
    this.heading = "",
    this.message = "",
    this.percent = "0%",
    this.status = "",
  });

  static ProofStageModel fromJson(Map<String, dynamic> json, String statusKey) {
    return ProofStageModel(
      heading: json["heading"]?.toString() ?? "",
      message: json["message"]?.toString() ?? "",
      percent: json["percent"]?.toString() ?? "0%",
      status: statusKey,
    );
  }

  int getPercentValue() {
    try {
      String percentStr = percent.replaceAll("%", "").trim();
      return int.parse(percentStr);
    } catch (e) {
      return 0;
    }
  }
}

