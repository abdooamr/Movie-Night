// To parse this JSON data, do
//
//     final watchprovider = watchproviderFromJson(jsonString);

import 'dart:convert';

Watchprovider watchproviderFromJson(String str) =>
    Watchprovider.fromJson(json.decode(str));

String watchproviderToJson(Watchprovider data) => json.encode(data.toJson());

class Watchprovider {
  int? id;
  Results? results;

  Watchprovider({
    this.id,
    this.results,
  });

  factory Watchprovider.fromJson(Map<String, dynamic> json) => Watchprovider(
        id: json["id"],
        results:
            json["results"] == null ? null : Results.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "results": results?.toJson(),
      };
}

class Results {
  Ae? ae;
  Al? al;
  Ae? ar;
  Ae? at;
  Ae? au;
  Ae? ba;
  Bb? bb;
  Ae? be;
  Ae? bg;
  Al? bh;
  Bb? bo;
  Bb? br;
  Bb? bs;
  Ae? ca;
  Ae? ch;
  Ae? cl;
  Ae? co;
  Bb? cr;
  Ae? cv;
  Ae? cz;
  Ae? de;
  Ae? dk;
  Bb? resultsDo;
  Ae? ec;
  Ae? ee;
  Ae? eg;
  Ae? es;
  Ae? fi;
  Al? fj;
  Ae? fr;
  Ae? gb;
  Bb? gf;
  Bb? gi;
  Ae? gr;
  Bb? gt;
  Bb? hk;
  Bb? hn;
  Ae? hr;
  Ae? hu;
  Bb? id;
  Ae? ie;
  Ae? il;
  Ae? resultsIn;
  Bb? iq;
  Ae? resultsIs;
  Ae? it;
  Bb? jm;
  Ae? jo;
  Ae? jp;
  Ae? kr;
  Ae? kw;
  Ae? lb;
  Bb? li;
  Ae? lt;
  Ae? lv;
  Ae? md;
  Ae? mk;
  Ae? mt;
  Ae? mu;
  Bb? mx;
  Bb? my;
  Ae? mz;
  Ae? nl;
  Ae? no;
  Ae? nz;
  Ae? om;
  Bb? pa;
  Ae? pe;
  Bb? ph;
  Bb? pk;
  Ae? pl;
  Bb? ps;
  Ae? pt;
  Bb? py;
  Ae? qa;
  Bb? ro;
  Ae? rs;
  Ae? ru;
  Ae? sa;
  Ae? se;
  Bb? sg;
  Ae? si;
  Ae? sk;
  Bb? sm;
  Bb? sv;
  Bb? th;
  Ae? tr;
  Bb? tt;
  Bb? tw;
  Ae? ug;
  Ae? us;
  Bb? uy;
  Ae? ve;
  Bb? ye;
  Ae? za;

  Results({
    this.ae,
    this.al,
    this.ar,
    this.at,
    this.au,
    this.ba,
    this.bb,
    this.be,
    this.bg,
    this.bh,
    this.bo,
    this.br,
    this.bs,
    this.ca,
    this.ch,
    this.cl,
    this.co,
    this.cr,
    this.cv,
    this.cz,
    this.de,
    this.dk,
    this.resultsDo,
    this.ec,
    this.ee,
    this.eg,
    this.es,
    this.fi,
    this.fj,
    this.fr,
    this.gb,
    this.gf,
    this.gi,
    this.gr,
    this.gt,
    this.hk,
    this.hn,
    this.hr,
    this.hu,
    this.id,
    this.ie,
    this.il,
    this.resultsIn,
    this.iq,
    this.resultsIs,
    this.it,
    this.jm,
    this.jo,
    this.jp,
    this.kr,
    this.kw,
    this.lb,
    this.li,
    this.lt,
    this.lv,
    this.md,
    this.mk,
    this.mt,
    this.mu,
    this.mx,
    this.my,
    this.mz,
    this.nl,
    this.no,
    this.nz,
    this.om,
    this.pa,
    this.pe,
    this.ph,
    this.pk,
    this.pl,
    this.ps,
    this.pt,
    this.py,
    this.qa,
    this.ro,
    this.rs,
    this.ru,
    this.sa,
    this.se,
    this.sg,
    this.si,
    this.sk,
    this.sm,
    this.sv,
    this.th,
    this.tr,
    this.tt,
    this.tw,
    this.ug,
    this.us,
    this.uy,
    this.ve,
    this.ye,
    this.za,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        ae: json["AE"] == null ? null : Ae.fromJson(json["AE"]),
        al: json["AL"] == null ? null : Al.fromJson(json["AL"]),
        ar: json["AR"] == null ? null : Ae.fromJson(json["AR"]),
        at: json["AT"] == null ? null : Ae.fromJson(json["AT"]),
        au: json["AU"] == null ? null : Ae.fromJson(json["AU"]),
        ba: json["BA"] == null ? null : Ae.fromJson(json["BA"]),
        bb: json["BB"] == null ? null : Bb.fromJson(json["BB"]),
        be: json["BE"] == null ? null : Ae.fromJson(json["BE"]),
        bg: json["BG"] == null ? null : Ae.fromJson(json["BG"]),
        bh: json["BH"] == null ? null : Al.fromJson(json["BH"]),
        bo: json["BO"] == null ? null : Bb.fromJson(json["BO"]),
        br: json["BR"] == null ? null : Bb.fromJson(json["BR"]),
        bs: json["BS"] == null ? null : Bb.fromJson(json["BS"]),
        ca: json["CA"] == null ? null : Ae.fromJson(json["CA"]),
        ch: json["CH"] == null ? null : Ae.fromJson(json["CH"]),
        cl: json["CL"] == null ? null : Ae.fromJson(json["CL"]),
        co: json["CO"] == null ? null : Ae.fromJson(json["CO"]),
        cr: json["CR"] == null ? null : Bb.fromJson(json["CR"]),
        cv: json["CV"] == null ? null : Ae.fromJson(json["CV"]),
        cz: json["CZ"] == null ? null : Ae.fromJson(json["CZ"]),
        de: json["DE"] == null ? null : Ae.fromJson(json["DE"]),
        dk: json["DK"] == null ? null : Ae.fromJson(json["DK"]),
        resultsDo: json["DO"] == null ? null : Bb.fromJson(json["DO"]),
        ec: json["EC"] == null ? null : Ae.fromJson(json["EC"]),
        ee: json["EE"] == null ? null : Ae.fromJson(json["EE"]),
        eg: json["EG"] == null ? null : Ae.fromJson(json["EG"]),
        es: json["ES"] == null ? null : Ae.fromJson(json["ES"]),
        fi: json["FI"] == null ? null : Ae.fromJson(json["FI"]),
        fj: json["FJ"] == null ? null : Al.fromJson(json["FJ"]),
        fr: json["FR"] == null ? null : Ae.fromJson(json["FR"]),
        gb: json["GB"] == null ? null : Ae.fromJson(json["GB"]),
        gf: json["GF"] == null ? null : Bb.fromJson(json["GF"]),
        gi: json["GI"] == null ? null : Bb.fromJson(json["GI"]),
        gr: json["GR"] == null ? null : Ae.fromJson(json["GR"]),
        gt: json["GT"] == null ? null : Bb.fromJson(json["GT"]),
        hk: json["HK"] == null ? null : Bb.fromJson(json["HK"]),
        hn: json["HN"] == null ? null : Bb.fromJson(json["HN"]),
        hr: json["HR"] == null ? null : Ae.fromJson(json["HR"]),
        hu: json["HU"] == null ? null : Ae.fromJson(json["HU"]),
        id: json["ID"] == null ? null : Bb.fromJson(json["ID"]),
        ie: json["IE"] == null ? null : Ae.fromJson(json["IE"]),
        il: json["IL"] == null ? null : Ae.fromJson(json["IL"]),
        resultsIn: json["IN"] == null ? null : Ae.fromJson(json["IN"]),
        iq: json["IQ"] == null ? null : Bb.fromJson(json["IQ"]),
        resultsIs: json["IS"] == null ? null : Ae.fromJson(json["IS"]),
        it: json["IT"] == null ? null : Ae.fromJson(json["IT"]),
        jm: json["JM"] == null ? null : Bb.fromJson(json["JM"]),
        jo: json["JO"] == null ? null : Ae.fromJson(json["JO"]),
        jp: json["JP"] == null ? null : Ae.fromJson(json["JP"]),
        kr: json["KR"] == null ? null : Ae.fromJson(json["KR"]),
        kw: json["KW"] == null ? null : Ae.fromJson(json["KW"]),
        lb: json["LB"] == null ? null : Ae.fromJson(json["LB"]),
        li: json["LI"] == null ? null : Bb.fromJson(json["LI"]),
        lt: json["LT"] == null ? null : Ae.fromJson(json["LT"]),
        lv: json["LV"] == null ? null : Ae.fromJson(json["LV"]),
        md: json["MD"] == null ? null : Ae.fromJson(json["MD"]),
        mk: json["MK"] == null ? null : Ae.fromJson(json["MK"]),
        mt: json["MT"] == null ? null : Ae.fromJson(json["MT"]),
        mu: json["MU"] == null ? null : Ae.fromJson(json["MU"]),
        mx: json["MX"] == null ? null : Bb.fromJson(json["MX"]),
        my: json["MY"] == null ? null : Bb.fromJson(json["MY"]),
        mz: json["MZ"] == null ? null : Ae.fromJson(json["MZ"]),
        nl: json["NL"] == null ? null : Ae.fromJson(json["NL"]),
        no: json["NO"] == null ? null : Ae.fromJson(json["NO"]),
        nz: json["NZ"] == null ? null : Ae.fromJson(json["NZ"]),
        om: json["OM"] == null ? null : Ae.fromJson(json["OM"]),
        pa: json["PA"] == null ? null : Bb.fromJson(json["PA"]),
        pe: json["PE"] == null ? null : Ae.fromJson(json["PE"]),
        ph: json["PH"] == null ? null : Bb.fromJson(json["PH"]),
        pk: json["PK"] == null ? null : Bb.fromJson(json["PK"]),
        pl: json["PL"] == null ? null : Ae.fromJson(json["PL"]),
        ps: json["PS"] == null ? null : Bb.fromJson(json["PS"]),
        pt: json["PT"] == null ? null : Ae.fromJson(json["PT"]),
        py: json["PY"] == null ? null : Bb.fromJson(json["PY"]),
        qa: json["QA"] == null ? null : Ae.fromJson(json["QA"]),
        ro: json["RO"] == null ? null : Bb.fromJson(json["RO"]),
        rs: json["RS"] == null ? null : Ae.fromJson(json["RS"]),
        ru: json["RU"] == null ? null : Ae.fromJson(json["RU"]),
        sa: json["SA"] == null ? null : Ae.fromJson(json["SA"]),
        se: json["SE"] == null ? null : Ae.fromJson(json["SE"]),
        sg: json["SG"] == null ? null : Bb.fromJson(json["SG"]),
        si: json["SI"] == null ? null : Ae.fromJson(json["SI"]),
        sk: json["SK"] == null ? null : Ae.fromJson(json["SK"]),
        sm: json["SM"] == null ? null : Bb.fromJson(json["SM"]),
        sv: json["SV"] == null ? null : Bb.fromJson(json["SV"]),
        th: json["TH"] == null ? null : Bb.fromJson(json["TH"]),
        tr: json["TR"] == null ? null : Ae.fromJson(json["TR"]),
        tt: json["TT"] == null ? null : Bb.fromJson(json["TT"]),
        tw: json["TW"] == null ? null : Bb.fromJson(json["TW"]),
        ug: json["UG"] == null ? null : Ae.fromJson(json["UG"]),
        us: json["US"] == null ? null : Ae.fromJson(json["US"]),
        uy: json["UY"] == null ? null : Bb.fromJson(json["UY"]),
        ve: json["VE"] == null ? null : Ae.fromJson(json["VE"]),
        ye: json["YE"] == null ? null : Bb.fromJson(json["YE"]),
        za: json["ZA"] == null ? null : Ae.fromJson(json["ZA"]),
      );

  Map<String, dynamic> toJson() => {
        "AE": ae?.toJson(),
        "AL": al?.toJson(),
        "AR": ar?.toJson(),
        "AT": at?.toJson(),
        "AU": au?.toJson(),
        "BA": ba?.toJson(),
        "BB": bb?.toJson(),
        "BE": be?.toJson(),
        "BG": bg?.toJson(),
        "BH": bh?.toJson(),
        "BO": bo?.toJson(),
        "BR": br?.toJson(),
        "BS": bs?.toJson(),
        "CA": ca?.toJson(),
        "CH": ch?.toJson(),
        "CL": cl?.toJson(),
        "CO": co?.toJson(),
        "CR": cr?.toJson(),
        "CV": cv?.toJson(),
        "CZ": cz?.toJson(),
        "DE": de?.toJson(),
        "DK": dk?.toJson(),
        "DO": resultsDo?.toJson(),
        "EC": ec?.toJson(),
        "EE": ee?.toJson(),
        "EG": eg?.toJson(),
        "ES": es?.toJson(),
        "FI": fi?.toJson(),
        "FJ": fj?.toJson(),
        "FR": fr?.toJson(),
        "GB": gb?.toJson(),
        "GF": gf?.toJson(),
        "GI": gi?.toJson(),
        "GR": gr?.toJson(),
        "GT": gt?.toJson(),
        "HK": hk?.toJson(),
        "HN": hn?.toJson(),
        "HR": hr?.toJson(),
        "HU": hu?.toJson(),
        "ID": id?.toJson(),
        "IE": ie?.toJson(),
        "IL": il?.toJson(),
        "IN": resultsIn?.toJson(),
        "IQ": iq?.toJson(),
        "IS": resultsIs?.toJson(),
        "IT": it?.toJson(),
        "JM": jm?.toJson(),
        "JO": jo?.toJson(),
        "JP": jp?.toJson(),
        "KR": kr?.toJson(),
        "KW": kw?.toJson(),
        "LB": lb?.toJson(),
        "LI": li?.toJson(),
        "LT": lt?.toJson(),
        "LV": lv?.toJson(),
        "MD": md?.toJson(),
        "MK": mk?.toJson(),
        "MT": mt?.toJson(),
        "MU": mu?.toJson(),
        "MX": mx?.toJson(),
        "MY": my?.toJson(),
        "MZ": mz?.toJson(),
        "NL": nl?.toJson(),
        "NO": no?.toJson(),
        "NZ": nz?.toJson(),
        "OM": om?.toJson(),
        "PA": pa?.toJson(),
        "PE": pe?.toJson(),
        "PH": ph?.toJson(),
        "PK": pk?.toJson(),
        "PL": pl?.toJson(),
        "PS": ps?.toJson(),
        "PT": pt?.toJson(),
        "PY": py?.toJson(),
        "QA": qa?.toJson(),
        "RO": ro?.toJson(),
        "RS": rs?.toJson(),
        "RU": ru?.toJson(),
        "SA": sa?.toJson(),
        "SE": se?.toJson(),
        "SG": sg?.toJson(),
        "SI": si?.toJson(),
        "SK": sk?.toJson(),
        "SM": sm?.toJson(),
        "SV": sv?.toJson(),
        "TH": th?.toJson(),
        "TR": tr?.toJson(),
        "TT": tt?.toJson(),
        "TW": tw?.toJson(),
        "UG": ug?.toJson(),
        "US": us?.toJson(),
        "UY": uy?.toJson(),
        "VE": ve?.toJson(),
        "YE": ye?.toJson(),
        "ZA": za?.toJson(),
      };
}

class Ae {
  String? link;
  List<Ad>? flatrate;
  List<Ad>? rent;
  List<Ad>? buy;
  List<Ad>? ads;

  Ae({
    this.link,
    this.flatrate,
    this.rent,
    this.buy,
    this.ads,
  });

  factory Ae.fromJson(Map<String, dynamic> json) => Ae(
        link: json["link"],
        flatrate: json["flatrate"] == null
            ? []
            : List<Ad>.from(json["flatrate"]!.map((x) => Ad.fromJson(x))),
        rent: json["rent"] == null
            ? []
            : List<Ad>.from(json["rent"]!.map((x) => Ad.fromJson(x))),
        buy: json["buy"] == null
            ? []
            : List<Ad>.from(json["buy"]!.map((x) => Ad.fromJson(x))),
        ads: json["ads"] == null
            ? []
            : List<Ad>.from(json["ads"]!.map((x) => Ad.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "flatrate": flatrate == null
            ? []
            : List<dynamic>.from(flatrate!.map((x) => x.toJson())),
        "rent": rent == null
            ? []
            : List<dynamic>.from(rent!.map((x) => x.toJson())),
        "buy":
            buy == null ? [] : List<dynamic>.from(buy!.map((x) => x.toJson())),
        "ads":
            ads == null ? [] : List<dynamic>.from(ads!.map((x) => x.toJson())),
      };
}

class Ad {
  String? logoPath;
  int? providerId;
  String? providerName;
  int? displayPriority;

  Ad({
    this.logoPath,
    this.providerId,
    this.providerName,
    this.displayPriority,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
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

class Al {
  String? link;
  List<Ad>? buy;

  Al({
    this.link,
    this.buy,
  });

  factory Al.fromJson(Map<String, dynamic> json) => Al(
        link: json["link"],
        buy: json["buy"] == null
            ? []
            : List<Ad>.from(json["buy"]!.map((x) => Ad.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "buy":
            buy == null ? [] : List<dynamic>.from(buy!.map((x) => x.toJson())),
      };
}

class Bb {
  String? link;
  List<Ad>? flatrate;

  Bb({
    this.link,
    this.flatrate,
  });

  factory Bb.fromJson(Map<String, dynamic> json) => Bb(
        link: json["link"],
        flatrate: json["flatrate"] == null
            ? []
            : List<Ad>.from(json["flatrate"]!.map((x) => Ad.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "flatrate": flatrate == null
            ? []
            : List<dynamic>.from(flatrate!.map((x) => x.toJson())),
      };
}
