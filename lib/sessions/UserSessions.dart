import 'package:shared_preferences/shared_preferences.dart';

class UserSessions{
  UserSessions._ctor();
  static final UserSessions instance = UserSessions._ctor();
  String UserID= "UserID";
  String Name= "Name";
  String ProfileImage= "ProfileImage";
  String UserCNIC= "UserCNIC";
  String UserEmail= "UserEmail";
  String UserNumber= "UserNumber";
  String UserAbout= "UserAbout";
  String UserAccount= "UserAccount";
  String UserSector= "UserSector";
  String UserRole= "UserRole";
  String Token= "Token";
  String UserType= "UserType";
  String RefID= "RefID";
  String AgentExpiry= "AgentExpiry";

  //employee info
  String EmployeeID= "EmployeeID";

  //D.E.O Info
  String DeoID= "DeoID";

  //Feedback Dialog
  String FeedbackDialogShown= "FeedbackDialogShown";

  SharedPreferences prefs;

  factory UserSessions()
  {
    return instance;
  }

  init() async
  {
    prefs= await SharedPreferences.getInstance();
  }

  Future setEmployeeID(String data)
  {
    return prefs.setString(EmployeeID, data);
  }

  get getEmployeeID
  {
    return prefs.getString(EmployeeID) ?? '';
  }

  Future setDeoID(bool data)
  {
    return prefs.setBool(DeoID, data);
  }

  get getDeoID
  {
    return prefs.getBool(DeoID) ?? false;
  }


  Future setAgentExpiry(String data)
  {
    return prefs.setString(AgentExpiry, data);
  }

  get getAgentExpiry
  {
    return prefs.getString(AgentExpiry) ?? '';
  }

  Future setRefID(String data)
  {
    return prefs.setString(RefID, data);
  }

  get getRefID
  {
    return prefs.getString(RefID) ?? '';
  }

  Future setUserRole(String data)
  {
    return prefs.setString(UserRole, data);
  }

  get getUserRole
  {
    return prefs.getString(UserRole) ?? '';
  }

  Future setUserSector(String data)
  {
    return prefs.setString(UserSector, data);
  }

  get getUserSector
  {
    return prefs.getString(UserSector) ?? '';
  }

  Future setUserAccount(String data)
  {
    return prefs.setString(UserAccount, data);
  }

  get getUserAccount
  {
    return prefs.getString(UserAccount) ?? '';
  }

  Future setUserAbout(String data)
  {
    return prefs.setString(UserAbout, data);
  }

  get getUserAbout
  {
    return prefs.getString(UserAbout) ?? '';
  }

  Future setUserNumber(String data)
  {
    return prefs.setString(UserNumber, data);
  }

  get getUserNumber
  {
    return prefs.getString(UserNumber) ?? '';
  }

  Future setUserEmail(String data)
  {
    return prefs.setString(UserEmail, data);
  }

  get getUserEmail
  {
    return prefs.getString(UserEmail) ?? '';
  }

  Future setUserCNIC(String data)
  {
    return prefs.setString(UserCNIC, data);
  }

  get getUserCNIC
  {
    return prefs.getString(UserCNIC) ?? '';
  }

  Future setUserID(String data)
  {
    return prefs.setString(UserID, data);
  }

  get getUserID
  {
    return prefs.getString(UserID) ?? '';
  }

  Future setUserName(String data)
  {
    return prefs.setString(Name, data);
  }

  get getUserName
  {
    return prefs.getString(Name) ?? '';
  }

  Future setUserImage(String data)
  {
    return prefs.setString(ProfileImage, data);
  }

  get getUserImage
  {
    return prefs.getString(ProfileImage);
  }

  Future setToken(String data)
  {
    prefs.setString(Token, data);
  }

  get getToken
  {
    return prefs.getString(Token);
  }

  Future setUserType(String data)
  {
    prefs.setString(UserType, data);
  }

  get getUserType
  {
    return prefs.getString(UserType);
  }

  Future setFeedbackDialogShown(bool data)
  {
    return prefs.setBool(FeedbackDialogShown, data);
  }

  get getFeedbackDialogShown
  {
    return prefs.getBool(FeedbackDialogShown) ?? false;
  }
}