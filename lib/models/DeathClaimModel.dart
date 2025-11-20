class DeathClaimModel{
  String claim_id, claim_dated, claim_amount, claim_payment, claim_stage, bene_name, bene_relation;
  String user_name, user_image, user_cnic; // Optional fields from API
  String bene_cnic, bene_contact; // Additional beneficiary fields

  DeathClaimModel(this.claim_id, this.claim_dated, this.claim_amount,
      this.claim_payment, this.claim_stage, this.bene_name, this.bene_relation,
      {this.user_name, this.user_image, this.user_cnic, this.bene_cnic, this.bene_contact});
}