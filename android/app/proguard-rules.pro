# Flutter Proguard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase Proguard Rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Hive Proguard Rules
-keep class com.hivedb.** { *; }
-dontwarn com.hivedb.**

# Play Core (Missing classes for Flutter deferred components)
-dontwarn com.google.android.play.core.**

# ML Kit Text Recognition Proguard Rules
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
