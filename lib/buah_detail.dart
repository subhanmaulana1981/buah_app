import 'package:buah_app/buah_argumen.dart';
import 'package:buah_app/buah.dart';
import 'package:buah_app/buah_database.dart';

import 'package:flutter/material.dart';

class BuahDetail extends StatefulWidget {
  const BuahDetail({Key? key}) : super(key: key);

  @override
  State<BuahDetail> createState() => _BuahDetailState();
}

class _BuahDetailState extends State<BuahDetail> {

  final _controllerBuah = TextEditingController();
  final _controllerHarga = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _buahArguments = ModalRoute.of(context)!.settings.arguments as BuahArguments;
    final String _kondisi = _buahArguments.kondisi;
    // print("kondisiDariArgumen $_kondisi");

    _kondisi == "edit"
        ? _controllerBuah.text = _buahArguments.nama
        : _controllerBuah.text = "";

    _kondisi == "edit"
        ? _controllerHarga.text = _buahArguments.harga.toString()
        : _controllerHarga.text = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buah | Detail"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controllerBuah,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.apple),
                labelText: "Nama Buah",
                hintText: "Masukkan nama buah di sini",
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controllerHarga,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
                labelText: "Harga Buah",
                hintText: "Masukkan harga buah di sini",
              ),
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.none,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonBar(
              children: <ElevatedButton>[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("Batal"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Validasi data kosong
                    if (_controllerBuah.text == "" ||
                        _controllerHarga.text == "") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Validasi"),
                              content: const Text("Harap isi data!"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Ok")),
                              ],
                            );
                          });
                    } else {
                      // SetUp
                      final int _id = _buahArguments.id;
                      final String _nama = _controllerBuah.text;
                      final int _harga = int.parse(_controllerHarga.text);

                      // Edit atau Save Mode
                      _kondisi == "edit"
                          ? await DatabaseBuah.instance.updateBuah(
                              Buah(id: _id, nama: _nama, harga: _harga))
                          : await DatabaseBuah.instance.addBuah(
                              Buah(id: _id, nama: _nama, harga: _harga));

                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
