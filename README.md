# color_swatch

Movie Sereis Tracker App.

# Build
## Android
1. Set Java 11+ as the JAVA_HOME.
```sh
java -version
# /usr/libexec/java_home -V
# JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk-13.0.1.jdk/Contents/Home'
JAVA_HOME='/Applications/Android Studio.app/Contents/jbr/Contents/Home'
java -version
```
1. Build with flutter.
```sh
flutter clean
flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols --split-per-abi
```

## MacOs
Replace all
`MACOSX_DEPLOYMENT_TARGET = 10.6;`
`MACOSX_DEPLOYMENT_TARGET = 10.11;`
to
`MACOSX_DEPLOYMENT_TARGET = 12.1;`
```sh
flutter clean
flutter build macos --obfuscate --split-debug-info=build/app/outputs/symbols
```
To analyze the app size, you can use:
```sh
flutter build macos --release --analyze-size
```

# Development Resources
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
