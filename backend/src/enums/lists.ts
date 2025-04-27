import exp from "constants";
export enum ActivityTypes {
    empty = "-",
    yetiskinKadin = "Yetişkin Kadın",
    yetiskinErkek = "Yetişkin Erkek",
    eykom = "EYKOM",
    cocuk = "Çocuk",
    yuzmeAkademisi = "Yüzme Akademisi",
    havuzBakim = "Havuz Bakım",
}

export enum AgeGroups {
    empty = "-",
    all = "Bütün Yaşlar",
    age13plus = "13+ Yaş",
    age6to12 = "6-12 Yaş",
    age7to12 = "7-12 Yaş",
    age4to6 = "4-6 Yaş",
}

export enum FeeTypes {
    empty = "-",
    paid = "Ücretli",
    free = "Ücretsiz",
}

export enum ReportTypes {
    SaglikRaporu = "Sağlık Raporu",
}

export enum Genders {
    Erkek = "Erkek",
    Kadin = "Kadın",
}


export enum EducationLevels {
    Ilkokul = "İlkokul",
    Ortaokul = "Ortaokul",
    Lise = "Lise",
    Lisans = "Lisans",
    YuksekLisans = "Yüksek Lisans",
    Doktora = "Doktora",
}

export enum HealthStatus {
    Saglikli = "Sağlıklı",
    KontrolEdiliyor = "Kontrol Ediliyor",
    Hasta = "Hasta",
    KontrolYapilmadi = "Kontrol Yapılmadı",
}

export enum PaymentStatus {
    OdemeYapildi = "Ödeme Yapıldı",
    OdemeYapilmadi = "Ödeme Yapılmadı",
}

export enum PaymentMethods {
    Nakit = "Nakit",
    KrediKarti = "Kredi Kartı",
    BankaHavalesi = "Banka Havalesi",
}

export enum SportTypes {
    Yuzme = "Yüzme",
    Pilates = "Pilates",
    Jimnastik = "Jimnastik",
}

export enum Cities {
    Adana = "Adana",
    Adıyaman = "Adıyaman",
    Afyonkarahisar = "Afyonkarahisar",
    Ağrı = "Ağrı",
    Aksaray = "Aksaray",
    Amasya = "Amasya",
    Ankara = "Ankara",
    Antalya = "Antalya",
    Ardahan = "Ardahan",
    Artvin = "Artvin",
    Aydın = "Aydın",
    Balıkesir = "Balıkesir",
    Bartın = "Bartın",
    Batman = "Batman",
    Bayburt = "Bayburt",
    Bilecik = "Bilecik",
    Bingöl = "Bingöl",
    Bitlis = "Bitlis",
    Bolu = "Bolu",
    Burdur = "Burdur",
    Bursa = "Bursa",
    Çanakkale = "Çanakkale",
    Çankırı = "Çankırı",
    Çorum = "Çorum",
    Denizli = "Denizli",
    Diyarbakır = "Diyarbakır",
    Düzce = "Düzce",
    Edirne = "Edirne",
    Elazığ = "Elazığ",
    Erzincan = "Erzincan",
    Erzurum = "Erzurum",
    Eskişehir = "Eskişehir",
    Gaziantep = "Gaziantep",
    Giresun = "Giresun",
    Gümüşhane = "Gümüşhane",
    Hakkari = "Hakkari",
    Hatay = "Hatay",
    Iğdır = "Iğdır",
    Isparta = "Isparta",
    İstanbul = "İstanbul",
    İzmir = "İzmir",
    Kahramanmaraş = "Kahramanmaraş",
    Karabük = "Karabük",
    Karaman = "Karaman",
    Kars = "Kars",
    Kastamonu = "Kastamonu",
    Kayseri = "Kayseri",
    Kırıkkale = "Kırıkkale",
    Kırklareli = "Kırklareli",
    Kırşehir = "Kırşehir",
    Kilis = "Kilis",
    Kocaeli = "Kocaeli",
    Konya = "Konya",
    Kütahya = "Kütahya",
    Malatya = "Malatya",
    Manisa = "Manisa",
    Mardin = "Mardin",
    Mersin = "Mersin",
    Muğla = "Muğla",
    Muş = "Muş",
    Nevşehir = "Nevşehir",
    Niğde = "Niğde",
    Ordu = "Ordu",
    Osmaniye = "Osmaniye",
    Rize = "Rize",
    Sakarya = "Sakarya",
    Samsun = "Samsun",
    Siirt = "Siirt",
    Sinop = "Sinop",
    Sivas = "Sivas",
    Şanlıurfa = "Şanlıurfa",
    Şırnak = "Şırnak",
    Tekirdağ = "Tekirdağ",
    Tokat = "Tokat",
    Trabzon = "Trabzon",
    Tunceli = "Tunceli",
    Uşak = "Uşak",
    Van = "Van",
    Yalova = "Yalova",
    Yozgat = "Yozgat",
    Zonguldak = "Zonguldak"
}