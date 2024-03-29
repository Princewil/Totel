import 'package:cheffy/Utils/app_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'app/app.dart';
import 'app/app.router.dart';
import 'modules/theme/theme.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_Ey2p2N4zmrg5nqZrLTpcPg4h00MJSdtjP2';
  //await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await Application.init(Flavor.dev);

  // if (kDebugMode) {
  runApp(const App());
  // } else {
  //   runZonedGuarded(
  //       () => runApp(const MyApp()),
  //       (error, stack) => FirebaseCrashlytics.instance
  //           .recordError(error, stack, fatal: true));
  // }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return EasyLocalization(
    //   supportedLocales: const [Locale('en'), Locale('si'), Locale('ta')],
    //   path: 'assets/langs',
    //   fallbackLocale: const Locale('en'),
    //   useOnlyLangCode: true,
    //   child:
    return ThemeBuilder(
      defaultThemeMode: ThemeMode.light, // Dark mode is not well implemented
      darkTheme: AppTheme.of(context).dark,
      lightTheme: AppTheme.of(context).light,
      builder: (context, regularTheme, darkTheme, themeMode) => MultiProvider(
        providers: appProviders,
        child: MaterialApp(
          title: '${Application.appName}${Application.flavor.appNameSuffix}',
          theme: regularTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          // localizationsDelegates: context.localizationDelegates,
          // supportedLocales: context.supportedLocales,
          // locale: context.locale,
          // initialRoute: ,
          // onGenerateRoute: RouteGenerator.generateRoute,
          navigatorKey: StackedService.navigatorKey,
          onGenerateRoute: StackedRouter().onGenerateRoute,
        ),
      ),
      // ),
    );
  }
}
