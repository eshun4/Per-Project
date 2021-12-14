import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:rideboard/models/address.dart';
import 'package:rideboard/models/history.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;

  void userPickupLocationAddress(Address pickupAdress) {
    pickUpLocation = pickupAdress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter) {
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory) {
    tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }
}
