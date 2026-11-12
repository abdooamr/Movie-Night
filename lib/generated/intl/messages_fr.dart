// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(name) => "${name} est maintenant admin";

  static String m1(character) => "Dans le rôle de ${character}";

  static String m2(email) =>
      "Vérifiez vos e-mails. Nous avons envoyé un lien à ${email}. Ouvrez-le pour activer votre compte, puis connectez-vous.";

  static String m3(section) => "Impossible de charger ${section}.";

  static String m4(name) => "Supprimer ${name} ?";

  static String m5(count) =>
      "${Intl.plural(count, one: '1 épisode', other: '${count} épisodes')}";

  static String m6(query) =>
      "Aucun résultat pour « ${query} ». Vérifiez l\'orthographe ou essayez un autre titre.";

  static String m7(title) => "Lire ${title}";

  static String m8(score) => "${score} sur 10";

  static String m9(email) =>
      "Vérifiez vos e-mails. Nous avons envoyé un lien de réinitialisation à ${email}.";

  static String m10(hours, minutes) => "${hours} h ${minutes} min";

  static String m11(hours) => "${hours} h";

  static String m12(minutes) => "${minutes} min";

  static String m13(count) =>
      "${Intl.plural(count, one: '1 saison', other: '${count} saisons')}";

  static String m14(count) => "Voir tous les avis (${count})";

  static String m15(title, url) => "Découvrez ${title} sur Movie Night\n${url}";

  static String m16(count) =>
      "${Intl.plural(count, one: '1 titre', other: '${count} titres')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Actiongenre": MessageLookupByLibrary.simpleMessage("Action"),
    "Adventuregenre": MessageLookupByLibrary.simpleMessage("Aventure"),
    "Animationgenre": MessageLookupByLibrary.simpleMessage("Animation"),
    "Comedygenre": MessageLookupByLibrary.simpleMessage("Comédie"),
    "Crimegenre": MessageLookupByLibrary.simpleMessage("Crime"),
    "Documentarygenre": MessageLookupByLibrary.simpleMessage("Documentaire"),
    "Dramagenre": MessageLookupByLibrary.simpleMessage("Drame"),
    "Familygenre": MessageLookupByLibrary.simpleMessage("Famille"),
    "Fantasygenre": MessageLookupByLibrary.simpleMessage("Fantaisie"),
    "Frenchlabel": MessageLookupByLibrary.simpleMessage("Français"),
    "Heylabel": MessageLookupByLibrary.simpleMessage("Salut"),
    "Heytherelabel": MessageLookupByLibrary.simpleMessage("Salut"),
    "Historygenre": MessageLookupByLibrary.simpleMessage("Histoire"),
    "Horrorgenre": MessageLookupByLibrary.simpleMessage("Horreur"),
    "Musicgenre": MessageLookupByLibrary.simpleMessage("Musique"),
    "Mysterygenre": MessageLookupByLibrary.simpleMessage("Mystère"),
    "OhNo": MessageLookupByLibrary.simpleMessage("Oh Non !"),
    "Recommendation": MessageLookupByLibrary.simpleMessage("Recommandation"),
    "Romancegenre": MessageLookupByLibrary.simpleMessage("Romance"),
    "ScienceFictiongenre": MessageLookupByLibrary.simpleMessage(
      "Science-Fiction",
    ),
    "Seealloptions": MessageLookupByLibrary.simpleMessage("Voir Tout"),
    "TVMoviegenre": MessageLookupByLibrary.simpleMessage("Téléfilm"),
    "Thrillergenre": MessageLookupByLibrary.simpleMessage("Thriller"),
    "Usernamelabel": MessageLookupByLibrary.simpleMessage("Nom d\'Utilisateur"),
    "Wargenre": MessageLookupByLibrary.simpleMessage("Guerre"),
    "Westerngenre": MessageLookupByLibrary.simpleMessage("Western"),
    "accountGroupLabel": MessageLookupByLibrary.simpleMessage("Compte"),
    "accountinfolabel": MessageLookupByLibrary.simpleMessage(
      "Informations du Compte",
    ),
    "accountsettingslabel": MessageLookupByLibrary.simpleMessage(
      "Paramètres du Compte",
    ),
    "accountsettingssubtitle": MessageLookupByLibrary.simpleMessage(
      "Modifier le compte, Confidentialité, Changer de Langue",
    ),
    "actionmovielabel": MessageLookupByLibrary.simpleMessage("Films d\'Action"),
    "actiontvlabel": MessageLookupByLibrary.simpleMessage(
      "Séries TV d\'Action et Aventure",
    ),
    "addAdmin": MessageLookupByLibrary.simpleMessage("Ajouter un admin"),
    "addtowatchlist": MessageLookupByLibrary.simpleMessage(
      "Ajouter à la Liste de Surveillance",
    ),
    "adminActions": MessageLookupByLibrary.simpleMessage("Actions"),
    "adminCopyId": MessageLookupByLibrary.simpleMessage(
      "Copier l’ID utilisateur",
    ),
    "adminDetails": MessageLookupByLibrary.simpleMessage("Détails"),
    "adminFilterAdmins": MessageLookupByLibrary.simpleMessage("Admins"),
    "adminFilterReported": MessageLookupByLibrary.simpleMessage("Signalés"),
    "adminIdCopied": MessageLookupByLibrary.simpleMessage(
      "ID utilisateur copié",
    ),
    "adminMakeAdmin": MessageLookupByLibrary.simpleMessage("Nommer admin"),
    "adminMakeAdminHint": MessageLookupByLibrary.simpleMessage(
      "Peut ouvrir ce panneau et gérer les utilisateurs",
    ),
    "adminNoUsersFound": MessageLookupByLibrary.simpleMessage(
      "Aucun utilisateur trouvé",
    ),
    "adminNoUsersHint": MessageLookupByLibrary.simpleMessage(
      "Essayez un autre nom ou e-mail.",
    ),
    "adminNowAdmin": m0,
    "adminPanel": MessageLookupByLibrary.simpleMessage(
      "Panneau d’administration",
    ),
    "adminReportCleared": MessageLookupByLibrary.simpleMessage(
      "Signalement effacé",
    ),
    "adminRoleUser": MessageLookupByLibrary.simpleMessage("Utilisateur"),
    "adminSearchHint": MessageLookupByLibrary.simpleMessage(
      "Rechercher par nom ou e-mail",
    ),
    "adminStatus": MessageLookupByLibrary.simpleMessage("Statut"),
    "adminUserId": MessageLookupByLibrary.simpleMessage("ID utilisateur"),
    "adminUserTitle": MessageLookupByLibrary.simpleMessage("Utilisateur"),
    "adminpanellabel": MessageLookupByLibrary.simpleMessage(
      "Panneau d\'Administration",
    ),
    "adminsettingslabel": MessageLookupByLibrary.simpleMessage(
      "Administration",
    ),
    "adventuremovielabel": MessageLookupByLibrary.simpleMessage(
      "Films d\'Aventure",
    ),
    "airingtodaywidget_title": MessageLookupByLibrary.simpleMessage(
      "Diffusion Aujourd\'hui",
    ),
    "alreadyhaveanaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Vous avez déjà un compte?",
    ),
    "animationmovielabel": MessageLookupByLibrary.simpleMessage(
      "Films d\'Animation",
    ),
    "appearance": MessageLookupByLibrary.simpleMessage("Apparence"),
    "appearanceDark": MessageLookupByLibrary.simpleMessage("Sombre"),
    "appearanceLight": MessageLookupByLibrary.simpleMessage("Clair"),
    "appearanceSystem": MessageLookupByLibrary.simpleMessage("Système"),
    "arabiclabel": MessageLookupByLibrary.simpleMessage("Arabe"),
    "authErrorEmailInUse": MessageLookupByLibrary.simpleMessage(
      "Un compte existe déjà avec cet e-mail.",
    ),
    "authErrorEmailNotConfirmed": MessageLookupByLibrary.simpleMessage(
      "Confirmez d\'abord votre e-mail. Ouvrez le lien que nous vous avons envoyé, puis connectez-vous.",
    ),
    "authErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Impossible de terminer. Réessayez.",
    ),
    "authErrorInvalidCredential": MessageLookupByLibrary.simpleMessage(
      "L\'e-mail ou le mot de passe est incorrect.",
    ),
    "authErrorInvalidEmail": MessageLookupByLibrary.simpleMessage(
      "Saisissez un e-mail comme nom@exemple.com.",
    ),
    "authErrorNetwork": MessageLookupByLibrary.simpleMessage(
      "Vous êtes hors ligne. Vérifiez votre connexion et réessayez.",
    ),
    "authErrorRecentLogin": MessageLookupByLibrary.simpleMessage(
      "Pour votre sécurité, reconnectez-vous afin de supprimer votre compte.",
    ),
    "authErrorSamePassword": MessageLookupByLibrary.simpleMessage(
      "Choisissez un mot de passe différent de l\'actuel.",
    ),
    "authErrorTooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Trop de tentatives. Réessayez dans quelques minutes.",
    ),
    "authErrorUserNotFound": MessageLookupByLibrary.simpleMessage(
      "Aucun compte n\'utilise cet e-mail.",
    ),
    "authErrorWeakPassword": MessageLookupByLibrary.simpleMessage(
      "Choisissez un mot de passe plus sûr.",
    ),
    "backOnline": MessageLookupByLibrary.simpleMessage(
      "Vous êtes de nouveau en ligne.",
    ),
    "backToLogIn": MessageLookupByLibrary.simpleMessage(
      "Retour à la connexion",
    ),
    "beFirstToReview": MessageLookupByLibrary.simpleMessage(
      "Aucun avis pour l\'instant. Écrivez le premier.",
    ),
    "biography": MessageLookupByLibrary.simpleMessage("Biographie"),
    "browseMovies": MessageLookupByLibrary.simpleMessage("Parcourir les films"),
    "buyon": MessageLookupByLibrary.simpleMessage("Acheter sur"),
    "cancelLabel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "castAs": m1,
    "changeProfilePhoto": MessageLookupByLibrary.simpleMessage(
      "Changer la Photo de Profil",
    ),
    "changelanguagelabel": MessageLookupByLibrary.simpleMessage(
      "Changer de langue",
    ),
    "changepassworderror": MessageLookupByLibrary.simpleMessage(
      "Erreur lors du Changement de Mot de Passe. Veuillez réessayer",
    ),
    "changepasswordlabel": MessageLookupByLibrary.simpleMessage(
      "Changer de Mot de Passe",
    ),
    "changepasswordsuccess": MessageLookupByLibrary.simpleMessage(
      "Mot de Passe Modifié avec Succès",
    ),
    "clearHistory": MessageLookupByLibrary.simpleMessage("Effacer"),
    "clearReport": MessageLookupByLibrary.simpleMessage(
      "Supprimer le signalement",
    ),
    "clearSearchTooltip": MessageLookupByLibrary.simpleMessage(
      "Effacer la recherche",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Fermer"),
    "comedymovielabel": MessageLookupByLibrary.simpleMessage(
      "Films de Comédie",
    ),
    "confirmEmailSent": m2,
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Continuer avec Google",
    ),
    "couldntLoadSection": m3,
    "couldntLoadTitle": MessageLookupByLibrary.simpleMessage(
      "Impossible de charger ce titre.",
    ),
    "createaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Créer un Compte",
    ),
    "crimemovielabel": MessageLookupByLibrary.simpleMessage("Films de Crime"),
    "darkmodelabel": MessageLookupByLibrary.simpleMessage("Mode Sombre"),
    "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
    "deleteAccountDone": MessageLookupByLibrary.simpleMessage(
      "Votre compte a été supprimé.",
    ),
    "deleteAccountMessage": MessageLookupByLibrary.simpleMessage(
      "Votre profil, votre liste de suivi et vos avis seront définitivement supprimés. Cette action est irréversible.",
    ),
    "deleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Supprimer le compte ?",
    ),
    "deleteBookmark": MessageLookupByLibrary.simpleMessage(
      "Supprimer le favori",
    ),
    "deleteBookmarkConfirmation": MessageLookupByLibrary.simpleMessage(
      "Es-tu sûr de vouloir supprimer ce favori ? Cette action est irréversible.",
    ),
    "deleteReviewMessage": MessageLookupByLibrary.simpleMessage(
      "Cette action est irréversible.",
    ),
    "deleteReviewTitle": MessageLookupByLibrary.simpleMessage(
      "Supprimer l\'avis ?",
    ),
    "deleteReviewTooltip": MessageLookupByLibrary.simpleMessage(
      "Supprimer l\'avis",
    ),
    "deleteUser": MessageLookupByLibrary.simpleMessage("Supprimer le compte"),
    "deleteUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Es-tu sûr de vouloir supprimer ton compte ? Cette action est irréversible.",
    ),
    "deleteUserTitle": m4,
    "deleteaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Supprimer le Compte",
    ),
    "deleteerror": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de la Suppression du Compte. Veuillez vous reconnecter et réessayer",
    ),
    "descriptionhint": MessageLookupByLibrary.simpleMessage(
      "Expliquez en détail le problème",
    ),
    "descriptionlabel": MessageLookupByLibrary.simpleMessage(
      "Description  (Requise)",
    ),
    "detailCategory": MessageLookupByLibrary.simpleMessage(
      "Catégorie de détail",
    ),
    "deutschlabel": MessageLookupByLibrary.simpleMessage("Allemand"),
    "documentarymovielabel": MessageLookupByLibrary.simpleMessage(
      "Films Documentaires",
    ),
    "dramamovielabel": MessageLookupByLibrary.simpleMessage("Films de Drame"),
    "editprofilelabel": MessageLookupByLibrary.simpleMessage(
      "Modifier le Profil",
    ),
    "egyptmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Films égyptiens",
    ),
    "egypttvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Séries égyptiennes",
    ),
    "email": MessageLookupByLibrary.simpleMessage("E-mail"),
    "emailaddresslabel": MessageLookupByLibrary.simpleMessage("Adresse Email"),
    "englishlabel": MessageLookupByLibrary.simpleMessage("Anglais"),
    "enterFirstName": MessageLookupByLibrary.simpleMessage(
      "Saisissez un prénom.",
    ),
    "enterPassword": MessageLookupByLibrary.simpleMessage(
      "Saisissez votre mot de passe.",
    ),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Saisissez une adresse e-mail valide.",
    ),
    "episodesCount": m5,
    "error": MessageLookupByLibrary.simpleMessage("Erreur"),
    "errorLoginAgain": MessageLookupByLibrary.simpleMessage(
      "Erreur, veuillez vous reconnecter et réessayer",
    ),
    "errorTitle": MessageLookupByLibrary.simpleMessage("Erreur"),
    "explorenavbar": MessageLookupByLibrary.simpleMessage("Rechercher"),
    "familymovielabel": MessageLookupByLibrary.simpleMessage("Films Familiaux"),
    "fantasymovielabel": MessageLookupByLibrary.simpleMessage(
      "Films Fantastiques",
    ),
    "filterAll": MessageLookupByLibrary.simpleMessage("Tout"),
    "filterLabel": MessageLookupByLibrary.simpleMessage("Filtrer"),
    "firstnamelabel": MessageLookupByLibrary.simpleMessage("Prénom"),
    "forgetPasswordPageQuestion": MessageLookupByLibrary.simpleMessage(
      "Entre l’adresse e-mail associée à ton compte",
    ),
    "forgotpasswordlabel": MessageLookupByLibrary.simpleMessage(
      "Mot de Passe Oublié?",
    ),
    "fullUserProfile": MessageLookupByLibrary.simpleMessage(
      "Profil utilisateur complet",
    ),
    "generalsettingslabel": MessageLookupByLibrary.simpleMessage("Général"),
    "genericError": MessageLookupByLibrary.simpleMessage(
      "Une erreur s\'est produite. Veuillez réessayer.",
    ),
    "globalreviewswitch": MessageLookupByLibrary.simpleMessage("Avis Global"),
    "hello": MessageLookupByLibrary.simpleMessage("Salut"),
    "hidePassword": MessageLookupByLibrary.simpleMessage(
      "Masquer le mot de passe",
    ),
    "hindilabel": MessageLookupByLibrary.simpleMessage("Hindi"),
    "historymovielabel": MessageLookupByLibrary.simpleMessage(
      "Films Historiques",
    ),
    "homenavbar": MessageLookupByLibrary.simpleMessage("Accueil"),
    "horrormovielabel": MessageLookupByLibrary.simpleMessage(
      "Films d\'Horreur",
    ),
    "id": MessageLookupByLibrary.simpleMessage("ID"),
    "inWatchlist": MessageLookupByLibrary.simpleMessage(
      "Dans la liste de suivi",
    ),
    "italianlabel": MessageLookupByLibrary.simpleMessage("Italien"),
    "kidstvlabel": MessageLookupByLibrary.simpleMessage(
      "Séries TV pour Enfants",
    ),
    "lastnamelabel": MessageLookupByLibrary.simpleMessage("Nom de Famille"),
    "libraryLiked": MessageLookupByLibrary.simpleMessage("Aimés"),
    "libraryNoMatches": MessageLookupByLibrary.simpleMessage(
      "Aucun titre ne correspond à ce filtre.",
    ),
    "libraryWatchlist": MessageLookupByLibrary.simpleMessage("Liste de suivi"),
    "like": MessageLookupByLibrary.simpleMessage("J\'aime"),
    "liked": MessageLookupByLibrary.simpleMessage("Aimé"),
    "likedEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Touchez ♡ sur un film ou une série pour le garder ici.",
    ),
    "likednavbar": MessageLookupByLibrary.simpleMessage("Bibliothèque"),
    "localreviewswitch": MessageLookupByLibrary.simpleMessage("Avis Local"),
    "logInToReview": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous pour écrire un avis",
    ),
    "loginbuttonlabel": MessageLookupByLibrary.simpleMessage("Se Connecter"),
    "logintocontinue": MessageLookupByLibrary.simpleMessage(
      "Veuillez vous connecter pour continuer",
    ),
    "logoutlabel": MessageLookupByLibrary.simpleMessage("Se Déconnecter"),
    "managesettingslabel": MessageLookupByLibrary.simpleMessage("Gérer"),
    "mediaMovie": MessageLookupByLibrary.simpleMessage("Film"),
    "mediaTvShow": MessageLookupByLibrary.simpleMessage("Série"),
    "mediatypemoviess": MessageLookupByLibrary.simpleMessage("Films"),
    "minute": MessageLookupByLibrary.simpleMessage("min"),
    "moviesKnownFor": MessageLookupByLibrary.simpleMessage(
      "Connu pour ses films",
    ),
    "movieswitch": MessageLookupByLibrary.simpleMessage("Films"),
    "musicmovielabel": MessageLookupByLibrary.simpleMessage("Films Musicaux"),
    "mysterymovielabel": MessageLookupByLibrary.simpleMessage(
      "Films de Mystère",
    ),
    "name": MessageLookupByLibrary.simpleMessage("Nom"),
    "newPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Nouveau mot de passe",
    ),
    "newstvlabel": MessageLookupByLibrary.simpleMessage(
      "Séries TV d\'Actualités",
    ),
    "noBirthdayFound": MessageLookupByLibrary.simpleMessage(
      "Aucune date de naissance trouvée",
    ),
    "noDataFound": MessageLookupByLibrary.simpleMessage("Rien à afficher"),
    "noImage": MessageLookupByLibrary.simpleMessage("Aucune image"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "Pas de Connexion Internet",
    ),
    "noInternetMessage": MessageLookupByLibrary.simpleMessage(
      "Veuillez vérifier votre connexion internet et réessayer",
    ),
    "noReport": MessageLookupByLibrary.simpleMessage("Aucun signalement"),
    "noResults": MessageLookupByLibrary.simpleMessage("Pas de Résultats"),
    "noResultsFor": m6,
    "noResultsMessage": MessageLookupByLibrary.simpleMessage(
      "Aucun résultat trouvé pour votre recherche",
    ),
    "noReviews": MessageLookupByLibrary.simpleMessage("Aucun avis"),
    "noUserDataAvailable": MessageLookupByLibrary.simpleMessage(
      "Aucune donnée utilisateur disponible",
    ),
    "noVideos": MessageLookupByLibrary.simpleMessage("Aucune vidéo"),
    "nobiographyfound": MessageLookupByLibrary.simpleMessage(
      "Aucune biographie disponible",
    ),
    "nobuyon": MessageLookupByLibrary.simpleMessage(
      "Aucun service d\'achat disponible",
    ),
    "noimage": MessageLookupByLibrary.simpleMessage("Aucune image"),
    "nointernetconnection": MessageLookupByLibrary.simpleMessage(
      "Pas de connexion Internet",
    ),
    "nolikedmovies": MessageLookupByLibrary.simpleMessage(
      "Aucun titre aimé pour l\'instant",
    ),
    "nomoviesinwatchlist": MessageLookupByLibrary.simpleMessage(
      "Votre Liste de Surveillance est Vide\nCommencez à ajouter des films à votre liste de surveillance et découvrez vos préférés !",
    ),
    "notNowLabel": MessageLookupByLibrary.simpleMessage("Plus tard"),
    "notamemberlabel": MessageLookupByLibrary.simpleMessage(
      "Pas encore membre?",
    ),
    "notvshowsinwatchlist": MessageLookupByLibrary.simpleMessage(
      "Votre Liste de Surveillance est Vide\nCommencez à ajouter des séries TV à votre liste de surveillance et découvrez vos préférées !",
    ),
    "nowatchmovieon": MessageLookupByLibrary.simpleMessage(
      "Aucun service de streaming disponible",
    ),
    "numberofepisodes": MessageLookupByLibrary.simpleMessage(
      "Nombre d\'Épisodes",
    ),
    "numberofseasons": MessageLookupByLibrary.simpleMessage(
      "Nombre de Saisons",
    ),
    "ohnolabel": MessageLookupByLibrary.simpleMessage("Oh Non !"),
    "okLabel": MessageLookupByLibrary.simpleMessage("OK"),
    "openInImdb": MessageLookupByLibrary.simpleMessage("Ouvrir dans IMDb"),
    "passwordMigrationBody": MessageLookupByLibrary.simpleMessage(
      "Movie Night utilise un nouveau système de connexion. Si vous aviez un compte avant cette mise à jour, votre ancien mot de passe ne fonctionne plus. Réinitialisez-le une fois pour continuer à utiliser votre compte.",
    ),
    "passwordMigrationTitle": MessageLookupByLibrary.simpleMessage(
      "Réinitialisez votre mot de passe une fois",
    ),
    "passwordUpdated": MessageLookupByLibrary.simpleMessage(
      "Votre mot de passe a été mis à jour.",
    ),
    "passwordconfirmlabel": MessageLookupByLibrary.simpleMessage(
      "Confirmer le Mot de Passe",
    ),
    "passwordlabel": MessageLookupByLibrary.simpleMessage("Mot de Passe"),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "Les mots de passe ne correspondent pas.",
    ),
    "passwordvalidationtext": MessageLookupByLibrary.simpleMessage(
      "Utilisez au moins 8 caractères, dont une majuscule, une minuscule, un chiffre et un symbole.",
    ),
    "playVideo": m7,
    "pleasecheckinternetconnection": MessageLookupByLibrary.simpleMessage(
      "S\'il vous plaît, vérifiez votre connexion à internet et réessayez",
    ),
    "pleasefillallfields": MessageLookupByLibrary.simpleMessage(
      "Veuillez remplir tous les champs",
    ),
    "popularmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Films Populaires",
    ),
    "populartvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Séries TV Populaires",
    ),
    "poweredby": MessageLookupByLibrary.simpleMessage("Propulsé par"),
    "privacylabel": MessageLookupByLibrary.simpleMessage("Confidentialité"),
    "profilePicUploadFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'envoyer la photo de profil. Veuillez réessayer.",
    ),
    "profileSignInBody": MessageLookupByLibrary.simpleMessage(
      "Gardez une liste de suivi, écrivez des avis et retrouvez votre profil sur tous vos appareils.",
    ),
    "profileSignInTitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous à Movie Night",
    ),
    "profilenavbar": MessageLookupByLibrary.simpleMessage("Profil"),
    "rateMovieNight": MessageLookupByLibrary.simpleMessage("Noter Movie Night"),
    "ratingOutOf10": m8,
    "readLess": MessageLookupByLibrary.simpleMessage("Lire moins"),
    "readmorelabel": MessageLookupByLibrary.simpleMessage("Lire la suite"),
    "realitytvlabel": MessageLookupByLibrary.simpleMessage(
      "Séries TV de Téléréalité",
    ),
    "registarnowlabel": MessageLookupByLibrary.simpleMessage("Créer un Compte"),
    "removeFromHistory": MessageLookupByLibrary.simpleMessage("Retirer"),
    "removeFromLiked": MessageLookupByLibrary.simpleMessage(
      "Retirer des favoris",
    ),
    "removedFromLiked": MessageLookupByLibrary.simpleMessage(
      "Retiré des titres aimés",
    ),
    "removedFromWatchlist": MessageLookupByLibrary.simpleMessage(
      "Retiré de la liste de suivi",
    ),
    "removefromwatchlist": MessageLookupByLibrary.simpleMessage(
      "Retirer de la Liste de Surveillance",
    ),
    "report": MessageLookupByLibrary.simpleMessage("Signalement"),
    "reportDescriptionRequired": MessageLookupByLibrary.simpleMessage(
      "Ajoutez une description.",
    ),
    "reportFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'envoyer le signalement. Réessayez.",
    ),
    "reportPage": MessageLookupByLibrary.simpleMessage("Page de signalement"),
    "reportSent": MessageLookupByLibrary.simpleMessage(
      "Signalement envoyé. Merci de contribuer à améliorer Movie Night.",
    ),
    "reportSummaryRequired": MessageLookupByLibrary.simpleMessage(
      "Ajoutez un bref résumé.",
    ),
    "reportabuglabel": MessageLookupByLibrary.simpleMessage(
      "Signaler un Problème",
    ),
    "reportpagelabel": MessageLookupByLibrary.simpleMessage(
      "Veuillez nous envoyer un rapport si vous trouvez des bugs ou avez des suggestions pour l\'application.",
    ),
    "resetLinkSent": m9,
    "resetPassword": MessageLookupByLibrary.simpleMessage(
      "Réinitialiser le mot de passe",
    ),
    "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Nous vous enverrons un lien de réinitialisation par e-mail",
    ),
    "reviewsTitle": MessageLookupByLibrary.simpleMessage("Avis"),
    "role": MessageLookupByLibrary.simpleMessage("Rôle"),
    "romancemovielabel": MessageLookupByLibrary.simpleMessage(
      "Films Romantiques",
    ),
    "runtimeHoursMinutes": m10,
    "runtimeHoursOnly": m11,
    "runtimeMinutesOnly": m12,
    "savePasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Enregistrer le mot de passe",
    ),
    "savelabel": MessageLookupByLibrary.simpleMessage("Enregistrer"),
    "sciencefictionmovielabel": MessageLookupByLibrary.simpleMessage(
      "Films de Science-Fiction",
    ),
    "scifitvlabel": MessageLookupByLibrary.simpleMessage(
      "Séries TV de Science-Fiction et Fantaisie",
    ),
    "searchhint": MessageLookupByLibrary.simpleMessage(
      "Films, séries, personnes",
    ),
    "seasonsCount": m13,
    "seeAllReviews": m14,
    "sendEmail": MessageLookupByLibrary.simpleMessage("Envoyer l’e-mail"),
    "sendReviewTooltip": MessageLookupByLibrary.simpleMessage(
      "Envoyer l\'avis",
    ),
    "sendfeedbacklabel": MessageLookupByLibrary.simpleMessage(
      "Envoyer des Commentaires",
    ),
    "sendreportlabel": MessageLookupByLibrary.simpleMessage(
      "Envoyer le Rapport",
    ),
    "setNewPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Choisissez un nouveau mot de passe pour votre compte.",
    ),
    "setNewPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Définir un nouveau mot de passe",
    ),
    "share": MessageLookupByLibrary.simpleMessage("Partager"),
    "shareText": m15,
    "showAll": MessageLookupByLibrary.simpleMessage("Tout afficher"),
    "showPassword": MessageLookupByLibrary.simpleMessage(
      "Afficher le mot de passe",
    ),
    "signInPromptBody": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous pour garder une liste de suivi, aimer des titres et écrire des avis.",
    ),
    "signInPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous pour enregistrer des titres",
    ),
    "signInToReview": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous pour lire et écrire des avis.",
    ),
    "signupbuttonlabel": MessageLookupByLibrary.simpleMessage(
      "Créer un Compte",
    ),
    "soaptvlabel": MessageLookupByLibrary.simpleMessage(
      "Séries TV de Feuilleton",
    ),
    "somethingwentwrong": MessageLookupByLibrary.simpleMessage(
      "Impossible de charger. Réessayez.",
    ),
    "spanishlabel": MessageLookupByLibrary.simpleMessage("Espagnol"),
    "storyline": MessageLookupByLibrary.simpleMessage("Synopsis"),
    "success": MessageLookupByLibrary.simpleMessage("Succès"),
    "summaryhint": MessageLookupByLibrary.simpleMessage(
      "Expliquez brièvement le problème",
    ),
    "summarylabel": MessageLookupByLibrary.simpleMessage("Résumé  (Requis)"),
    "talktvlabel": MessageLookupByLibrary.simpleMessage(
      "Séries TV de Discussion",
    ),
    "thecast": MessageLookupByLibrary.simpleMessage("La Distribution"),
    "thrillermovielabel": MessageLookupByLibrary.simpleMessage(
      "Films à Suspense",
    ),
    "titlesCount": m16,
    "tmdbLabel": MessageLookupByLibrary.simpleMessage("TMDB"),
    "trendingmovieswidget_title": MessageLookupByLibrary.simpleMessage(
      "Films Tendances",
    ),
    "trendingtvwidget_title": MessageLookupByLibrary.simpleMessage(
      "Séries TV Tendances",
    ),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "tvShowsKnownFor": MessageLookupByLibrary.simpleMessage(
      "Connu pour ses séries",
    ),
    "tvkids": MessageLookupByLibrary.simpleMessage("Enfants"),
    "tvmovielabel": MessageLookupByLibrary.simpleMessage("Téléfilms"),
    "tvnews": MessageLookupByLibrary.simpleMessage("Actualités"),
    "tvreality": MessageLookupByLibrary.simpleMessage("Téléréalité"),
    "tvsoap": MessageLookupByLibrary.simpleMessage("Feuilleton"),
    "tvswitch": MessageLookupByLibrary.simpleMessage("Séries TV"),
    "tvtalk": MessageLookupByLibrary.simpleMessage("Émission de Discussion"),
    "undo": MessageLookupByLibrary.simpleMessage("Annuler"),
    "unlike": MessageLookupByLibrary.simpleMessage("Je n\'aime plus"),
    "upcomingwidget_title": MessageLookupByLibrary.simpleMessage(
      "Prochains Films",
    ),
    "updateaccountlabel": MessageLookupByLibrary.simpleMessage(
      "Mettre à Jour le Compte",
    ),
    "updateprofilelabel": MessageLookupByLibrary.simpleMessage(
      "Mettre à Jour le Profil",
    ),
    "updateprofilesuccess": MessageLookupByLibrary.simpleMessage(
      "Profil mis à jour",
    ),
    "userProfile": MessageLookupByLibrary.simpleMessage("Profil utilisateur"),
    "videoslabel": MessageLookupByLibrary.simpleMessage("Vidéos"),
    "viewFullDetails": MessageLookupByLibrary.simpleMessage(
      "Voir tous les détails",
    ),
    "viewPosterFullScreen": MessageLookupByLibrary.simpleMessage(
      "Voir l\'affiche en plein écran",
    ),
    "viewReports": MessageLookupByLibrary.simpleMessage(
      "Voir les signalements",
    ),
    "warmovielabel": MessageLookupByLibrary.simpleMessage("Films de Guerre"),
    "wartvlabel": MessageLookupByLibrary.simpleMessage(
      "Séries TV de Guerre et Politique",
    ),
    "watchTrailers": MessageLookupByLibrary.simpleMessage(
      "Regarder les bandes-annonces",
    ),
    "watchlistEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Ajoutez des titres à votre liste de suivi pour les retrouver ici plus tard.",
    ),
    "watchlistEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Votre liste de suivi est vide",
    ),
    "watchlistSignInBody": MessageLookupByLibrary.simpleMessage(
      "Votre liste est enregistrée dans votre compte et vous suit sur tous vos appareils.",
    ),
    "watchlistSignInTitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous pour utiliser votre liste de suivi",
    ),
    "watchlistUpdateFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible de mettre à jour la liste de suivi. Réessayez.",
    ),
    "watchlistlabel": MessageLookupByLibrary.simpleMessage(
      "Liste de Surveillance",
    ),
    "watchon": MessageLookupByLibrary.simpleMessage("Regarder sur"),
    "watchvideosbuttonlabel": MessageLookupByLibrary.simpleMessage(
      "Regarder des Vidéos",
    ),
    "welcomemessage": MessageLookupByLibrary.simpleMessage(
      "Bienvenue de retour",
    ),
    "westernmovielabel": MessageLookupByLibrary.simpleMessage("Films Western"),
    "writeReview": MessageLookupByLibrary.simpleMessage("Écrire un avis"),
  };
}
