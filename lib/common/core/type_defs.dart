import 'package:fpdart/fpdart.dart';
import 'package:wsu_laptops/common/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
