# Smart Organizer — Flutter Starter

هذه حزمة بداية لمشروع Android باستخدام Flutter + Kotlin.

## مهم قبل البدء
الحزمة تحتوي على ملفات التطبيق الأساسية وتعديلات Android، وليست APK جاهزًا.
لإنشاء APK تحتاج إلى Flutter SDK وAndroid SDK داخل بيئة التطوير.

## الاستيراد في Klencod
1. أنشئ مشروع Flutter جديدًا باسم `smart_organizer`.
2. اختر Kotlin كلغة Android الأصلية.
3. انسخ مجلد `lib` من هذه الحزمة إلى جذر مشروع Flutter واستبدله.
4. انسخ مجلد `android/app/src/main` من هذه الحزمة إلى:
   `android/app/src/main` في مشروعك، مع استبدال الملفات عند الطلب.
5. تأكد أن `namespace` و`applicationId` في ملف Gradle يساويان:
   `com.example.smart_organizer`
   وإذا كانا مختلفين، غيّر سطر `package` في `MainActivity.kt` ومسار المجلد ليتطابقا.
6. من Terminal نفّذ:
   `flutter pub get`
   `flutter run`

## إنشاء APK
بعد نجاح التشغيل:
`flutter build apk --release`

ملف APK الناتج عادةً:
`build/app/outputs/flutter-apk/app-release.apk`

## ما الذي يفعله الإصدار الحالي؟
- يعرض التطبيقات التي تظهر في قائمة تشغيل التطبيقات (Launcher activities).
- يعرض الاسم والأيقونة واسم الحزمة.
- يعرض عدد التطبيقات المكتشفة.

## حدود Android
هذا الإصدار لا ينقل الأيقونات أو ينشئ مجلدات على شاشة Vivo الأصلية.
يمكنه لاحقًا إنشاء مخطط ترتيب ومعاينة تفاعلية، ثم إرشاد المستخدم لتطبيقه يدويًا.
نقل أيقونات تطبيق آخر أو إعادة ترتيبها ليس متاحًا عبر Android API عامة لتطبيق عادي.

استخدمنا `<queries>` لاستعلام تطبيقات Launcher بدل طلب `QUERY_ALL_PACKAGES` في البداية.
قد تختلف الرؤية حسب إصدار Android وسياسات الجهاز.