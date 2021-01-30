// enum Declinatio {
//   Decl1,
//   Decl2,
//   Decl3,
//   Decl4,
//   Decl5,
//   Decl3EI,
//   Decl3GYI,
//   Decl4Ne,
// }

var _ragok = [
  ['am', 'ae', 'ae', 'a', 'ae', 'as', 'arum', 'is', 'is'],
  ['um', 'i', 'o', 'o', 'i', 'os', 'orum', 'is', 'is'],
  ['em', 'is', 'i', 'e', 'es', 'es', 'um', 'ibus', 'ibus'],
  ['um', 'us', 'ui', 'u', 'us', 'us', 'uum', 'ibus', 'ibus'],
  ['em', 'ei', 'ei', 'e', 'es', 'es', 'erum', 'ebus', 'ebus'],
  ['em', 'is', 'i', 'e', 'es', 'es', 'ium', 'ibus', 'ibus'],
  ['em', 'is', 'i', 'i', 'es', 'es', 'ium', 'ibus', 'ibus'],
  ['u', 'us', 'u', 'u', 'ua', 'ua', 'uum', 'ibus', 'ibus'],
];

var _ne_p_nmac = ['', 'a', 'a', 'ua', '', '', 'ia', 'ua'];

class LatinWord {
  int decl;
  String base;
  String nominativus;
  bool neutrum;

  LatinWord({this.decl, this.base, this.nominativus, this.neutrum});

  String ragoz(int index) {
    if (index >= 10) {
      throw Exception('Index out of bounds');
    }

    if (index == 0) {
      // Singularis nominativus
      return this.nominativus;
    } else if (index == 1 && neutrum) {
      return this.nominativus;
    }

    if ((index == 5 || index == 6) && neutrum) {
      return base + _ne_p_nmac[this.decl];
    }

    return base + _ragok[this.decl][index - 1];
  }

  LatinWord.autoDetect({String genitivus, this.nominativus, this.neutrum}) {
    var index = _ragok.indexWhere((element) => genitivus.endsWith(element[1]));
    if (index == -1) {
      throw Exception('Invalid genitivus');
    }
    if (genitivus.endsWith("ei")) {
      this.decl = 4;
    } else {
      this.decl = index;
    }

    _declinatioMagic(genitivus);
  }

  LatinWord.forceDecl(
      {String genitivus, this.nominativus, this.neutrum, this.decl}) {
    _declinatioMagic(genitivus);
  }

  void _declinatioMagic(String genitivus) {
    this.base =
        genitivus.substring(0, genitivus.length - _ragok[decl][1].length);

    if (decl == 2) {
      if (parisyl(genitivus, nominativus) || fustli(base, nominativus)) {
        this.decl = 5;
      } else if (nyarale(nominativus)) {
        this.decl = 6;
      }
    }

    if (decl == 4 && neutrum) {
      this.decl = 7;
    }
  }
}

var _mgh = ['a', 'e', 'i', 'o', 'u'];

int _syllables(String word) {
  int syl = 0;
  for (int i = 0; i < word.length; ++i) {
    if (_mgh.contains(word[i])) {
      ++syl;
      if (i < word.length - 1 && word[i] == 'a' && word[i + 1] == 'e') {
        ++i;
      }
    }
  }
  return syl;
}

bool parisyl(String genitivus, String nominativus) {
  return _syllables(genitivus) == _syllables(nominativus) &&
      (nominativus.endsWith('es') || nominativus.endsWith('is'));
}

bool fustli(String base, String nominativus) {
  return !(_mgh.contains(base[base.length - 1]) ||
          _mgh.contains(base[base.length - 2])) &&
      ['s', 'x'].any((element) => nominativus.endsWith(element));
}

bool nyarale(String nominativus) {
  return ['ar', 'al', 'e'].any((element) => nominativus.endsWith(element));
}

bool checkCorrectGenitivus(String genitivus) {
  return _ragok.any((element) => genitivus.endsWith(element[1]));
}
