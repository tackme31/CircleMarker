String buildMapDisplayTitle(String? eventName, String? mapName) {
  if (eventName?.isEmpty == true && mapName?.isEmpty == true) {
    return '無題のマップ';
  } else if (eventName?.isEmpty == true) {
    return mapName!;
  } else if (mapName?.isEmpty == true) {
    return eventName!;
  } else {
    return '$eventName/$mapName';
  }
}
