import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

CollectionReference areasRef = FirebaseFirestore.instance.collection("areas");

class SchoolsPage extends StatefulWidget {
  const SchoolsPage({super.key});

  @override
  State<SchoolsPage> createState() => _SchoolsPageState();
}

class _SchoolsPageState extends State<SchoolsPage> {
  CollectionReference schoolsRef =
      FirebaseFirestore.instance.collection("schools");

  Future? filter;

  List areas = [];

  // ignore: prefer_typing_uninitialized_variables
  var selectedArea;

  getAreas() async {
    var responseBody = await areasRef.get();
    for (var element in responseBody.docs) {
      setState(() {
        areas.add(element.data());
      });
    }
  }

  @override
  void initState() {
    getAreas();
    filter = schoolsRef.limit(100).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).splashColor,
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: DropdownButton(
            borderRadius: BorderRadius.circular(10),
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            dropdownColor: Theme.of(context).splashColor,
            underline: const Divider(),
            isExpanded: true,
            hint: Container(
              alignment: Alignment.center,
              child: const Text("Select Area"),
            ),
            items: areas
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("${e["name"]}"),
                      ),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedArea = val;
                filter = schoolsRef
                    .where("area", isEqualTo: selectedArea["name"])
                    .get();
              });
              FirebaseFirestore.instance.snapshotsInSync();
            },
            value: selectedArea,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: FutureBuilder(
            future: filter,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(5),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Text("${snapshot.data.docs[i]['name']}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Text("Type : "),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(child: Text("${snapshot.data.docs[i]['type']}")),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Text("Address : "),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      child: Text(
                                          "${snapshot.data.docs[i]['address']}")),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(",${snapshot.data.docs[i]['area']}"),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Text("School Fees : "),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      child: Text(
                                          "${snapshot.data.docs[i]['fees']}")),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Text("Tel. : "),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      child: Text(
                                          "${snapshot.data.docs[i]['phone']}")),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Text("Mail : "),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(child: Text("${snapshot.data.docs[i]['email']}")),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (snapshot.data.docs[i]['facebook'] != " ") {
                                    await launchUrl(Uri.parse(
                                        "fb://facewebmodal/f?href=${snapshot.data.docs[i]['facebook']}"));
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.scale,
                                      title:
                                          "School doesn't have Facebook Page",
                                      padding: const EdgeInsets.all(5),
                                      showCloseIcon: true,
                                      // ignore: use_build_context_synchronously
                                      dialogBackgroundColor: Theme.of(context).splashColor,
                                    ).show();
                                  }
                                },
                                icon: Image.asset("images/fbicon.png"),
                                iconSize: 70,
                                padding: const EdgeInsets.all(5)),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
