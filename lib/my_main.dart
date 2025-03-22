import 'package:bloc_structure/common/extensions/size_extensions.dart';
import 'package:bloc_structure/presentation/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common/constants/size_constants.dart';
import 'common/constants/translation_constants.dart';
import 'utils/routes.dart';
import 'presentation/blocs/theme/theme_cubit.dart';

import 'common/constants/languages.dart';
import 'common/constants/route_constants.dart';
import 'common/screenutil/screenutil.dart';
import 'di/get_it.dart';
import 'utils/app_localizations.dart';
import 'presentation/blocs/language/language_cubit.dart';
import 'presentation/blocs/loading/loading_cubit.dart';
import 'presentation/blocs/login/login_cubit.dart';
import 'utils/fade_page_route_builder.dart';
import 'presentation/journeys/loading/loading_screen.dart';

import 'presentation/themes/theme_color.dart';
import 'presentation/themes/theme_text.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyMain extends StatefulWidget {
  const MyMain({super.key});

  @override
  _MyMainState createState() => _MyMainState();
}

class _MyMainState extends State<MyMain> {
  late LanguageCubit _languageCubit;
  late LoginCubit _loginBloc;
  late LoadingCubit _loadingCubit;
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _languageCubit = getItInstance<LanguageCubit>();
    _languageCubit.loadPreferredLanguage();
    _loginBloc = getItInstance<LoginCubit>();
    _loadingCubit = getItInstance<LoadingCubit>();
    _themeCubit = getItInstance<ThemeCubit>();

    _themeCubit.loadPreferredTheme();
  }

  @override
  void dispose() {
    _languageCubit.close();
    _loginBloc.close();
    _loadingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context1) {
    ScreenUtil.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>.value(value: _languageCubit),
        BlocProvider<LoginCubit>.value(value: _loginBloc),
        BlocProvider<LoadingCubit>.value(value: _loadingCubit),
        BlocProvider<ThemeCubit>.value(value: _themeCubit),

        // BlocProvider<InternetCubit>(
        //   create: (context) => internetCubit,
        // ),
      ],
      child: BlocBuilder<ThemeCubit, Themes>(
        builder: (context, theme) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'Movie App',
                theme: ThemeData(
                  unselectedWidgetColor: AppColor.royalBlue,
                  primaryColor:
                      theme == Themes.dark ? AppColor.vulcan : Colors.white,
                  hintColor: AppColor.royalBlue,
                  scaffoldBackgroundColor:
                      theme == Themes.dark ? AppColor.vulcan : Colors.white,
                  brightness:
                      theme == Themes.dark ? Brightness.dark : Brightness.light,
                  cardTheme: CardTheme(
                    color:
                        theme == Themes.dark ? Colors.white : AppColor.vulcan,
                  ),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme: theme == Themes.dark
                      ? ThemeText.getTextTheme()
                      : ThemeText.getLightTextTheme(),
                  appBarTheme: const AppBarTheme(elevation: 0),
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle: Theme.of(context).textTheme.greytitleMedium,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: theme == Themes.dark
                            ? Colors.white
                            : AppColor.vulcan,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                supportedLocales:
                    Languages.languages.map((e) => Locale(e.code)).toList(),
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                builder: (ctx, child) {
                  return LoadingScreen(
                    screen: child!,
                  );
                },
                initialRoute: RouteList.initial,
                onGenerateRoute: (RouteSettings settings) {
                  final routes = Routes.getRoutes(settings);
                  final WidgetBuilder? builder = routes[settings.name];
                  return FadePageRouteBuilder(
                    builder: builder!,
                    settings: settings,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: TranslationConstants.about,
        description: TranslationConstants.aboutDescription,
        buttonText: TranslationConstants.okay,
        image: Image.asset(
          'assets/pngs/tmdb_logo.png',
          height: Sizes.dimen_32.h,
        ),
      ),
    );
  }
}
