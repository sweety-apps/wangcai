jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore .\coolstore_android.key -signedjar .\wangcai_apkcrypt_sign.apk .\wangcai_apkcrypt.apk com.coolstore.wangcai




D:\Program\android-sdks\tools\zipalign.exe -f  -v 4 .\wangcai_apkcrypt_sign.apk .\wangcai_apkcrypt_sign_align.apk


del /s .\wangcai_apkcrypt_sign.apk