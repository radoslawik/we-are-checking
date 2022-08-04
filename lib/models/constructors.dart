class Constructor {
    Constructor({
        required this.constructorId,
        required this.url,
        required this.name,
        required this.nationality,
    });

    String constructorId;
    String url;
    String name;
    String nationality;

    factory Constructor.fromJson(Map<String, dynamic> json) => Constructor(
        constructorId: json["constructorId"],
        url: json["url"],
        name: json["name"],
        nationality: json["nationality"],
    );
}