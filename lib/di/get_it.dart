import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import '../domain/usecases/get_preferred_theme.dart';
import '../domain/usecases/update_theme.dart';
import '../presentation/blocs/theme/theme_cubit.dart';

import '../data/core/api_client.dart';
import '../data/data_sources/authentication_local_data_source.dart';
import '../data/data_sources/authentication_remote_data_source.dart';
import '../data/data_sources/language_local_data_source.dart';
import '../data/data_sources/movie_local_data_source.dart';
import '../data/data_sources/movie_remote_data_source.dart';
import '../data/repositories/app_repository_impl.dart';
import '../data/repositories/authentication_repository_impl.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/local_repository.dart';
import '../domain/repositories/authentication_repository.dart';
import '../domain/repositories/network_repository.dart';
import '../domain/usecases/check_if_movie_favorite.dart';
import '../domain/usecases/delete_favorite_movie.dart';
import '../domain/usecases/get_cast.dart';
import '../domain/usecases/get_coming_soon.dart';
import '../domain/usecases/get_favorite_movies.dart';
import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/get_playing_now.dart';
import '../domain/usecases/get_popular.dart';
import '../domain/usecases/get_preferred_language.dart';
import '../domain/usecases/get_trending.dart';
import '../domain/usecases/get_videos.dart';
import '../domain/usecases/login_user.dart';
import '../domain/usecases/logout_user.dart';
import '../domain/usecases/save_movie.dart';
import '../domain/usecases/search_movies.dart';
import '../domain/usecases/update_language.dart';
import '../presentation/blocs/language/language_cubit.dart';
import '../presentation/blocs/loading/loading_cubit.dart';
import '../presentation/blocs/login/login_cubit.dart';

import '../presentation/blocs/movie_carousel/movie_carousel_cubit.dart';

final getItInstance = GetIt.I;

Future init() async {
  //TODO : JE BLOC NE EK VAR INITIALIZE KARAVA NI JARUR PADE TENE registerSingleton INITIALIZE KARVANO
  //TODO : registerSingleton EK J VAR INITIALIZE KARSE NE TENE REUSE KARSE WHILE USE MA AAVSE TYARE
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance
      .registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl());

  getItInstance.registerLazySingleton<LanguageLocalDataSource>(
      () => LanguageLocalDataSourceImpl());

  getItInstance.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<AuthenticationLocalDataSource>(
      () => AuthenticationLocalDataSourceImpl());

  getItInstance
      .registerLazySingleton<GetTrending>(() => GetTrending(getItInstance()));
  getItInstance
      .registerLazySingleton<GetPopular>(() => GetPopular(getItInstance()));
  getItInstance.registerLazySingleton<GetPlayingNow>(
      () => GetPlayingNow(getItInstance()));
  getItInstance.registerLazySingleton<GetComingSoon>(
      () => GetComingSoon(getItInstance()));

  getItInstance.registerLazySingleton<GetMovieDetail>(
      () => GetMovieDetail(getItInstance()));

  getItInstance.registerLazySingleton<GetCast>(() => GetCast(getItInstance()));

  getItInstance
      .registerLazySingleton<SearchMovies>(() => SearchMovies(getItInstance()));

  getItInstance
      .registerLazySingleton<GetVideos>(() => GetVideos(getItInstance()));

  getItInstance
      .registerLazySingleton<SaveMovie>(() => SaveMovie(getItInstance()));

  getItInstance.registerLazySingleton<GetFavoriteMovies>(
      () => GetFavoriteMovies(getItInstance()));

  getItInstance.registerLazySingleton<DeleteFavoriteMovie>(
      () => DeleteFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<CheckIfFavoriteMovie>(
      () => CheckIfFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<UpdateLanguage>(
      () => UpdateLanguage(getItInstance()));

  getItInstance.registerLazySingleton<GetPreferredLanguage>(
      () => GetPreferredLanguage(getItInstance()));

  getItInstance
      .registerLazySingleton<UpdateTheme>(() => UpdateTheme(getItInstance()));

  getItInstance.registerLazySingleton<GetPreferredTheme>(
      () => GetPreferredTheme(getItInstance()));

  getItInstance
      .registerLazySingleton<LoginUser>(() => LoginUser(getItInstance()));

  getItInstance
      .registerLazySingleton<LogoutUser>(() => LogoutUser(getItInstance()));

  getItInstance
      .registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
            getItInstance(),
            getItInstance(),
          ));

  getItInstance.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(
        getItInstance(),
      ));
  getItInstance.registerFactory(
    () => MovieCarouselCubit(
      loadingCubit: getItInstance(),
      getTrending: getItInstance(),
    ),
  );

  getItInstance.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(getItInstance(), getItInstance()));

  getItInstance.registerSingleton<LanguageCubit>(LanguageCubit(
    updateLanguage: getItInstance(),
    getPreferredLanguage: getItInstance(),
  ));

  //TODO : JE BLOC NE VARUMVAR UPDATE KARVANI JARUR PADE TENE registerFactory INITIALZE KARVANO
  //TODO : registerFactory DAR VAKHTE NO INSTANCE BANAVI NE AAPE
  getItInstance.registerFactory(() => LoginCubit(
        loginUser: getItInstance(),
        logoutUser: getItInstance(),
        loadingCubit: getItInstance(),
      ));

  //TODO : JE BLOC NE EK VAR INITIALIZE KARAVA NI JARUR PADE TENE registerSingleton INITIALIZE KARVANO
  //TODO : registerSingleton EK J VAR INITIALIZE KARSE NE TENE REUSE KARSE WHILE IN MAIN
  getItInstance.registerSingleton<LoadingCubit>(LoadingCubit());
  getItInstance.registerSingleton<ThemeCubit>(ThemeCubit(
    getPreferredTheme: getItInstance(),
    updateTheme: getItInstance(),
  ));
}
