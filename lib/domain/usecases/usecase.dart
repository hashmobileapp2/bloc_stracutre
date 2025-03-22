import 'package:dartz/dartz.dart';

import '../entities/app_error.dart';


//Type = anything that will return to the data
//params = anything that will come from the cubit or bloc to the data
abstract class UseCase<returnData, Params> {
  Future<Either<AppError, returnData>> call(Params params);
}
