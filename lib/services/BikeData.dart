import 'dart:math';

class BackendService {
  static Future<List> getSuggestions(String query) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
  }
}

class BikeName {

  String? brandName;

  BikeName({required this.brandName});

  static final List<String> tvs = [
    'Apache RTR 160 159.7cc Petrol',
    'Apache RTR 160 4V 159.7cc Petrol',
    'Apache RR 310 312cc Petrol',
    'Apache RTR 180 177.4cc Petrol',
    'Apache RTR 200 4V 197.75cc Petrol',
    'Sport 109.7cc',
    'Jupiter 109.7cc Petrol',
    'NTORQ 125 124.8cc Petrol',
    'XL100 99.7cc Petrol',
    'Scooty Zest 109.7cc',
    'Scooty Pep Plus 87.8cc',
    'Star City Plus 109.7cc',
    'Radeon 109.7cc',
    'Scooty Zest 109.7cc',
    'Pep',
    'Victor',
    'Wego',
    'Streak',
    'Max',
    'Jive',
    'Star Sport',
    'iQube Electric 4400W',
  ];

  static final List<String> hero = [
    'Splendor Plus 97.2cc',
    'HF Delux 97.2cc',
    'Glamour 125cc',
    'Passion Pro 113.2cc',
    'Super Splendor 124.7cc',
    'Maestro Edge 125 125cc',
    'Pleasure Plus 110.9cc',
    'Splendor iSmart 113.2cc',
    'Destini 125 124.6cc',
    'Xtreme 160R 163cc',
    'XPulse200 199.6cc',
    'CD Delux',
    'CD 100',
    'Achiever',
    'CBZ Xtreme',
    'Passion',
    'Passion Plus',
    'Splendor',
    'Karizma ZMR',
    'Hunk',
    'Maestro',
    'Pleasure',
    'Duet',
    'Ignitor',
  ];

  static final List<String> honda = [
    'Activs 6G 109.51cc',
    'Shine 124cc',
    'Dio 109.51cc',
    'Activa 125 124cc',
    'Unicorn 162.7cc',
    'Sp 125 124cc',
    'Livo 109.51cc',
    'XBlade 126.71cc',
    'Grazia 124cc',
    'CD 110 Dream 109.51cc',
    'CB Hornet',
    'CBR',
    'Activa 5G',
    'Activa 4G',
    'Activa 3G',
    'Activa 2G',
    'Activa',
    'Stunner',
    'Trigger',
    'Dream Yuga',
    'Twister',
  ];

  static final List<String> royalenfield = [
    'Classic 350 346cc',
    'Classic 500',
    'Thunderbird 350',
    'Thunderbird 500',
    'Bullet 350 346cc',
    'Himalayan 411cc',
    'Interceptor 650 648cc',
    'Continental GT 650 648cc',
  ];

  static final List<String> bajaj = [
    'Pulsar 150 149.5cc',
    'Pulsar NS200 199.5cc',
    'Pulsar 220F 220cc',
    'Pulsar RS200 199.5cc',
    'Pulsar 125 124.4cc',
    'Pulsar NS160 160.3cc',
    'Pulsar 180F 178.6cc',
    'CT 100 102cc',
    'Dominar 400 373.3cc',
    'Dominar 250 248.77cc',
    'Avenger Street 160 160cc',
    'Avenger Cruise 220 220cc',
    'Discover 150',
    'Discover 100',
    'Vikrant V15',
    'CT110 115.45cc',
    'Platina 110 H Gear 115.45',
    'Platina 100 102cc',
    'Chetak',
  ];

  static final List<String> yamaha = [
    'FZS 25',
    'FZ 25',
    'YZF R15',
    'FZS-F1',
    'MT-15',
    'Fascino 125',
    'FZ-F1',
    'RayZR 125',
    'RayZ',
    'XSR 155',
    'N Max 155',
    'FZ',
    'FZ S',
    'RX 100',
    'Fazer',
    'Gladiator',
  ];

  static final List<String> suzuki = [
    'Access',
    'Gixxer 155',
    'Gixxer 250',
    'Gixxer SF 155',
    'Gixxer SF 250',
    'Burgman Street',
    'Intruder',
    'Swish Hayate',
    'Samurai',
    'GS',
    'Sling Shot',
    'Fiero',
  ];

  static final List<String> mahindra = [
    'Mojo',
    'Duro',
    'Gusto',
    'Centuro',
  ];

  static final List<String> ktm = [
    'Duke 125',
    'Duke 200',
    'Duke 250',
    'Duke 390',
    'RC 125',
    'RC 200',
    'RC 250',
    'RC 390',
    'Adventure 390',
  ];

  static final List<String> jawa = [
    'Jawa',
    'Jawa Perak',
    'Jawa 42',
  ];

  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    if(this.brandName == 'tvs'){
      matches.addAll(tvs);
    }else if(this.brandName == 'hero'){
      matches.addAll(hero);
    }else if(this.brandName == 'honda'){
      matches.addAll(honda);
    }else if(this.brandName == 'royal enfield'){
      matches.addAll(royalenfield);
    }else if(this.brandName == 'bajaj'){
      matches.addAll(bajaj);
    }else if(this.brandName == 'yamaha'){
      matches.addAll(yamaha);
    }else if(this.brandName == 'suzuki'){
      matches.addAll(suzuki);
    }else if(this.brandName == 'mahindra'){
      matches.addAll(mahindra);
    }else if(this.brandName == 'ktm'){
      matches.addAll(ktm);
    }else if(this.brandName == 'jawa'){
      matches.addAll(jawa);
    }
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class CompanyName {
  static final List<String> companynames = [
    'TVS',
    'Hero',
    'Honda',
    'Royal Enfield',
    'Bajaj',
    'Yamaha',
    'Suzuki',
    'Mahindra',
    'KTM',
    'Jawa',
  ];

  static List<String> getSuggestions(String query) {
    var matches = <String>[];
    matches.addAll(companynames);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}