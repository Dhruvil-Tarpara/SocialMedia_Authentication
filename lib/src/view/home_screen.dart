import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_user/src/constant/const_colors.dart';
import 'package:get_user/src/constant/widgets/common_text.dart';
import 'package:get_user/src/provider/authentication/firebase_auth_helper.dart';
import 'package:get_user/src/provider/database/local_database.dart';
import 'package:get_user/src/provider/model.dart';
import 'package:get_user/src/view/login_screen.dart';
import '../provider/database/cloud_database.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColor.backgroundColor,
        title: const CommonText(
          text: "Notes",
          size: 24,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logout().then(
                    (value) => SPHelper.prefs.setBool("is_login", false).then(
                          (value) => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                        ),
                  );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseCloud.firebaseCloud.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: CommonText(text: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data?.docs;

            List<Note> allData = data!.map((e) => Note.fromStream(e)).toList();

            return (allData.isNotEmpty)
                ? ListView.builder(
                    itemCount: allData.length,
                    itemBuilder: (context, index) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          width: 0.8,
                          color: Colors.black,
                        ),
                      ),
                      elevation: 4,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            _buildPageTransitionAnimation(
                              page: DetailScreen(
                                note: Note(
                                    title: allData[index].title,
                                    body: allData[index].body),
                                doc: data[index].id,
                                isAdd: false,
                              ),
                            ),
                          );
                        },
                        title: CommonText(
                          text: allData[index].title,
                          fontWeight: FontWeight.bold,
                          size: 20,
                        ),
                        subtitle: CommonText(
                          text: allData[index].body,
                          size: 16,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            FirebaseCloud.firebaseCloud
                                .deleteData(doc: data[index].id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: ConstColor.buttonColor,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        hoverElevation: 0.6,
        onPressed: () {
          Navigator.of(context).push(
            _buildPageTransitionAnimation(
              page: DetailScreen(
                isAdd: true,
                note: Note(
                  title: "New",
                  body: "",
                ),
                doc: "",
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: ConstColor.backgroundColor,
        ),
      ),
    );
  }

  Widget _userPermission({required int index}) {
    return AlertDialog(
      title: const CommonText(
          text: "Delete Alert", color: Colors.red, fontWeight: FontWeight.w500),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
      content: const CommonText(
        text: "Are you Sure ..!",
        color: Colors.black,
        fontWeight: FontWeight.w400,
        size: 18,
      ),
    );
  }

  PageRouteBuilder _buildPageTransitionAnimation({required final page}) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          alignment: Alignment.center,
          scale: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return page;
      },
    );
  }
}
