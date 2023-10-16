//TODO: написать нормальный класс, который будет помогать в поиске
class Tag {
  Tag parent;
  List<Tag> children;

  Tag({required this.parent, required this.children});
}
