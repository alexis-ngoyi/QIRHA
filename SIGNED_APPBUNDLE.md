# qirha

# TO GENERATE SIGNED APPBUNDLE

1. cd android && ./gradlew clean
2. cd .. && flutter clean
3. flutter build appbundle --release
4. keytool -genkeypair -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
5. apksigner sign --ks my-release-key.keystore --min-sdk-version 16 --out signed-app-release.aab build/app/outputs/bundle/release/app-release.aab


flutter run -d 101132535J112255