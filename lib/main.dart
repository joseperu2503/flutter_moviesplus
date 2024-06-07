import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/environment.dart';
import 'package:moviesplus/config/router/app_router_mobile.dart';
import 'package:moviesplus/config/router/app_router_web.dart';
import 'package:moviesplus/config/theme/app_theme.dart';
import 'package:moviesplus/features/profile/providers/profile_provider.dart';
import 'package:moviesplus/features/shared/services/device_service.dart';
import 'package:moviesplus/generated/l10n.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  await Environment.initEnvironment();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.backgroundColor,
    ),
  );
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    ref.read(profileProvider.notifier).getLanguage();

    //** En caso de ser celular bloquea el giro */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!kIsWeb && Device(context).isPhone) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    return MaterialApp.router(
      title: 'Movies Plus',
      debugShowCheckedModeBanner: false,
      routerConfig: kIsWeb ? appRouterWeb : appRouterMobile,
      theme: AppTheme.getTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('pt'),
      ],
      locale: Locale(profileState.language?.iso6391 ?? 'en'),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      
    );
  }
}
