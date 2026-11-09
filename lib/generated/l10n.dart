// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Upcoming Movies`
  String get upcomingwidget_title {
    return Intl.message(
      'Upcoming Movies',
      name: 'upcomingwidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Trending Movies`
  String get trendingmovieswidget_title {
    return Intl.message(
      'Trending Movies',
      name: 'trendingmovieswidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Popular Movies`
  String get popularmovieswidget_title {
    return Intl.message(
      'Popular Movies',
      name: 'popularmovieswidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian Movies`
  String get egyptmovieswidget_title {
    return Intl.message(
      'Egyptian Movies',
      name: 'egyptmovieswidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Airing Today`
  String get airingtodaywidget_title {
    return Intl.message(
      'Airing Today',
      name: 'airingtodaywidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Trending TV Shows`
  String get trendingtvwidget_title {
    return Intl.message(
      'Trending TV Shows',
      name: 'trendingtvwidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Popular TV Shows`
  String get populartvwidget_title {
    return Intl.message(
      'Popular TV Shows',
      name: 'populartvwidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian TV Shows`
  String get egypttvwidget_title {
    return Intl.message(
      'Egyptian TV Shows',
      name: 'egypttvwidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homenavbar {
    return Intl.message('Home', name: 'homenavbar', desc: '', args: []);
  }

  /// `Search`
  String get explorenavbar {
    return Intl.message('Search', name: 'explorenavbar', desc: '', args: []);
  }

  /// `Library`
  String get likednavbar {
    return Intl.message('Library', name: 'likednavbar', desc: '', args: []);
  }

  /// `Profile`
  String get profilenavbar {
    return Intl.message('Profile', name: 'profilenavbar', desc: '', args: []);
  }

  /// `Movies`
  String get movieswitch {
    return Intl.message('Movies', name: 'movieswitch', desc: '', args: []);
  }

  /// `TV Shows`
  String get tvswitch {
    return Intl.message('TV Shows', name: 'tvswitch', desc: '', args: []);
  }

  /// `Movies, TV shows, people`
  String get searchhint {
    return Intl.message(
      'Movies, TV shows, people',
      name: 'searchhint',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get Actiongenre {
    return Intl.message('Action', name: 'Actiongenre', desc: '', args: []);
  }

  /// `Adventure`
  String get Adventuregenre {
    return Intl.message(
      'Adventure',
      name: 'Adventuregenre',
      desc: '',
      args: [],
    );
  }

  /// `Animation`
  String get Animationgenre {
    return Intl.message(
      'Animation',
      name: 'Animationgenre',
      desc: '',
      args: [],
    );
  }

  /// `Comedy`
  String get Comedygenre {
    return Intl.message('Comedy', name: 'Comedygenre', desc: '', args: []);
  }

  /// `Crime`
  String get Crimegenre {
    return Intl.message('Crime', name: 'Crimegenre', desc: '', args: []);
  }

  /// `Documentary`
  String get Documentarygenre {
    return Intl.message(
      'Documentary',
      name: 'Documentarygenre',
      desc: '',
      args: [],
    );
  }

  /// `Drama`
  String get Dramagenre {
    return Intl.message('Drama', name: 'Dramagenre', desc: '', args: []);
  }

  /// `Family`
  String get Familygenre {
    return Intl.message('Family', name: 'Familygenre', desc: '', args: []);
  }

  /// `Fantasy`
  String get Fantasygenre {
    return Intl.message('Fantasy', name: 'Fantasygenre', desc: '', args: []);
  }

  /// `History`
  String get Historygenre {
    return Intl.message('History', name: 'Historygenre', desc: '', args: []);
  }

  /// `Horror`
  String get Horrorgenre {
    return Intl.message('Horror', name: 'Horrorgenre', desc: '', args: []);
  }

  /// `Music`
  String get Musicgenre {
    return Intl.message('Music', name: 'Musicgenre', desc: '', args: []);
  }

  /// `Mystery`
  String get Mysterygenre {
    return Intl.message('Mystery', name: 'Mysterygenre', desc: '', args: []);
  }

  /// `Romance`
  String get Romancegenre {
    return Intl.message('Romance', name: 'Romancegenre', desc: '', args: []);
  }

  /// `Science Fiction`
  String get ScienceFictiongenre {
    return Intl.message(
      'Science Fiction',
      name: 'ScienceFictiongenre',
      desc: '',
      args: [],
    );
  }

  /// `TV Movie`
  String get TVMoviegenre {
    return Intl.message('TV Movie', name: 'TVMoviegenre', desc: '', args: []);
  }

  /// `Thriller`
  String get Thrillergenre {
    return Intl.message('Thriller', name: 'Thrillergenre', desc: '', args: []);
  }

  /// `War`
  String get Wargenre {
    return Intl.message('War', name: 'Wargenre', desc: '', args: []);
  }

  /// `Western`
  String get Westerngenre {
    return Intl.message('Western', name: 'Westerngenre', desc: '', args: []);
  }

  // skipped getter for the 'tvaction&adventure' key

  /// `Kids`
  String get tvkids {
    return Intl.message('Kids', name: 'tvkids', desc: '', args: []);
  }

  /// `News`
  String get tvnews {
    return Intl.message('News', name: 'tvnews', desc: '', args: []);
  }

  /// `Reality`
  String get tvreality {
    return Intl.message('Reality', name: 'tvreality', desc: '', args: []);
  }

  // skipped getter for the 'tvscifi&fantasy' key

  /// `Soap`
  String get tvsoap {
    return Intl.message('Soap', name: 'tvsoap', desc: '', args: []);
  }

  /// `Talk`
  String get tvtalk {
    return Intl.message('Talk', name: 'tvtalk', desc: '', args: []);
  }

  // skipped getter for the 'tvwar&politics' key

  /// `No Internet Connection`
  String get noInternet {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection and try again`
  String get noInternetMessage {
    return Intl.message(
      'Please check your internet connection and try again',
      name: 'noInternetMessage',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `No Results`
  String get noResults {
    return Intl.message('No Results', name: 'noResults', desc: '', args: []);
  }

  /// `No results found for your search`
  String get noResultsMessage {
    return Intl.message(
      'No results found for your search',
      name: 'noResultsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Oh No!`
  String get OhNo {
    return Intl.message('Oh No!', name: 'OhNo', desc: '', args: []);
  }

  /// `No liked titles yet`
  String get nolikedmovies {
    return Intl.message(
      'No liked titles yet',
      name: 'nolikedmovies',
      desc: '',
      args: [],
    );
  }

  /// `Action Movies`
  String get actionmovielabel {
    return Intl.message(
      'Action Movies',
      name: 'actionmovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Adventure Movies`
  String get adventuremovielabel {
    return Intl.message(
      'Adventure Movies',
      name: 'adventuremovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Animation Movies`
  String get animationmovielabel {
    return Intl.message(
      'Animation Movies',
      name: 'animationmovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Comedy Movies`
  String get comedymovielabel {
    return Intl.message(
      'Comedy Movies',
      name: 'comedymovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Crime Movies`
  String get crimemovielabel {
    return Intl.message(
      'Crime Movies',
      name: 'crimemovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Documentary Movies`
  String get documentarymovielabel {
    return Intl.message(
      'Documentary Movies',
      name: 'documentarymovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Drama Movies`
  String get dramamovielabel {
    return Intl.message(
      'Drama Movies',
      name: 'dramamovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Family Movies`
  String get familymovielabel {
    return Intl.message(
      'Family Movies',
      name: 'familymovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Fantasy Movies`
  String get fantasymovielabel {
    return Intl.message(
      'Fantasy Movies',
      name: 'fantasymovielabel',
      desc: '',
      args: [],
    );
  }

  /// `History Movies`
  String get historymovielabel {
    return Intl.message(
      'History Movies',
      name: 'historymovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Horror Movies`
  String get horrormovielabel {
    return Intl.message(
      'Horror Movies',
      name: 'horrormovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Music Movies`
  String get musicmovielabel {
    return Intl.message(
      'Music Movies',
      name: 'musicmovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Mystery Movies`
  String get mysterymovielabel {
    return Intl.message(
      'Mystery Movies',
      name: 'mysterymovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Romance Movies`
  String get romancemovielabel {
    return Intl.message(
      'Romance Movies',
      name: 'romancemovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Sci-Fi Movies`
  String get sciencefictionmovielabel {
    return Intl.message(
      'Sci-Fi Movies',
      name: 'sciencefictionmovielabel',
      desc: '',
      args: [],
    );
  }

  /// `TV Movies`
  String get tvmovielabel {
    return Intl.message('TV Movies', name: 'tvmovielabel', desc: '', args: []);
  }

  /// `Thriller Movies`
  String get thrillermovielabel {
    return Intl.message(
      'Thriller Movies',
      name: 'thrillermovielabel',
      desc: '',
      args: [],
    );
  }

  /// `War Movies`
  String get warmovielabel {
    return Intl.message(
      'War Movies',
      name: 'warmovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Western Movies`
  String get westernmovielabel {
    return Intl.message(
      'Western Movies',
      name: 'westernmovielabel',
      desc: '',
      args: [],
    );
  }

  /// `Action & Adventure TV Shows`
  String get actiontvlabel {
    return Intl.message(
      'Action & Adventure TV Shows',
      name: 'actiontvlabel',
      desc: '',
      args: [],
    );
  }

  /// `Kids TV Shows`
  String get kidstvlabel {
    return Intl.message(
      'Kids TV Shows',
      name: 'kidstvlabel',
      desc: '',
      args: [],
    );
  }

  /// `News TV Shows`
  String get newstvlabel {
    return Intl.message(
      'News TV Shows',
      name: 'newstvlabel',
      desc: '',
      args: [],
    );
  }

  /// `Reality TV Shows`
  String get realitytvlabel {
    return Intl.message(
      'Reality TV Shows',
      name: 'realitytvlabel',
      desc: '',
      args: [],
    );
  }

  /// `Sci-Fi & Fantasy TV Shows`
  String get scifitvlabel {
    return Intl.message(
      'Sci-Fi & Fantasy TV Shows',
      name: 'scifitvlabel',
      desc: '',
      args: [],
    );
  }

  /// `Soap TV Shows`
  String get soaptvlabel {
    return Intl.message(
      'Soap TV Shows',
      name: 'soaptvlabel',
      desc: '',
      args: [],
    );
  }

  /// `Talk TV Shows`
  String get talktvlabel {
    return Intl.message(
      'Talk TV Shows',
      name: 'talktvlabel',
      desc: '',
      args: [],
    );
  }

  /// `War & Politics TV Shows`
  String get wartvlabel {
    return Intl.message(
      'War & Politics TV Shows',
      name: 'wartvlabel',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get Seealloptions {
    return Intl.message('See All', name: 'Seealloptions', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkmodelabel {
    return Intl.message('Dark Mode', name: 'darkmodelabel', desc: '', args: []);
  }

  /// `Admin Panel`
  String get adminpanellabel {
    return Intl.message(
      'Admin Panel',
      name: 'adminpanellabel',
      desc: '',
      args: [],
    );
  }

  /// `Watchlist`
  String get watchlistlabel {
    return Intl.message(
      'Watchlist',
      name: 'watchlistlabel',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get accountsettingslabel {
    return Intl.message(
      'Account Settings',
      name: 'accountsettingslabel',
      desc: '',
      args: [],
    );
  }

  /// `Report a Bug`
  String get reportabuglabel {
    return Intl.message(
      'Report a Bug',
      name: 'reportabuglabel',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logoutlabel {
    return Intl.message('Log Out', name: 'logoutlabel', desc: '', args: []);
  }

  /// `Delete Account`
  String get deleteaccountlabel {
    return Intl.message(
      'Delete Account',
      name: 'deleteaccountlabel',
      desc: '',
      args: [],
    );
  }

  /// `Send Feedback`
  String get sendfeedbacklabel {
    return Intl.message(
      'Send Feedback',
      name: 'sendfeedbacklabel',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get generalsettingslabel {
    return Intl.message(
      'General',
      name: 'generalsettingslabel',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get managesettingslabel {
    return Intl.message(
      'Manage',
      name: 'managesettingslabel',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get adminsettingslabel {
    return Intl.message(
      'Admin',
      name: 'adminsettingslabel',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Error Deleting Account. Please log in again and try again`
  String get deleteerror {
    return Intl.message(
      'Error Deleting Account. Please log in again and try again',
      name: 'deleteerror',
      desc: '',
      args: [],
    );
  }

  /// `Edit account, Privacy, Change Language`
  String get accountsettingssubtitle {
    return Intl.message(
      'Edit account, Privacy, Change Language',
      name: 'accountsettingssubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Account Info`
  String get accountinfolabel {
    return Intl.message(
      'Account Info',
      name: 'accountinfolabel',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacylabel {
    return Intl.message('Privacy', name: 'privacylabel', desc: '', args: []);
  }

  /// `Change Password`
  String get changepasswordlabel {
    return Intl.message(
      'Change Password',
      name: 'changepasswordlabel',
      desc: '',
      args: [],
    );
  }

  /// `The password reset email has been sent successfully`
  String get changepasswordsuccess {
    return Intl.message(
      'The password reset email has been sent successfully',
      name: 'changepasswordsuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error Changing Password. Please try again`
  String get changepassworderror {
    return Intl.message(
      'Error Changing Password. Please try again',
      name: 'changepassworderror',
      desc: '',
      args: [],
    );
  }

  /// `Update Profile`
  String get updateprofilelabel {
    return Intl.message(
      'Update Profile',
      name: 'updateprofilelabel',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get Usernamelabel {
    return Intl.message('Username', name: 'Usernamelabel', desc: '', args: []);
  }

  /// `First Name`
  String get firstnamelabel {
    return Intl.message(
      'First Name',
      name: 'firstnamelabel',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastnamelabel {
    return Intl.message('Last Name', name: 'lastnamelabel', desc: '', args: []);
  }

  /// `Profile updated`
  String get updateprofilesuccess {
    return Intl.message(
      'Profile updated',
      name: 'updateprofilesuccess',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editprofilelabel {
    return Intl.message(
      'Edit Profile',
      name: 'editprofilelabel',
      desc: '',
      args: [],
    );
  }

  /// `Please send us a report if you find any bugs or have any suggestions for the app.`
  String get reportpagelabel {
    return Intl.message(
      'Please send us a report if you find any bugs or have any suggestions for the app.',
      name: 'reportpagelabel',
      desc: '',
      args: [],
    );
  }

  /// `Summary  (Required)`
  String get summarylabel {
    return Intl.message(
      'Summary  (Required)',
      name: 'summarylabel',
      desc: '',
      args: [],
    );
  }

  /// `Explain the problem briefly`
  String get summaryhint {
    return Intl.message(
      'Explain the problem briefly',
      name: 'summaryhint',
      desc: '',
      args: [],
    );
  }

  /// `Description  (Required)`
  String get descriptionlabel {
    return Intl.message(
      'Description  (Required)',
      name: 'descriptionlabel',
      desc: '',
      args: [],
    );
  }

  /// `Explain the problem in detail`
  String get descriptionhint {
    return Intl.message(
      'Explain the problem in detail',
      name: 'descriptionhint',
      desc: '',
      args: [],
    );
  }

  /// `Send Report`
  String get sendreportlabel {
    return Intl.message(
      'Send Report',
      name: 'sendreportlabel',
      desc: '',
      args: [],
    );
  }

  /// `Hey there`
  String get Heytherelabel {
    return Intl.message('Hey there', name: 'Heytherelabel', desc: '', args: []);
  }

  /// `Your Watchlist is Empty\nStart adding some movies to your watchlist and discover your favorites!`
  String get nomoviesinwatchlist {
    return Intl.message(
      'Your Watchlist is Empty\nStart adding some movies to your watchlist and discover your favorites!',
      name: 'nomoviesinwatchlist',
      desc: '',
      args: [],
    );
  }

  /// `Your Watchlist is Empty\nStart adding some TV Shows to your watchlist and discover your favorites!`
  String get notvshowsinwatchlist {
    return Intl.message(
      'Your Watchlist is Empty\nStart adding some TV Shows to your watchlist and discover your favorites!',
      name: 'notvshowsinwatchlist',
      desc: '',
      args: [],
    );
  }

  /// `Update Account`
  String get updateaccountlabel {
    return Intl.message(
      'Update Account',
      name: 'updateaccountlabel',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changelanguagelabel {
    return Intl.message(
      'Change Language',
      name: 'changelanguagelabel',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get englishlabel {
    return Intl.message('English', name: 'englishlabel', desc: '', args: []);
  }

  /// `Arabic`
  String get arabiclabel {
    return Intl.message('Arabic', name: 'arabiclabel', desc: '', args: []);
  }

  /// `French`
  String get Frenchlabel {
    return Intl.message('French', name: 'Frenchlabel', desc: '', args: []);
  }

  /// `Spanish`
  String get spanishlabel {
    return Intl.message('Spanish', name: 'spanishlabel', desc: '', args: []);
  }

  /// `Deutsch`
  String get deutschlabel {
    return Intl.message('Deutsch', name: 'deutschlabel', desc: '', args: []);
  }

  /// `Italian`
  String get italianlabel {
    return Intl.message('Italian', name: 'italianlabel', desc: '', args: []);
  }

  /// `Hindi`
  String get hindilabel {
    return Intl.message('Hindi', name: 'hindilabel', desc: '', args: []);
  }

  /// `Save`
  String get savelabel {
    return Intl.message('Save', name: 'savelabel', desc: '', args: []);
  }

  /// `min`
  String get minute {
    return Intl.message('min', name: 'minute', desc: '', args: []);
  }

  /// `Watch Videos`
  String get watchvideosbuttonlabel {
    return Intl.message(
      'Watch Videos',
      name: 'watchvideosbuttonlabel',
      desc: '',
      args: [],
    );
  }

  /// `Number of Seasons`
  String get numberofseasons {
    return Intl.message(
      'Number of Seasons',
      name: 'numberofseasons',
      desc: '',
      args: [],
    );
  }

  /// `Number of Episodes`
  String get numberofepisodes {
    return Intl.message(
      'Number of Episodes',
      name: 'numberofepisodes',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get like {
    return Intl.message('Like', name: 'like', desc: '', args: []);
  }

  /// `Unlike`
  String get unlike {
    return Intl.message('Unlike', name: 'unlike', desc: '', args: []);
  }

  /// `Add to Watchlist`
  String get addtowatchlist {
    return Intl.message(
      'Add to Watchlist',
      name: 'addtowatchlist',
      desc: '',
      args: [],
    );
  }

  /// `Remove from Watchlist`
  String get removefromwatchlist {
    return Intl.message(
      'Remove from Watchlist',
      name: 'removefromwatchlist',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Storyline`
  String get storyline {
    return Intl.message('Storyline', name: 'storyline', desc: '', args: []);
  }

  /// `The Cast`
  String get thecast {
    return Intl.message('The Cast', name: 'thecast', desc: '', args: []);
  }

  /// `No streaming services available`
  String get nowatchmovieon {
    return Intl.message(
      'No streaming services available',
      name: 'nowatchmovieon',
      desc: '',
      args: [],
    );
  }

  /// `Watch on`
  String get watchon {
    return Intl.message('Watch on', name: 'watchon', desc: '', args: []);
  }

  /// `Buy on`
  String get buyon {
    return Intl.message('Buy on', name: 'buyon', desc: '', args: []);
  }

  /// `No buying services available`
  String get nobuyon {
    return Intl.message(
      'No buying services available',
      name: 'nobuyon',
      desc: '',
      args: [],
    );
  }

  /// `Recommendation`
  String get Recommendation {
    return Intl.message(
      'Recommendation',
      name: 'Recommendation',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Welcome Back`
  String get welcomemessage {
    return Intl.message(
      'Welcome Back',
      name: 'welcomemessage',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get loginbuttonlabel {
    return Intl.message('Log In', name: 'loginbuttonlabel', desc: '', args: []);
  }

  /// `Create Account`
  String get signupbuttonlabel {
    return Intl.message(
      'Create Account',
      name: 'signupbuttonlabel',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createaccountlabel {
    return Intl.message(
      'Create Account',
      name: 'createaccountlabel',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get pleasefillallfields {
    return Intl.message(
      'Please fill all fields',
      name: 'pleasefillallfields',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailaddresslabel {
    return Intl.message(
      'Email Address',
      name: 'emailaddresslabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordlabel {
    return Intl.message('Password', name: 'passwordlabel', desc: '', args: []);
  }

  /// `Confirm Password`
  String get passwordconfirmlabel {
    return Intl.message(
      'Confirm Password',
      name: 'passwordconfirmlabel',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyhaveanaccountlabel {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyhaveanaccountlabel',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotpasswordlabel {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotpasswordlabel',
      desc: '',
      args: [],
    );
  }

  /// `Use at least 8 characters, including an uppercase letter, a lowercase letter, a number and a symbol.`
  String get passwordvalidationtext {
    return Intl.message(
      'Use at least 8 characters, including an uppercase letter, a lowercase letter, a number and a symbol.',
      name: 'passwordvalidationtext',
      desc: '',
      args: [],
    );
  }

  /// `Please login to continue`
  String get logintocontinue {
    return Intl.message(
      'Please login to continue',
      name: 'logintocontinue',
      desc: '',
      args: [],
    );
  }

  /// `Not a member?`
  String get notamemberlabel {
    return Intl.message(
      'Not a member?',
      name: 'notamemberlabel',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get registarnowlabel {
    return Intl.message(
      'Create Account',
      name: 'registarnowlabel',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get nointernetconnection {
    return Intl.message(
      'No Internet Connection',
      name: 'nointernetconnection',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection and try again`
  String get pleasecheckinternetconnection {
    return Intl.message(
      'Please check your internet connection and try again',
      name: 'pleasecheckinternetconnection',
      desc: '',
      args: [],
    );
  }

  /// `Movies`
  String get mediatypemoviess {
    return Intl.message('Movies', name: 'mediatypemoviess', desc: '', args: []);
  }

  /// `Global Review`
  String get globalreviewswitch {
    return Intl.message(
      'Global Review',
      name: 'globalreviewswitch',
      desc: '',
      args: [],
    );
  }

  /// `Local Review`
  String get localreviewswitch {
    return Intl.message(
      'Local Review',
      name: 'localreviewswitch',
      desc: '',
      args: [],
    );
  }

  /// `Oh No!`
  String get ohnolabel {
    return Intl.message('Oh No!', name: 'ohnolabel', desc: '', args: []);
  }

  /// `OK`
  String get okLabel {
    return Intl.message('OK', name: 'okLabel', desc: '', args: []);
  }

  /// `Couldn't load this. Try again.`
  String get somethingwentwrong {
    return Intl.message(
      'Couldn\'t load this. Try again.',
      name: 'somethingwentwrong',
      desc: '',
      args: [],
    );
  }

  /// `Delete User`
  String get deleteUser {
    return Intl.message('Delete User', name: 'deleteUser', desc: '', args: []);
  }

  /// `Are you sure you want to delete your account? This action cannot be undone.`
  String get deleteUserConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account? This action cannot be undone.',
      name: 'deleteUserConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `No Image`
  String get noImage {
    return Intl.message('No Image', name: 'noImage', desc: '', args: []);
  }

  /// `User Profile`
  String get userProfile {
    return Intl.message(
      'User Profile',
      name: 'userProfile',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Role`
  String get role {
    return Intl.message('Role', name: 'role', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Add Admin`
  String get addAdmin {
    return Intl.message('Add Admin', name: 'addAdmin', desc: '', args: []);
  }

  /// `Cancel`
  String get cancelLabel {
    return Intl.message('Cancel', name: 'cancelLabel', desc: '', args: []);
  }

  /// `Admin Panel`
  String get adminPanel {
    return Intl.message('Admin Panel', name: 'adminPanel', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `ID`
  String get id {
    return Intl.message('ID', name: 'id', desc: '', args: []);
  }

  /// `Report`
  String get report {
    return Intl.message('Report', name: 'report', desc: '', args: []);
  }

  /// `Detail Category`
  String get detailCategory {
    return Intl.message(
      'Detail Category',
      name: 'detailCategory',
      desc: '',
      args: [],
    );
  }

  /// `View Reports`
  String get viewReports {
    return Intl.message(
      'View Reports',
      name: 'viewReports',
      desc: '',
      args: [],
    );
  }

  /// `View Full Details`
  String get viewFullDetails {
    return Intl.message(
      'View Full Details',
      name: 'viewFullDetails',
      desc: '',
      args: [],
    );
  }

  /// `Full User Profile`
  String get fullUserProfile {
    return Intl.message(
      'Full User Profile',
      name: 'fullUserProfile',
      desc: '',
      args: [],
    );
  }

  /// `Report Page`
  String get reportPage {
    return Intl.message('Report Page', name: 'reportPage', desc: '', args: []);
  }

  /// `Clear Report`
  String get clearReport {
    return Intl.message(
      'Clear Report',
      name: 'clearReport',
      desc: '',
      args: [],
    );
  }

  /// `No reports`
  String get noReport {
    return Intl.message('No reports', name: 'noReport', desc: '', args: []);
  }

  /// `Enter the email associated with your account`
  String get forgetPasswordPageQuestion {
    return Intl.message(
      'Enter the email associated with your account',
      name: 'forgetPasswordPageQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Send Email`
  String get sendEmail {
    return Intl.message('Send Email', name: 'sendEmail', desc: '', args: []);
  }

  /// `Nothing to show`
  String get noDataFound {
    return Intl.message(
      'Nothing to show',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `No birthday found`
  String get noBirthdayFound {
    return Intl.message(
      'No birthday found',
      name: 'noBirthdayFound',
      desc: '',
      args: [],
    );
  }

  /// `Biography`
  String get biography {
    return Intl.message('Biography', name: 'biography', desc: '', args: []);
  }

  /// `No biography found`
  String get nobiographyfound {
    return Intl.message(
      'No biography found',
      name: 'nobiographyfound',
      desc: '',
      args: [],
    );
  }

  /// `Movies Known For`
  String get moviesKnownFor {
    return Intl.message(
      'Movies Known For',
      name: 'moviesKnownFor',
      desc: '',
      args: [],
    );
  }

  /// `TV Shows Known For`
  String get tvShowsKnownFor {
    return Intl.message(
      'TV Shows Known For',
      name: 'tvShowsKnownFor',
      desc: '',
      args: [],
    );
  }

  /// `Videos`
  String get videoslabel {
    return Intl.message('Videos', name: 'videoslabel', desc: '', args: []);
  }

  /// `Powered by`
  String get poweredby {
    return Intl.message('Powered by', name: 'poweredby', desc: '', args: []);
  }

  /// `Read more`
  String get readmorelabel {
    return Intl.message('Read more', name: 'readmorelabel', desc: '', args: []);
  }

  /// `No Image`
  String get noimage {
    return Intl.message('No Image', name: 'noimage', desc: '', args: []);
  }

  /// `No Videos`
  String get noVideos {
    return Intl.message('No Videos', name: 'noVideos', desc: '', args: []);
  }

  /// `No user data available`
  String get noUserDataAvailable {
    return Intl.message(
      'No user data available',
      name: 'noUserDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Hey`
  String get Heylabel {
    return Intl.message('Hey', name: 'Heylabel', desc: '', args: []);
  }

  /// `Delete Bookmark`
  String get deleteBookmark {
    return Intl.message(
      'Delete Bookmark',
      name: 'deleteBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this bookmark? This action cannot be undone.`
  String get deleteBookmarkConfirmation {
    return Intl.message(
      'Are you sure you want to delete this bookmark? This action cannot be undone.',
      name: 'deleteBookmarkConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `No Reviews`
  String get noReviews {
    return Intl.message('No Reviews', name: 'noReviews', desc: '', args: []);
  }

  /// `Write a review`
  String get writeReview {
    return Intl.message(
      'Write a review',
      name: 'writeReview',
      desc: '',
      args: [],
    );
  }

  /// `As {character}`
  String castAs(Object character) {
    return Intl.message(
      'As $character',
      name: 'castAs',
      desc: '',
      args: [character],
    );
  }

  /// `Error`
  String get errorTitle {
    return Intl.message('Error', name: 'errorTitle', desc: '', args: []);
  }

  /// `Error please log in again and try again`
  String get errorLoginAgain {
    return Intl.message(
      'Error please log in again and try again',
      name: 'errorLoginAgain',
      desc: '',
      args: [],
    );
  }

  /// `Delete review`
  String get deleteReviewTooltip {
    return Intl.message(
      'Delete review',
      name: 'deleteReviewTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Send review`
  String get sendReviewTooltip {
    return Intl.message(
      'Send review',
      name: 'sendReviewTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Clear search`
  String get clearSearchTooltip {
    return Intl.message(
      'Clear search',
      name: 'clearSearchTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get genericError {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'genericError',
      desc: '',
      args: [],
    );
  }

  /// `Could not upload profile picture. Please try again.`
  String get profilePicUploadFailed {
    return Intl.message(
      'Could not upload profile picture. Please try again.',
      name: 'profilePicUploadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Liked`
  String get libraryLiked {
    return Intl.message('Liked', name: 'libraryLiked', desc: '', args: []);
  }

  /// `Watchlist`
  String get libraryWatchlist {
    return Intl.message(
      'Watchlist',
      name: 'libraryWatchlist',
      desc: '',
      args: [],
    );
  }

  /// `Tap ♡ on any movie or show to keep it here.`
  String get likedEmptyBody {
    return Intl.message(
      'Tap ♡ on any movie or show to keep it here.',
      name: 'likedEmptyBody',
      desc: '',
      args: [],
    );
  }

  /// `Add titles to your Watchlist to find them here later.`
  String get watchlistEmptyBody {
    return Intl.message(
      'Add titles to your Watchlist to find them here later.',
      name: 'watchlistEmptyBody',
      desc: '',
      args: [],
    );
  }

  /// `Browse Movies`
  String get browseMovies {
    return Intl.message(
      'Browse Movies',
      name: 'browseMovies',
      desc: '',
      args: [],
    );
  }

  /// `Log In to Save Titles`
  String get signInPromptTitle {
    return Intl.message(
      'Log In to Save Titles',
      name: 'signInPromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Log in to keep a watchlist, like titles and write reviews.`
  String get signInPromptBody {
    return Intl.message(
      'Log in to keep a watchlist, like titles and write reviews.',
      name: 'signInPromptBody',
      desc: '',
      args: [],
    );
  }

  /// `Log in to read and write reviews.`
  String get signInToReview {
    return Intl.message(
      'Log in to read and write reviews.',
      name: 'signInToReview',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load {section}.`
  String couldntLoadSection(Object section) {
    return Intl.message(
      'Couldn\'t load $section.',
      name: 'couldntLoadSection',
      desc: '',
      args: [section],
    );
  }

  /// `Couldn't load this title.`
  String get couldntLoadTitle {
    return Intl.message(
      'Couldn\'t load this title.',
      name: 'couldntLoadTitle',
      desc: '',
      args: [],
    );
  }

  /// `No results for “{query}”. Check the spelling or try another title.`
  String noResultsFor(Object query) {
    return Intl.message(
      'No results for “$query”. Check the spelling or try another title.',
      name: 'noResultsFor',
      desc: '',
      args: [query],
    );
  }

  /// `Clear`
  String get clearHistory {
    return Intl.message('Clear', name: 'clearHistory', desc: '', args: []);
  }

  /// `Undo`
  String get undo {
    return Intl.message('Undo', name: 'undo', desc: '', args: []);
  }

  /// `Removed from Watchlist`
  String get removedFromWatchlist {
    return Intl.message(
      'Removed from Watchlist',
      name: 'removedFromWatchlist',
      desc: '',
      args: [],
    );
  }

  /// `Removed from Liked`
  String get removedFromLiked {
    return Intl.message(
      'Removed from Liked',
      name: 'removedFromLiked',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account?`
  String get deleteAccountTitle {
    return Intl.message(
      'Delete Account?',
      name: 'deleteAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your profile, watchlist and reviews will be permanently deleted. This can't be undone.`
  String get deleteAccountMessage {
    return Intl.message(
      'Your profile, watchlist and reviews will be permanently deleted. This can\'t be undone.',
      name: 'deleteAccountMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been deleted.`
  String get deleteAccountDone {
    return Intl.message(
      'Your account has been deleted.',
      name: 'deleteAccountDone',
      desc: '',
      args: [],
    );
  }

  /// `Delete Review?`
  String get deleteReviewTitle {
    return Intl.message(
      'Delete Review?',
      name: 'deleteReviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `This can't be undone.`
  String get deleteReviewMessage {
    return Intl.message(
      'This can\'t be undone.',
      name: 'deleteReviewMessage',
      desc: '',
      args: [],
    );
  }

  /// `Email or password is incorrect.`
  String get authErrorInvalidCredential {
    return Intl.message(
      'Email or password is incorrect.',
      name: 'authErrorInvalidCredential',
      desc: '',
      args: [],
    );
  }

  /// `You're offline. Check your connection and try again.`
  String get authErrorNetwork {
    return Intl.message(
      'You\'re offline. Check your connection and try again.',
      name: 'authErrorNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Try again in a few minutes.`
  String get authErrorTooManyRequests {
    return Intl.message(
      'Too many attempts. Try again in a few minutes.',
      name: 'authErrorTooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `An account with this email already exists.`
  String get authErrorEmailInUse {
    return Intl.message(
      'An account with this email already exists.',
      name: 'authErrorEmailInUse',
      desc: '',
      args: [],
    );
  }

  /// `Choose a stronger password.`
  String get authErrorWeakPassword {
    return Intl.message(
      'Choose a stronger password.',
      name: 'authErrorWeakPassword',
      desc: '',
      args: [],
    );
  }

  /// `No account uses this email.`
  String get authErrorUserNotFound {
    return Intl.message(
      'No account uses this email.',
      name: 'authErrorUserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Enter an email like name@example.com.`
  String get authErrorInvalidEmail {
    return Intl.message(
      'Enter an email like name@example.com.',
      name: 'authErrorInvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't complete that. Try again.`
  String get authErrorGeneric {
    return Intl.message(
      'Couldn\'t complete that. Try again.',
      name: 'authErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `For your security, log in again to delete your account.`
  String get authErrorRecentLogin {
    return Intl.message(
      'For your security, log in again to delete your account.',
      name: 'authErrorRecentLogin',
      desc: '',
      args: [],
    );
  }

  /// `Passwords don't match.`
  String get passwordsDontMatch {
    return Intl.message(
      'Passwords don\'t match.',
      name: 'passwordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address.`
  String get enterValidEmail {
    return Intl.message(
      'Enter a valid email address.',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password.`
  String get enterPassword {
    return Intl.message(
      'Enter your password.',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter a first name.`
  String get enterFirstName {
    return Intl.message(
      'Enter a first name.',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Check your email. We sent a reset link to {email}.`
  String resetLinkSent(Object email) {
    return Intl.message(
      'Check your email. We sent a reset link to $email.',
      name: 'resetLinkSent',
      desc: '',
      args: [email],
    );
  }

  /// `Back to Log In`
  String get backToLogIn {
    return Intl.message(
      'Back to Log In',
      name: 'backToLogIn',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `We'll email you a reset link`
  String get resetPasswordSubtitle {
    return Intl.message(
      'We\'ll email you a reset link',
      name: 'resetPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Report sent. Thanks for helping improve Movie Night.`
  String get reportSent {
    return Intl.message(
      'Report sent. Thanks for helping improve Movie Night.',
      name: 'reportSent',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't send report. Try again.`
  String get reportFailed {
    return Intl.message(
      'Couldn\'t send report. Try again.',
      name: 'reportFailed',
      desc: '',
      args: [],
    );
  }

  /// `Add a short summary.`
  String get reportSummaryRequired {
    return Intl.message(
      'Add a short summary.',
      name: 'reportSummaryRequired',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't update Watchlist. Try again.`
  String get watchlistUpdateFailed {
    return Intl.message(
      'Couldn\'t update Watchlist. Try again.',
      name: 'watchlistUpdateFailed',
      desc: '',
      args: [],
    );
  }

  /// `In Watchlist`
  String get inWatchlist {
    return Intl.message(
      'In Watchlist',
      name: 'inWatchlist',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message('Appearance', name: 'appearance', desc: '', args: []);
  }

  /// `System`
  String get appearanceSystem {
    return Intl.message('System', name: 'appearanceSystem', desc: '', args: []);
  }

  /// `Dark`
  String get appearanceDark {
    return Intl.message('Dark', name: 'appearanceDark', desc: '', args: []);
  }

  /// `Light`
  String get appearanceLight {
    return Intl.message('Light', name: 'appearanceLight', desc: '', args: []);
  }

  /// `See All Reviews ({count})`
  String seeAllReviews(Object count) {
    return Intl.message(
      'See All Reviews ($count)',
      name: 'seeAllReviews',
      desc: '',
      args: [count],
    );
  }

  /// `Watch Trailers`
  String get watchTrailers {
    return Intl.message(
      'Watch Trailers',
      name: 'watchTrailers',
      desc: '',
      args: [],
    );
  }

  /// `View poster full screen`
  String get viewPosterFullScreen {
    return Intl.message(
      'View poster full screen',
      name: 'viewPosterFullScreen',
      desc: '',
      args: [],
    );
  }

  /// `Play {title}`
  String playVideo(Object title) {
    return Intl.message(
      'Play $title',
      name: 'playVideo',
      desc: '',
      args: [title],
    );
  }

  /// `{score} out of 10`
  String ratingOutOf10(Object score) {
    return Intl.message(
      '$score out of 10',
      name: 'ratingOutOf10',
      desc: '',
      args: [score],
    );
  }

  /// `TMDB`
  String get tmdbLabel {
    return Intl.message('TMDB', name: 'tmdbLabel', desc: '', args: []);
  }

  /// `Check out {title} on Movie Night\n{url}`
  String shareText(Object title, Object url) {
    return Intl.message(
      'Check out $title on Movie Night\n$url',
      name: 'shareText',
      desc: '',
      args: [title, url],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Liked`
  String get liked {
    return Intl.message('Liked', name: 'liked', desc: '', args: []);
  }

  /// `Show password`
  String get showPassword {
    return Intl.message(
      'Show password',
      name: 'showPassword',
      desc: '',
      args: [],
    );
  }

  /// `Hide password`
  String get hidePassword {
    return Intl.message(
      'Hide password',
      name: 'hidePassword',
      desc: '',
      args: [],
    );
  }

  /// `Read less`
  String get readLess {
    return Intl.message('Read less', name: 'readLess', desc: '', args: []);
  }

  /// `Delete {name}?`
  String deleteUserTitle(Object name) {
    return Intl.message(
      'Delete $name?',
      name: 'deleteUserTitle',
      desc: '',
      args: [name],
    );
  }

  /// `You're back online.`
  String get backOnline {
    return Intl.message(
      'You\'re back online.',
      name: 'backOnline',
      desc: '',
      args: [],
    );
  }

  /// `Change Profile Photo`
  String get changeProfilePhoto {
    return Intl.message(
      'Change Profile Photo',
      name: 'changeProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Add a description.`
  String get reportDescriptionRequired {
    return Intl.message(
      'Add a description.',
      name: 'reportDescriptionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Rate Movie Night`
  String get rateMovieNight {
    return Intl.message(
      'Rate Movie Night',
      name: 'rateMovieNight',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountGroupLabel {
    return Intl.message(
      'Account',
      name: 'accountGroupLabel',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get removeFromHistory {
    return Intl.message(
      'Remove',
      name: 'removeFromHistory',
      desc: '',
      args: [],
    );
  }

  /// `Movie`
  String get mediaMovie {
    return Intl.message('Movie', name: 'mediaMovie', desc: '', args: []);
  }

  /// `TV Show`
  String get mediaTvShow {
    return Intl.message('TV Show', name: 'mediaTvShow', desc: '', args: []);
  }

  /// `Confirm your email first. Open the link we sent you, then log in.`
  String get authErrorEmailNotConfirmed {
    return Intl.message(
      'Confirm your email first. Open the link we sent you, then log in.',
      name: 'authErrorEmailNotConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Choose a password that's different from your current one.`
  String get authErrorSamePassword {
    return Intl.message(
      'Choose a password that\'s different from your current one.',
      name: 'authErrorSamePassword',
      desc: '',
      args: [],
    );
  }

  /// `Check your email. We sent a link to {email}. Open it to activate your account, then log in.`
  String confirmEmailSent(Object email) {
    return Intl.message(
      'Check your email. We sent a link to $email. Open it to activate your account, then log in.',
      name: 'confirmEmailSent',
      desc: '',
      args: [email],
    );
  }

  /// `Reset Your Password Once`
  String get passwordMigrationTitle {
    return Intl.message(
      'Reset Your Password Once',
      name: 'passwordMigrationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Movie Night moved to a new sign-in system. If you had an account before this update, your old password no longer works. Reset it once to keep using your account.`
  String get passwordMigrationBody {
    return Intl.message(
      'Movie Night moved to a new sign-in system. If you had an account before this update, your old password no longer works. Reset it once to keep using your account.',
      name: 'passwordMigrationBody',
      desc: '',
      args: [],
    );
  }

  /// `Not Now`
  String get notNowLabel {
    return Intl.message('Not Now', name: 'notNowLabel', desc: '', args: []);
  }

  /// `Set a New Password`
  String get setNewPasswordTitle {
    return Intl.message(
      'Set a New Password',
      name: 'setNewPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose a new password for your account.`
  String get setNewPasswordSubtitle {
    return Intl.message(
      'Choose a new password for your account.',
      name: 'setNewPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPasswordLabel {
    return Intl.message(
      'New Password',
      name: 'newPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Save Password`
  String get savePasswordLabel {
    return Intl.message(
      'Save Password',
      name: 'savePasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Your password was updated.`
  String get passwordUpdated {
    return Intl.message(
      'Your password was updated.',
      name: 'passwordUpdated',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
