import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mitra_ekspedisi/pages/check_page.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String? kota_asal;
  final String? kota_tujuan;
  final String? berat;
  final String? kurir;

  DetailPage({this.kota_asal, this.kota_tujuan, this.berat, this.kurir});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List _data = [];
  var key = 'API-key Anda';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://api.rajaongkir.com/starter/cost",
        ),
        //MENGIRIM PARAMETER
        body: {
          "key": key,
          "origin": widget.kota_asal,
          "destination": widget.kota_tujuan,
          "weight": widget.berat,
          "courier": widget.kurir
        },
      ).then((value) {
        var data = jsonDecode(value.body);

        setState(() {
          _data = data['rajaongkir']['results'][0]['costs'];
        });
      });
    } catch (e) {
      //ERROR
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 0, 102, 255),
        title: const Text("Detail Ongkos Kirim"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return CheckPage();
              }));
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListTile(
              title: Text("${_data[index]['service']}"),
              subtitle: Text("${_data[index]['description']}"),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Rp. ${_data[index]['cost'][0]['value']}",
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text("${_data[index]['cost'][0]['etd']} / Days")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
