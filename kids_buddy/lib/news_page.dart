import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List news = [];

  Future? newsFuture;

  CollectionReference newsRef = FirebaseFirestore.instance.collection("news");

  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic('kidsBuddy');
    newsFuture = newsRef.orderBy('no',descending: true).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        FutureBuilder(
            future: newsFuture,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ListTile(
                              title: Text("${snapshot.data.docs[i]['date']}"),
                              trailing:
                                  Text("${snapshot.data.docs[i]['title']}"),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Image.network(
                              "${snapshot.data.docs[i]['target']}",
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("${snapshot.data.docs[i]['dialog']}",
                                textDirection: TextDirection.rtl),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return Container(
                    margin: const EdgeInsets.all(30),
                    child: const Center(child: CircularProgressIndicator()));
              }
            }),
      ],
    );
  }
}

// Text("${snapshot.data.docs[i]['dialog']}"),
