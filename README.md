IONIC - Soccer
=============================

#### Install
```
$ sudo npm install
$ bower install
$ ionic plugin add cordova-plugin-device
$ ionic plugin add cordova-plugin-console
$ ionic plugin add cordova-plugin-whitelist
$ ionic plugin add cordova-plugin-splashscreen
$ ionic plugin add cordova-plugin-statusbar
$ ionic plugin add cordova-plugin-inappbrowser
$ ionic plugin add com.ionic.keyboard
$ ionic plugin add cordova-plugin-app-version
$ ionic platform remove ios && ionic platform add ios
$ ionic platform remove android && ionic platform add android
```

#### Run
* iOS
```shell
$ ionic run ios -l -c -b
$ ionic run ios -l -c -b --target="iPhone-4s"
$ ionic run ios -l -c -b --device"
```
* Android
```
$ ionic run android -l -c -b
$ ionic run android -l -c -b --device"
```

#### Release Builds
* iOS
```shell
$ ionic plugin remove cordova-plugin-console
$ ionic build ios --release
```
* Android
```
$ ionic plugin remove cordova-plugin-console
$ ionic build android --release
$ keytool -genkey -v -keystore Soccer.keystore -alias Soccer -keyalg RSA -keysize 2048 -validity 10000
$ jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore Soccer.keystore "platforms/android/build/outputs/apk/android-release-unsigned.apk" Soccer
$ zipalign -v 4 "platforms/android/build/outputs/apk/android-release-unsigned.apk" "platforms/android/build/outputs/apk/Soccer.apk"
```

#### Download
* iOS
  - TestFight app
* Android
  - https://intbizth.com/apps/bypass/soccer
