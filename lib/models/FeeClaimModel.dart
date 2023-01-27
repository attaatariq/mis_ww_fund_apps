class FeeClaimModel{
  String claim_id, for_whom, child_id, child_name, claim_started, claim_ended, claim_amount, other_charges,
      tuition_fee, claim_payment, claim_stage, created_at;

  FeeClaimModel(
      this.claim_id,
      this.for_whom,
      this.child_id,
      this.child_name,
      this.claim_started,
      this.claim_ended,
      this.claim_amount,
      this.other_charges,
      this.tuition_fee,
      this.claim_payment,
      this.claim_stage,
      this.created_at);
}