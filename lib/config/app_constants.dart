import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();
  static const String appName = 'Gully Cricket';
  static const baseUrl = kReleaseMode
      ? "http://3.7.92.159:3000/api"
      // : "http://192.168.0.105:3000/api";//personL
      : "http://192.168.29.9:3000/api"; //Office
  // : "http://3.7.92.159:3000/api"; //server
  // : "http://172.20.10.5:3000/api";
  static const websocketUrl =
      kReleaseMode ? "ws://65.1.61.197:3001" : "ws://65.1.61.197:3001";
  // static const websocketUrl ="http://192.168.159.11:3001";
  static const String s3BucketUrl =
      "https://gully-team-bucket.s3.amazonaws.com/";

  static const String googleApiKey = "AIzaSyCUv3LmufUU86Lp_Wk34-3AZ3bnCQ3XmJg";

  static const String helloWorld = "¡Hola Mundo!";
  static const String signup = "Sign Up";
  static const String login = "Log In";
  static const String signupgoogle = "Sign Up with Google";
  static const String signupapple = "Sign Up with Apple";
  static const String by_continuing = "By continuing, you agree to the";
  static const String terms_of_service = "Terms of Service ";
  static const String and = "and";
  static const String privacy_policy = "Privacy Policy";
  static const String create_profile = "Create\nProfile";
  static const String name = "Name";
  static const String name_cannot_contain_special_characters =
      "Name cannot contain special characters";
  static const String name_cannot_contain_emojis = "Name cannot contain emojis";
  static const String name_cannot_contain_special_characters_numbers =
      "Name cannot contain special characters & numbers";
  static const String contact_no = "Contact No";
  static const String please_enter_valid_phone_number =
      "Please enter a valid phone number";
  static const String please_select_an_image = "Please select an image";
  static const String please_select_a_valid_image =
      "Please select a valid image";
  static const String please_enter_5_digit_code =
      "Enter 5 digit code sent to your mobile number";
  static const String resend = "Resend";
  static const String resend_code_in = "Resend code in";
  static const String verify = "Verify";
  static const String create_your_tournament = "Create Your Tournament";
  static const String create_tournament = "Create Tournament";
  static const String tournaments = "Tournaments";
  static const String past = "Past";
  static const String upcoming = "Upcoming";
  static const String current = "Current";
  static const String no_matches = "Oops! No matches on this day.";
  static const String looking = "Looking";
  static const String what_others_looking_for = "What are you looking for?";
  static const String leaderboard = "Leaderboard";
  static const String player_ranking = "Player Ranking";
  static const String top_performers = "Top Performers";
  static const String team_ranking = "Team Ranking";
  static const String challenge_team = "Challenge Team";
  static const String my_performance = "My Performance";
  static const String about_us = "About Us";
  static const String contact_us = "Contact Us";
  static const String share_app = "Share App";
  static const String faqs = "FAQs";
  static const String disclaimer = "Disclaimer";
  static const String logout = "Log Out";
  static const String tournamentName = "Tournament Name";
  static const String pleaseEnterTournamentName =
      "Please enter tournament name";
  static const String tournamentNameCannotContainEmojis =
      "Tournament name cannot contain emojis";
  static const String tournamentStartDateShouldBeLessThanEndDate =
      "Tournament start date should be less than end date";
  static const String pleaseSelectTournamentStartDate =
      "Please select tournament start date";
  static const String tournamentEndDateShouldBeGreaterThanStartDate =
      "Tournament end date should be greater than start date";
  static const String tournamentCategory = "Tournament Category";
  static const String selectTournamentCategory = "Select Tournament Category";
  static const String ballType = "Ball Type";
  static const String selectBallType = "Select Ball Type";
  static const String pitchType = "Pitch Type";
  static const String selectPitchType = "Select Pitch Type";
  static const String organizerName = "Organizer Name";
  static const String organizerContactNo = "Organizer Contact No";
  static const String cohost1Name = "Co-host 1 Name";
  static const String pleaseEnterCohost1ContactNo =
      "Please enter co-host 1 contact no";
  static const String rulesCannotContainEmojis = "Rules cannot contain emojis";
  static const String cohost1ContactNo = "Co-host 1 Contact No";
  static const String pleaseEnterValidCohost1ContactNo =
      "Please enter a valid co-host 1 contact no";
  static const String cohost1AndCohost2ContactNoCannotBeSame =
      "Co-host 1 and Co-host 2 contact no cannot be same";
  static const String pleaseEnterValidContactNo =
      "Please enter a valid contact no";
  static const String cohost2Name = "Co-host 2 Name";
  static const String cohost2ContactNo = "Co-host 2 Contact No";
  static const String entryFee = "Entry Fee";
  static const String pleaseEnterEntryFee = "Please enter entry fee";
  static const String pleaseEnterValidEntryFee =
      "Please enter a valid entry fee";
  static const String entryFeeCannotStartWith0 =
      "Entry fee cannot start with 0";
  static const String ballCharges = "Ball Charges";
  static const String pleaseEnterBallCharges = "Please enter ball charges";
  static const String pleaseEnterValidBallCharges =
      "Please enter a valid ball charges";
  static const String breakfastCharges = "Breakfast Charges";
  static const String pleaseEnterBreakfastCharges =
      "Please enter breakfast charges";
  static const String pleaseEnterValidBreakfastCharges =
      "Please enter valid breakfast charges";
  static const String teamLimit = "Team Limit";
  static const String pleaseEnterTeamLimit = "Please enter team limit";
  static const String pleaseEnterValidTeamLimit =
      "Please enter a valid team limit";
  static const String teamLimitShouldBeEqualOrGreaterThan2 =
      "Team limit should be equal or greater than 2";
  static const String rules = "Rules";
  static const String prizes = "Prizes";
  static const String pleaseEnterRules = "Please enter rules";
  static const String selectStadiumAddress = "Select Stadium Address";
  static const String iHerebyAgreeToThe = "I hereby agree to the ";
  static const String termsAndConditions = "Terms and Conditions";
  static const String addPlayer = "Add Player";
  static const String players = "Players";
  static const String deletePlayer = "Delete Player";
  static const String no = "No";
  static const String yes = "Yes";
  static const String deletePlayerConfirmation =
      "Are you sure you want to delete this Player";
  static const String addViaPhoneNumber = "Add via phone number";
  static const String addFromContacts = "Add from contacts";
  static const String selectContactWithName =
      "Please select a contact with a name";
  static const String selectContactWithPhoneNumber =
      "Please select a contact with a phone number";
  static const String addFromContact = "Add from Contact";
  static const String contactNumber = "Contact Number";
  static const String fillAllFields = "Please fill all the fields";
  static const String validName = "Please enter a valid name";
  static const String validPhoneNumber = "Please enter a valid phone number";
  static const String teamCreatedSuccessfully =
      "Congratulations!\nYour team has been successfully created.";
  static const String addPlayersButton = "Add Players";
  static const String doneButton = "Done";
  static const String addTeamHeaderText = "ADD\nTEAM";
  static const String teamNameHintText = "Eg: Mumbai Sixers";
  static const String teamNameLabelText = "Team Name";
  static const String saveButton = "Save";
  static const String pleaseEnterTeamName = "Please enter a team name";
  static const String teamNameValidationMessage =
      "Team name should be at least 3 characters long";
  static const String teamNameValidationPattern =
      "Team name should contain only alphabets and numbers, and allow spaces between words without consecutive spaces";
  static const String selectValidImage = "Please select a valid image";
  static const String saveButtonError = "Please enter a team name";
  static const String teamNameFormatError = "Please enter a valid Team Name";
  static const String teamNameLengthError =
      "Team name should be at least 3 characters long";
  static const String challengeTeamTitle = "Challenge Team";
  static const String challengeTeamMessage =
      "Please pay Rs.200/- to challenge a team";
  static const String payNow = "Pay Now";
  static const String chooseLanguageTitle = "Choose Language";
  static const String continueButtonText = "Continue";
  static const String contactUsTitle = "Contact Us";
  static const String nameLabel = "Name";
  static const String emailLabel = "Email";
  static const String messageLabel = "Message";
  static const String emptyMessageError = "Please enter message";
  static const String shortMessageError =
      "Message should be at least 20 characters long";
  static const String pleaseEnterYourEmail = "Please enter your email";
  static const String enterValildEmailAddress = "Enter a valid email address";
  static const String thankYouMessage = "Thank you for contacting us.";
  static const String replySoonMessage =
      "Your request has been sent successfully. Please wait for the revert. We will get back to you in 2-3 working days.";
  static const String submitButton = "Submit";
  static const String okButton = "OK";
  static const String emailInfo = "info@nileegames.com";

  static const String addressInfo =
      "508, 5th floor, Fly Edge building, S.V. Road, Borivali East";
  static const String phoneInfo = "+91 9855453210, 555-899-80085";
  static const String currentTournamentTitle = "Current Tournament";
  static const String enterRoundNumberLabel = "Enter Round Number";
  static const String leaderboardTitle = "Leaderboard";
  static const String playerRankingTitle = "Player Ranking";
  static const String teamRankingTitle = "Team Ranking";
  static const String topPerformerTitle = "Top Performer";
  static const String deleteAccountConfirmation =
      "If you want to delete your account, please click the button below. Your account will be deleted permanently and you will not be able to recover it.";
  static const String request_sent_successfully = "Request sent successfully";
  static const String selectLocation = "Select Location";
  static const String changeLanguage = "Change Language";
  static const String search_tournament = "Search Tournament...";
  static const String addTeam = "Add Team";
  static const String viewMyTeam = "View My Team";
  static const String viewOpponent = "View Opponent";
  static const String request = "Request";
  static const String currentMatches = "Current Matches";
  static const String manageTournamentAuthority = "Manage Tournament Authority";
  static const String organize = "Organize";
  static const String viewMatchup = "View Matchup";
  static const String scoreboard = "Scoreboard";
  static const String editTournamentForm = "Edit Tournament Form";
  static const String promoteYourBanner = "Promote Your Banner";
  static const String transactionHistory = "Transaction History";
  static const String viewYourTournament = "View Your Tournament";
  static const String bannerlocInfo = "Banner Location Information";
  static const String shoplocInfo = "Shop Location Information";
  static const String bannerwarningtext =
      'To ensure your banner displays properly, make sure it meets the recommended size.\n\n'
      '✅ Optimal size: 1260px (width) x 459px (height)\n\n'
      'If the dimensions are incorrect, your banner may not appear as expected.';
  static const String bannerinfotext =
      "Your banner will be displayed within a 15Km radius of the selected location. "
      "Make sure to choose a location where your audience is most likely to engage. "
      "A banner placed too far from the target area might not be visible to the relevant users.";

  static const String bannerfeescancellation =
      "The Banner fee is non-refundable. In case of any issue, kindly contact Gully Support.";
  static const String shopfeescancellation =
      "Please note that the fee to enable product listing is non-refundable. For support or further assistance, contact Gully Support.";
  //Shop Text
  static const String aadharBothSideImage =
      "Please upload both the front and back sides of your Aadhaar card for verification ";

  static const String shopinfotext =
      "Please select a location near your shop. This helps us display your shop to users within a 15Km radius. "
      "Choosing a nearby location ensures that potential customers in your area can easily discover your business.";

  //Shop Owner
  static const String ownerAddharCard = "Owner Id Proof (Addhar Card)";
  static const String ownerPanCard = "Owner Pan Card";

  static const String ownerAddress = "Owner Address";
  static const String ownerPhone = "Phone Number";
  static const String owneremail = "Email Address";
  static const String ownerName = "Name";

  //Aadhar Card
  static const String aadharCardAdded =
      "Aadhaar Card Added to Edit click on Image";
  static const String tapToEdit = "Tap to Add Aadhaar Images";
  static const String tapToView = "Tap to View your Aadhaar Images";

  static const String selectproductcategory = "Select Product Category";
  static const String selectallproductcategory = "Select Product Category";
  static const String productaddedsuccessfully = "Product Added SUccessfully";

  static const String unlistProduct =
      "Are you sure you want to unlist this product? It will no longer be visible to other users, but you can relist it anytime from your dashboard.";
  static const String relistProduct =
      "Would you like to relist this product? It will be active again and visible to all users.";
  static const String shopPaymentSuccessful =
      "Congratulations !!!\nYour transaction was successful. You can now start adding your products and manage your shop listings.";

  static const String additionalPackagePaymentSuccess =
      "Payment Successful!\nYour additional package has been activated. You can now upload more product images and continue growing your shop seamlessly.";
  static const String bannerPaymentSuccessful =
      "Congratulations !!!\nYour transaction has been successful. Your banner Details will be updated sortly!";
}
