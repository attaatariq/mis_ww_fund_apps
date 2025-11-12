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
    if (stageKey == null || stageKey.isEmpty || stageKey == "-") {
      return ClaimStageModel(
        stage: "Unknown",
        state: "Unknown",
        title: "Status information not available",
        color: "info",
      );
    }

    // Try exact match first
    if (stages.containsKey(stageKey)) {
      return stages[stageKey];
    }

    // Try case-insensitive match
    String lowerKey = stageKey.toLowerCase();
    for (var key in stages.keys) {
      if (key.toLowerCase() == lowerKey) {
        return stages[key];
      }
    }

    // Return default if not found
    return ClaimStageModel(
      stage: stageKey,
      state: stageKey,
      title: "Status: $stageKey",
      color: "info",
    );
  }

  bool hasStages() {
    return stages.isNotEmpty;
  }
}

