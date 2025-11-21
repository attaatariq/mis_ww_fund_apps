import 'package:wwf_apps/models/ProofStageModel.dart';

class ProofStagesData {
  static final ProofStagesData instance = ProofStagesData._internal();
  Map<String, ProofStageModel> stages = {};

  ProofStagesData._internal();

  void loadFromJson(Map<String, dynamic> json) {
    stages.clear();
    if (json != null) {
      json.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          stages[key] = ProofStageModel.fromJson(value, key);
        }
      });
    }
  }

  ProofStageModel getStageForStatus(String empCheck) {
    if (empCheck == null || empCheck.isEmpty) {
      return ProofStageModel(
        heading: "Status Unknown",
        message: "Verification status is not available.",
        percent: "0%",
        status: "unknown",
      );
    }

    String trimmedKey = empCheck.trim();

    // Direct match
    if (stages.containsKey(trimmedKey)) {
      return stages[trimmedKey];
    }

    // Try case-insensitive match
    String lowerKey = trimmedKey.toLowerCase();
    for (var key in stages.keys) {
      if (key.toLowerCase() == lowerKey) {
        return stages[key];
      }
    }

    // Return default if not found
    return ProofStageModel(
      heading: "Status: $trimmedKey",
      message: "Your verification status is: $trimmedKey",
      percent: "0%",
      status: trimmedKey,
    );
  }

  bool hasStages() {
    return stages.isNotEmpty;
  }

  // Helper method to load proof_stages from information API response
  static void loadFromInformationResponse(Map<String, dynamic> data) {
    if (data != null && data["proof_stages"] != null) {
      try {
        Map<String, dynamic> proofStagesJson = data["proof_stages"];
        if (proofStagesJson is Map<String, dynamic>) {
          instance.loadFromJson(proofStagesJson);
        }
      } catch (e) {
        // Silently fail if proof stages parsing fails
      }
    }
  }
}
