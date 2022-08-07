class ImageSourceProvider {
    static const String _baseTeamImageUrl = 'https://www.formula1.com/content/dam/fom-website/teams/2022/';
    static const String _baseDriverImageUrl = 'https://www.formula1.com/content/dam/fom-website/drivers/';
    static final Map _constructorNamesMap = {
    'red_bull': 'red-bull-racing',
    'ferrari': 'ferrari',
    'mercedes': 'mercedes',
    'alpine': 'alpine',
    'mclaren': 'mclaren',
    'alfa': 'alfa-romeo',
    'haas': 'haas-f1-team',
    'alphatauri': 'alphatauri',
    'aston_martin': 'aston-martin',
    'williams': 'williams',
  };
  static const Map _driverNamesMap = {
    'max_verstappen': 'M/MAXVER01_Max_Verstappen/maxver01',
    'leclerc': 'C/CHALEC01_Charles_Leclerc/chalec01',
    'perez': 'S/SERPER01_Sergio_Perez/serper01',
    'russell': 'G/GEORUS01_George_Russell/georus01',
    'sainz': 'C/CARSAI01_Carlos_Sainz/carsai01',
    'hamilton': 'L/LEWHAM01_Lewis_Hamilton/lewham01',
    'norris': 'L/LANNOR01_Lando_Norris/lannor01',
    'ocon': 'E/ESTOCO01_Esteban_Ocon/estoco01',
    'bottas': 'V/VALBOT01_Valtteri_Bottas/valbot01',
    'alonso': 'F/FERALO01_Fernando_Alonso/feralo01',
    'kevin_magnussen': 'K/KEVMAG01_Kevin_Magnussen/kevmag01',
    'ricciardo': 'D/DANRIC01_Daniel_Ricciardo/danric01',
    'gasly': 'P/PIEGAS01_Pierre_Gasly/piegas01',
    'vettel': 'S/SEBVET01_Sebastian_Vettel/sebvet01',
    'mick_schumacher': 'M/MICSCH02_Mick_Schumacher/micsch02',
    'tsunoda': 'Y/YUKTSU01_Yuki_Tsunoda/yuktsu01',
    'zhou': 'G/GUAZHO01_Guanyu_Zhou/guazho01',
    'stroll': 'L/LANSTR01_Lance_Stroll/lanstr01',
    'albon': 'A/ALEALB01_Alexander_Albon/alealb01',
    'latifi': 'N/NICLAF01_Nicholas_Latifi/niclaf01',
    'hulkenberg': 'N/NICHUL01_Nico_Hulkenberg/nichul01',
  };

  static String getCarImageSource(String key){
    var val = _constructorNamesMap[key];
    return '$_baseTeamImageUrl$val.png';
  }

  static String getLogoImageSource(String key){
    var val = _constructorNamesMap[key];
    return '$_baseTeamImageUrl$val-logo.png';
  }

  static String getDriverImageSource(String key){
    var driverString = _driverNamesMap[key];
    return '$_baseDriverImageUrl$driverString.png.transform/2col/image.png';
  }
}