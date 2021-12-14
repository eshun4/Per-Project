import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideboard/Assistants/requestAssistants.dart';
import 'package:rideboard/ui/components/Configmaps.dart';
import 'package:rideboard/models/address.dart';
import 'package:rideboard/models/placePredictions.dart';
import 'package:rideboard/services/appData.dart';
import 'package:rideboard/ui/components/constants.dart';
import 'package:rideboard/ui/components/divider.dart';
import 'package:rideboard/ui/components/progressIndicator.dart';
import 'package:rideboard/ui/components/text_field.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController dropOffLocationController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickupLocationController.text = placeAddress;
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 215.0,
          decoration:
              BoxDecoration(color: kthemeColor.withOpacity(0.4), boxShadow: [
            BoxShadow(
              color: kthemeColor.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            )
          ]),
          child: Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              top: 25,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Center(
                        child: Text(
                          "Set Destination",
                          style: ktextTheme4,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/pickup.png",
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kthemeColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: DynamicTextField(
                              label: 'My Location',
                              myController: pickupLocationController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/dropoff.png",
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kthemeColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: DynamicTextField(
                              onEntry: (val) {
                                findPlace(val);
                              },
                              label: 'Heading where?',
                              myController: dropOffLocationController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //tile for predictions display
        SizedBox(
          height: 10.0,
        ),
        (placePredictionList.length > 0)
            ? Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return PredictionTile(
                        placePredictions: placePredictionList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        MyDivider(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                ),
              )
            : Container(),
      ],
    ));
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:usa';
      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];

        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Icon(Icons.location_searching_outlined, color: Colors.white),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: ktextTheme4,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: ktextTheme5,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => LoadingIndicator(
              message: 'Loading...',
            ));
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if (res == "failed") {
      return;
    }
    if (res['status'] == 'OK') {
      Address address = Address();
      address.placeName = res['result']['name'];
      address.placeId = placeId;
      address.latitude = res['result']['geometry']['location']['lat'];
      address.longitude = res['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);
      print('This is your drop off Location:');
      print(address.placeName);

      Navigator.pop(context, 'obtainDirection');
    }
  }
}
