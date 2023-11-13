// Вообще, по хорошему, надо и штуки, и миллилитры тоже в граммы переводить
// TODO: добавить ещё всякие столовые и чайные ложки
enum IngredientUnit {
  grams,
  mils,
  pieces,
}

class Ingredient {
  /// Название продукта.
  final String name;

  /// Название продукта на торговой площадке.
  ///
  /// Используется при заказе доставки данного продукта.
  final String marketName;

  /// Единица измерения продукта: граммы, миллилитры или штуки.
  final IngredientUnit unit;

  /// Количество ккал на 100 гр/мл или 1 штуку.
  final double kcal;

  /// Количество углеводов на 100 гр/мл или 1 штуку.
  final double carbs;

  /// Количество белков на 100 гр/мл или 1 штуку.
  final double proteins;

  /// Количество жиров на 100 гр/мл или 1 штуку.
  final double fats;

  const Ingredient(
      {required this.name,
        required this.marketName,
      required this.unit,
      // TODO: убрать нули и вернуть required
      this.kcal = 0,
      this.carbs = 0,
      this.proteins = 0,
      this.fats = 0})
      : assert(kcal >= 0),
        assert(carbs >= 0 && carbs <= 100),
        assert(proteins >= 0 && proteins <= 100),
        assert(fats >= 0 && fats <= 100);
}
