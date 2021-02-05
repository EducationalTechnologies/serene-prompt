import 'package:serene/services/data_service.dart';

class LoggingService {
  DataService _dataService;
  LoggingService(this._dataService) {}

  getTimestamp() {
    return DateTime.now().toIso8601String();
  }

  logEvent(String eventName) {
    var event = {"type": "event", "time": getTimestamp(), "name": eventName};
    _dataService.logData(event);
  }
}
