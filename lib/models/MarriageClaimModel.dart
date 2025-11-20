class MarriageClaimModel{
  String claim_id, claim_husband, claim_dated, beneficiary, claim_stage;
  String user_name, user_image, user_cnic; // Optional fields from API

  MarriageClaimModel(this.claim_id, this.claim_husband, this.claim_dated,
      this.beneficiary, this.claim_stage, {this.user_name, this.user_image, this.user_cnic});
  
  // Getter for backward compatibility (maps beneficiary to claim_category)
  String get claim_category => beneficiary;
}