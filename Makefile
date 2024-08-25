gen-build:
	dart run build_runner build

init-native-splash-screen:
	dart run flutter_native_splash:create

init-launcher-icons:
	flutter pub run flutter_launcher_icons