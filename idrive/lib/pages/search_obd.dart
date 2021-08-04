import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idrive/model/make.dart';
import 'package:idrive/model/model.dart';
import 'package:idrive/service/car.dart';
import 'package:idrive/shared/dialog.dart';
import 'package:idrive/shared/logo.dart';
import 'package:sizer/sizer.dart';

class SearchOBDPage extends StatefulWidget {
    static const path = "/searchobd";

   SearchOBDPage({Key? key}) : super(key: key);

  @override
  _SearchOBDPageState createState() => _SearchOBDPageState();
}

class _SearchOBDPageState extends State<SearchOBDPage> {
  // initialize empty objects for makes & models
  Makes makes = Makes(count: 0, message: "Makes", results: []);
  Models models =
      Models(count: 0, message: "Models", results: [], searchCriteria: '');

  bool _showModels = false;

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference modelsCollection =
      FirebaseFirestore.instance.collection('models');

  Future<void> addModel(
      int modelId, String modelName, int makeId, String makeName) {
    // Call the model's CollectionReference to add a new model
    return modelsCollection
        .add({
          'model_id': modelId,
          'model_name': modelName,
          'make_id': makeId,
          'make_name': makeName,
        })
        .then((value) =>
            {showAlertDialog(context, "Success!", "Added data to firebase")})
        .catchError((error) =>
            showAlertDialog(context, "Error", "There was a firebase error"));
  }

  @override
  void initState() {
    getAllMakes();
    super.initState();
  }

  void getAllMakes() async {
    // get all the makes from the API and store it in the makes object
    makes = await new CarService().fetchAllMakes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildLogo(),
            Padding(
              padding:
                   EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text: "Connect to your ",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: "OBD",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              // if show models is true, then display model list
              // otherwise show the make list, if the makes haven't been loaded from the API
              // show a circular progress indicator
              child: _showModels
                  ? _buildModelList()
                  : makes.count == 0
                      ? SizedBox(
                        height: 125,
                        width: 275,
                        child: Padding(
                          padding:  EdgeInsets.all(64.0),
                          child: Container(
                            child: CircularProgressIndicator(strokeWidth: 10,),
                          ),
                        ),
                      )
                      : _buildMakeList(),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          // if show models is true, make it false and go back to make list
          if (_showModels) {
            setState(() {
              _showModels = false;
            });
          } else {
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.arrow_back_ios_outlined),
      ),
      elevation: 0,
    );
  }

  Widget _buildModelList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.w),
          leading: Text(
            // Display the model ID
            "ID\n#${models.results[index].modelId}",
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
          ),
          trailing: GestureDetector(
            // When the save icon is pressed, call add model
            onTap: () {
              addModel(
                  models.results[index].modelId,
                  models.results[index].modelName,
                  models.results[index].makeId,
                  models.results[index].makeName);
            },
            child: Icon(Icons.save),
          ),
          title: Text(
            models.results[index].modelName,
            style:
                Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            models.results[index].makeName,
            style:
                Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 9.sp),
          ),
        );
      },
      itemCount: models.count,
    );
  }

  Widget _buildMakeList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            // enable showing models
            _showModels = true;
            // get all the models from the API and store it in the models object for a specific make
            models = await new CarService()
                .fetchModelsByMake(makes.results[index].makeName);
            setState(() {});
          },
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.w),
          leading: Text(
            "ID\n#${makes.results[index].makeId}",
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.lightBlue),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          title: Text(
            makes.results[index].makeName,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
        );
      },
      itemCount: makes.count,
    );
  }
}
