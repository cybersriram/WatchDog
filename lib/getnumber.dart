// ignore_for_file: prefer_const_constructors, unnecessary_new
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Numberget extends StatefulWidget {
  const Numberget({Key? key}) : super(key: key);

  @override
  _NumbergetState createState() => _NumbergetState();
}

class _NumbergetState extends State<Numberget> {
  @override
  void initState() {
    super.initState();
    _getContactPermission();
    func();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  List<Widget> _cardList = [];
  Future<void> func() async {
    final prefs = await SharedPreferences.getInstance();
    _cardList.clear();
    setState(() {
      var a = prefs.getKeys();
      for (String j in a) {
        _cardList.add(_card(j));
      }
    });
  }
  void deleteContact(String Name) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Name);
  }
  final FlutterContactPicker _contactPicker = new FlutterContactPicker();
  late Contact _contact;
  // ignore: non_constant_identifier_names
  Widget _card(String Name) {
    return Center(
      child: Card(
        child: SizedBox(
          width: 300,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Name, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      deleteContact(Name);
                      func();
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 26.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Edit Contacts'),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        // ignore: prefer_is_empty
        child: _cardList.length > 0
            ? ListView.builder(
          shrinkWrap: true,
          itemCount: _cardList.length,
          itemBuilder: (context, index) {
            return _cardList[index];
          },
        )
            : const Center(
          child: Text(
            'Add Contacts',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          Contact? contact = await _contactPicker.selectContact();
          setState(() {
            _contact = contact!;
          });
          await prefs.setString(_contact.fullName!, _contact.phoneNumbers![0]);
          func();
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
