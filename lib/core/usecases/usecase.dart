abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use when a use case requires no parameters.
class NoParams {}
