import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_mitra_ekspedisi/models/city.dart';
import 'package:flutter_mitra_ekspedisi/pages/detail_page.dart';
import 'package:flutter_mitra_ekspedisi/pages/home_page.dart';
import 'package:http/http.dart' as http;

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  var key = 'API-key Anda';
  var kota_asal;
  var kota_tujuan;
  var berat;
  var kurir;

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 0, 102, 255),
        title: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: const Text("Cek Ongkir",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _popUpDialogInfo(context),
                        );
                        //Navigator.pop(context);
                      },
                      icon: const Icon(Icons.info_outline_rounded),
                      color: const Color.fromARGB(255, 255, 181, 7),
                    ),
                    Text(" Tentang")
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                    color: Colors.red,
                  ),
                  const Text(
                    "Batal",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  )
                ]),
              ),
            ],
          ),
          /*IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CheckPage();
              }));
            },
          ),*/
        ],
      ),
      body: Stack(children: [
        Container(
          color: const Color.fromARGB(255, 0, 102, 255),
        ),
        Align(
          child: ListView(scrollDirection: Axis.vertical, children: [
            Container(
              height: MediaQuery.of(context).size.height * 1.00,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              //margin: EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: const Text(
                            "Silakan cek ongkos kirim anda",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 129, 129, 129)),
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  DropdownSearch<Kota>(
                    //kamu bisa mendekorasi tampilan field
                    dropdownSearchDecoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      //fillColor: Color.fromARGB(255, 219, 219, 219),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 191, 191, 191)),
                      ),
                      labelText: "Kota Asal",
                      hintText: "Pilih Kota Asal",
                    ),

                    //tersedia mode menu dan mode dialog
                    mode: Mode.MENU,

                    //jika ingin menampilkan pencarian box
                    showSearchBox: true,

                    //di dalam event kita bisa set state atau menyimpan variabel
                    onChanged: (value) {
                      kota_asal = value?.cityId;
                    },

                    //kata yang ditampilkan setelah kita memilih
                    itemAsString: (item) => "${item!.type} ${item.cityName}",

                    //mencari data dari api
                    onFind: (text) async {
                      //mengambil data dari api
                      var response = await http.get(Uri.parse(
                          "https://api.rajaongkir.com/starter/city?key=${key}"));

                      //parse string json as dart string dynamic
                      //get data just from results
                      List allKota = (jsonDecode(response.body)
                          as Map<String, dynamic>)['rajaongkir']['results'];

                      //simpan data ke dalam model kota
                      var dataKota = Kota.fromJsonList(allKota);

                      //return data
                      return dataKota;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<Kota>(
                    //kamu bisa merubah tampilan field sesuai keinginan
                    dropdownSearchDecoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      //fillColor: Color.fromARGB(255, 219, 219, 219),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 191, 191, 191)),
                      ),
                      labelText: "Kota Tujuan",
                      hintText: "Pilih Kota Tujuan",
                    ),

                    //tersedia mode menu dan mode dialog
                    mode: Mode.MENU,

                    //jika kamu ingin menampilkan pencarian
                    showSearchBox: true,

                    //di dalam onchang3e kamu bisa set state
                    onChanged: (value) {
                      kota_tujuan = value?.cityId;
                    },

                    //kata yang akan ditampilkan setelah dipilih
                    itemAsString: (item) => "${item!.type} ${item.cityName}",

                    //find data from api
                    onFind: (text) async {
                      //get data from api
                      var response = await http.get(Uri.parse(
                          "https://api.rajaongkir.com/starter/city?key=${key}"));

                      //parse string json as dart string dynamic
                      //get data just from results

                      List allKota = (jsonDecode(response.body)
                          as Map<String, dynamic>)['rajaongkir']['results'];

                      //store data to model
                      var dataKota = Kota.fromJsonList(allKota);

                      //return data
                      return dataKota;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    //input hanya angka
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      //fillColor: Color.fromARGB(255, 219, 219, 219),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 191, 191, 191)),
                      ),
                      labelText: "Berat Paket (gram)",
                      hintText: "Masukan Berat Paket",
                    ),
                    onChanged: (text) {
                      berat = text;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<String>(
                      mode: Mode.MENU,
                      showSelectedItems: true,
                      //pilihan kurir
                      items: const ["jne", "tiki", "pos"],
                      dropdownSearchDecoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        //fillColor: Color.fromARGB(255, 219, 219, 219),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 191, 191, 191)),
                        ),
                        labelText: "Kurir",
                        hintText: "Kurir",
                      ),
                      popupItemDisabled: (String s) => s.startsWith('I'),
                      onChanged: (text) {
                        kurir = text;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: RaisedButton(
                      color: Color.fromARGB(255, 255, 147, 7),
                      onPressed: () {
                        //validasi
                        if (kota_asal == '' ||
                            kota_tujuan == '' ||
                            berat == '' ||
                            kurir == '') {
                          final snackBar = SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                "Isi bagian yang masih kosong!",
                                style: const TextStyle(color: Colors.red),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          //berpindah halaman dan bawa data
                          Navigator.push(
                            context,
                            // DetailPage adalah halaman yang dituju
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      kota_asal: kota_asal,
                                      kota_tujuan: kota_tujuan,
                                      berat: berat,
                                      kurir: kurir,
                                    )),
                          );
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Cek Ongkos Kirim",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonTheme(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: RaisedButton(
                      color: Color.fromARGB(255, 0, 102, 255),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CheckPage();
                        }));
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            Text(
                              " Refresh",
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
    }
  }

  //Popup Dialog information
  Widget _popUpDialogInfo(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 1,
      /*title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.green),
          const Text(
          ' Informasi pengguna',
          style: TextStyle(color: Colors.green),
        ),
      ]),*/
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/Image1.png"),
            fit: BoxFit.cover,
          ),
          Text(
            "Mitra Ongkir adalah aplikasi untuk mengetahui dan membandingkan ongkos kirim dari satu tempat ke tempat lain oleh mitra pengiriman yang terdaftar di Indonesia.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 132, 132, 132)),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "*Aplikasi masih dalam tahap pengembangan",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              RaisedButton(
                elevation: 0,
                splashColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Tutup",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 140, 0),
                  ),
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 255, 140, 0), width: 2),
                ),
              ),
            ])
      ],
    );
  }
}
