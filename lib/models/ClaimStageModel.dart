class ClaimStageModel {
  String stage;
  String state;
  String title;
  String color;

  ClaimStageModel({
    this.stage,
    this.state,
    this.title,
    this.color,
  });

  factory ClaimStageModel.fromJson(Map<String, dynamic> json) {
    return ClaimStageModel(
      stage: json['stage'] != null ? json['stage'].toString() : "",
      state: json['state'] != null ? json['state'].toString() : "",
      title: json['title'] != null ? json['title'].toString() : "",
      color: json['color'] != null ? json['color'].toString() : "info",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage,
      'state': state,
      'title': title,
      'color': color,
    };
  }
}

class ClaimStagesData {
  static ClaimStagesData _instance;
  Map<String, ClaimStageModel> stages = {};

  ClaimStagesData._();

  static ClaimStagesData get instance {
    if (_instance == null) {
      _instance = ClaimStagesData._();
    }
    return _instance;
  }

  void loadFromJson(Map<String, dynamic> json) {
    stages.clear();
    if (json != null) {
      json.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          stages[key] = ClaimStageModel.fromJson(value);
        }
      });
    }
  }

  ClaimStageModel getStage(String stageKey) {
    // Handle null, empty, or invalid stage keys
    if (stageKey == null || stageKey.isEmpty || stageKey == "-" || stageKey == "null" || stageKey == "NULL") {
      return ClaimStageModel(
        stage: "Unknown",
        state: "Unknown",
        title: "Status information not available",
        color: "info",
      );
    }

    // Trim whitespace from stage key
    String trimmedKey = stageKey.trim();

    // Try exact match first
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

    // Try matching with trimmed keys (handle keys with extra spaces)
    for (var key in stages.keys) {
      if (key.trim().toLowerCase() == lowerKey) {
        return stages[key];
      }
    }

    // Return default if not found - this will show the raw stage key
    // This ensures "Stage-7" is displayed if not in claim_stages
    return ClaimStageModel(
      stage: trimmedKey,
      state: trimmedKey,
      title: "Status: $trimmedKey",
      color: "info",
    );
  }

  bool hasStages() {
    return stages.isNotEmpty;
  }

  // Helper method to load claim_stages from information API response
  static void loadFromInformationResponse(Map<String, dynamic> data) {
    if (data != null && data["claim_stages"] != null) {
      try {
        Map<String, dynamic> claimStagesJson = data["claim_stages"];
        if (claimStagesJson is Map<String, dynamic>) {
          instance.loadFromJson(claimStagesJson);
        }
      } catch (e) {
        // Silently fail if claim stages parsing fails
      }
    }
  }
}

