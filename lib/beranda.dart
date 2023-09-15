import 'package:flutter/material.dart';
import 'package:buah_app/buah.dart';
import 'package:buah_app/buah_database.dart';
import 'package:buah_app/buah_argumen.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  late String buahState = "normal";

  // Editing controller
  final _controllerCari = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Buah"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("aset/buah_background_small.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[

            // Pencarian
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controllerCari,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    labelText: "Pencarian",
                    hintText: "Cari buah di sini"),
                onChanged: (text) {
                  // State management versi sendiri
                  setState(() {
                    buahState = "cari";
                  });
                },
              ),
            ),

            // List all data buah
            Expanded(
              child: FutureBuilder<List<Buah>>(
                  future: buahState == "normal"
                  // Refresh hasil dalam kondisi awal load
                      ? DatabaseBuah.instance.getBuahAll()
                  // Refesh hasil dalam kondisi pencarian
                      : DatabaseBuah.instance.getBuah(_controllerCari.text),
                  builder:
                      (BuildContext context, AsyncSnapshot<List<Buah>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Loading..."),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(
                      child: Text("Belum ada data!"),
                    )
                        : ListView(
                      children: snapshot.data!.map((buah) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10.0,
                              child: ListTile(
                                title: Text(buah.nama),
                                subtitle: Text("Harga: Rp. " +
                                    buah.harga.toString()),
                                trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                            const Text("Konfirmasi"),
                                            content: Text("Hapus " +
                                                buah.nama +
                                                "?"),
                                            actions: <Widget>[
                                              // Batal
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop();
                                                },
                                                child:
                                                const Text("Batal"),
                                              ),
                                              // Hapus
                                              TextButton(
                                                  onPressed: () async {
                                                    final _id = buah.id;

                                                    await DatabaseBuah
                                                        .instance
                                                        .deleteBuah(_id);

                                                    setState(() {
                                                      buahState =
                                                      "normal";
                                                      // print("kondisiDariHapus $buahState");
                                                    });

                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: const Text(
                                                      "Hapus")),
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                onTap: () {
                                  // Klik pada tile panggil form detail
                                  final _buahArguments = BuahArguments(
                                      buah.id,
                                      buah.nama,
                                      buah.harga,
                                      "edit");
                                  Navigator.pushNamed(
                                    context,
                                    "/BuahDetail",
                                    arguments: _buahArguments,
                                  ).whenComplete(() {
                                    setState(() {
                                      buahState = "normal";
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Kirim parameter argumennya
          final _buahArguments = BuahArguments(0, "", 0, "simpan");
          buahState = "simpan";
          // Panggil form detail
          Navigator.pushNamed(
            context,
            ("/BuahDetail"),
            arguments: _buahArguments,
          ).whenComplete(() {
            setState(() {
              buahState = "normal";
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
