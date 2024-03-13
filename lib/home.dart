import 'package:bifappp/add.dart';
import 'package:bifappp/service.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final Service _service = Service();

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
                  return ListTile(
                      title: Text(_userdata.name),
                      subtitle: Text(_userdata.phonenumber),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(_userdata.imageurl)));
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
