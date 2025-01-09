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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
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

  /// `Egyption Movies`
  String get egyptmovieswidget_title {
    return Intl.message(
      'Egyption Movies',
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

  /// `Egyption TV Shows`
  String get egypttvwidget_title {
    return Intl.message(
      'Egyption TV Shows',
      name: 'egypttvwidget_title',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homenavbar {
    return Intl.message(
      'Home',
      name: 'homenavbar',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get explorenavbar {
    return Intl.message(
      'Explore',
      name: 'explorenavbar',
      desc: '',
      args: [],
    );
  }

  /// `Liked`
  String get likednavbar {
    return Intl.message(
      'Liked',
      name: 'likednavbar',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profilenavbar {
    return Intl.message(
      'Profile',
      name: 'profilenavbar',
      desc: '',
      args: [],
    );
  }

  /// `Movies`
  String get movieswitch {
    return Intl.message(
      'Movies',
      name: 'movieswitch',
      desc: '',
      args: [],
    );
  }

  /// `TV Shows`
  String get tvswitch {
    return Intl.message(
      'TV Shows',
      name: 'tvswitch',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchhint {
    return Intl.message(
      'Search',
      name: 'searchhint',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get Actiongenre {
    return Intl.message(
      'Action',
      name: 'Actiongenre',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Comedy',
      name: 'Comedygenre',
      desc: '',
      args: [],
    );
  }

  /// `Crime`
  String get Crimegenre {
    return Intl.message(
      'Crime',
      name: 'Crimegenre',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Drama',
      name: 'Dramagenre',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get Familygenre {
    return Intl.message(
      'Family',
      name: 'Familygenre',
      desc: '',
      args: [],
    );
  }

  /// `Fantasy`
  String get Fantasygenre {
    return Intl.message(
      'Fantasy',
      name: 'Fantasygenre',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get Historygenre {
    return Intl.message(
      'History',
      name: 'Historygenre',
      desc: '',
      args: [],
    );
  }

  /// `Horror`
  String get Horrorgenre {
    return Intl.message(
      'Horror',
      name: 'Horrorgenre',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get Musicgenre {
    return Intl.message(
      'Music',
      name: 'Musicgenre',
      desc: '',
      args: [],
    );
  }

  /// `Mystery`
  String get Mysterygenre {
    return Intl.message(
      'Mystery',
      name: 'Mysterygenre',
      desc: '',
      args: [],
    );
  }

  /// `Romance`
  String get Romancegenre {
    return Intl.message(
      'Romance',
      name: 'Romancegenre',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'TV Movie',
      name: 'TVMoviegenre',
      desc: '',
      args: [],
    );
  }

  /// `Thriller`
  String get Thrillergenre {
    return Intl.message(
      'Thriller',
      name: 'Thrillergenre',
      desc: '',
      args: [],
    );
  }

  /// `War`
  String get Wargenre {
    return Intl.message(
      'War',
      name: 'Wargenre',
      desc: '',
      args: [],
    );
  }

  /// `Western`
  String get Westerngenre {
    return Intl.message(
      'Western',
      name: 'Westerngenre',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'tvaction&adventure' key

  /// `Kids`
  String get tvkids {
    return Intl.message(
      'Kids',
      name: 'tvkids',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get tvnews {
    return Intl.message(
      'News',
      name: 'tvnews',
      desc: '',
      args: [],
    );
  }

  /// `Reality`
  String get tvreality {
    return Intl.message(
      'Reality',
      name: 'tvreality',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'tvscifi&fantasy' key

  /// `Soap`
  String get tvsoap {
    return Intl.message(
      'Soap',
      name: 'tvsoap',
      desc: '',
      args: [],
    );
  }

  /// `Talk`
  String get tvtalk {
    return Intl.message(
      'Talk',
      name: 'tvtalk',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Try Again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `No Results`
  String get noResults {
    return Intl.message(
      'No Results',
      name: 'noResults',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Oh No!',
      name: 'OhNo',
      desc: '',
      args: [],
    );
  }

  /// `Your Liked Movies List is Empty\nStart adding some movies to your likes and discover your favorites!`
  String get nolikedmovies {
    return Intl.message(
      'Your Liked Movies List is Empty\nStart adding some movies to your likes and discover your favorites!',
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
    return Intl.message(
      'TV Movies',
      name: 'tvmovielabel',
      desc: '',
      args: [],
    );
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

  /// `See all`
  String get Seealloptions {
    return Intl.message(
      'See all',
      name: 'Seealloptions',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkmodelabel {
    return Intl.message(
      'Dark Mode',
      name: 'darkmodelabel',
      desc: '',
      args: [],
    );
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

  /// `Logout`
  String get logoutlabel {
    return Intl.message(
      'Logout',
      name: 'logoutlabel',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Privacy',
      name: 'privacylabel',
      desc: '',
      args: [],
    );
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

  /// `Password Changed Successfully`
  String get changepasswordsuccess {
    return Intl.message(
      'Password Changed Successfully',
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
    return Intl.message(
      'Username',
      name: 'Usernamelabel',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Last Name',
      name: 'lastnamelabel',
      desc: '',
      args: [],
    );
  }

  /// `Profile Updated Successfully`
  String get updateprofilesuccess {
    return Intl.message(
      'Profile Updated Successfully',
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
    return Intl.message(
      'Hey there',
      name: 'Heytherelabel',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'English',
      name: 'englishlabel',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabiclabel {
    return Intl.message(
      'Arabic',
      name: 'arabiclabel',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get Frenchlabel {
    return Intl.message(
      'French',
      name: 'Frenchlabel',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanishlabel {
    return Intl.message(
      'Spanish',
      name: 'spanishlabel',
      desc: '',
      args: [],
    );
  }

  /// `Deutsch`
  String get deutschlabel {
    return Intl.message(
      'Deutsch',
      name: 'deutschlabel',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get italianlabel {
    return Intl.message(
      'Italian',
      name: 'italianlabel',
      desc: '',
      args: [],
    );
  }

  /// `Hindi`
  String get hindilabel {
    return Intl.message(
      'Hindi',
      name: 'hindilabel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get savelabel {
    return Intl.message(
      'Save',
      name: 'savelabel',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get minute {
    return Intl.message(
      'min',
      name: 'minute',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Like',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `Unlike`
  String get unlike {
    return Intl.message(
      'Unlike',
      name: 'unlike',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Storyline`
  String get storyline {
    return Intl.message(
      'Storyline',
      name: 'storyline',
      desc: '',
      args: [],
    );
  }

  /// `The Cast`
  String get thecast {
    return Intl.message(
      'The Cast',
      name: 'thecast',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Watch on',
      name: 'watchon',
      desc: '',
      args: [],
    );
  }

  /// `Buy on`
  String get buyon {
    return Intl.message(
      'Buy on',
      name: 'buyon',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
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

  /// `Login`
  String get loginbuttonlabel {
    return Intl.message(
      'Login',
      name: 'loginbuttonlabel',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signupbuttonlabel {
    return Intl.message(
      'Sign Up',
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
    return Intl.message(
      'Password',
      name: 'passwordlabel',
      desc: '',
      args: [],
    );
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

  /// `•Password must be: \n •8 characters long \n •Contain at least one uppercase letter \n •One lowercase letter \n •One special character`
  String get passwordvalidationtext {
    return Intl.message(
      '•Password must be: \n •8 characters long \n •Contain at least one uppercase letter \n •One lowercase letter \n •One special character',
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

  /// `Register Now`
  String get registarnowlabel {
    return Intl.message(
      'Register Now',
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
    return Intl.message(
      'Movies',
      name: 'mediatypemoviess',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Oh No!',
      name: 'ohnolabel',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get themelabel {
    return Intl.message(
      'Theme',
      name: 'themelabel',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get LightTheme {
    return Intl.message(
      'Light Theme',
      name: 'LightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get DarkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'DarkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Oceanic Waves`
  String get OceanicWaves {
    return Intl.message(
      'Oceanic Waves',
      name: 'OceanicWaves',
      desc: '',
      args: [],
    );
  }

  /// `Elegant Neutrals`
  String get ElegantNeutrals {
    return Intl.message(
      'Elegant Neutrals',
      name: 'ElegantNeutrals',
      desc: '',
      args: [],
    );
  }

  /// `Golden Hour`
  String get GoldenHour {
    return Intl.message(
      'Golden Hour',
      name: 'GoldenHour',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Candy`
  String get CottonCandy {
    return Intl.message(
      'Cotton Candy',
      name: 'CottonCandy',
      desc: '',
      args: [],
    );
  }

  /// `Luminous Galaxy`
  String get LuminousGalaxy {
    return Intl.message(
      'Luminous Galaxy',
      name: 'LuminousGalaxy',
      desc: '',
      args: [],
    );
  }

  /// `Cherry Blossom`
  String get CherryBlossom {
    return Intl.message(
      'Cherry Blossom',
      name: 'CherryBlossom',
      desc: '',
      args: [],
    );
  }

  /// `Mystic Meadows`
  String get mysticMeadows {
    return Intl.message(
      'Mystic Meadows',
      name: 'mysticMeadows',
      desc: '',
      args: [],
    );
  }

  /// `Hey`
  String get heylabel {
    return Intl.message(
      'Hey',
      name: 'heylabel',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get New {
    return Intl.message(
      'New',
      name: 'New',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get oklabel {
    return Intl.message(
      'Ok',
      name: 'oklabel',
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
