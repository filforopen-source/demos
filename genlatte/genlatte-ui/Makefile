app:
	fvm flutter run -d web-server --web-port 8080

app/kiosk: app

app/kiosk/wasm:
	fvm flutter run -d web-server --wasm --web-port 8080

app/barista:
	fvm flutter run -d web-server --web-port 8083

app/moderator:
	fvm flutter run -d web-server --web-port 8085

app/queue:
	fvm flutter run -d web-server --web-port 8084

app/queue/wasm:
	fvm flutter run -d web-server --wasm --web-port 8084

app/recent:
	fvm flutter run -d web-server --web-port 8082

app/recent/wasm:
	fvm flutter run -d web-server --wasm --web-port 8082

gen/ui:
	fvm dart run build_runner build --delete-conflicting-outputs

gen/data:
	cd ../genlatte-data && fvm dart run build_runner build --delete-conflicting-outputs

gen:
	$(MAKE) gen/data
	$(MAKE) gen/ui

gen/widgetbook:
	cd widgetbook && fvm dart run build_runner build -d

.PHONY: widgetbook
widgetbook:
	cd widgetbook && fvm flutter run -d web-server --web-port 8081