import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpmg_employees/widget/progress_indicator_widget.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

List<ParseObject>? _dealers;
class AllEntries extends StatefulWidget {
  @override
  _AllEntriesState createState() => _AllEntriesState();
}

class _AllEntriesState extends State<AllEntries> {
  var _isLoading;
  var _entriesLoaded;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      _entriesLoaded = false;
    });
    _getAllEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 24.0),
          _entriesLoaded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text("DATABASE",
                          textAlign: TextAlign.left,
                          textScaleFactor: 2.0,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Text("data")
                        ],
                      )
                    ])
              : Column(),
          const SizedBox(height: 20.0),
          _entriesLoaded
              ? _buildDetails()
              : Text("Please Wait..",
                  textAlign: TextAlign.left,
                  textScaleFactor: 2.0,
                  style: TextStyle(color: Colors.black54)),
          Visibility(
            visible: _isLoading,
            child: CustomProgressIndicatorWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return (_dealers != null && _dealers!.length == 0)
        ? Text("No data found")
        : Container(
          height: MediaQuery.of(context).size.height *.8,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                
                Expanded(
                    child: ListView.separated(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _dealers!.length,
                  itemBuilder: (context, index) {
                    final _dealer = _dealers![index];
                    //final userVerified = user.a) ?? false;
                    return _buildDealerTile(_dealer);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ))
              ]));
  }

  Widget _buildDealerTile(ParseObject _dealer) {
    // var lat = _dealer.get<ParseGeoPoint>('location')!.latitude;
    // var lon = _dealer.get<ParseGeoPoint>('location')!.longitude;
    var EmpID = _dealer['EmpId'] as String;
    var Name = _dealer['Name'] as String;
    var Initiative = _dealer['Initiative'] as String;
    var Manager = _dealer['Employee'] as String;
    var designation = _dealer['Designation'] as String;
    var Project = _dealer['Project'] as String;
    
    
    return SizedBox(
        height: 100, // Some height
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    Text(EmpID,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                   
                    Text(Name,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                   
                    Text(Initiative,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                   
                    Text(Manager,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                   
                    Text(designation,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                   
                    Text(Project,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                   
            
                    
                  ])),
            )));
  }

  
  

  void _getAllEntries() async {
    // var gp = ParseGeoPoint(latitude: lat, longitude: lon);
    
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('KPMG'));
    

    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      var allDealers = apiResponse.results! as List<ParseObject>;
      setState(() {
        _dealers = allDealers;
      });
    }
    setState(() {
      _isLoading = false;
      _entriesLoaded = true;
    });
  }

  
}
