import 'dart:convert';

Favorites favoritesFromJson(String str) => Favorites.fromJson(json.decode(str));

String favoritesToJson(Favorites data) => json.encode(data.toJson());

class Favorites {
  List<Favorite> favorites;

  Favorites({
    required this.favorites,
  });

  factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
        favorites: List<Favorite>.from(
            json["favorites"].map((x) => Favorite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "favorites": List<dynamic>.from(favorites.map((x) => x.toJson())),
      };
}

class Favorite {
  String cityName;
  double latitude;
  double longitude;

  Favorite({
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        cityName: json["city_name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "city_name": cityName,
        "latitude": latitude,
        "longitude": longitude,
      };
}
