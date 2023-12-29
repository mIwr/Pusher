
enum HmsFastAppTarget {
  dev, prod
}

extension HmsFastAppTargetExt on HmsFastAppTarget {

  static HmsFastAppTarget? from(int apiKey) {
    switch(apiKey) {
      case 1: return HmsFastAppTarget.dev;
      case 2: return HmsFastAppTarget.prod;
    }
    return null;
  }

  int get apiKey {
    switch(this) {
      case HmsFastAppTarget.dev: return 1;
      case HmsFastAppTarget.prod: return 2;
    }
  }
}