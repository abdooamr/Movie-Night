// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static String m0(name) => "${name} ora è admin";

  static String m1(character) => "Nel ruolo di ${character}";

  static String m2(email) =>
      "Controlla la tua email. Abbiamo inviato un link a ${email}. Aprilo per attivare il tuo account, poi accedi.";

  static String m3(section) => "Impossibile caricare ${section}.";

  static String m4(name) => "Eliminare ${name}?";

  static String m5(count) =>
      "${Intl.plural(count, one: '1 episodio', other: '${count} episodi')}";

  static String m6(query) =>
      "Nessun risultato per “${query}”. Controlla l\'ortografia o prova un altro titolo.";

  static String m7(title) => "Riproduci ${title}";

  static String m8(rank, title) => "Posizione ${rank}: ${title}";

  static String m9(score) => "${score} su 10";

  static String m10(email) =>
      "Controlla la tua email. Abbiamo inviato un link di reimpostazione a ${email}.";

  static String m11(hours, minutes) => "${hours} h ${minutes} min";

  static String m12(hours) => "${hours} h";

  static String m13(minutes) => "${minutes} min";

  static String m14(count) =>
      "${Intl.plural(count, one: '1 stagione', other: '${count} stagioni')}";

  static String m15(count) => "Vedi tutte le recensioni (${count})";

  static String m16(title, url) => "Guarda ${title} su Movie Night\n${url}";

  static String m17(count) =>
      "${Intl.plural(count, one: '1 titolo', other: '${count} titoli')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Actiongenre": MessageLookupByLibrary.simpleMessage("Azione"),
    "Adventuregenre": MessageLookupByLibrary.simpleMessage("Avventura"),
    "Animationgenre": MessageLookupByLibrary.simpleMessage("Animazione"),
    "Comedygenre": MessageLookupByLibrary.simpleMessage("Commedia"),
    "Crimegenre": MessageLookupByLibrary.simpleMessage("Crimine"),
    "Documentarygenre": MessageLookupByLibrary.simpleMessage("Documentario"),
    "Dramagenre": MessageLookupByLibrary.simpleMessage("Dramma"),
    "Familygenre": MessageLookupByLibrary.simpleMessage("Famiglia"),
    "Fantasygenre": MessageLookupByLibrary.simpleMessage("Fantasy"),
    "Frenchlabel": MessageLookupByLibrary.simpleMessage("Francese"),
    "Heylabel": MessageLookupByLibrary.simpleMessage("Ciao"),
    "Heytherelabel": MessageLookupByLibrary.simpleMessage("Ciao"),
    "Historygenre": MessageLookupByLibrary.simpleMessage("Storico"),
    "Horrorgenre": MessageLookupByLibrary.simpleMessage("Horror"),
    "Musicgenre": MessageLookupByLibrary.simpleMessage("Musica"),
    "Mysterygenre": MessageLookupByLibrary.simpleMessage("Mistero"),
    "OhNo": MessageLookupByLibrary.simpleMessage("Oh No!"),
    "Recommendation": MessageLookupByLibrary.simpleMessage("Raccomandazione"),
    "Romancegenre": MessageLookupByLibrary.simpleMessage("Romantico"),
    "ScienceFictiongenre": MessageLookupByLibrary.simpleMessage("Fantascienza"),
    "Seealloptions": MessageLookupByLibrary.simpleMessage("Vedi Tutto"),
    "TVMoviegenre": MessageLookupByLibrary.simpleMessage("Film TV"),
    "Thrillergenre": MessageLookupByLibrary.simpleMessage("Thriller"),
    "Usernamelabel": MessageLookupByLibrary.simpleMessage("Nome Utente"),
    "Wargenre": MessageLookupByLibrary.simpleMessage("Guerra"),
    "Westerngenre": MessageLookupByLibrary.simpleMessage("Western"),
    "accountGroupLabel": MessageLookupByLibrary.simpleMessage("Account"),
    "accountinfolabel": MessageLookupByLibrary.simpleMessage(
      "Informazioni Account",
    ),
    "accountsettingslabel": MessageLookupByLibrary.simpleMessage(
      "Impostazioni Account",
    ),
    "accountsettingssubtitle": MessageLookupByLibrary.simpleMessage(
      "Modifica account, Privacy, Cambio lingua",
    ),
    "actionmovielabel": MessageLookupByLibrary.simpleMessage("Film d\'Azione"),
    "actiontvlabel": MessageLookupByLibrary.simpleMessage(
      "Serie TV Azione e Avventura",
    ),
    "addAdmin": MessageLookupByLibrary.simpleMessage("Aggiungi admin"),
    "addtowatchlist": MessageLookupByLibrary.simpleMessage(
      "Aggiungi alla Lista dei Preferiti",
    ),
    "adminActions": MessageLookupByLibrary.simpleMessage("Azioni"),
    "adminCopyId": MessageLookupByLibrary.simpleMessage("Copia ID utente"),
    "adminDetails": MessageLookupByLibrary.simpleMessage("Dettagli"),
    "adminFilterAdmins": MessageLookupByLibrary.simpleMessage("Admin"),
    "adminFilterReported": MessageLookupByLibrary.simpleMessage("Segnalati"),
    "adminIdCopied": MessageLookupByLibrary.simpleMessage("ID utente copiato"),
    "adminMakeAdmin": MessageLookupByLibrary.simpleMessage("Rendi admin"),
    "adminMakeAdminHint": MessageLookupByLibrary.simpleMessage(
      "Può aprire questo pannello e gestire gli utenti",
    ),
    "adminNoUsersFound": MessageLookupByLibrary.simpleMessage(
      "Nessun utente trovato",
    ),
    "adminNoUsersHint": MessageLookupByLibrary.simpleMessage(
      "Prova un altro nome o email.",
    ),
    "adminNowAdmin": m0,
    "adminPanel": MessageLookupByLibrary.simpleMessage("Pannello admin"),
    "adminReportCleared": MessageLookupByLibrary.simpleMessage(
      "Segnalazione rimossa",
    ),
    "adminRoleUser": MessageLookupByLibrary.simpleMessage("Utente"),
    "adminSearchHint": MessageLookupByLibrary.simpleMessage(
      "Cerca per nome o email",
    ),
    "adminStatus": MessageLookupByLibrary.simpleMessage("Stato"),
    "adminUserId": MessageLookupByLibrary.simpleMessage("ID utente"),
    "adminUserTitle": MessageLookupByLibrary.simpleMessage("Utente"),
    "adminpanellabel": MessageLookupByLibrary.simpleMessage(
      "Pannello di Amministrazione",
    ),
    "adminsettingslabel": MessageLookupByLibrary.simpleMessage(
      "Amministrazione",
    ),
    "adventuremovielabel": MessageLookupByLibrary.simpleMessage(
      "Film d\'Avventura",
    ),
    "airingtodaywidget_title": MessageLookupByLibrary.simpleMessage(
      "In Onda Oggi",
    ),
    "alreadyhaveanaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Hai già un account?",
    ),
    "animationmovielabel": MessageLookupByLibrary.simpleMessage(
      "Film d\'Animazione",
    ),
    "appearance": MessageLookupByLibrary.simpleMessage("Aspetto"),
    "appearanceDark": MessageLookupByLibrary.simpleMessage("Scuro"),
    "appearanceLight": MessageLookupByLibrary.simpleMessage("Chiaro"),
    "appearanceSystem": MessageLookupByLibrary.simpleMessage("Sistema"),
    "arabiclabel": MessageLookupByLibrary.simpleMessage("Arabo"),
    "authErrorEmailInUse": MessageLookupByLibrary.simpleMessage(
      "Esiste già un account con questa email.",
    ),
    "authErrorEmailNotConfirmed": MessageLookupByLibrary.simpleMessage(
      "Prima conferma la tua email. Apri il link che ti abbiamo inviato, poi accedi.",
    ),
    "authErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Impossibile completare l\'operazione. Riprova.",
    ),
    "authErrorInvalidCredential": MessageLookupByLibrary.simpleMessage(
      "Email o password non corretti.",
    ),
    "authErrorInvalidEmail": MessageLookupByLibrary.simpleMessage(
      "Inserisci un\'email come nome@esempio.com.",
    ),
    "authErrorNetwork": MessageLookupByLibrary.simpleMessage(
      "Sei offline. Controlla la connessione e riprova.",
    ),
    "authErrorRecentLogin": MessageLookupByLibrary.simpleMessage(
      "Per la tua sicurezza, accedi di nuovo per eliminare il tuo account.",
    ),
    "authErrorSamePassword": MessageLookupByLibrary.simpleMessage(
      "Scegli una password diversa da quella attuale.",
    ),
    "authErrorTooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Troppi tentativi. Riprova tra qualche minuto.",
    ),
    "authErrorUserNotFound": MessageLookupByLibrary.simpleMessage(
      "Nessun account usa questa email.",
    ),
    "authErrorWeakPassword": MessageLookupByLibrary.simpleMessage(
      "Scegli una password più sicura.",
    ),
    "backOnline": MessageLookupByLibrary.simpleMessage("Sei di nuovo online."),
    "backToLogIn": MessageLookupByLibrary.simpleMessage("Torna ad Accedi"),
    "beFirstToReview": MessageLookupByLibrary.simpleMessage(
      "Ancora nessuna recensione. Scrivi la prima.",
    ),
    "biography": MessageLookupByLibrary.simpleMessage("Biografia"),
    "browseMovies": MessageLookupByLibrary.simpleMessage("Sfoglia i film"),
    "buyon": MessageLookupByLibrary.simpleMessage("Acquista su"),
    "cancelLabel": MessageLookupByLibrary.simpleMessage("Annulla"),
    "castAs": m1,
    "changeProfilePhoto": MessageLookupByLibrary.simpleMessage(
      "Cambia Foto Profilo",
    ),
    "changelanguagelabel": MessageLookupByLibrary.simpleMessage(
      "Cambia Lingua",
    ),
    "changepassworderror": MessageLookupByLibrary.simpleMessage(
      "Errore nel Cambio Password. Per favore riprova",
    ),
    "changepasswordlabel": MessageLookupByLibrary.simpleMessage(
      "Cambia Password",
    ),
    "changepasswordsuccess": MessageLookupByLibrary.simpleMessage(
      "Password Cambiata con Successo",
    ),
    "clearHistory": MessageLookupByLibrary.simpleMessage("Cancella"),
    "clearReport": MessageLookupByLibrary.simpleMessage(
      "Cancella segnalazione",
    ),
    "clearSearchTooltip": MessageLookupByLibrary.simpleMessage(
      "Cancella ricerca",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Chiudi"),
    "comedymovielabel": MessageLookupByLibrary.simpleMessage("Film Commedia"),
    "confirmEmailSent": m2,
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Continua con Google",
    ),
    "couldntLoadSection": m3,
    "couldntLoadTitle": MessageLookupByLibrary.simpleMessage(
      "Impossibile caricare questo titolo.",
    ),
    "createaccountlabel": MessageLookupByLibrary.simpleMessage("Crea Account"),
    "crimemovielabel": MessageLookupByLibrary.simpleMessage("Film Crimine"),
    "darkmodelabel": MessageLookupByLibrary.simpleMessage("Modalità Scuro"),
    "delete": MessageLookupByLibrary.simpleMessage("Elimina"),
    "deleteAccountDone": MessageLookupByLibrary.simpleMessage(
      "Il tuo account è stato eliminato.",
    ),
    "deleteAccountMessage": MessageLookupByLibrary.simpleMessage(
      "Il tuo profilo, la watchlist e le recensioni verranno eliminati definitivamente. L\'operazione non può essere annullata.",
    ),
    "deleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminare l\'account?",
    ),
    "deleteBookmark": MessageLookupByLibrary.simpleMessage(
      "Elimina segnalibro",
    ),
    "deleteBookmarkConfirmation": MessageLookupByLibrary.simpleMessage(
      "Sei sicuro di voler eliminare questo segnalibro? Questa azione non può essere annullata.",
    ),
    "deleteReviewMessage": MessageLookupByLibrary.simpleMessage(
      "L\'operazione non può essere annullata.",
    ),
    "deleteReviewTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminare la recensione?",
    ),
    "deleteReviewTooltip": MessageLookupByLibrary.simpleMessage(
      "Elimina recensione",
    ),
    "deleteUser": MessageLookupByLibrary.simpleMessage("Elimina utente"),
    "deleteUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Sei sicuro di voler eliminare il tuo account? Questa azione non può essere annullata.",
    ),
    "deleteUserTitle": m4,
    "deleteaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Elimina Account",
    ),
    "deleteerror": MessageLookupByLibrary.simpleMessage(
      "Errore nell\'Eliminazione dell\'Account. Effettua nuovamente il login e riprova",
    ),
    "descriptionhint": MessageLookupByLibrary.simpleMessage(
      "Spiega dettagliatamente il problema",
    ),
    "descriptionlabel": MessageLookupByLibrary.simpleMessage(
      "Descrizione  (Obbligatorio)",
    ),
    "detailCategory": MessageLookupByLibrary.simpleMessage(
      "Categoria dettaglio",
    ),
    "deutschlabel": MessageLookupByLibrary.simpleMessage("Tedesco"),
    "documentarymovielabel": MessageLookupByLibrary.simpleMessage(
      "Film Documentario",
    ),
    "dramamovielabel": MessageLookupByLibrary.simpleMessage("Film Dramma"),
    "editprofilelabel": MessageLookupByLibrary.simpleMessage(
      "Modifica Profilo",
    ),
    "egyptmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Film egiziani",
    ),
    "egypttvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Serie egiziane",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailaddresslabel": MessageLookupByLibrary.simpleMessage(
      "Indirizzo Email",
    ),
    "englishlabel": MessageLookupByLibrary.simpleMessage("Inglese"),
    "enterFirstName": MessageLookupByLibrary.simpleMessage(
      "Inserisci un nome.",
    ),
    "enterPassword": MessageLookupByLibrary.simpleMessage(
      "Inserisci la tua password.",
    ),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Inserisci un indirizzo email valido.",
    ),
    "episodesCount": m5,
    "error": MessageLookupByLibrary.simpleMessage("Errore"),
    "errorLoginAgain": MessageLookupByLibrary.simpleMessage(
      "Errore, accedi di nuovo e riprova",
    ),
    "errorTitle": MessageLookupByLibrary.simpleMessage("Errore"),
    "explorenavbar": MessageLookupByLibrary.simpleMessage("Cerca"),
    "familymovielabel": MessageLookupByLibrary.simpleMessage("Film Famiglia"),
    "fantasymovielabel": MessageLookupByLibrary.simpleMessage("Film Fantasy"),
    "filterAll": MessageLookupByLibrary.simpleMessage("Tutti"),
    "filterLabel": MessageLookupByLibrary.simpleMessage("Filtra"),
    "firstnamelabel": MessageLookupByLibrary.simpleMessage("Nome"),
    "forgetPasswordPageQuestion": MessageLookupByLibrary.simpleMessage(
      "Inserisci l’email associata al tuo account",
    ),
    "forgotpasswordlabel": MessageLookupByLibrary.simpleMessage(
      "Password dimenticata?",
    ),
    "fullUserProfile": MessageLookupByLibrary.simpleMessage(
      "Profilo completo dell’utente",
    ),
    "generalsettingslabel": MessageLookupByLibrary.simpleMessage("Generali"),
    "genericError": MessageLookupByLibrary.simpleMessage(
      "Qualcosa è andato storto. Riprova.",
    ),
    "globalreviewswitch": MessageLookupByLibrary.simpleMessage(
      "Revisione Globale",
    ),
    "hello": MessageLookupByLibrary.simpleMessage("Ciao"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("Nascondi password"),
    "hindilabel": MessageLookupByLibrary.simpleMessage("Hindi"),
    "historymovielabel": MessageLookupByLibrary.simpleMessage("Film Storico"),
    "homenavbar": MessageLookupByLibrary.simpleMessage("Home"),
    "horrormovielabel": MessageLookupByLibrary.simpleMessage("Film Horror"),
    "id": MessageLookupByLibrary.simpleMessage("ID"),
    "inWatchlist": MessageLookupByLibrary.simpleMessage("Nella Watchlist"),
    "italianlabel": MessageLookupByLibrary.simpleMessage("Italiano"),
    "kidstvlabel": MessageLookupByLibrary.simpleMessage("Serie TV per Bambini"),
    "lastnamelabel": MessageLookupByLibrary.simpleMessage("Cognome"),
    "libraryLiked": MessageLookupByLibrary.simpleMessage("Preferiti"),
    "libraryNoMatches": MessageLookupByLibrary.simpleMessage(
      "Nessun titolo corrisponde a questo filtro.",
    ),
    "libraryWatchlist": MessageLookupByLibrary.simpleMessage("Watchlist"),
    "like": MessageLookupByLibrary.simpleMessage("Mi Piace"),
    "liked": MessageLookupByLibrary.simpleMessage("Preferito"),
    "likedEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Tocca ♡ su un film o una serie per tenerlo qui.",
    ),
    "likednavbar": MessageLookupByLibrary.simpleMessage("Libreria"),
    "localreviewswitch": MessageLookupByLibrary.simpleMessage(
      "Revisione Locale",
    ),
    "logInToReview": MessageLookupByLibrary.simpleMessage(
      "Accedi per Scrivere una Recensione",
    ),
    "loginbuttonlabel": MessageLookupByLibrary.simpleMessage("Accedi"),
    "logintocontinue": MessageLookupByLibrary.simpleMessage(
      "Per favore accedi per continuare",
    ),
    "logoutlabel": MessageLookupByLibrary.simpleMessage("Esci"),
    "managesettingslabel": MessageLookupByLibrary.simpleMessage("Gestione"),
    "mediaMovie": MessageLookupByLibrary.simpleMessage("Film"),
    "mediaTvShow": MessageLookupByLibrary.simpleMessage("Serie"),
    "mediatypemoviess": MessageLookupByLibrary.simpleMessage("Film"),
    "minute": MessageLookupByLibrary.simpleMessage("min"),
    "moviesKnownFor": MessageLookupByLibrary.simpleMessage("Famoso per i film"),
    "movieswitch": MessageLookupByLibrary.simpleMessage("Film"),
    "musicmovielabel": MessageLookupByLibrary.simpleMessage("Film Musica"),
    "mysterymovielabel": MessageLookupByLibrary.simpleMessage("Film Mistero"),
    "name": MessageLookupByLibrary.simpleMessage("Nome"),
    "newEpisode": MessageLookupByLibrary.simpleMessage("Nuovo episodio"),
    "newPasswordLabel": MessageLookupByLibrary.simpleMessage("Nuova Password"),
    "newstvlabel": MessageLookupByLibrary.simpleMessage("Serie TV Notizie"),
    "noBirthdayFound": MessageLookupByLibrary.simpleMessage(
      "Nessuna data di nascita trovata",
    ),
    "noDataFound": MessageLookupByLibrary.simpleMessage("Niente da mostrare"),
    "noImage": MessageLookupByLibrary.simpleMessage("Nessuna immagine"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "Nessuna Connessione Internet",
    ),
    "noInternetMessage": MessageLookupByLibrary.simpleMessage(
      "Controlla la tua connessione internet e riprova",
    ),
    "noReport": MessageLookupByLibrary.simpleMessage("Nessuna segnalazione"),
    "noResults": MessageLookupByLibrary.simpleMessage("Nessun Risultato"),
    "noResultsFor": m6,
    "noResultsMessage": MessageLookupByLibrary.simpleMessage(
      "Nessun risultato trovato per la tua ricerca",
    ),
    "noReviews": MessageLookupByLibrary.simpleMessage("Nessuna recensione"),
    "noUserDataAvailable": MessageLookupByLibrary.simpleMessage(
      "Nessun dato utente disponibile",
    ),
    "noVideos": MessageLookupByLibrary.simpleMessage("Nessun video"),
    "nobiographyfound": MessageLookupByLibrary.simpleMessage(
      "Nessuna biografia disponibile",
    ),
    "nobuyon": MessageLookupByLibrary.simpleMessage(
      "Nessun servizio di acquisto disponibile",
    ),
    "noimage": MessageLookupByLibrary.simpleMessage("Nessuna immagine"),
    "nointernetconnection": MessageLookupByLibrary.simpleMessage(
      "Nessuna connessione internet",
    ),
    "nolikedmovies": MessageLookupByLibrary.simpleMessage(
      "Ancora nessun titolo tra i preferiti",
    ),
    "nomoviesinwatchlist": MessageLookupByLibrary.simpleMessage(
      "La tua Lista dei Preferiti è Vuota\nInizia ad aggiungere dei film alla tua lista dei preferiti e scopri i tuoi preferiti!",
    ),
    "notNowLabel": MessageLookupByLibrary.simpleMessage("Non Ora"),
    "notamemberlabel": MessageLookupByLibrary.simpleMessage(
      "Non sei un membro?",
    ),
    "notvshowsinwatchlist": MessageLookupByLibrary.simpleMessage(
      "La tua Lista dei Preferiti è Vuota\nInizia ad aggiungere delle Serie TV alla tua lista dei preferiti e scopri i tuoi preferiti!",
    ),
    "nowatchmovieon": MessageLookupByLibrary.simpleMessage(
      "Nessun servizio di streaming disponibile",
    ),
    "numberofepisodes": MessageLookupByLibrary.simpleMessage(
      "Numero di Episodi",
    ),
    "numberofseasons": MessageLookupByLibrary.simpleMessage(
      "Numero di Stagioni",
    ),
    "ohnolabel": MessageLookupByLibrary.simpleMessage("Oh No!"),
    "okLabel": MessageLookupByLibrary.simpleMessage("OK"),
    "openInImdb": MessageLookupByLibrary.simpleMessage("Apri in IMDb"),
    "passwordMigrationBody": MessageLookupByLibrary.simpleMessage(
      "Movie Night è passato a un nuovo sistema di accesso. Se avevi un account prima di questo aggiornamento, la vecchia password non funziona più. Reimpostala una volta per continuare a usare il tuo account.",
    ),
    "passwordMigrationTitle": MessageLookupByLibrary.simpleMessage(
      "Reimposta la Password una Volta",
    ),
    "passwordUpdated": MessageLookupByLibrary.simpleMessage(
      "La tua password è stata aggiornata.",
    ),
    "passwordconfirmlabel": MessageLookupByLibrary.simpleMessage(
      "Conferma Password",
    ),
    "passwordlabel": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "Le password non corrispondono.",
    ),
    "passwordvalidationtext": MessageLookupByLibrary.simpleMessage(
      "Usa almeno 8 caratteri, tra cui una maiuscola, una minuscola, un numero e un simbolo.",
    ),
    "playVideo": m7,
    "pleasecheckinternetconnection": MessageLookupByLibrary.simpleMessage(
      "per favore controlla la tua connessione Internet e prova di nuovo",
    ),
    "pleasefillallfields": MessageLookupByLibrary.simpleMessage(
      "Per favore completa tutti i campi",
    ),
    "popularmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Film Popolari",
    ),
    "populartvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Serie Popolari",
    ),
    "poweredby": MessageLookupByLibrary.simpleMessage("Realizzato da"),
    "privacylabel": MessageLookupByLibrary.simpleMessage("Privacy"),
    "profilePicUploadFailed": MessageLookupByLibrary.simpleMessage(
      "Impossibile caricare la foto del profilo. Riprova.",
    ),
    "profileSignInBody": MessageLookupByLibrary.simpleMessage(
      "Tieni una watchlist, scrivi recensioni e porta il tuo profilo su ogni dispositivo.",
    ),
    "profileSignInTitle": MessageLookupByLibrary.simpleMessage(
      "Accedi a Movie Night",
    ),
    "profilenavbar": MessageLookupByLibrary.simpleMessage("Profilo"),
    "rankedTitle": m8,
    "rateMovieNight": MessageLookupByLibrary.simpleMessage(
      "Valuta Movie Night",
    ),
    "ratingOutOf10": m9,
    "readLess": MessageLookupByLibrary.simpleMessage("Mostra meno"),
    "readmorelabel": MessageLookupByLibrary.simpleMessage("Leggi tutto"),
    "realitytvlabel": MessageLookupByLibrary.simpleMessage("Serie TV Reality"),
    "registarnowlabel": MessageLookupByLibrary.simpleMessage("Crea Account"),
    "removeFromHistory": MessageLookupByLibrary.simpleMessage("Rimuovi"),
    "removeFromLiked": MessageLookupByLibrary.simpleMessage(
      "Rimuovi dai Preferiti",
    ),
    "removedFromLiked": MessageLookupByLibrary.simpleMessage(
      "Rimosso dai Preferiti",
    ),
    "removedFromWatchlist": MessageLookupByLibrary.simpleMessage(
      "Rimosso dalla Watchlist",
    ),
    "removefromwatchlist": MessageLookupByLibrary.simpleMessage(
      "Rimuovi dalla Lista dei Preferiti",
    ),
    "report": MessageLookupByLibrary.simpleMessage("Segnala"),
    "reportDescriptionRequired": MessageLookupByLibrary.simpleMessage(
      "Aggiungi una descrizione.",
    ),
    "reportFailed": MessageLookupByLibrary.simpleMessage(
      "Impossibile inviare la segnalazione. Riprova.",
    ),
    "reportPage": MessageLookupByLibrary.simpleMessage("Pagina segnalazioni"),
    "reportSent": MessageLookupByLibrary.simpleMessage(
      "Segnalazione inviata. Grazie per aiutarci a migliorare Movie Night.",
    ),
    "reportSummaryRequired": MessageLookupByLibrary.simpleMessage(
      "Aggiungi un breve riepilogo.",
    ),
    "reportabuglabel": MessageLookupByLibrary.simpleMessage("Segnala un Bug"),
    "reportpagelabel": MessageLookupByLibrary.simpleMessage(
      "Per favore inviaci un report se trovi dei bug o hai suggerimenti per l\'app.",
    ),
    "resetLinkSent": m10,
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reimposta Password"),
    "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ti invieremo un link di reimpostazione via email",
    ),
    "reviewsTitle": MessageLookupByLibrary.simpleMessage("Recensioni"),
    "role": MessageLookupByLibrary.simpleMessage("Ruolo"),
    "romancemovielabel": MessageLookupByLibrary.simpleMessage("Film Romance"),
    "runtimeHoursMinutes": m11,
    "runtimeHoursOnly": m12,
    "runtimeMinutesOnly": m13,
    "savePasswordLabel": MessageLookupByLibrary.simpleMessage("Salva Password"),
    "savelabel": MessageLookupByLibrary.simpleMessage("Salva"),
    "sciencefictionmovielabel": MessageLookupByLibrary.simpleMessage(
      "Film Fantascienza",
    ),
    "scifitvlabel": MessageLookupByLibrary.simpleMessage(
      "Serie TV Fantascienza e Fantasy",
    ),
    "searchhint": MessageLookupByLibrary.simpleMessage("Film, serie, persone"),
    "seasonsCount": m14,
    "seeAllReviews": m15,
    "sendEmail": MessageLookupByLibrary.simpleMessage("Invia email"),
    "sendReviewTooltip": MessageLookupByLibrary.simpleMessage(
      "Invia recensione",
    ),
    "sendfeedbacklabel": MessageLookupByLibrary.simpleMessage("Invia Feedback"),
    "sendreportlabel": MessageLookupByLibrary.simpleMessage("Invia Report"),
    "setNewPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Scegli una nuova password per il tuo account.",
    ),
    "setNewPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Imposta una Nuova Password",
    ),
    "share": MessageLookupByLibrary.simpleMessage("Condividi"),
    "shareText": m16,
    "showAll": MessageLookupByLibrary.simpleMessage("Mostra Tutti"),
    "showPassword": MessageLookupByLibrary.simpleMessage("Mostra password"),
    "signInPromptBody": MessageLookupByLibrary.simpleMessage(
      "Accedi per tenere una watchlist, mettere mi piace ai titoli e scrivere recensioni.",
    ),
    "signInPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Accedi per salvare i titoli",
    ),
    "signInToReview": MessageLookupByLibrary.simpleMessage(
      "Accedi per leggere e scrivere recensioni.",
    ),
    "signupbuttonlabel": MessageLookupByLibrary.simpleMessage("Crea Account"),
    "soaptvlabel": MessageLookupByLibrary.simpleMessage("Serie TV Soap"),
    "somethingwentwrong": MessageLookupByLibrary.simpleMessage(
      "Impossibile caricare. Riprova.",
    ),
    "spanishlabel": MessageLookupByLibrary.simpleMessage("Spagnolo"),
    "storyline": MessageLookupByLibrary.simpleMessage("Trama"),
    "success": MessageLookupByLibrary.simpleMessage("Successo"),
    "summaryhint": MessageLookupByLibrary.simpleMessage(
      "Spiega brevemente il problema",
    ),
    "summarylabel": MessageLookupByLibrary.simpleMessage(
      "Sommario  (Obbligatorio)",
    ),
    "talktvlabel": MessageLookupByLibrary.simpleMessage("Serie TV Talk show"),
    "thecast": MessageLookupByLibrary.simpleMessage("Il Cast"),
    "thrillermovielabel": MessageLookupByLibrary.simpleMessage("Film Thriller"),
    "titlesCount": m17,
    "tmdbLabel": MessageLookupByLibrary.simpleMessage("TMDB"),
    "trendingmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Film in Tendenza",
    ),
    "trendingtvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Serie in Tendenza",
    ),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Riprova"),
    "tvActionAdventure": MessageLookupByLibrary.simpleMessage(
      "Azione e Avventura",
    ),
    "tvSciFiFantasy": MessageLookupByLibrary.simpleMessage(
      "Fantascienza e Fantasy",
    ),
    "tvShowsKnownFor": MessageLookupByLibrary.simpleMessage(
      "Famoso per le serie",
    ),
    "tvWarPolitics": MessageLookupByLibrary.simpleMessage("Guerra e Politica"),
    "tvkids": MessageLookupByLibrary.simpleMessage("Bambini"),
    "tvmovielabel": MessageLookupByLibrary.simpleMessage("Film TV"),
    "tvnews": MessageLookupByLibrary.simpleMessage("Notizie"),
    "tvreality": MessageLookupByLibrary.simpleMessage("Reality"),
    "tvsoap": MessageLookupByLibrary.simpleMessage("Soap"),
    "tvswitch": MessageLookupByLibrary.simpleMessage("Serie"),
    "tvtalk": MessageLookupByLibrary.simpleMessage("Talk show"),
    "undo": MessageLookupByLibrary.simpleMessage("Annulla"),
    "unlike": MessageLookupByLibrary.simpleMessage("Non Mi Piace"),
    "upcomingwidget_title": MessageLookupByLibrary.simpleMessage(
      "Prossimi Film",
    ),
    "updateaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Aggiorna Account",
    ),
    "updateprofilelabel": MessageLookupByLibrary.simpleMessage(
      "Aggiorna Profilo",
    ),
    "updateprofilesuccess": MessageLookupByLibrary.simpleMessage(
      "Profilo aggiornato",
    ),
    "userProfile": MessageLookupByLibrary.simpleMessage("Profilo utente"),
    "videoslabel": MessageLookupByLibrary.simpleMessage("Video"),
    "viewFullDetails": MessageLookupByLibrary.simpleMessage(
      "Visualizza tutti i dettagli",
    ),
    "viewPosterFullScreen": MessageLookupByLibrary.simpleMessage(
      "Visualizza il poster a schermo intero",
    ),
    "viewReports": MessageLookupByLibrary.simpleMessage(
      "Visualizza segnalazioni",
    ),
    "warmovielabel": MessageLookupByLibrary.simpleMessage("Film Guerra"),
    "wartvlabel": MessageLookupByLibrary.simpleMessage(
      "Serie TV Guerra e Politica",
    ),
    "watchTrailers": MessageLookupByLibrary.simpleMessage("Guarda i trailer"),
    "watchlistEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Aggiungi titoli alla tua Watchlist per ritrovarli qui più tardi.",
    ),
    "watchlistEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "La Tua Watchlist È Vuota",
    ),
    "watchlistSignInBody": MessageLookupByLibrary.simpleMessage(
      "La watchlist è salvata nel tuo account, così ti segue su ogni dispositivo.",
    ),
    "watchlistSignInTitle": MessageLookupByLibrary.simpleMessage(
      "Accedi per Usare la Watchlist",
    ),
    "watchlistUpdateFailed": MessageLookupByLibrary.simpleMessage(
      "Impossibile aggiornare la Watchlist. Riprova.",
    ),
    "watchlistlabel": MessageLookupByLibrary.simpleMessage(
      "Lista dei Preferiti",
    ),
    "watchon": MessageLookupByLibrary.simpleMessage("Guarda su"),
    "watchvideosbuttonlabel": MessageLookupByLibrary.simpleMessage(
      "Guarda Video",
    ),
    "welcomemessage": MessageLookupByLibrary.simpleMessage(
      "Benvenuto di nuovo",
    ),
    "westernmovielabel": MessageLookupByLibrary.simpleMessage("Film Western"),
    "writeReview": MessageLookupByLibrary.simpleMessage(
      "Scrivi una recensione",
    ),
  };
}
