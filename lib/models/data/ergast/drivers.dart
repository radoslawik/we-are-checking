
class DriverTable {
    DriverTable({
        required this.season,
        required this.drivers,
    });

    String season;
    List<Driver> drivers;

    factory DriverTable.fromJson(Map<String, dynamic> json) => DriverTable(
        season: json["season"],
        drivers: List<Driver>.from(json["Drivers"].map((x) => Driver.fromJson(x))),
    );
}

class Driver {
    Driver({
        required this.driverId,
        required this.permanentNumber,
        required this.code,
        required this.url,
        required this.givenName,
        required this.familyName,
        required this.dateOfBirth,
        required this.nationality,
    });

    String driverId;
    String permanentNumber;
    String code;
    String url;
    String givenName;
    String familyName;
    DateTime dateOfBirth;
    String nationality;

    String getDriverNumber() => permanentNumber == "33" ? "1" : permanentNumber; // MV fcked it up

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverId: json["driverId"], 
        permanentNumber: json["permanentNumber"],
        code: json["code"],
        url: json["url"],
        givenName: json["givenName"],
        familyName: json["familyName"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        nationality: json["nationality"],
    );
}
