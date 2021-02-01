# latrag_app

Egy segédprogram fõleg a latin házi feladatok
megkönnyítéséhez. Automatikusan elragoz egy
latin fõnevet, most app formában.

# Telepítés

A Flutternek köszönhetõen ez az app elfut

 - Androidon
 - iOS-en
 - Linuxon
 - Macen
 - Windowson
 - Webalkalmazásként

A helyi fordításhoz szükség van a Flutter CLI-re.
(A [flutter.dev](https://flutter.dev) oldalról beszerezhetõ)

Ezenkivul szukseg van ezekre:

 - Linuxon: CMake, Git, GCC, G++, GTK+ fejlesztoi fejlecek
 - Macen: XCode
 - Windowson: Visual Studio C++ fejlesztoeszkozokkel

Amennyiben Android buildet szeretnenk kesziteni, kell az Android SDK is.
Ezt legegyszerubben az [Android Studio](https://developer.android.com/studio) telepitesevel szerezhetjuk be.

A forditashoz lepjunk be a `git clone`-val letoltott forraskod mappajaba
parancssorban (Windowson lehetoleg PowerShell, Linuxon es Macen lehet
bash, zsh, barmelyik), es futtassuk ezeket a parancsokat:

```bash
$ flutter create . # Biztosítsuk az összes szükséges buildfájl meglételét
$ flutter build <célpont>
```

<célpont> lehet

 - `apk`: Androidhoz
 - `windows` / `macosx` / `linux`
 - `ios`

A `flutter build` parancs kimenete megmutatja a leforditott fajlok helyet.
A kesz program telepitese es/vagy kozzetetele platformfuggo.
