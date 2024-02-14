class Strings{
  Strings._ctor();
  static final Strings instance = Strings._ctor();

  factory Strings()
  {
    return instance;
  }

  init() async
  {}

  final String logout= "Logout";
  final String logoutMessage= "Do you want to logout?";
  final String expireSessionTitle= "Session Expired";
  final String expireSessionMessage= "Your session has been expired, Login again";
  final String companyCategoryMessage= "Select Category";
  final String fullnameMessage= "Name shouldn't be empty";
  final String emailMessage= "Email shouldn't be empty";
  final String invalidEmailMessage= "Invalid Email Address";
  final String numberMessage= "Contact Number shouldn't be empty";
  final String invalidNumberMessage= "Invalid contact number";
  final String cnicMessage= "CNIC shouldn't be empty";
  final String invalidCNICMessage= "Invalid CNIC";
  final String passwordMessage= "Password shouldn't be empty";
  final String confirmPasswordMessage= "Confirm password shouldn't be empty";
  final String passwordMatchMessage= "Password doesn't match";
  final String selectLocation= "Select Location";
  final String internetNotConnected= "Internet not connected";
  final String noServerResponse= "No response from server";
  final String badRequestError= "Bad Request Error";
  final String pageNotFound= "Page Not Found";
  final String internalServerError= "Internal Server Error";
  final String somethingWentWrong= "Something went wrong, Please try again";
  final String pleaseWait= "Please Wait...";
  final String invalidEmailVerificationCode= "Invalid email verification code";
  final String invalidNumberVerificationCode= "Invalid number verification code";
  final String missingEmailVerificationCode= "Missing email verification code";
  final String missingNumberVerificationCode= "Missing number verification code";
  final String failedVerificationCode= "Failed to send verification code, Try Again";
  final String loginSuccess= "Successfully login";
  final String loginFailed= "Login failed, Try Again";

  final String cNameMessage= "Company name shouldn't be empty";
  final String cLandlineMessage= "Company Landline shouldn't be empty";
  final String cEstablishDateMessage= "Select establish date";
  final String cCodeMessage= "Code shouldn't be empty";
  final String cFileMessage= "File number shouldn't be empty";
  final String cIndustryMessage= "Industry shouldn't be empty";
  final String cFocusMessage= "Focus shouldn't be empty";
  final String cNumberMessage= "Company number shouldn't be empty";
  final String cTypeMessage= "Select company type";
  final String cFaxNoMessage= "Fax number shouldn't be empty";
  final String cWebsiteMessage= "Please provide your website URL";
  final String cCityMessage= "Select city";
  final String cProvinceMessage= "Select province";
  final String cAddressMessage= "Address shouldn't be empty";
  final String cLogoMessage= "Select company logo";
  final String cClosingMonthMessage= "Select closing month";
  final String companyInformationSavedSuccessfully= "Company information saved successfully";

  final String cppersonNameMessage= "Person name shouldn't be empty";
  final String cpdesignationMessage= "Designation Shouldn't be empty";
  final String cpaboutMessage= "About Shouldn't be empty";

  final String companyAddFailed= "Failed to add company, Try Again";
  final String deoAddFailed= "Failed to add Deo, Try Again";
  final String deoAddMessage= "Successfully add Deo";

  ////fields strings
  final String selectYear= "Select Year";
  final String selectCompany= "Select Company";
  final String selectStatement= "Select Statement";
  final String selectReceivedDate= "Select Received Date";
  final String selectFinancialYear= "Select Financial Year";
  final String selectClosingMonth="Select Closing Month";
  final String selectModeOfPayment="Mode of Payment";
  final String selectBankName="Bank Name";
  final String selectPaymentDate= "Select Payment Date";
  final String netProfitNotEmpty= "Net profit shouldn't be empty";
  final String wppfNotEmpty= "WPPF amount shouldn't be empty";

  final String category1WorkerNotEmpty= "Category 1 Worker shouldn't be empty";
  final String category2WorkerNotEmpty= "Category 2 Worker shouldn't be empty";
  final String category3WorkerNotEmpty= "Category 3 Worker shouldn't be empty";
  final String category1AmountNotEmpty= "Category 1 amount shouldn't be empty";
  final String category2AmountNotEmpty= "Category 2 amount shouldn't be empty";
  final String category3AmountNotEmpty= "Category 3 amount shouldn't be empty";
  final String category1AmountDistributedNotEmpty= "Category 1 amount distributed shouldn't be empty";
  final String category2AmountDistributedNotEmpty= "Category 2 amount distributed shouldn't be empty";
  final String category3AmountDistributedNotEmpty= "Category 3 amount distributed shouldn't be empty";

  final String amountPaidCompanyNotEmpty= "Amount paid by company shouldn't be empty";
  final String amountEarnedPaidBOTNotEmpty= "Amount earned/paid by BOT shouldn't be empty";
  final String totaInterstNotEmpty= "Total interest shouldn't be empty";
  final String investedByCONotEmpty= "Invested by CO shouldn't be empty";
  final String totalEmployeesNotEmpty= "Total Employees shouldn't be empty";
    final String welfareFundNotEmpty= "Welfare Fund shouldn't be empty";
  final String investedByBOTNotEmpty= "Invested by BOT shouldn't be empty";
  final String numberOfWorkersNotEmpty= "Number of workers shouldn't be empty";
  final String amountDistributedNotEmpty= "Amount distributed shouldn't be empty";
  final String amountContributedNotEmpty= "Amount contributed shouldn't be empty";
  final String chalanNumberNotEmpty= "Challan Number shouldn't be empty";
  final String totalPaymentNotEmpty= "Total payment shouldn't be empty";
  final String uploadChallan= "Select challan image";
  final String annexAAdded= "AnnexA added successfully";
  final String annexAFiled= "Failed to add annexA, Try again";
  final String wwf2PerAmount= "WWF 2% amount shouldn't be empty";
  final String totalEmployee= "Total number of employee shouldn't be empty";
  final String amountDistributed1NotEmpty= "Amount distributed category 1 shouldn't be empty";
  final String amountDistributed2NotEmpty= "Amount distributed category 2 shouldn't be empty";
  final String amountDistributed3NotEmpty= "Amount distributed category 3 shouldn't be empty";

  final String companiesNotAvail= "Companies Not Available";
  final String selectDOB= "Select Date of Birth";
  final String selectedCnicIssueDate= "CNIC Issue Date";
  final String selectedCnicExpiryDate= "CNIC Expiry Date";
  final String selectedAppointmentDate= "Appointment Date";
  final String selectDisability= "Select Disability";
  final String selectCity= "Select city";
  final String selectProvince= "Select Province";
  final String fatherNameMessage= "Father name shouldn't be empty";
  final String payScaleMessage= "Pay Scale shouldn't be empty";
  final String eobiNumberMessage= "EOBI Number shouldn't be empty";
  final String ssnNumberMessage= "SSN Number shouldn't be empty";
  final String addressMessage= "Address shouldn't be empty";
  final String disabilityDetail= "Please provide disability detail";
  final String accountTitleMessage= "Account title shouldn't be empty";
  final String accountNumberMessage= "Account number shouldn't be empty";

  final String uploadCnic= "Upload CNIC*";
  final String uploadSSnFile= "SSN File Upload*";
  final String uploadEobiFile= "EOBI File Upload*";
  final String uploadAppointmentLetter= "Upload Appointment Letter*";
  final String uploadAffidavit= "Upload Affidavit Upload*";
  final String uploadRegistrationCertificate= "Reg. Certificate Upload*";
  final String uploadIRA2012= "IRA 2012 Upload*";
  final String uploadFactoryCard= "Upload Factory Card*";
  final String failedToGetInfo= "Failed To Get Information";
  final String selectDistrict= "Select District";
  final String employeeAddFailed= "Failed to add employee";
  final String selectedIdentity= "Select Identity Type";
  final String selectedAccount= "Select Account Type";
  final String nameNotEmpty= "Name shouldn't be empty";
  final String selectImage = "Select Image";
  final String selectCnic = "Select CNIC";
  final String selectEducationType = "Select Education Type";
  final String selectLevel = "Select Level";
  final String selectedStartedDate= "Started Date";
  final String selectedEndedDate= "Ended Date";
  final String dateNotSame= "Date Should Not Same";
  final String selectedLiving= "Select Living";
  final String beneficiaryRelation= "Beneficiary Relation";

  final String childAddFailed= "Failed to add child, Try Again";
  final String childAddMessage= "Successfully add child";
  final String selfEducationMessage= "Successfully add your education";
  final String failedSelfEducation= "Failed to add your education, Try Again";

  final String degreeMessage= "Degree shouldn't be empty";
  final String classMessage= "Class shouldn't be empty";
  final String resultCardMessage= "Select Result Card";
  final String selectStudentCard= "Select Student Card";
  final String placeNameReq= "Place Name is Required";
  final String placeAddressReq= "Address is Required";
  final String placeContactReq= "Contact Number is Required";
  final String messDetailReq= "Mess Detail is Required";
  final String transportDetailReq= "Transport Detail is Required";
  final String selectAffiliate= "Select Affiliate";
  final String selectedSchool= "Select School";
  final String schoolNotAvail= "School Not Available";
  final String selectedBeneficiaryRelation= "Select Beneficiary Relation";
  final String selectBeneficiaryName= "Beneficiary name shouldn't be empty";
  final String bNumber= "Beneficiary number shouldn't be empty";
  final String bGuardianName= "Guardian name shouldn't be empty";
  final String bContactNumber= "Contact number shouldn't be empty";
  final String bCnicNumber= "CNIC number shouldn't be empty";
  final String bAddress= "Address shouldn't be empty";
  final String bAccountTitle= "Account title shouldn't be empty";
  final String bAccountNumber= "Account Number shouldn't be empty";
  final String bSelectCnic= "Select CNIC/B-Form";
  final String bSelectAccount= "Select Account Type";

  final String selectedChild= "Select Child";
  final String childNotAvail= "Child Not Available";
  final String addChildFirst= "Child Not Available, Please add your child first, Try again";

  final String beneficiaryMessage= "Successfully add your beneficiary";
  final String failedbeneficiary= "Failed to add your beneficiary, Try Again";

  final String selectedDeathDate= "Death Date";

  final String dcSelectedEobiPension= "Select EOBI Pension";
  final String dcAffaiadavitNoClaim= "Select Affidavit Not Claimed";
  final String dcAffaidavitNoMarriage= "Select Affidavit No Marriage";
  final String dcSelectCompansationAward= "Select Compensation Award";
  final String dcSelectDeathCertificate= "Select Death Certificate";
  final String dcSelectPensionBook= "Select Pension Book";
  final String dcSelectCondonsation= "Select Condonation";
  final String dcSelectCnic= "Select CNIC/Form-B";

  final String deathClaimRequestMessage= "Your death claim request has been sent successfully";
  final String faileddeathClaim= "Failed to send death calim request, Try Again";

  final String marriageClaimRequestMessage= "Your marriage claim request has been sent successfully";
  final String failedMarriageClaim= "Failed to send marriage calim request, Try Again";

  final String selectedCategory= "Select Category";
  final String selectedMarriageDate= "Selected Marriage Date";
  final String husbandNameMessage= "Husband name shouldn't be empty";
  final String selectServiceCertificate= "Select service certificate";
  final String nikahNamaMessage= "Select Nikah Nama";
  final String accumulativeServiceMessage= "Select Accumulative Service";

  final String resetPasswordFailed= "Failed to reset password, Try again";
  final String resetPasswordSuccess= "Successfully reset your password";

  final String failedFeedback= "Failed to send feedback, Try again";
  final String successFeedback= "Successfully send your feedback, Thank you";

  final String failedComplaint= "Failed to send your message, Try again";
  final String successComplaint= "Successfully send your message, Thank you";

  final String turnOverSaveFail= "Failed to save turnover, Try again";
  final String turnOverSaveSuccess= "Successfully save turnover, Thank you";

  final String awaitResponse= "Awaiting for a response.";
  final String selectedComplaintType= "Select Subject";

  final String turnOverType= "Select Turn-over Type";
  final String selectProfile= "Select profile image";

  final String oldPassReq= "Old password shouldn't be empty";
  final String newPassReq= "New password shouldn't be empty";
  final String confirmPassReq= "Confirm password shouldn't be empty";
  final String confirmPassNotMatch= "Confirm password doesn't match";
  final String oldPasswordMatch= "Old Password and New Password should be different";

  final String depositedDate= "Select Deposited Date";
  final String challanNoReq= "Challan number shouldn't be empty";

  final String failedAddIns= "Failed to add installment, Try again";
  final String successAddIns= "Successfully add your installment, Thank you";

  final String remarksReq= "Remarks shouldn't be empty";

  final String selectedclaim= "Select Claim Type";
  final String transportVoucher= "Transport Voucher";
  final String hostelVoucher= "Hostel Voucher";
  final String residenceVoucher= "Residence Voucher";
  final String applicationFormDoc= "Application Form";
  final String resultCardDoc= "Result Card";
  final String feeVoucher= "Fee Voucher";
  final String please_add_education_first= "Please add your education first";
  final String please_add_child_education_first= "Please add your child education first";

  final String selectStartDate= "Select Start Date";
  final String selectEndDate= "Select End Date";
  final String selectTutionFee= "Select Tuition Fee";
  final String selectRegFee= "Select Registration Fee";
  final String selectProsFee= "Select Prospectus Fee";
  final String selectSecurityFee= "Select Security Fee";
  final String selectLibraryFee= "Select Library Fee";
  final String selectExamFee= "Select Examination Fee";
  final String selectComptFee= "Select Computer Fee";
  final String selectSpotsFee= "Select Spots Fee";
  final String selectWashCharges= "Select Washing Charges";
  final String selectDevelopCharges= "Select Development Charges";
  final String selectFeeArrears= "Select Arrears Fee";
  final String selectAdjCharges= "Select Adjustment Charges";
  final String selectReimbursment= "Select Reimbursment";
  final String selectTaxFee= "Select Tax Fee";
  final String selectLateFeeFine= "Select Late Fee Fine";
  final String selectOtherFine= "Select Other Fine";
  final String selectOtherCharges= "Select Other Charges";
  final String selectOtherFineRemarks= "Select Other Fine Remarks";
  final String selectOtherChargesRemarks= "Select Other Charges Remarks";
  final String selectTransPortCost= "Select Transport Cost";
  final String selectHostelRent= "Select Hostel Rent";
  final String selectMessCharges= "Select Mess Charges";
  final String selectChild= "Select Child First";

  final String uniformVoucherDoc= "Uniform Voucher";
  final String booksVoucherDoc= "Books Voucher";
  final String stationaryVoucherDoc= "Stationary Voucher";
  final String selectAccountTitle= "Select Account Title";
  final String selectAccountNumber= "Select Account Number";
  final String educationListNotAvail= "Education Not Available";
  final String childrenListNotAvail= "Children Not Available";
  final String notAvail= "Not Available";
  final String contactPerson= "Contact Person";
}