class EducationalClaimModel {
  // Claim Basic Info
  String claim_id;
  String beneficiary; // "Child" or "Self"
  String comp_id;
  String emp_id;
  String start_date; // "January-2024"
  String end_date; // "February-2024"
  String claim_stage;
  String created_at; // "17-May-2024"
  
  // Financial Summary
  String claim_amount;
  String claim_payment;
  String claim_excluded;
  
  // Fee Breakdown
  String tuition_fee;
  String registration_fee;
  String prospectus_fee;
  String security_fee;
  String library_fee;
  String examination_fee;
  String computer_fee;
  String sports_fee;
  String washing_fee;
  String development;
  String outstanding_fee;
  String adjustment;
  String reimbursement;
  String tax_amount;
  String late_fee_fine;
  String other_fine;
  String other_charges;
  
  // Transport & Hostel
  String transport_cost;
  String transport_voucher; // Can be null
  String hostel_rent;
  String mess_charges;
  String hostel_voucher; // Can be null
  
  // Documents (Can be null)
  String application_form;
  String result_card;
  String fee_structure;
  String fee_voucher;
  
  // Remarks
  String remarks_1;
  String remarks_2;
  
  // Child Information (Embedded)
  String child_id;
  String child_name;
  String child_cnic;
  String child_issued;
  String child_expiry;
  String child_gender;
  String child_birthday;
  String child_image;
  String child_identity; // "B-Form"
  String child_upload;
  String child_status; // "Active"
  String child_check; // "Pending"
  
  EducationalClaimModel({
    this.claim_id = "",
    this.beneficiary = "",
    this.comp_id = "",
    this.emp_id = "",
    this.start_date = "",
    this.end_date = "",
    this.claim_stage = "",
    this.created_at = "",
    this.claim_amount = "",
    this.claim_payment = "",
    this.claim_excluded = "",
    this.tuition_fee = "",
    this.registration_fee = "",
    this.prospectus_fee = "",
    this.security_fee = "",
    this.library_fee = "",
    this.examination_fee = "",
    this.computer_fee = "",
    this.sports_fee = "",
    this.washing_fee = "",
    this.development = "",
    this.outstanding_fee = "",
    this.adjustment = "",
    this.reimbursement = "",
    this.tax_amount = "",
    this.late_fee_fine = "",
    this.other_fine = "",
    this.other_charges = "",
    this.transport_cost = "",
    this.transport_voucher = "",
    this.hostel_rent = "",
    this.mess_charges = "",
    this.hostel_voucher = "",
    this.application_form = "",
    this.result_card = "",
    this.fee_structure = "",
    this.fee_voucher = "",
    this.remarks_1 = "",
    this.remarks_2 = "",
    this.child_id = "",
    this.child_name = "",
    this.child_cnic = "",
    this.child_issued = "",
    this.child_expiry = "",
    this.child_gender = "",
    this.child_birthday = "",
    this.child_image = "",
    this.child_identity = "",
    this.child_upload = "",
    this.child_status = "",
    this.child_check = "",
  });
}

