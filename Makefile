gen-build:
	dart run build_runner build

gen-locale:
	dart pub run easy_localization:generate -f keys -o locale.g.dart -S assets/translations -O lib/res/generated

init-native-splash-screen:
	dart run flutter_native_splash:create

init-launcher-icons:
	flutter pub run flutter_launcher_icons