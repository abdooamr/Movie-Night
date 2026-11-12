// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "${name} is now an admin";

  static String m1(character) => "As ${character}";

  static String m2(email) =>
      "Check your email. We sent a link to ${email}. Open it to activate your account, then log in.";

  static String m3(section) => "Couldn\'t load ${section}.";

  static String m4(name) => "Delete ${name}?";

  static String m5(count) =>
      "${Intl.plural(count, one: '1 episode', other: '${count} episodes')}";

  static String m6(query) =>
      "No results for “${query}”. Check the spelling or try another title.";

  static String m7(title) => "Play ${title}";

  static String m8(score) => "${score} out of 10";

  static String m9(email) =>
      "Check your email. We sent a reset link to ${email}.";

  static String m10(hours, minutes) => "${hours}h ${minutes}m";

  static String m11(hours) => "${hours}h";

  static String m12(minutes) => "${minutes}m";

  static String m13(count) =>
      "${Intl.plural(count, one: '1 season', other: '${count} seasons')}";

  static String m14(count) => "See All Reviews (${count})";

  static String m15(title, url) => "Check out ${title} on Movie Night\n${url}";

  static String m16(count) =>
      "${Intl.plural(count, one: '1 title', other: '${count} titles')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Actiongenre": MessageLookupByLibrary.simpleMessage("Action"),
    "Adventuregenre": MessageLookupByLibrary.simpleMessage("Adventure"),
    "Animationgenre": MessageLookupByLibrary.simpleMessage("Animation"),
    "Comedygenre": MessageLookupByLibrary.simpleMessage("Comedy"),
    "Crimegenre": MessageLookupByLibrary.simpleMessage("Crime"),
    "Documentarygenre": MessageLookupByLibrary.simpleMessage("Documentary"),
    "Dramagenre": MessageLookupByLibrary.simpleMessage("Drama"),
    "Familygenre": MessageLookupByLibrary.simpleMessage("Family"),
    "Fantasygenre": MessageLookupByLibrary.simpleMessage("Fantasy"),
    "Frenchlabel": MessageLookupByLibrary.simpleMessage("French"),
    "Heylabel": MessageLookupByLibrary.simpleMessage("Hey"),
    "Heytherelabel": MessageLookupByLibrary.simpleMessage("Hey there"),
    "Historygenre": MessageLookupByLibrary.simpleMessage("History"),
    "Horrorgenre": MessageLookupByLibrary.simpleMessage("Horror"),
    "Musicgenre": MessageLookupByLibrary.simpleMessage("Music"),
    "Mysterygenre": MessageLookupByLibrary.simpleMessage("Mystery"),
    "OhNo": MessageLookupByLibrary.simpleMessage("Oh No!"),
    "Recommendation": MessageLookupByLibrary.simpleMessage("Recommendation"),
    "Romancegenre": MessageLookupByLibrary.simpleMessage("Romance"),
    "ScienceFictiongenre": MessageLookupByLibrary.simpleMessage(
      "Science Fiction",
    ),
    "Seealloptions": MessageLookupByLibrary.simpleMessage("See All"),
    "TVMoviegenre": MessageLookupByLibrary.simpleMessage("TV Movie"),
    "Thrillergenre": MessageLookupByLibrary.simpleMessage("Thriller"),
    "Usernamelabel": MessageLookupByLibrary.simpleMessage("Username"),
    "Wargenre": MessageLookupByLibrary.simpleMessage("War"),
    "Westerngenre": MessageLookupByLibrary.simpleMessage("Western"),
    "accountGroupLabel": MessageLookupByLibrary.simpleMessage("Account"),
    "accountinfolabel": MessageLookupByLibrary.simpleMessage("Account Info"),
    "accountsettingslabel": MessageLookupByLibrary.simpleMessage(
      "Account Settings",
    ),
    "accountsettingssubtitle": MessageLookupByLibrary.simpleMessage(
      "Edit account, Privacy, Change Language",
    ),
    "actionmovielabel": MessageLookupByLibrary.simpleMessage("Action Movies"),
    "actiontvlabel": MessageLookupByLibrary.simpleMessage(
      "Action & Adventure TV Shows",
    ),
    "addAdmin": MessageLookupByLibrary.simpleMessage("Add Admin"),
    "addtowatchlist": MessageLookupByLibrary.simpleMessage("Add to Watchlist"),
    "adminActions": MessageLookupByLibrary.simpleMessage("Actions"),
    "adminCopyId": MessageLookupByLibrary.simpleMessage("Copy user ID"),
    "adminDetails": MessageLookupByLibrary.simpleMessage("Details"),
    "adminFilterAdmins": MessageLookupByLibrary.simpleMessage("Admins"),
    "adminFilterReported": MessageLookupByLibrary.simpleMessage("Reported"),
    "adminIdCopied": MessageLookupByLibrary.simpleMessage("User ID copied"),
    "adminMakeAdmin": MessageLookupByLibrary.simpleMessage("Make Admin"),
    "adminMakeAdminHint": MessageLookupByLibrary.simpleMessage(
      "Can open this panel and manage users",
    ),
    "adminNoUsersFound": MessageLookupByLibrary.simpleMessage("No users found"),
    "adminNoUsersHint": MessageLookupByLibrary.simpleMessage(
      "Try another name or email.",
    ),
    "adminNowAdmin": m0,
    "adminPanel": MessageLookupByLibrary.simpleMessage("Admin Panel"),
    "adminReportCleared": MessageLookupByLibrary.simpleMessage(
      "Report cleared",
    ),
    "adminRoleUser": MessageLookupByLibrary.simpleMessage("User"),
    "adminSearchHint": MessageLookupByLibrary.simpleMessage(
      "Search by name or email",
    ),
    "adminStatus": MessageLookupByLibrary.simpleMessage("Status"),
    "adminUserId": MessageLookupByLibrary.simpleMessage("User ID"),
    "adminUserTitle": MessageLookupByLibrary.simpleMessage("User"),
    "adminpanellabel": MessageLookupByLibrary.simpleMessage("Admin Panel"),
    "adminsettingslabel": MessageLookupByLibrary.simpleMessage("Admin"),
    "adventuremovielabel": MessageLookupByLibrary.simpleMessage(
      "Adventure Movies",
    ),
    "airingtodaywidget_title": MessageLookupByLibrary.simpleMessage(
      "Airing Today",
    ),
    "alreadyhaveanaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "animationmovielabel": MessageLookupByLibrary.simpleMessage(
      "Animation Movies",
    ),
    "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
    "appearanceDark": MessageLookupByLibrary.simpleMessage("Dark"),
    "appearanceLight": MessageLookupByLibrary.simpleMessage("Light"),
    "appearanceSystem": MessageLookupByLibrary.simpleMessage("System"),
    "arabiclabel": MessageLookupByLibrary.simpleMessage("Arabic"),
    "authErrorEmailInUse": MessageLookupByLibrary.simpleMessage(
      "An account with this email already exists.",
    ),
    "authErrorEmailNotConfirmed": MessageLookupByLibrary.simpleMessage(
      "Confirm your email first. Open the link we sent you, then log in.",
    ),
    "authErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t complete that. Try again.",
    ),
    "authErrorInvalidCredential": MessageLookupByLibrary.simpleMessage(
      "Email or password is incorrect.",
    ),
    "authErrorInvalidEmail": MessageLookupByLibrary.simpleMessage(
      "Enter an email like name@example.com.",
    ),
    "authErrorNetwork": MessageLookupByLibrary.simpleMessage(
      "You\'re offline. Check your connection and try again.",
    ),
    "authErrorRecentLogin": MessageLookupByLibrary.simpleMessage(
      "For your security, log in again to delete your account.",
    ),
    "authErrorSamePassword": MessageLookupByLibrary.simpleMessage(
      "Choose a password that\'s different from your current one.",
    ),
    "authErrorTooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Too many attempts. Try again in a few minutes.",
    ),
    "authErrorUserNotFound": MessageLookupByLibrary.simpleMessage(
      "No account uses this email.",
    ),
    "authErrorWeakPassword": MessageLookupByLibrary.simpleMessage(
      "Choose a stronger password.",
    ),
    "backOnline": MessageLookupByLibrary.simpleMessage("You\'re back online."),
    "backToLogIn": MessageLookupByLibrary.simpleMessage("Back to Log In"),
    "beFirstToReview": MessageLookupByLibrary.simpleMessage(
      "No reviews yet. Be the first to write one.",
    ),
    "biography": MessageLookupByLibrary.simpleMessage("Biography"),
    "browseMovies": MessageLookupByLibrary.simpleMessage("Browse Movies"),
    "buyon": MessageLookupByLibrary.simpleMessage("Buy on"),
    "cancelLabel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "castAs": m1,
    "changeProfilePhoto": MessageLookupByLibrary.simpleMessage(
      "Change Profile Photo",
    ),
    "changelanguagelabel": MessageLookupByLibrary.simpleMessage(
      "Change Language",
    ),
    "changepassworderror": MessageLookupByLibrary.simpleMessage(
      "Error Changing Password. Please try again",
    ),
    "changepasswordlabel": MessageLookupByLibrary.simpleMessage(
      "Change Password",
    ),
    "changepasswordsuccess": MessageLookupByLibrary.simpleMessage(
      "The password reset email has been sent successfully",
    ),
    "clearHistory": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearReport": MessageLookupByLibrary.simpleMessage("Clear Report"),
    "clearSearchTooltip": MessageLookupByLibrary.simpleMessage("Clear search"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "comedymovielabel": MessageLookupByLibrary.simpleMessage("Comedy Movies"),
    "confirmEmailSent": m2,
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "couldntLoadSection": m3,
    "couldntLoadTitle": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load this title.",
    ),
    "createaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Create Account",
    ),
    "crimemovielabel": MessageLookupByLibrary.simpleMessage("Crime Movies"),
    "darkmodelabel": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAccountDone": MessageLookupByLibrary.simpleMessage(
      "Your account has been deleted.",
    ),
    "deleteAccountMessage": MessageLookupByLibrary.simpleMessage(
      "Your profile, watchlist and reviews will be permanently deleted. This can\'t be undone.",
    ),
    "deleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Delete Account?",
    ),
    "deleteBookmark": MessageLookupByLibrary.simpleMessage("Delete Bookmark"),
    "deleteBookmarkConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this bookmark? This action cannot be undone.",
    ),
    "deleteReviewMessage": MessageLookupByLibrary.simpleMessage(
      "This can\'t be undone.",
    ),
    "deleteReviewTitle": MessageLookupByLibrary.simpleMessage("Delete Review?"),
    "deleteReviewTooltip": MessageLookupByLibrary.simpleMessage(
      "Delete review",
    ),
    "deleteUser": MessageLookupByLibrary.simpleMessage("Delete User"),
    "deleteUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete your account? This action cannot be undone.",
    ),
    "deleteUserTitle": m4,
    "deleteaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Delete Account",
    ),
    "deleteerror": MessageLookupByLibrary.simpleMessage(
      "Error Deleting Account. Please log in again and try again",
    ),
    "descriptionhint": MessageLookupByLibrary.simpleMessage(
      "Explain the problem in detail",
    ),
    "descriptionlabel": MessageLookupByLibrary.simpleMessage(
      "Description  (Required)",
    ),
    "detailCategory": MessageLookupByLibrary.simpleMessage("Detail Category"),
    "deutschlabel": MessageLookupByLibrary.simpleMessage("Deutsch"),
    "documentarymovielabel": MessageLookupByLibrary.simpleMessage(
      "Documentary Movies",
    ),
    "dramamovielabel": MessageLookupByLibrary.simpleMessage("Drama Movies"),
    "editprofilelabel": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "egyptmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Egyptian Movies",
    ),
    "egypttvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Egyptian Series",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailaddresslabel": MessageLookupByLibrary.simpleMessage("Email Address"),
    "englishlabel": MessageLookupByLibrary.simpleMessage("English"),
    "enterFirstName": MessageLookupByLibrary.simpleMessage(
      "Enter a first name.",
    ),
    "enterPassword": MessageLookupByLibrary.simpleMessage(
      "Enter your password.",
    ),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Enter a valid email address.",
    ),
    "episodesCount": m5,
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorLoginAgain": MessageLookupByLibrary.simpleMessage(
      "Error please log in again and try again",
    ),
    "errorTitle": MessageLookupByLibrary.simpleMessage("Error"),
    "explorenavbar": MessageLookupByLibrary.simpleMessage("Search"),
    "familymovielabel": MessageLookupByLibrary.simpleMessage("Family Movies"),
    "fantasymovielabel": MessageLookupByLibrary.simpleMessage("Fantasy Movies"),
    "filterAll": MessageLookupByLibrary.simpleMessage("All"),
    "filterLabel": MessageLookupByLibrary.simpleMessage("Filter"),
    "firstnamelabel": MessageLookupByLibrary.simpleMessage("First Name"),
    "forgetPasswordPageQuestion": MessageLookupByLibrary.simpleMessage(
      "Enter the email associated with your account",
    ),
    "forgotpasswordlabel": MessageLookupByLibrary.simpleMessage(
      "Forgot Password?",
    ),
    "fullUserProfile": MessageLookupByLibrary.simpleMessage(
      "Full User Profile",
    ),
    "generalsettingslabel": MessageLookupByLibrary.simpleMessage("General"),
    "genericError": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "globalreviewswitch": MessageLookupByLibrary.simpleMessage("Global Review"),
    "hello": MessageLookupByLibrary.simpleMessage("Hello"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("Hide password"),
    "hindilabel": MessageLookupByLibrary.simpleMessage("Hindi"),
    "historymovielabel": MessageLookupByLibrary.simpleMessage("History Movies"),
    "homenavbar": MessageLookupByLibrary.simpleMessage("Home"),
    "horrormovielabel": MessageLookupByLibrary.simpleMessage("Horror Movies"),
    "id": MessageLookupByLibrary.simpleMessage("ID"),
    "inWatchlist": MessageLookupByLibrary.simpleMessage("In Watchlist"),
    "italianlabel": MessageLookupByLibrary.simpleMessage("Italian"),
    "kidstvlabel": MessageLookupByLibrary.simpleMessage("Kids TV Shows"),
    "lastnamelabel": MessageLookupByLibrary.simpleMessage("Last Name"),
    "libraryLiked": MessageLookupByLibrary.simpleMessage("Liked"),
    "libraryNoMatches": MessageLookupByLibrary.simpleMessage(
      "No titles match this filter.",
    ),
    "libraryWatchlist": MessageLookupByLibrary.simpleMessage("Watchlist"),
    "like": MessageLookupByLibrary.simpleMessage("Like"),
    "liked": MessageLookupByLibrary.simpleMessage("Liked"),
    "likedEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Tap ♡ on any movie or show to keep it here.",
    ),
    "likednavbar": MessageLookupByLibrary.simpleMessage("Library"),
    "localreviewswitch": MessageLookupByLibrary.simpleMessage("Local Review"),
    "logInToReview": MessageLookupByLibrary.simpleMessage(
      "Log In to Write a Review",
    ),
    "loginbuttonlabel": MessageLookupByLibrary.simpleMessage("Log In"),
    "logintocontinue": MessageLookupByLibrary.simpleMessage(
      "Please login to continue",
    ),
    "logoutlabel": MessageLookupByLibrary.simpleMessage("Log Out"),
    "managesettingslabel": MessageLookupByLibrary.simpleMessage("Manage"),
    "mediaMovie": MessageLookupByLibrary.simpleMessage("Movie"),
    "mediaTvShow": MessageLookupByLibrary.simpleMessage("Series"),
    "mediatypemoviess": MessageLookupByLibrary.simpleMessage("Movies"),
    "minute": MessageLookupByLibrary.simpleMessage("min"),
    "moviesKnownFor": MessageLookupByLibrary.simpleMessage("Movies Known For"),
    "movieswitch": MessageLookupByLibrary.simpleMessage("Movies"),
    "musicmovielabel": MessageLookupByLibrary.simpleMessage("Music Movies"),
    "mysterymovielabel": MessageLookupByLibrary.simpleMessage("Mystery Movies"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "newPasswordLabel": MessageLookupByLibrary.simpleMessage("New Password"),
    "newstvlabel": MessageLookupByLibrary.simpleMessage("News TV Shows"),
    "noBirthdayFound": MessageLookupByLibrary.simpleMessage(
      "No birthday found",
    ),
    "noDataFound": MessageLookupByLibrary.simpleMessage("Nothing to show"),
    "noImage": MessageLookupByLibrary.simpleMessage("No Image"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "noInternetMessage": MessageLookupByLibrary.simpleMessage(
      "Please check your internet connection and try again",
    ),
    "noReport": MessageLookupByLibrary.simpleMessage("No reports"),
    "noResults": MessageLookupByLibrary.simpleMessage("No Results"),
    "noResultsFor": m6,
    "noResultsMessage": MessageLookupByLibrary.simpleMessage(
      "No results found for your search",
    ),
    "noReviews": MessageLookupByLibrary.simpleMessage("No Reviews"),
    "noUserDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No user data available",
    ),
    "noVideos": MessageLookupByLibrary.simpleMessage("No Videos"),
    "nobiographyfound": MessageLookupByLibrary.simpleMessage(
      "No biography found",
    ),
    "nobuyon": MessageLookupByLibrary.simpleMessage(
      "No buying services available",
    ),
    "noimage": MessageLookupByLibrary.simpleMessage("No Image"),
    "nointernetconnection": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "nolikedmovies": MessageLookupByLibrary.simpleMessage(
      "No liked titles yet",
    ),
    "nomoviesinwatchlist": MessageLookupByLibrary.simpleMessage(
      "Your Watchlist is Empty\nStart adding some movies to your watchlist and discover your favorites!",
    ),
    "notNowLabel": MessageLookupByLibrary.simpleMessage("Not Now"),
    "notamemberlabel": MessageLookupByLibrary.simpleMessage("Not a member?"),
    "notvshowsinwatchlist": MessageLookupByLibrary.simpleMessage(
      "Your Watchlist is Empty\nStart adding some series to your watchlist and discover your favorites!",
    ),
    "nowatchmovieon": MessageLookupByLibrary.simpleMessage(
      "No streaming services available",
    ),
    "numberofepisodes": MessageLookupByLibrary.simpleMessage(
      "Number of Episodes",
    ),
    "numberofseasons": MessageLookupByLibrary.simpleMessage(
      "Number of Seasons",
    ),
    "ohnolabel": MessageLookupByLibrary.simpleMessage("Oh No!"),
    "okLabel": MessageLookupByLibrary.simpleMessage("OK"),
    "openInImdb": MessageLookupByLibrary.simpleMessage("Open in IMDb"),
    "passwordMigrationBody": MessageLookupByLibrary.simpleMessage(
      "Movie Night moved to a new sign-in system. If you had an account before this update, your old password no longer works. Reset it once to keep using your account.",
    ),
    "passwordMigrationTitle": MessageLookupByLibrary.simpleMessage(
      "Reset Your Password Once",
    ),
    "passwordUpdated": MessageLookupByLibrary.simpleMessage(
      "Your password was updated.",
    ),
    "passwordconfirmlabel": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "passwordlabel": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords don\'t match.",
    ),
    "passwordvalidationtext": MessageLookupByLibrary.simpleMessage(
      "Use at least 8 characters, including an uppercase letter, a lowercase letter, a number and a symbol.",
    ),
    "playVideo": m7,
    "pleasecheckinternetconnection": MessageLookupByLibrary.simpleMessage(
      "Please check your internet connection and try again",
    ),
    "pleasefillallfields": MessageLookupByLibrary.simpleMessage(
      "Please fill all fields",
    ),
    "popularmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Popular Movies",
    ),
    "populartvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Popular Series",
    ),
    "poweredby": MessageLookupByLibrary.simpleMessage("Powered by"),
    "privacylabel": MessageLookupByLibrary.simpleMessage("Privacy"),
    "profilePicUploadFailed": MessageLookupByLibrary.simpleMessage(
      "Could not upload profile picture. Please try again.",
    ),
    "profileSignInBody": MessageLookupByLibrary.simpleMessage(
      "Keep a watchlist, write reviews and take your profile to any device.",
    ),
    "profileSignInTitle": MessageLookupByLibrary.simpleMessage(
      "Log In to Movie Night",
    ),
    "profilenavbar": MessageLookupByLibrary.simpleMessage("Profile"),
    "rateMovieNight": MessageLookupByLibrary.simpleMessage("Rate Movie Night"),
    "ratingOutOf10": m8,
    "readLess": MessageLookupByLibrary.simpleMessage("Read less"),
    "readmorelabel": MessageLookupByLibrary.simpleMessage("Read more"),
    "realitytvlabel": MessageLookupByLibrary.simpleMessage("Reality TV Shows"),
    "registarnowlabel": MessageLookupByLibrary.simpleMessage("Create Account"),
    "removeFromHistory": MessageLookupByLibrary.simpleMessage("Remove"),
    "removeFromLiked": MessageLookupByLibrary.simpleMessage(
      "Remove from Liked",
    ),
    "removedFromLiked": MessageLookupByLibrary.simpleMessage(
      "Removed from Liked",
    ),
    "removedFromWatchlist": MessageLookupByLibrary.simpleMessage(
      "Removed from Watchlist",
    ),
    "removefromwatchlist": MessageLookupByLibrary.simpleMessage(
      "Remove from Watchlist",
    ),
    "report": MessageLookupByLibrary.simpleMessage("Report"),
    "reportDescriptionRequired": MessageLookupByLibrary.simpleMessage(
      "Add a description.",
    ),
    "reportFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t send report. Try again.",
    ),
    "reportPage": MessageLookupByLibrary.simpleMessage("Report Page"),
    "reportSent": MessageLookupByLibrary.simpleMessage(
      "Report sent. Thanks for helping improve Movie Night.",
    ),
    "reportSummaryRequired": MessageLookupByLibrary.simpleMessage(
      "Add a short summary.",
    ),
    "reportabuglabel": MessageLookupByLibrary.simpleMessage("Report a Bug"),
    "reportpagelabel": MessageLookupByLibrary.simpleMessage(
      "Please send us a report if you find any bugs or have any suggestions for the app.",
    ),
    "resetLinkSent": m9,
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "We\'ll email you a reset link",
    ),
    "reviewsTitle": MessageLookupByLibrary.simpleMessage("Reviews"),
    "role": MessageLookupByLibrary.simpleMessage("Role"),
    "romancemovielabel": MessageLookupByLibrary.simpleMessage("Romance Movies"),
    "runtimeHoursMinutes": m10,
    "runtimeHoursOnly": m11,
    "runtimeMinutesOnly": m12,
    "savePasswordLabel": MessageLookupByLibrary.simpleMessage("Save Password"),
    "savelabel": MessageLookupByLibrary.simpleMessage("Save"),
    "sciencefictionmovielabel": MessageLookupByLibrary.simpleMessage(
      "Sci-Fi Movies",
    ),
    "scifitvlabel": MessageLookupByLibrary.simpleMessage(
      "Sci-Fi & Fantasy TV Shows",
    ),
    "searchhint": MessageLookupByLibrary.simpleMessage(
      "Movies, series, people",
    ),
    "seasonsCount": m13,
    "seeAllReviews": m14,
    "sendEmail": MessageLookupByLibrary.simpleMessage("Send Email"),
    "sendReviewTooltip": MessageLookupByLibrary.simpleMessage("Send review"),
    "sendfeedbacklabel": MessageLookupByLibrary.simpleMessage("Send Feedback"),
    "sendreportlabel": MessageLookupByLibrary.simpleMessage("Send Report"),
    "setNewPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Choose a new password for your account.",
    ),
    "setNewPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Set a New Password",
    ),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "shareText": m15,
    "showAll": MessageLookupByLibrary.simpleMessage("Show All"),
    "showPassword": MessageLookupByLibrary.simpleMessage("Show password"),
    "signInPromptBody": MessageLookupByLibrary.simpleMessage(
      "Log in to keep a watchlist, like titles and write reviews.",
    ),
    "signInPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Log In to Save Titles",
    ),
    "signInToReview": MessageLookupByLibrary.simpleMessage(
      "Log in to read and write reviews.",
    ),
    "signupbuttonlabel": MessageLookupByLibrary.simpleMessage("Create Account"),
    "soaptvlabel": MessageLookupByLibrary.simpleMessage("Soap TV Shows"),
    "somethingwentwrong": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load this. Try again.",
    ),
    "spanishlabel": MessageLookupByLibrary.simpleMessage("Spanish"),
    "storyline": MessageLookupByLibrary.simpleMessage("Storyline"),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "summaryhint": MessageLookupByLibrary.simpleMessage(
      "Explain the problem briefly",
    ),
    "summarylabel": MessageLookupByLibrary.simpleMessage("Summary  (Required)"),
    "talktvlabel": MessageLookupByLibrary.simpleMessage("Talk TV Shows"),
    "thecast": MessageLookupByLibrary.simpleMessage("The Cast"),
    "thrillermovielabel": MessageLookupByLibrary.simpleMessage(
      "Thriller Movies",
    ),
    "titlesCount": m16,
    "tmdbLabel": MessageLookupByLibrary.simpleMessage("TMDB"),
    "trendingmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Trending Movies",
    ),
    "trendingtvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Trending Series",
    ),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
    "tvActionAdventure": MessageLookupByLibrary.simpleMessage(
      "Action & Adventure",
    ),
    "tvSciFiFantasy": MessageLookupByLibrary.simpleMessage("Sci-Fi & Fantasy"),
    "tvShowsKnownFor": MessageLookupByLibrary.simpleMessage("Series Known For"),
    "tvWarPolitics": MessageLookupByLibrary.simpleMessage("War & Politics"),
    "tvkids": MessageLookupByLibrary.simpleMessage("Kids"),
    "tvmovielabel": MessageLookupByLibrary.simpleMessage("TV Movies"),
    "tvnews": MessageLookupByLibrary.simpleMessage("News"),
    "tvreality": MessageLookupByLibrary.simpleMessage("Reality"),
    "tvsoap": MessageLookupByLibrary.simpleMessage("Soap"),
    "tvswitch": MessageLookupByLibrary.simpleMessage("Series"),
    "tvtalk": MessageLookupByLibrary.simpleMessage("Talk"),
    "undo": MessageLookupByLibrary.simpleMessage("Undo"),
    "unlike": MessageLookupByLibrary.simpleMessage("Unlike"),
    "upcomingwidget_title": MessageLookupByLibrary.simpleMessage(
      "Upcoming Movies",
    ),
    "updateaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Update Account",
    ),
    "updateprofilelabel": MessageLookupByLibrary.simpleMessage(
      "Update Profile",
    ),
    "updateprofilesuccess": MessageLookupByLibrary.simpleMessage(
      "Profile updated",
    ),
    "userProfile": MessageLookupByLibrary.simpleMessage("User Profile"),
    "videoslabel": MessageLookupByLibrary.simpleMessage("Videos"),
    "viewFullDetails": MessageLookupByLibrary.simpleMessage(
      "View Full Details",
    ),
    "viewPosterFullScreen": MessageLookupByLibrary.simpleMessage(
      "View poster full screen",
    ),
    "viewReports": MessageLookupByLibrary.simpleMessage("View Reports"),
    "warmovielabel": MessageLookupByLibrary.simpleMessage("War Movies"),
    "wartvlabel": MessageLookupByLibrary.simpleMessage(
      "War & Politics TV Shows",
    ),
    "watchTrailers": MessageLookupByLibrary.simpleMessage("Watch Trailers"),
    "watchlistEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Add titles to your Watchlist to find them here later.",
    ),
    "watchlistEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Your Watchlist Is Empty",
    ),
    "watchlistSignInBody": MessageLookupByLibrary.simpleMessage(
      "Your watchlist is saved to your account, so it follows you to any device.",
    ),
    "watchlistSignInTitle": MessageLookupByLibrary.simpleMessage(
      "Log In to Use Your Watchlist",
    ),
    "watchlistUpdateFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t update Watchlist. Try again.",
    ),
    "watchlistlabel": MessageLookupByLibrary.simpleMessage("Watchlist"),
    "watchon": MessageLookupByLibrary.simpleMessage("Watch on"),
    "watchvideosbuttonlabel": MessageLookupByLibrary.simpleMessage(
      "Watch Videos",
    ),
    "welcomemessage": MessageLookupByLibrary.simpleMessage("Welcome Back"),
    "westernmovielabel": MessageLookupByLibrary.simpleMessage("Western Movies"),
    "writeReview": MessageLookupByLibrary.simpleMessage("Write a review"),
  };
}
