import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/add_post.dart';
import 'package:flutter_firebase/screens/login_screen.dart';
import 'package:flutter_firebase/widgets/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchController = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              tooltip: 'LogOut',
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout_outlined)),
          SizedBox(width: 10)
        ],
        title: Text('Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePostScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // Expanded(
            //     child: StreamBuilder(
            //   stream: ref.onValue,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else if (snapshot.hasData) {
            //       Map<dynamic, dynamic> data =
            //           snapshot.data!.snapshot.value as dynamic;
            //       List<dynamic> list = [];
            //       list.clear();
            //       list = data.values.toList();
            //       // print(data);
            //       // print('data values - ${data.values}');
            //       // print(list);
            //       return ListView.builder(
            //         itemCount: snapshot.data!.snapshot.children.length,
            //         itemBuilder: (context, index) {
            //           return ListTile(
            //             title: Text(list[index]['title'].toString()),
            //             subtitle: Text(list[index]['id'].toString()),
            //           );
            //         },
            //       );
            //     }
            //     return Center(
            //       child: Text('An Error Occured'),
            //     );
            //   },
            // )),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: FirebaseAnimatedList(
              defaultChild: Center(
                child: CircularProgressIndicator(),
              ),
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();
                if (searchController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            showUpdateDialog(
                                title, snapshot.child('id').value.toString());
                          },
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        )),
                        PopupMenuItem(
                            child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            ref
                                .child(snapshot.child('id').value.toString())
                                .remove();
                          },
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        )),
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase().toString())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            showUpdateDialog(
                                title, snapshot.child('id').value.toString());
                          },
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        )),
                        PopupMenuItem(
                            child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            ref
                                .child(snapshot.child('id').value.toString())
                                .remove();
                          },
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        )),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> showUpdateDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: 'Edit here',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update({
                    'title': editController.text.toString(),
                  }).then((value) {
                    Utils().toastMessage('Post Updated');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: Text('Update')),
          ],
        );
      },
    );
  }
}
