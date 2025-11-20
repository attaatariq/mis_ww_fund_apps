class EstateClaimModel{
  String claim_id, claim_scheme, scheme_name, claim_balloting, claim_quota, claim_dated, 
      claim_location, claim_abode, claim_number, claim_floor, claim_street, claim_block,
      claim_amount, claim_payment, claim_balance, claim_impound;
  String user_name, user_image, user_cnic, user_gender; // Optional fields from API
  String emp_id; // Employee ID

  EstateClaimModel(
      this.claim_id,
      this.claim_scheme,
      this.scheme_name,
      this.claim_balloting,
      this.claim_quota,
      this.claim_dated,
      this.claim_location,
      this.claim_abode,
      this.claim_number,
      this.claim_floor,
      this.claim_street,
      this.claim_block,
      this.claim_amount,
      this.claim_payment,
      this.claim_balance,
      this.claim_impound,
      {this.user_name, this.user_image, this.user_cnic, this.user_gender, this.emp_id});
}
