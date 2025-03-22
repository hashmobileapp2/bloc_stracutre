import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/get_it.dart';

import '../../../utils/loading_progress_bar.dart';
import '../../blocs/movie_carousel/movie_carousel_cubit.dart';

import '../../widgets/app_error_widget.dart';
import '../drawer/navigation_drawer.dart' as ND;
import 'movie_carousel/movie_carousel_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieCarouselCubit movieCarouselCubit;
  @override
  void initState() {
    super.initState();
    movieCarouselCubit = getItInstance<MovieCarouselCubit>();
    movieCarouselCubit.loadCarousel();
  }

  @override
  void dispose() {
    super.dispose();
    movieCarouselCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //provide all the bloc that will used in the screen if already create through "register factory" then used
        // BlocProvider.value(
        //   value: searchMovieCubit,
        // ),
        //else if not create then we need to create the through
        BlocProvider(
          create: (context) => movieCarouselCubit,
        ),
        // BlocProvider(
        //   create: (context) => movieBackdropCubit,
        // ),
        // BlocProvider(
        //   create: (context) => movieTabbedCubit,
        // ),
        // BlocProvider.value(
        //   value: searchMovieCubit,
        // ),
      ],
      child: Scaffold(
        drawer: const ND.NavigationDrawer(),
        body: BlocBuilder<MovieCarouselCubit, MovieCarouselState>(
          builder: (context, state) {
            if (state is MovieCarouselLoaded) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FractionallySizedBox(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.6,
                    child: MovieCarouselWidget(
                      movies: state.movies,
                      defaultIndex: state.defaultIndex,
                    ),
                  ),
                ],
              );
            } else if (state is MovieCarouselError) {
              return AppErrorWidget(
                onPressed: () => movieCarouselCubit.loadCarousel(),
                errorType: state.errorType,
              );
            } else if (state is MovieCarouseLoading) {
              return Center(
                child: LoadingProgressBar(
                  height: 35,
                  width: 35,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
