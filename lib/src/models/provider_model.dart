// To parse this JSON data, do
//
//     final watchprovider = watchproviderFromJson(jsonString);

import 'dart:convert';

Watchprovider? watchproviderFromJson(String str) =>
    Watchprovider.fromJson(json.decode(str));

String watchproviderToJson(Watchprovider? data) => json.encode(data!.toJson());

class Watchprovider {
  Watchprovider({
    required this.id,
    required this.results,
  });

  int? id;
  Results? results;

  factory Watchprovider.fromJson(Map<String, dynamic> json) => Watchprovider(
        id: json["id"],
        results: Results.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "results": results!.toJson(),
      };
}

class Results {
  Results({
    required this.ar,
    required this.au,
    required this.bo,
    required this.br,
    required this.ca,
    required this.cl,
    required this.co,
    required this.cr,
    required this.resultsDo,
    required this.ec,
    required this.gb,
    required this.gt,
    required this.hn,
    required this.ie,
    required this.resultsIn,
    required this.jp,
    required this.kr,
    required this.mx,
    required this.nz,
    required this.pa,
    required this.pe,
    required this.ph,
    required this.pt,
    required this.py,
    required this.sv,
    required this.us,
    required this.uy,
    required this.ve,
  });

  Ar? ar;
  Ar? au;
  Ar? bo;
  Ar? br;
  Ar? ca;
  Ar? cl;
  Ar? co;
  Ar? cr;
  Ar? resultsDo;
  Ar? ec;
  Gb? gb;
  Ar? gt;
  Ar? hn;
  Gb? ie;
  Ar? resultsIn;
  Ar? jp;
  Ar? kr;
  Ar? mx;
  Ar? nz;
  Ar? pa;
  Ar? pe;
  Ar? ph;
  Ar? pt;
  Ar? py;
  Ar? sv;
  Ar? us;
  Ar? uy;
  Ar? ve;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        ar: Ar.fromJson(json["AR"]) == Null
            ? Ar(link: '', buy: [], rent: [], flatrate: [])
            : Ar.fromJson(json["AR"]),
        au: Ar.fromJson(json["AU"]),
        bo: Ar.fromJson(json["BO"]),
        br: Ar.fromJson(json["BR"]),
        ca: Ar.fromJson(json["CA"]),
        cl: Ar.fromJson(json["CL"]),
        co: Ar.fromJson(json["CO"]),
        cr: Ar.fromJson(json["CR"]),
        resultsDo: Ar.fromJson(json["DO"]),
        ec: Ar.fromJson(json["EC"]),
        gb: Gb.fromJson(json["GB"]),
        gt: Ar.fromJson(json["GT"]),
        hn: Ar.fromJson(json["HN"]),
        ie: Gb.fromJson(json["IE"]),
        resultsIn: Ar.fromJson(json["IN"]),
        jp: Ar.fromJson(json["JP"]),
        kr: Ar.fromJson(json["KR"]),
        mx: Ar.fromJson(json["MX"]),
        nz: Ar.fromJson(json["NZ"]),
        pa: Ar.fromJson(json["PA"]),
        pe: Ar.fromJson(json["PE"]),
        ph: Ar.fromJson(json["PH"]),
        pt: Ar.fromJson(json["PT"]),
        py: Ar.fromJson(json["PY"]),
        sv: Ar.fromJson(json["SV"]),
        us: Ar.fromJson(json["US"]),
        uy: Ar.fromJson(json["UY"]),
        ve: Ar.fromJson(json["VE"]),
      );

  Map<String, dynamic> toJson() => {
        "AR": ar!.toJson(),
        "AU": au!.toJson(),
        "BO": bo!.toJson(),
        "BR": br!.toJson(),
        "CA": ca!.toJson(),
        "CL": cl!.toJson(),
        "CO": co!.toJson(),
        "CR": cr!.toJson(),
        "DO": resultsDo!.toJson(),
        "EC": ec!.toJson(),
        "GB": gb!.toJson(),
        "GT": gt!.toJson(),
        "HN": hn!.toJson(),
        "IE": ie!.toJson(),
        "IN": resultsIn!.toJson(),
        "JP": jp!.toJson(),
        "KR": kr!.toJson(),
        "MX": mx!.toJson(),
        "NZ": nz!.toJson(),
        "PA": pa!.toJson(),
        "PE": pe!.toJson(),
        "PH": ph!.toJson(),
        "PT": pt!.toJson(),
        "PY": py!.toJson(),
        "SV": sv!.toJson(),
        "US": us!.toJson(),
        "UY": uy!.toJson(),
        "VE": ve!.toJson(),
      };
}

class Ar {
  Ar({
    required this.link,
    required this.buy,
    required this.rent,
    required this.flatrate,
  });

  String? link;
  List<Buy?>? buy;
  List<Buy?>? rent;
  List<Buy?>? flatrate;

  factory Ar.fromJson(Map<String, dynamic> json) => Ar(
        link: json["link"],
        buy: json["buy"] == null
            ? []
            : List<Buy?>.from(json["buy"]!.map((x) => Buy.fromJson(x))),
        rent: json["rent"] == null
            ? []
            : List<Buy?>.from(json["rent"]!.map((x) => Buy.fromJson(x))),
        flatrate: json["flatrate"] == null
            ? []
            : json["flatrate"] == null
                ? []
                : List<Buy?>.from(
                    json["flatrate"]!.map((x) => Buy.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "buy":
            buy == null ? [] : List<dynamic>.from(buy!.map((x) => x!.toJson())),
        "rent": rent == null
            ? []
            : List<dynamic>.from(rent!.map((x) => x!.toJson())),
        "flatrate": flatrate == null
            ? []
            : flatrate == null
                ? []
                : List<dynamic>.from(flatrate!.map((x) => x!.toJson())),
      };
}

class Buy {
  Buy({
    required this.logoPath,
    required this.providerId,
    required this.providerName,
    required this.displayPriority,
  });

  String? logoPath;
  int? providerId;
  String? providerName;
  int? displayPriority;

  factory Buy.fromJson(Map<String, dynamic> json) => Buy(
        logoPath: json["logo_path"],
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        displayPriority: json["display_priority"],
      );

  Map<String, dynamic> toJson() => {
        "logo_path": logoPath,
        "provider_id": providerId,
        "provider_name": providerName,
        "display_priority": displayPriority,
      };
}

class Gb {
  Gb({
    required this.link,
    required this.rent,
  });

  String? link;
  List<Buy?>? rent;

  factory Gb.fromJson(Map<String, dynamic> json) => Gb(
        link: json["link"],
        rent: json["rent"] == null
            ? []
            : List<Buy?>.from(json["rent"]!.map((x) => Buy.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "rent": rent == null
            ? []
            : List<dynamic>.from(rent!.map((x) => x!.toJson())),
      };
}
