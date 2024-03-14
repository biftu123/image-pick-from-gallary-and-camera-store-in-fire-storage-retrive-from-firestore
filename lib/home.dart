import 'package:bifappp/add.dart';
import 'package:bifappp/service.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Service _service = Service();

  @override
  void initState() {
    super.initState();
    _service.getUser(); // Get users initially
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _service.getUser(); // Re-fetch users
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text('BIFA APP'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshUsers,
            ),
          ]),
      body: StreamBuilder(
          stream: _service.getUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("add the element");
            }
            List user = snapshot.data?.docs ?? [];
            return ListView.builder(
                itemCount: user.length,
                itemBuilder: (context, index) {
                  final _userdata = user[index].data();

                  String userid = user[index].id;

                  return ListTile(
                      title: Text(_userdata.name),
                      subtitle: Text(_userdata.phonenumber),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(_userdata.imageurl)),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("delete item "),
                                    content:
                                        Text("are you sure  want to delete"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            _service.delete(userid);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Yes')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'))
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.delete)));
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Add())),
        child: Icon(Icons.add),
      ),
    );
  }
}
