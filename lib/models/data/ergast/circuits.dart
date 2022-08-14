class RaceTable {
    RaceTable({
        required this.season,
        required this.races,
    });

    String season;
    List<Race> races;

    factory RaceTable.fromJson(Map<String, dynamic> json) => RaceTable(
        season: json["season"],
        races: List<Race>.from(json["Races"].map((x) => Race.fromJson(x))),
    );
}

class Race {
    Race({
        required this.season,
        required this.round,
        required this.url,
        required this.raceName,
        required this.circuit,
        required this.date,
        required this.time,
        required this.firstPractice,
        required this.secondPractice,
        required this.thirdPractice,
        required this.qualifying,
        required this.sprint,
    });

    String season;
    String round;
    String url;
    String raceName;
    Circuit circuit;
    DateTime date;
    String time;
    Session firstPractice;
    Session secondPractice;
    Session? thirdPractice;
    Session qualifying;
    Session? sprint;

    factory Race.fromJson(Map<String, dynamic> json) => Race(
        season: json["season"],
        round: json["round"],
        url: json["url"],
        raceName: json["raceName"],
        circuit: Circuit.fromJson(json["Circuit"]),
        date: DateTime.parse(json["date"]),
        time: json["time"],
        firstPractice: Session.fromJson(json["FirstPractice"]),
        secondPractice: Session.fromJson(json["SecondPractice"]),
        thirdPractice: json["ThirdPractice"] != null ? Session.fromJson(json["ThirdPractice"]) : null,
        qualifying: Session.fromJson(json["Qualifying"]),
        sprint: json["Sprint"] != null ? Session.fromJson(json["Sprint"]) : null,
    );
}

class Circuit {
    Circuit({
        required this.circuitId,
        required this.url,
        required this.circuitName,
        required this.location,
    });

    String circuitId;
    String url;
    String circuitName;
    Location location;

    factory Circuit.fromJson(Map<String, dynamic> json) => Circuit(
        circuitId: json["circuitId"],
        url: json["url"],
        circuitName: json["circuitName"],
        location: Location.fromJson(json["Location"]),
    );
}

class Location {
    Location({
        required this.lat,
        required this.long,
        required this.locality,
        required this.country,
    });

    String lat;
    String long;
    String locality;
    String country;

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"],
        long: json["long"],
        locality: json["locality"],
        country: json["country"],
    );
}

class Session {
    Session({
        required this.date,
        required this.time,
    });

    DateTime date;
    String time;

    factory Session.fromJson(Map<String, dynamic> json) => Session(
        date: DateTime.parse(json["date"]),
        time: json["time"],
    );
}
