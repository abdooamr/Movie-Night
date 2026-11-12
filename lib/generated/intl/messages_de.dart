// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(name) => "${name} ist jetzt Admin";

  static String m1(character) => "Als ${character}";

  static String m2(email) =>
      "Prüfe dein Postfach. Wir haben einen Link an ${email} gesendet. Öffne ihn, um dein Konto zu aktivieren, und melde dich dann an.";

  static String m3(section) => "${section} konnte nicht geladen werden.";

  static String m4(name) => "${name} löschen?";

  static String m5(count) =>
      "${Intl.plural(count, one: '1 Folge', other: '${count} Folgen')}";

  static String m6(query) =>
      "Keine Ergebnisse für „${query}“. Prüfe die Schreibweise oder versuche einen anderen Titel.";

  static String m7(title) => "${title} abspielen";

  static String m8(score) => "${score} von 10";

  static String m9(email) =>
      "Prüfe dein Postfach. Wir haben einen Link zum Zurücksetzen an ${email} gesendet.";

  static String m10(hours, minutes) => "${hours} Std. ${minutes} Min.";

  static String m11(hours) => "${hours} Std.";

  static String m12(minutes) => "${minutes} Min.";

  static String m13(count) =>
      "${Intl.plural(count, one: '1 Staffel', other: '${count} Staffeln')}";

  static String m14(count) => "Alle Bewertungen ansehen (${count})";

  static String m15(title, url) =>
      "Schau dir ${title} auf Movie Night an\n${url}";

  static String m16(count) =>
      "${Intl.plural(count, one: '1 Titel', other: '${count} Titel')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Actiongenre": MessageLookupByLibrary.simpleMessage("Action"),
    "Adventuregenre": MessageLookupByLibrary.simpleMessage("Abenteuer"),
    "Animationgenre": MessageLookupByLibrary.simpleMessage("Animation"),
    "Comedygenre": MessageLookupByLibrary.simpleMessage("Komödie"),
    "Crimegenre": MessageLookupByLibrary.simpleMessage("Krimi"),
    "Documentarygenre": MessageLookupByLibrary.simpleMessage("Dokumentation"),
    "Dramagenre": MessageLookupByLibrary.simpleMessage("Drama"),
    "Familygenre": MessageLookupByLibrary.simpleMessage("Familie"),
    "Fantasygenre": MessageLookupByLibrary.simpleMessage("Fantasie"),
    "Frenchlabel": MessageLookupByLibrary.simpleMessage("Französisch"),
    "Heylabel": MessageLookupByLibrary.simpleMessage("Hallo"),
    "Heytherelabel": MessageLookupByLibrary.simpleMessage("Hallo"),
    "Historygenre": MessageLookupByLibrary.simpleMessage("Geschichte"),
    "Horrorgenre": MessageLookupByLibrary.simpleMessage("Horror"),
    "Musicgenre": MessageLookupByLibrary.simpleMessage("Musik"),
    "Mysterygenre": MessageLookupByLibrary.simpleMessage("Mysterium"),
    "OhNo": MessageLookupByLibrary.simpleMessage("Oh Nein!"),
    "Recommendation": MessageLookupByLibrary.simpleMessage("Empfehlung"),
    "Romancegenre": MessageLookupByLibrary.simpleMessage("Romantik"),
    "ScienceFictiongenre": MessageLookupByLibrary.simpleMessage(
      "Science-Fiction",
    ),
    "Seealloptions": MessageLookupByLibrary.simpleMessage("Alles Sehen"),
    "TVMoviegenre": MessageLookupByLibrary.simpleMessage("TV-Film"),
    "Thrillergenre": MessageLookupByLibrary.simpleMessage("Thriller"),
    "Usernamelabel": MessageLookupByLibrary.simpleMessage("Benutzername"),
    "Wargenre": MessageLookupByLibrary.simpleMessage("Krieg"),
    "Westerngenre": MessageLookupByLibrary.simpleMessage("Western"),
    "accountGroupLabel": MessageLookupByLibrary.simpleMessage("Konto"),
    "accountinfolabel": MessageLookupByLibrary.simpleMessage(
      "Kontoinformationen",
    ),
    "accountsettingslabel": MessageLookupByLibrary.simpleMessage(
      "Kontoeinstellungen",
    ),
    "accountsettingssubtitle": MessageLookupByLibrary.simpleMessage(
      "Konto bearbeiten, Privatsphäre, Sprache ändern",
    ),
    "actionmovielabel": MessageLookupByLibrary.simpleMessage("Actionfilme"),
    "actiontvlabel": MessageLookupByLibrary.simpleMessage(
      "Action & Abenteuer Fernsehsendungen",
    ),
    "addAdmin": MessageLookupByLibrary.simpleMessage("Admin hinzufügen"),
    "addtowatchlist": MessageLookupByLibrary.simpleMessage(
      "Zur Merkliste hinzufügen",
    ),
    "adminActions": MessageLookupByLibrary.simpleMessage("Aktionen"),
    "adminCopyId": MessageLookupByLibrary.simpleMessage("Nutzer-ID kopieren"),
    "adminDetails": MessageLookupByLibrary.simpleMessage("Details"),
    "adminFilterAdmins": MessageLookupByLibrary.simpleMessage("Admins"),
    "adminFilterReported": MessageLookupByLibrary.simpleMessage("Gemeldet"),
    "adminIdCopied": MessageLookupByLibrary.simpleMessage("Nutzer-ID kopiert"),
    "adminMakeAdmin": MessageLookupByLibrary.simpleMessage("Zum Admin machen"),
    "adminMakeAdminHint": MessageLookupByLibrary.simpleMessage(
      "Kann dieses Panel öffnen und Nutzer verwalten",
    ),
    "adminNoUsersFound": MessageLookupByLibrary.simpleMessage(
      "Keine Nutzer gefunden",
    ),
    "adminNoUsersHint": MessageLookupByLibrary.simpleMessage(
      "Versuche einen anderen Namen oder eine andere E-Mail.",
    ),
    "adminNowAdmin": m0,
    "adminPanel": MessageLookupByLibrary.simpleMessage("Admin-Bereich"),
    "adminReportCleared": MessageLookupByLibrary.simpleMessage(
      "Meldung entfernt",
    ),
    "adminRoleUser": MessageLookupByLibrary.simpleMessage("Nutzer"),
    "adminSearchHint": MessageLookupByLibrary.simpleMessage(
      "Nach Name oder E-Mail suchen",
    ),
    "adminStatus": MessageLookupByLibrary.simpleMessage("Status"),
    "adminUserId": MessageLookupByLibrary.simpleMessage("Nutzer-ID"),
    "adminUserTitle": MessageLookupByLibrary.simpleMessage("Nutzer"),
    "adminpanellabel": MessageLookupByLibrary.simpleMessage("Admin-Panel"),
    "adminsettingslabel": MessageLookupByLibrary.simpleMessage("Admin"),
    "adventuremovielabel": MessageLookupByLibrary.simpleMessage(
      "Abenteuerfilme",
    ),
    "airingtodaywidget_title": MessageLookupByLibrary.simpleMessage(
      "Heute neu",
    ),
    "alreadyhaveanaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Bereits ein Konto?",
    ),
    "animationmovielabel": MessageLookupByLibrary.simpleMessage(
      "Animationsfilme",
    ),
    "appearance": MessageLookupByLibrary.simpleMessage("Darstellung"),
    "appearanceDark": MessageLookupByLibrary.simpleMessage("Dunkel"),
    "appearanceLight": MessageLookupByLibrary.simpleMessage("Hell"),
    "appearanceSystem": MessageLookupByLibrary.simpleMessage("System"),
    "arabiclabel": MessageLookupByLibrary.simpleMessage("Arabisch"),
    "authErrorEmailInUse": MessageLookupByLibrary.simpleMessage(
      "Ein Konto mit dieser E-Mail existiert bereits.",
    ),
    "authErrorEmailNotConfirmed": MessageLookupByLibrary.simpleMessage(
      "Bestätige zuerst deine E-Mail-Adresse. Öffne den Link, den wir dir gesendet haben, und melde dich dann an.",
    ),
    "authErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Das hat nicht geklappt. Versuche es erneut.",
    ),
    "authErrorInvalidCredential": MessageLookupByLibrary.simpleMessage(
      "E-Mail oder Passwort ist falsch.",
    ),
    "authErrorInvalidEmail": MessageLookupByLibrary.simpleMessage(
      "Gib eine E-Mail wie name@example.com ein.",
    ),
    "authErrorNetwork": MessageLookupByLibrary.simpleMessage(
      "Du bist offline. Prüfe deine Verbindung und versuche es erneut.",
    ),
    "authErrorRecentLogin": MessageLookupByLibrary.simpleMessage(
      "Aus Sicherheitsgründen melde dich erneut an, um dein Konto zu löschen.",
    ),
    "authErrorSamePassword": MessageLookupByLibrary.simpleMessage(
      "Wähle ein Passwort, das sich von deinem aktuellen unterscheidet.",
    ),
    "authErrorTooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Zu viele Versuche. Versuche es in ein paar Minuten erneut.",
    ),
    "authErrorUserNotFound": MessageLookupByLibrary.simpleMessage(
      "Kein Konto verwendet diese E-Mail.",
    ),
    "authErrorWeakPassword": MessageLookupByLibrary.simpleMessage(
      "Wähle ein stärkeres Passwort.",
    ),
    "backOnline": MessageLookupByLibrary.simpleMessage(
      "Du bist wieder online.",
    ),
    "backToLogIn": MessageLookupByLibrary.simpleMessage("Zurück zum Anmelden"),
    "beFirstToReview": MessageLookupByLibrary.simpleMessage(
      "Noch keine Bewertungen. Schreib die erste.",
    ),
    "biography": MessageLookupByLibrary.simpleMessage("Biografie"),
    "browseMovies": MessageLookupByLibrary.simpleMessage("Filme durchstöbern"),
    "buyon": MessageLookupByLibrary.simpleMessage("Kaufen auf"),
    "cancelLabel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "castAs": m1,
    "changeProfilePhoto": MessageLookupByLibrary.simpleMessage(
      "Profilbild Ändern",
    ),
    "changelanguagelabel": MessageLookupByLibrary.simpleMessage(
      "Sprache ändern",
    ),
    "changepassworderror": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Ändern des Passworts. Bitte versuchen Sie es erneut",
    ),
    "changepasswordlabel": MessageLookupByLibrary.simpleMessage(
      "Passwort ändern",
    ),
    "changepasswordsuccess": MessageLookupByLibrary.simpleMessage(
      "Passwort erfolgreich geändert",
    ),
    "clearHistory": MessageLookupByLibrary.simpleMessage("Löschen"),
    "clearReport": MessageLookupByLibrary.simpleMessage("Meldung entfernen"),
    "clearSearchTooltip": MessageLookupByLibrary.simpleMessage("Suche löschen"),
    "close": MessageLookupByLibrary.simpleMessage("Schließen"),
    "comedymovielabel": MessageLookupByLibrary.simpleMessage("Komödienfilme"),
    "confirmEmailSent": m2,
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Weiter mit Google",
    ),
    "couldntLoadSection": m3,
    "couldntLoadTitle": MessageLookupByLibrary.simpleMessage(
      "Dieser Titel konnte nicht geladen werden.",
    ),
    "createaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Konto erstellen",
    ),
    "crimemovielabel": MessageLookupByLibrary.simpleMessage("Krimifilme"),
    "darkmodelabel": MessageLookupByLibrary.simpleMessage("Dunkler Modus"),
    "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
    "deleteAccountDone": MessageLookupByLibrary.simpleMessage(
      "Dein Konto wurde gelöscht.",
    ),
    "deleteAccountMessage": MessageLookupByLibrary.simpleMessage(
      "Dein Profil, deine Merkliste und deine Bewertungen werden dauerhaft gelöscht. Das kann nicht rückgängig gemacht werden.",
    ),
    "deleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Konto löschen?",
    ),
    "deleteBookmark": MessageLookupByLibrary.simpleMessage(
      "Lesezeichen löschen",
    ),
    "deleteBookmarkConfirmation": MessageLookupByLibrary.simpleMessage(
      "Bist du sicher, dass du dieses Lesezeichen löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.",
    ),
    "deleteReviewMessage": MessageLookupByLibrary.simpleMessage(
      "Das kann nicht rückgängig gemacht werden.",
    ),
    "deleteReviewTitle": MessageLookupByLibrary.simpleMessage(
      "Bewertung löschen?",
    ),
    "deleteReviewTooltip": MessageLookupByLibrary.simpleMessage(
      "Rezension löschen",
    ),
    "deleteUser": MessageLookupByLibrary.simpleMessage("Benutzer löschen"),
    "deleteUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Bist du sicher, dass du dein Konto löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.",
    ),
    "deleteUserTitle": m4,
    "deleteaccountlabel": MessageLookupByLibrary.simpleMessage("Konto löschen"),
    "deleteerror": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Löschen des Kontos. Bitte melden Sie sich erneut an und versuchen Sie es erneut",
    ),
    "descriptionhint": MessageLookupByLibrary.simpleMessage(
      "Erklären Sie das Problem ausführlich",
    ),
    "descriptionlabel": MessageLookupByLibrary.simpleMessage(
      "Beschreibung (Erforderlich)",
    ),
    "detailCategory": MessageLookupByLibrary.simpleMessage("Detailkategorie"),
    "deutschlabel": MessageLookupByLibrary.simpleMessage("Deutsch"),
    "documentarymovielabel": MessageLookupByLibrary.simpleMessage(
      "Dokumentarfilme",
    ),
    "dramamovielabel": MessageLookupByLibrary.simpleMessage("Dramafilme"),
    "editprofilelabel": MessageLookupByLibrary.simpleMessage(
      "Profil bearbeiten",
    ),
    "egyptmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Ägyptische Filme",
    ),
    "egypttvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Ägyptische Serien",
    ),
    "email": MessageLookupByLibrary.simpleMessage("E-Mail"),
    "emailaddresslabel": MessageLookupByLibrary.simpleMessage("E-Mail-Adresse"),
    "englishlabel": MessageLookupByLibrary.simpleMessage("Englisch"),
    "enterFirstName": MessageLookupByLibrary.simpleMessage(
      "Gib einen Vornamen ein.",
    ),
    "enterPassword": MessageLookupByLibrary.simpleMessage(
      "Gib dein Passwort ein.",
    ),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Gib eine gültige E-Mail-Adresse ein.",
    ),
    "episodesCount": m5,
    "error": MessageLookupByLibrary.simpleMessage("Fehler"),
    "errorLoginAgain": MessageLookupByLibrary.simpleMessage(
      "Fehler, bitte melden Sie sich erneut an und versuchen Sie es noch einmal",
    ),
    "errorTitle": MessageLookupByLibrary.simpleMessage("Fehler"),
    "explorenavbar": MessageLookupByLibrary.simpleMessage("Suche"),
    "familymovielabel": MessageLookupByLibrary.simpleMessage("Familienfilme"),
    "fantasymovielabel": MessageLookupByLibrary.simpleMessage("Fantasiefilme"),
    "filterAll": MessageLookupByLibrary.simpleMessage("Alle"),
    "filterLabel": MessageLookupByLibrary.simpleMessage("Filtern"),
    "firstnamelabel": MessageLookupByLibrary.simpleMessage("Vorname"),
    "forgetPasswordPageQuestion": MessageLookupByLibrary.simpleMessage(
      "Gib die mit deinem Konto verknüpfte E-Mail-Adresse ein",
    ),
    "forgotpasswordlabel": MessageLookupByLibrary.simpleMessage(
      "Passwort vergessen?",
    ),
    "fullUserProfile": MessageLookupByLibrary.simpleMessage(
      "Vollständiges Benutzerprofil",
    ),
    "generalsettingslabel": MessageLookupByLibrary.simpleMessage("Allgemein"),
    "genericError": MessageLookupByLibrary.simpleMessage(
      "Etwas ist schiefgelaufen. Bitte versuche es erneut.",
    ),
    "globalreviewswitch": MessageLookupByLibrary.simpleMessage(
      "Globale Bewertung",
    ),
    "hello": MessageLookupByLibrary.simpleMessage("Hallo"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("Passwort ausblenden"),
    "hindilabel": MessageLookupByLibrary.simpleMessage("Hindi"),
    "historymovielabel": MessageLookupByLibrary.simpleMessage(
      "Geschichtsfilme",
    ),
    "homenavbar": MessageLookupByLibrary.simpleMessage("Startseite"),
    "horrormovielabel": MessageLookupByLibrary.simpleMessage("Horrorfilme"),
    "id": MessageLookupByLibrary.simpleMessage("ID"),
    "inWatchlist": MessageLookupByLibrary.simpleMessage("In der Merkliste"),
    "italianlabel": MessageLookupByLibrary.simpleMessage("Italienisch"),
    "kidstvlabel": MessageLookupByLibrary.simpleMessage(
      "Kinderfernsehsendungen",
    ),
    "lastnamelabel": MessageLookupByLibrary.simpleMessage("Nachname"),
    "libraryLiked": MessageLookupByLibrary.simpleMessage("Gemocht"),
    "libraryNoMatches": MessageLookupByLibrary.simpleMessage(
      "Keine Titel passen zu diesem Filter.",
    ),
    "libraryWatchlist": MessageLookupByLibrary.simpleMessage("Merkliste"),
    "like": MessageLookupByLibrary.simpleMessage("Gefällt mir"),
    "liked": MessageLookupByLibrary.simpleMessage("Gemocht"),
    "likedEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Tippe bei einem Film oder einer Serie auf ♡, um sie hier zu speichern.",
    ),
    "likednavbar": MessageLookupByLibrary.simpleMessage("Bibliothek"),
    "localreviewswitch": MessageLookupByLibrary.simpleMessage(
      "Lokale Bewertung",
    ),
    "logInToReview": MessageLookupByLibrary.simpleMessage(
      "Anmelden, um zu bewerten",
    ),
    "loginbuttonlabel": MessageLookupByLibrary.simpleMessage("Anmelden"),
    "logintocontinue": MessageLookupByLibrary.simpleMessage(
      "Bitte anmelden, um fortzufahren",
    ),
    "logoutlabel": MessageLookupByLibrary.simpleMessage("Abmelden"),
    "managesettingslabel": MessageLookupByLibrary.simpleMessage("Verwalten"),
    "mediaMovie": MessageLookupByLibrary.simpleMessage("Film"),
    "mediaTvShow": MessageLookupByLibrary.simpleMessage("Serie"),
    "mediatypemoviess": MessageLookupByLibrary.simpleMessage("Filme"),
    "minute": MessageLookupByLibrary.simpleMessage("Min"),
    "moviesKnownFor": MessageLookupByLibrary.simpleMessage("Bekannt für Filme"),
    "movieswitch": MessageLookupByLibrary.simpleMessage("Filme"),
    "musicmovielabel": MessageLookupByLibrary.simpleMessage("Musikfilme"),
    "mysterymovielabel": MessageLookupByLibrary.simpleMessage("Mysterienfilme"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "newPasswordLabel": MessageLookupByLibrary.simpleMessage("Neues Passwort"),
    "newstvlabel": MessageLookupByLibrary.simpleMessage(
      "Nachrichten Fernsehsendungen",
    ),
    "noBirthdayFound": MessageLookupByLibrary.simpleMessage(
      "Kein Geburtsdatum gefunden",
    ),
    "noDataFound": MessageLookupByLibrary.simpleMessage("Nichts zu zeigen"),
    "noImage": MessageLookupByLibrary.simpleMessage("Kein Bild"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "Keine Internetverbindung",
    ),
    "noInternetMessage": MessageLookupByLibrary.simpleMessage(
      "Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut",
    ),
    "noReport": MessageLookupByLibrary.simpleMessage("Keine Meldungen"),
    "noResults": MessageLookupByLibrary.simpleMessage("Keine Ergebnisse"),
    "noResultsFor": m6,
    "noResultsMessage": MessageLookupByLibrary.simpleMessage(
      "Keine Ergebnisse für Ihre Suche gefunden",
    ),
    "noReviews": MessageLookupByLibrary.simpleMessage("Keine Bewertungen"),
    "noUserDataAvailable": MessageLookupByLibrary.simpleMessage(
      "Keine Benutzerdaten verfügbar",
    ),
    "noVideos": MessageLookupByLibrary.simpleMessage("Keine Videos"),
    "nobiographyfound": MessageLookupByLibrary.simpleMessage(
      "Keine Biografie verfügbar",
    ),
    "nobuyon": MessageLookupByLibrary.simpleMessage(
      "Keine Kaufdienste verfügbar",
    ),
    "noimage": MessageLookupByLibrary.simpleMessage("Kein Bild"),
    "nointernetconnection": MessageLookupByLibrary.simpleMessage(
      "Keine Internetverbindung",
    ),
    "nolikedmovies": MessageLookupByLibrary.simpleMessage(
      "Noch keine gemochten Titel",
    ),
    "nomoviesinwatchlist": MessageLookupByLibrary.simpleMessage(
      "Ihre Merkliste ist leer.\nBeginnen Sie damit, einige Filme zur Merkliste hinzuzufügen und entdecken Sie Ihre Favoriten!",
    ),
    "notNowLabel": MessageLookupByLibrary.simpleMessage("Nicht jetzt"),
    "notamemberlabel": MessageLookupByLibrary.simpleMessage(
      "Noch kein Mitglied?",
    ),
    "notvshowsinwatchlist": MessageLookupByLibrary.simpleMessage(
      "Ihre Merkliste ist leer.\nBeginnen Sie damit, einige Fernsehsendungen zur Merkliste hinzuzufügen und entdecken Sie Ihre Favoriten!",
    ),
    "nowatchmovieon": MessageLookupByLibrary.simpleMessage(
      "Keine Streaming-Dienste verfügbar",
    ),
    "numberofepisodes": MessageLookupByLibrary.simpleMessage(
      "Anzahl der Episoden",
    ),
    "numberofseasons": MessageLookupByLibrary.simpleMessage(
      "Anzahl der Staffeln",
    ),
    "ohnolabel": MessageLookupByLibrary.simpleMessage("Oh Nein!"),
    "okLabel": MessageLookupByLibrary.simpleMessage("OK"),
    "openInImdb": MessageLookupByLibrary.simpleMessage("In IMDb öffnen"),
    "passwordMigrationBody": MessageLookupByLibrary.simpleMessage(
      "Movie Night verwendet jetzt ein neues Anmeldesystem. Wenn du vor diesem Update ein Konto hattest, funktioniert dein altes Passwort nicht mehr. Setze es einmal zurück, um dein Konto weiter zu nutzen.",
    ),
    "passwordMigrationTitle": MessageLookupByLibrary.simpleMessage(
      "Passwort einmal zurücksetzen",
    ),
    "passwordUpdated": MessageLookupByLibrary.simpleMessage(
      "Dein Passwort wurde aktualisiert.",
    ),
    "passwordconfirmlabel": MessageLookupByLibrary.simpleMessage(
      "Passwort bestätigen",
    ),
    "passwordlabel": MessageLookupByLibrary.simpleMessage("Passwort"),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "Die Passwörter stimmen nicht überein.",
    ),
    "passwordvalidationtext": MessageLookupByLibrary.simpleMessage(
      "Verwende mindestens 8 Zeichen, darunter einen Großbuchstaben, einen Kleinbuchstaben, eine Zahl und ein Sonderzeichen.",
    ),
    "playVideo": m7,
    "pleasecheckinternetconnection": MessageLookupByLibrary.simpleMessage(
      "Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut",
    ),
    "pleasefillallfields": MessageLookupByLibrary.simpleMessage(
      "Bitte füllen Sie alle Felder aus",
    ),
    "popularmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Beliebte Filme",
    ),
    "populartvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Beliebte Serien",
    ),
    "poweredby": MessageLookupByLibrary.simpleMessage("Bereitgestellt von"),
    "privacylabel": MessageLookupByLibrary.simpleMessage("Datenschutz"),
    "profilePicUploadFailed": MessageLookupByLibrary.simpleMessage(
      "Profilbild konnte nicht hochgeladen werden. Bitte erneut versuchen.",
    ),
    "profileSignInBody": MessageLookupByLibrary.simpleMessage(
      "Führe eine Merkliste, schreibe Bewertungen und nimm dein Profil auf jedes Gerät mit.",
    ),
    "profileSignInTitle": MessageLookupByLibrary.simpleMessage(
      "Bei Movie Night anmelden",
    ),
    "profilenavbar": MessageLookupByLibrary.simpleMessage("Profil"),
    "rateMovieNight": MessageLookupByLibrary.simpleMessage(
      "Movie Night Bewerten",
    ),
    "ratingOutOf10": m8,
    "readLess": MessageLookupByLibrary.simpleMessage("Weniger anzeigen"),
    "readmorelabel": MessageLookupByLibrary.simpleMessage("Mehr lesen"),
    "realitytvlabel": MessageLookupByLibrary.simpleMessage(
      "Reality-Fernsehsendungen",
    ),
    "registarnowlabel": MessageLookupByLibrary.simpleMessage("Konto erstellen"),
    "removeFromHistory": MessageLookupByLibrary.simpleMessage("Entfernen"),
    "removeFromLiked": MessageLookupByLibrary.simpleMessage(
      "Aus „Gefällt mir“ entfernen",
    ),
    "removedFromLiked": MessageLookupByLibrary.simpleMessage(
      "Aus Gemocht entfernt",
    ),
    "removedFromWatchlist": MessageLookupByLibrary.simpleMessage(
      "Aus der Merkliste entfernt",
    ),
    "removefromwatchlist": MessageLookupByLibrary.simpleMessage(
      "Aus der Merkliste entfernen",
    ),
    "report": MessageLookupByLibrary.simpleMessage("Meldung"),
    "reportDescriptionRequired": MessageLookupByLibrary.simpleMessage(
      "Füge eine Beschreibung hinzu.",
    ),
    "reportFailed": MessageLookupByLibrary.simpleMessage(
      "Die Meldung konnte nicht gesendet werden. Versuche es erneut.",
    ),
    "reportPage": MessageLookupByLibrary.simpleMessage("Meldungsseite"),
    "reportSent": MessageLookupByLibrary.simpleMessage(
      "Meldung gesendet. Danke, dass du hilfst, Movie Night zu verbessern.",
    ),
    "reportSummaryRequired": MessageLookupByLibrary.simpleMessage(
      "Füge eine kurze Zusammenfassung hinzu.",
    ),
    "reportabuglabel": MessageLookupByLibrary.simpleMessage(
      "Einen Fehler melden",
    ),
    "reportpagelabel": MessageLookupByLibrary.simpleMessage(
      "Bitte senden Sie uns einen Bericht, wenn Sie Fehler finden oder Vorschläge für die App haben.",
    ),
    "resetLinkSent": m9,
    "resetPassword": MessageLookupByLibrary.simpleMessage(
      "Passwort zurücksetzen",
    ),
    "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wir senden dir einen Link zum Zurücksetzen",
    ),
    "reviewsTitle": MessageLookupByLibrary.simpleMessage("Bewertungen"),
    "role": MessageLookupByLibrary.simpleMessage("Rolle"),
    "romancemovielabel": MessageLookupByLibrary.simpleMessage("Liebesfilme"),
    "runtimeHoursMinutes": m10,
    "runtimeHoursOnly": m11,
    "runtimeMinutesOnly": m12,
    "savePasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Passwort speichern",
    ),
    "savelabel": MessageLookupByLibrary.simpleMessage("Speichern"),
    "sciencefictionmovielabel": MessageLookupByLibrary.simpleMessage(
      "Science-Fiction-Filme",
    ),
    "scifitvlabel": MessageLookupByLibrary.simpleMessage(
      "Sci-Fi & Fantasy Fernsehsendungen",
    ),
    "searchhint": MessageLookupByLibrary.simpleMessage(
      "Filme, Serien, Personen",
    ),
    "seasonsCount": m13,
    "seeAllReviews": m14,
    "sendEmail": MessageLookupByLibrary.simpleMessage("E-Mail senden"),
    "sendReviewTooltip": MessageLookupByLibrary.simpleMessage(
      "Rezension senden",
    ),
    "sendfeedbacklabel": MessageLookupByLibrary.simpleMessage(
      "Feedback senden",
    ),
    "sendreportlabel": MessageLookupByLibrary.simpleMessage("Bericht senden"),
    "setNewPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wähle ein neues Passwort für dein Konto.",
    ),
    "setNewPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Neues Passwort festlegen",
    ),
    "share": MessageLookupByLibrary.simpleMessage("Teilen"),
    "shareText": m15,
    "showAll": MessageLookupByLibrary.simpleMessage("Alle anzeigen"),
    "showPassword": MessageLookupByLibrary.simpleMessage("Passwort anzeigen"),
    "signInPromptBody": MessageLookupByLibrary.simpleMessage(
      "Melde dich an, um eine Merkliste zu führen, Titel zu mögen und Bewertungen zu schreiben.",
    ),
    "signInPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Zum Speichern von Titeln anmelden",
    ),
    "signInToReview": MessageLookupByLibrary.simpleMessage(
      "Melde dich an, um Bewertungen zu lesen und zu schreiben.",
    ),
    "signupbuttonlabel": MessageLookupByLibrary.simpleMessage(
      "Konto erstellen",
    ),
    "soaptvlabel": MessageLookupByLibrary.simpleMessage(
      "Seifenoper-Fernsehsendungen",
    ),
    "somethingwentwrong": MessageLookupByLibrary.simpleMessage(
      "Das konnte nicht geladen werden. Versuche es erneut.",
    ),
    "spanishlabel": MessageLookupByLibrary.simpleMessage("Spanisch"),
    "storyline": MessageLookupByLibrary.simpleMessage("Handlung"),
    "success": MessageLookupByLibrary.simpleMessage("Erfolg"),
    "summaryhint": MessageLookupByLibrary.simpleMessage(
      "Beschreiben Sie das Problem kurz",
    ),
    "summarylabel": MessageLookupByLibrary.simpleMessage(
      "Zusammenfassung (Erforderlich)",
    ),
    "talktvlabel": MessageLookupByLibrary.simpleMessage(
      "Talkshow-Fernsehsendungen",
    ),
    "thecast": MessageLookupByLibrary.simpleMessage("Die Besetzung"),
    "thrillermovielabel": MessageLookupByLibrary.simpleMessage("Thrillerfilme"),
    "titlesCount": m16,
    "tmdbLabel": MessageLookupByLibrary.simpleMessage("TMDB"),
    "trendingmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Trendfilme",
    ),
    "trendingtvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Trendserien",
    ),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Erneut versuchen"),
    "tvActionAdventure": MessageLookupByLibrary.simpleMessage(
      "Action & Abenteuer",
    ),
    "tvSciFiFantasy": MessageLookupByLibrary.simpleMessage("Sci-Fi & Fantasy"),
    "tvShowsKnownFor": MessageLookupByLibrary.simpleMessage(
      "Bekannt für Serien",
    ),
    "tvWarPolitics": MessageLookupByLibrary.simpleMessage("Krieg & Politik"),
    "tvkids": MessageLookupByLibrary.simpleMessage("Kinder"),
    "tvmovielabel": MessageLookupByLibrary.simpleMessage("TV-Filme"),
    "tvnews": MessageLookupByLibrary.simpleMessage("Nachrichten"),
    "tvreality": MessageLookupByLibrary.simpleMessage("Reality"),
    "tvsoap": MessageLookupByLibrary.simpleMessage("Seifenoper"),
    "tvswitch": MessageLookupByLibrary.simpleMessage("Serien"),
    "tvtalk": MessageLookupByLibrary.simpleMessage("Talkshow"),
    "undo": MessageLookupByLibrary.simpleMessage("Rückgängig"),
    "unlike": MessageLookupByLibrary.simpleMessage("Gefällt nicht mehr"),
    "upcomingwidget_title": MessageLookupByLibrary.simpleMessage(
      "Kommende Filme",
    ),
    "updateaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Konto aktualisieren",
    ),
    "updateprofilelabel": MessageLookupByLibrary.simpleMessage(
      "Profil aktualisieren",
    ),
    "updateprofilesuccess": MessageLookupByLibrary.simpleMessage(
      "Profil aktualisiert",
    ),
    "userProfile": MessageLookupByLibrary.simpleMessage("Benutzerprofil"),
    "videoslabel": MessageLookupByLibrary.simpleMessage("Videos"),
    "viewFullDetails": MessageLookupByLibrary.simpleMessage(
      "Vollständige Details anzeigen",
    ),
    "viewPosterFullScreen": MessageLookupByLibrary.simpleMessage(
      "Poster im Vollbild ansehen",
    ),
    "viewReports": MessageLookupByLibrary.simpleMessage("Meldungen anzeigen"),
    "warmovielabel": MessageLookupByLibrary.simpleMessage("Kriegsfilme"),
    "wartvlabel": MessageLookupByLibrary.simpleMessage(
      "Krieg & Politik Fernsehsendungen",
    ),
    "watchTrailers": MessageLookupByLibrary.simpleMessage("Trailer ansehen"),
    "watchlistEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Füge Titel zu deiner Merkliste hinzu, um sie später hier zu finden.",
    ),
    "watchlistEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Deine Merkliste ist leer",
    ),
    "watchlistSignInBody": MessageLookupByLibrary.simpleMessage(
      "Deine Merkliste wird in deinem Konto gespeichert und ist so auf jedem Gerät verfügbar.",
    ),
    "watchlistSignInTitle": MessageLookupByLibrary.simpleMessage(
      "Anmelden, um die Merkliste zu nutzen",
    ),
    "watchlistUpdateFailed": MessageLookupByLibrary.simpleMessage(
      "Die Merkliste konnte nicht aktualisiert werden. Versuche es erneut.",
    ),
    "watchlistlabel": MessageLookupByLibrary.simpleMessage("Merkliste"),
    "watchon": MessageLookupByLibrary.simpleMessage("Ansehen auf"),
    "watchvideosbuttonlabel": MessageLookupByLibrary.simpleMessage(
      "Videos ansehen",
    ),
    "welcomemessage": MessageLookupByLibrary.simpleMessage("Willkommen zurück"),
    "westernmovielabel": MessageLookupByLibrary.simpleMessage("Westernfilme"),
    "writeReview": MessageLookupByLibrary.simpleMessage("Bewertung schreiben"),
  };
}
