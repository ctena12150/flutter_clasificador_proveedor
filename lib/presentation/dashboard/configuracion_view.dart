import 'package:flutter/material.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/dashboard/panel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_clasificacion_proveedor/utils/navigation_utils.dart';

class ConfigurationView extends StatefulWidget {
  final UserModel usuario;
  ConfigurationView({Key? key, required this.usuario}) : super(key: key);

  @override
  State<ConfigurationView> createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  late Future<String> sectionJournal;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController skuController = TextEditingController();
  TextEditingController matriculaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _retrieveValues();
  }

  @override
  void dispose() {
    skuController.dispose();
    matriculaController.dispose();

    super.dispose();
  }

  _retrieveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      skuController.text = prefs.getString('longuitudSku') ?? "0";
      matriculaController.text = prefs.getString('longitudMatricula') ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Configuración"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Panel',
            onPressed: () {
              popAllandPush(context, Panel(usuario: widget.usuario));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                "Si las longitudes son 0 la app validará con los valores por defecto"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: skuController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: const Text("Longitud sku"),
                  hintText: "Longitud sku",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: matriculaController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: const Text("Longitud matrícula"),
                  hintText: "Longitud matrícula",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('longuitudSku', skuController.text);
                  prefs.setString(
                      'longitudMatricula', matriculaController.text);
                },
                child: const Text("Guardar")),
          ],
        ),
      ),
    );
  }
}
