class EducationalClaimModel {
  // Claim Basic Info
  String claim_id;
  String beneficiary; // "Child" or "Self"
  String support_type; // "Academic", "Combined"
  String start_date; // "January-2024" or "2024-01-01"
  String end_date; // "February-2024" or "2024-02-29"
  String claim_stage;
  String claim_gateway; // "Direct Payment"
  String reference_number;
  String bank_status;
  String created_at; // "17-May-2024"
  
  // Financial Summary
  String claim_amount;
  String claim_payment;
  String claim_excluded;
  
  // User Information
  String user_id;
  String user_name;
  String user_cnic;
  String user_email;
  String user_contact;
  String user_gender;
  String user_image;
  String user_scale;
  String user_about;
  
  // Company Information
  String comp_id;
  String comp_name;
  String role_name;
  String sector_name;
  
  // Employee Information
  String emp_id;
  String emp_father;
  String emp_about;
  String emp_address;
  String emp_bank;
  String emp_title;
  String emp_account;
  
  // Location Information
  String city_name;
  String district_name;
  String state_name;
  
  // Child Information (when beneficiary = "Child")
  String child_name;
  String child_cnic;
  String child_gender;
  String child_image;
  
  // School Information
  String school_name;
  String school_panel;
  String school_email;
  String school_contact;
  String school_fax_no;
  String school_type;
  String school_bank;
  String school_title;
  String school_nature;
  String school_account;
  String school_code;
  
  // Education Information
  String edu_nature;
  String edu_level;
  String edu_degree;
  String edu_class;
  String edu_started;
  String edu_ended;
  String edu_living;
  String edu_mess;
  String edu_transport;
  
  // Payment Information
  String term_frequency;
  String debit_account;
  String recipient_bank;
  String credit_account;
  String credit_amount;
  String bank_number;
  String transferred_at;
  
  // Benefit Inclusion Flags (JSON string: {"1":1,"2":0,"3":1,"4":0,"5":1})
  String claim_benefit;
  
  // Benefit 1: Academic Fee (tbl_benefit_1)
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
  String remarks_1; // Fine Remarks
  String other_charges;
  String remarks_2; // Charges Remarks
  String application_form;
  String result_card;
  String fee_structure;
  String fee_voucher;
  
  // Benefit 2: Uniform & Books (tbl_benefit_2)
  String uniform_charges;
  String supplies_charges;
  String uniform_voucher;
  String supplies_voucher;
  String essentials_remarks;
  
  // Benefit 3: Transport (tbl_benefit_3)
  String transport_type;
  String travel_distance;
  String transport_cost;
  String transport_voucher;
  
  // Benefit 4: Stipend (tbl_benefit_4)
  String stipend_amount;
  String stipend_category;
  String stipend_remarks;
  
  // Benefit 5: Hostel & Mess (tbl_benefit_5)
  String hostel_rent;
  String mess_charges;
  String hostel_voucher;
  String hostel_remarks;
  
  EducationalClaimModel({
    this.claim_id = "",
    this.beneficiary = "",
    this.support_type = "",
    this.start_date = "",
    this.end_date = "",
    this.claim_stage = "",
    this.claim_gateway = "",
    this.reference_number = "",
    this.bank_status = "",
    this.created_at = "",
    this.claim_amount = "",
    this.claim_payment = "",
    this.claim_excluded = "",
    this.user_id = "",
    this.user_name = "",
    this.user_cnic = "",
    this.user_email = "",
    this.user_contact = "",
    this.user_gender = "",
    this.user_image = "",
    this.user_scale = "",
    this.user_about = "",
    this.comp_id = "",
    this.comp_name = "",
    this.role_name = "",
    this.sector_name = "",
    this.emp_id = "",
    this.emp_father = "",
    this.emp_about = "",
    this.emp_address = "",
    this.emp_bank = "",
    this.emp_title = "",
    this.emp_account = "",
    this.city_name = "",
    this.district_name = "",
    this.state_name = "",
    this.child_name = "",
    this.child_cnic = "",
    this.child_gender = "",
    this.child_image = "",
    this.school_name = "",
    this.school_panel = "",
    this.school_email = "",
    this.school_contact = "",
    this.school_fax_no = "",
    this.school_type = "",
    this.school_bank = "",
    this.school_title = "",
    this.school_nature = "",
    this.school_account = "",
    this.school_code = "",
    this.edu_nature = "",
    this.edu_level = "",
    this.edu_degree = "",
    this.edu_class = "",
    this.edu_started = "",
    this.edu_ended = "",
    this.edu_living = "",
    this.edu_mess = "",
    this.edu_transport = "",
    this.term_frequency = "",
    this.debit_account = "",
    this.recipient_bank = "",
    this.credit_account = "",
    this.credit_amount = "",
    this.bank_number = "",
    this.transferred_at = "",
    this.claim_benefit = "",
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
    this.remarks_1 = "",
    this.other_charges = "",
    this.remarks_2 = "",
    this.application_form = "",
    this.result_card = "",
    this.fee_structure = "",
    this.fee_voucher = "",
    this.uniform_charges = "",
    this.supplies_charges = "",
    this.uniform_voucher = "",
    this.supplies_voucher = "",
    this.essentials_remarks = "",
    this.transport_type = "",
    this.travel_distance = "",
    this.transport_cost = "",
    this.transport_voucher = "",
    this.stipend_amount = "",
    this.stipend_category = "",
    this.stipend_remarks = "",
    this.hostel_rent = "",
    this.mess_charges = "",
    this.hostel_voucher = "",
    this.hostel_remarks = "",
  });
  
  // Helper method to check if a benefit is included
  bool isBenefitIncluded(int benefitNumber) {
    if (claim_benefit.isEmpty || claim_benefit == "null") return false;
    
    try {
      // Parse the JSON-like string {"1":1,"2":0,"3":1,"4":0,"5":1}
      // Simple parsing without importing dart:convert
      String cleaned = claim_benefit
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll('"', '');
      
      List<String> pairs = cleaned.split(',');
      Map<String, int> decoded = {};
      
      for (String pair in pairs) {
        List<String> parts = pair.split(':');
        if (parts.length == 2) {
          String key = parts[0].trim();
          int value = int.tryParse(parts[1].trim()) ?? 0;
          decoded[key] = value;
        }
      }
      
      return (decoded[benefitNumber.toString()] ?? 0) == 1;
    } catch (e) {
      return false;
    }
  }
}
