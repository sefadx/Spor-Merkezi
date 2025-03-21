enum ActivityType {
  yetiskinKadin,
  yetiskinErkek,
  eykom,
  cocuk,
  yuzmeAkademisi,
  havuzBakim;

  @override
  String toString() {
    switch (this) {
      case yetiskinErkek:
        return "Yetişkin Erkek";
      case yetiskinKadin:
        return "Yetişkin Kadın";
      case ActivityType.eykom:
        return "EYKOM";
      case ActivityType.cocuk:
        return "Çocuk";
      case ActivityType.yuzmeAkademisi:
        return "Yüzme Akademisi";
      case ActivityType.havuzBakim:
        return "Havuz Bakım";
    }
  }

  static ActivityType fromString(String value) => ActivityType.values.firstWhere((e) => e.toString() == value);
}

enum FeeType {
  paid,
  free;

  @override
  String toString() {
    switch (this) {
      case paid:
        return "Ücretli";
      case free:
        return "Ücretsiz";
    }
  }

  static FeeType fromString(String value) => FeeType.values.firstWhere((e) => e.toString() == value);
}

//List<String> ageGroup = ["13+","6-12","7-12","4-6"];
enum AgeGroup {
  all,
  age13Plus,
  age6to12,
  age7to12,
  age4to6;

  @override
  String toString() {
    switch (this) {
      case all:
        return "Bütün Yaşlar";
      case age13Plus:
        return "13+ Yaş";
      case age6to12:
        return "6-12 Yaş";
      case age7to12:
        return "7-12 Yaş";
      case age4to6:
        return "4-6 Yaş";
    }
  }

  static AgeGroup fromString(String value) => AgeGroup.values.firstWhere((e) => e.toString() == value);
}

enum ReportTypes {
  SaglikRaporu;

  @override
  String toString() {
    switch (this) {
      case SaglikRaporu:
        return "Sağlık Raporu";
    }
  }

  static ReportTypes fromString(String value) => ReportTypes.values.firstWhere((e) => e.toString() == value);
}

enum SportTypes {
  Yuzme,
  Pilates,
  Jimnastik;

  @override
  String toString() {
    switch (this) {
      case Yuzme:
        return "Yüzme";
      case Pilates:
        return "Pilates";
      case Jimnastik:
        return "Jimnastik";
      default:
        return "Unknown data";
    }
  }

  static SportTypes fromString(String value) => SportTypes.values.firstWhere((e) => e.toString() == value);
}

enum PaymentMethods {
  Nakit,
  KrediKarti,
  BankaHavalesi;

  @override
  String toString() {
    switch (this) {
      case Nakit:
        return "Nakit";
      case KrediKarti:
        return "Kredi Kartı";
      case BankaHavalesi:
        return "Banka Havalesi";
      default:
        return "Unknown data";
    }
  }

  static PaymentMethods fromString(String value) => PaymentMethods.values.firstWhere((e) => e.toString() == value);
}

enum Genders {
  Erkek,
  Kadin;

  @override
  String toString() {
    switch (this) {
      case Erkek:
        return "Erkek";
      case Kadin:
        return "Kadın";
      default:
        return "Unknown data";
    }
  }

  static Genders fromString(String value) => Genders.values.firstWhere((e) => e.toString() == value);
}

enum EducationLevels {
  Ilkokul,
  Ortaokul,
  Lise,
  Lisans,
  YuksekLisans,
  Doktora;

  @override
  String toString() {
    switch (this) {
      case Ilkokul:
        return "İlkokul";
      case Ortaokul:
        return "Ortaokul";
      case Lisans:
        return "Lisans";
      case Lise:
        return "Lise";
      case Lisans:
        return "Lisans";
      case YuksekLisans:
        return "Yüksek Lisans";
      case Doktora:
        return "Doktora";
      default:
        return "Unknown data";
    }
  }

  static EducationLevels fromString(String value) => EducationLevels.values.firstWhere((e) => e.toString() == value);
}

enum Cities {
  Adana,
  Adiyaman,
  Afyonkarahisar,
  Agri,
  Aksaray,
  Amasya,
  Ankara,
  Antalya,
  Ardahan,
  Artvin,
  Aydin,
  Balikesir,
  Bartin,
  Batman,
  Bayburt,
  Bilecik,
  Bingol,
  Bitlis,
  Bolu,
  Burdur,
  Bursa,
  Canakkale,
  Cankiri,
  Corum,
  Denizli,
  Diyarbakir,
  Duzce,
  Edirne,
  Elazig,
  Erzincan,
  Erzurum,
  Eskisehir,
  Gaziantep,
  Giresun,
  Gumushane,
  Hakkari,
  Hatay,
  Igdir,
  Isparta,
  Istanbul,
  Izmir,
  Kahramanmaras,
  Karabuk,
  Karaman,
  Kars,
  Kastamonu,
  Kayseri,
  Kirikkale,
  Kirklareli,
  Kirsehir,
  Kilis,
  Kocaeli,
  Konya,
  Kutahya,
  Malatya,
  Manisa,
  Mardin,
  Mersin,
  Mugla,
  Mus,
  Nevsehir,
  Nigde,
  Ordu,
  Osmaniye,
  Rize,
  Sakarya,
  Samsun,
  Siirt,
  Sinop,
  Sivas,
  Sanliurfa,
  Sirnak,
  Tekirdag,
  Tokat,
  Trabzon,
  Tunceli,
  Usak,
  Van,
  Yalova,
  Yozgat,
  Zonguldak;

  @override
  String toString() {
    switch (this) {
      case Cities.Adana:
        return "Adana";
      case Cities.Adiyaman:
        return "Adıyaman";
      case Cities.Afyonkarahisar:
        return "Afyonkarahisar";
      case Cities.Agri:
        return "Ağrı";
      case Cities.Aksaray:
        return "Aksaray";
      case Cities.Amasya:
        return "Amasya";
      case Cities.Ankara:
        return "Ankara";
      case Cities.Antalya:
        return "Antalya";
      case Cities.Ardahan:
        return "Ardahan";
      case Cities.Artvin:
        return "Artvin";
      case Cities.Aydin:
        return "Aydın";
      case Cities.Balikesir:
        return "Balıkesir";
      case Cities.Bartin:
        return "Bartın";
      case Cities.Batman:
        return "Batman";
      case Cities.Bayburt:
        return "Bayburt";
      case Cities.Bilecik:
        return "Bilecik";
      case Cities.Bingol:
        return "Bingöl";
      case Cities.Bitlis:
        return "Bitlis";
      case Cities.Bolu:
        return "Bolu";
      case Cities.Burdur:
        return "Burdur";
      case Cities.Bursa:
        return "Bursa";
      case Cities.Canakkale:
        return "Çanakkale";
      case Cities.Cankiri:
        return "Çankırı";
      case Cities.Corum:
        return "Çorum";
      case Cities.Denizli:
        return "Denizli";
      case Cities.Diyarbakir:
        return "Diyarbakır";
      case Cities.Duzce:
        return "Düzce";
      case Cities.Edirne:
        return "Edirne";
      case Cities.Elazig:
        return "Elazığ";
      case Cities.Erzincan:
        return "Erzincan";
      case Cities.Erzurum:
        return "Erzurum";
      case Cities.Eskisehir:
        return "Eskişehir";
      case Cities.Gaziantep:
        return "Gaziantep";
      case Cities.Giresun:
        return "Giresun";
      case Cities.Gumushane:
        return "Gümüşhane";
      case Cities.Hakkari:
        return "Hakkari";
      case Cities.Hatay:
        return "Hatay";
      case Cities.Igdir:
        return "Iğdır";
      case Cities.Isparta:
        return "Isparta";
      case Cities.Istanbul:
        return "İstanbul";
      case Cities.Izmir:
        return "İzmir";
      case Cities.Kahramanmaras:
        return "Kahramanmaraş";
      case Cities.Karabuk:
        return "Karabük";
      case Cities.Karaman:
        return "Karaman";
      case Cities.Kars:
        return "Kars";
      case Cities.Kastamonu:
        return "Kastamonu";
      case Cities.Kayseri:
        return "Kayseri";
      case Cities.Kirikkale:
        return "Kırıkkale";
      case Cities.Kirklareli:
        return "Kırklareli";
      case Cities.Kirsehir:
        return "Kırşehir";
      case Cities.Kilis:
        return "Kilis";
      case Cities.Kocaeli:
        return "Kocaeli";
      case Cities.Konya:
        return "Konya";
      case Cities.Kutahya:
        return "Kütahya";
      case Cities.Malatya:
        return "Malatya";
      case Cities.Manisa:
        return "Manisa";
      case Cities.Mardin:
        return "Mardin";
      case Cities.Mersin:
        return "Mersin";
      case Cities.Mugla:
        return "Muğla";
      case Cities.Mus:
        return "Muş";
      case Cities.Nevsehir:
        return "Nevşehir";
      case Cities.Nigde:
        return "Niğde";
      case Cities.Ordu:
        return "Ordu";
      case Cities.Osmaniye:
        return "Osmaniye";
      case Cities.Rize:
        return "Rize";
      case Cities.Sakarya:
        return "Sakarya";
      case Cities.Samsun:
        return "Samsun";
      case Cities.Siirt:
        return "Siirt";
      case Cities.Sinop:
        return "Sinop";
      case Cities.Sivas:
        return "Sivas";
      case Cities.Sanliurfa:
        return "Şanlıurfa";
      case Cities.Sirnak:
        return "Şırnak";
      case Cities.Tekirdag:
        return "Tekirdağ";
      case Cities.Tokat:
        return "Tokat";
      case Cities.Trabzon:
        return "Trabzon";
      case Cities.Tunceli:
        return "Tunceli";
      case Cities.Usak:
        return "Uşak";
      case Cities.Van:
        return "Van";
      case Cities.Yalova:
        return "Yalova";
      case Cities.Yozgat:
        return "Yozgat";
      case Cities.Zonguldak:
        return "Zonguldak";
      default:
        return "Unknown City";
    }
  }

  static Cities fromString(String value) => Cities.values.firstWhere((e) => e.toString() == value);
}
