import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/classification/classification_direct_lines.dart';
import 'package:flutter_clasificacion_proveedor/presentation/classification/pendiente.dart';
import 'package:flutter_clasificacion_proveedor/services/services.dart';

class ClassificationDirect extends StatefulWidget {
  final UserModel usuario;
  const ClassificationDirect({super.key, required this.usuario});

  @override
  _ClassificationDirectState createState() => _ClassificationDirectState();
}

class _ClassificationDirectState extends State<ClassificationDirect> {
  final TextEditingController _firstInputController = TextEditingController();

  @override
  void dispose() {
    _firstInputController.dispose();

    super.dispose();
  }

  void errorDialog(String error) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: error,
      //btnCancelOnPress: () {},
      btnOkOnPress: () {
        //Navigator.pop(context);
      },
    ).show();
  }

  void logInsert() async {
    if (_firstInputController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'El nombre de la clasificación está vacío',
        //btnCancelOnPress: () {},
        btnOkOnPress: () {
          // FlutterRingtonePlayer.stop();

          //Navigator.pop(context);
        },
      ).show();
      return;
    }
    String pos = _firstInputController.text.trim();

    Service service = Service();
    service
        .saveHeaderDirect(pos, widget.usuario.usuarioId)
        .then((value) => {
              if (value.isEmpty)
                {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.bottomSlide,
                    title: 'Error',
                    desc: "Error en el servidor",
                    //btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      //Navigator.pop(context);
                    },
                  ).show(),
                }
              else
                {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ClassificationDirectLines(
                            usuario: widget.usuario,
                            header: value[0],
                          ))),
                }

              // ClassificationDirectLines
            })
        .catchError((e) {
      setState(() {
        // Handle error here
        errorDialog("Error en el servidor");
      });
      return Future.value(
          <Set<Future<dynamic>>>{}); // Ensure a value is returned
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuData> menu = [
      MenuData(Icons.add_shopping_cart, 'CLASIFICACIONES PENDIENTES'),
      // MenuData(Icons.rule, 'CLASIFICADOR REPARTO PROVEEDOR'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificación Directa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstInputController,
              decoration: const InputDecoration(
                labelText: 'Orden de trabajo de la clasificación',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text(
                "Crear nueva clasificación",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                logInsert();

                /*  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CalidadDetalles(
                          usuario: widget.usuario,
                          nombre: itemsResult[index].descripcion,
                        )));*/
              },
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: menu.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 0.2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: InkWell(
                    onTap: () {
                      switch (index) {
                        case 0: // Enter this block if mark == 0
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Pendiente(
                                    usuario: widget.usuario,
                                  )));
                          break;
                        /*case 1: // Enter this block if mark == 0
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Pendiente(
                                    usuario: widget.usuario,
                                  )));
                          break;*/
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          menu[index].icon,
                          size: 30,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          menu[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuData {
  MenuData(this.icon, this.title);
  final IconData icon;
  final String title;
}
