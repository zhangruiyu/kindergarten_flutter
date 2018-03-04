class HomeItemWidget {
  HomeItemWidget({
    this.url,
    this.routeName,
    this.title,
  });

  final String url;
  final String title;
  final String routeName;

  String get tag => url; // Assuming that all asset names are unique.

  bool get isValid => url != null && title != null;
}
