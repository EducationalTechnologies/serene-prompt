import 'package:serene/services/data_service.dart';

class LoggingService {
  List<Map<String, String>> logs = [];
  DataService _dataService;
  LoggingService(this._dataService);

  getTimestamp() {
    return DateTime.now().toIso8601String();
  }

  logData(String data) {
  }

  logEvent(String eventName) {
    Map<String, String> event = {
      "type": "event",
      "time": getTimestamp(),
      "name": eventName
    };
    // TODO: Submit logs batched in the no task screen
    logs.add(event);
    _dataService.logData(event);
  }
}
