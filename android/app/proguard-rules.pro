-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
}

-assumenosideeffects class kotlin.io.ConsoleKt {
    public static *** println(...);
}

-assumenosideeffects class java.io.PrintStream {
    public void println(...);
}

-dontwarn android.util.Log
-dontwarn kotlin.io.ConsoleKt

-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

