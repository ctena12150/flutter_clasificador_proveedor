// ignore_for_file: dead_code

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clasificacion_proveedor/data/model/borrar_bulto_calidad.dart';
import 'package:flutter_clasificacion_proveedor/data/model/calidad_detalle_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/calidad_model_bulto.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_calidad.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/quality/calidad.dart';
import 'package:flutter_clasificacion_proveedor/presentation/screens/login/login_screen.dart';
import 'package:flutter_clasificacion_proveedor/services/services.dart';
import 'package:flutter_clasificacion_proveedor/utils/navigation_utils.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CalidadDetalles extends StatefulWidget {
  final UserModel usuario;
  final String nombre;
  CalidadDetalles({Key? key, required this.usuario, required this.nombre})
      : super(key: key);

  @override
  State<CalidadDetalles> createState() => _DashBoardState();
}

class _DashBoardState extends State<CalidadDetalles> {
  var bultoController = TextEditingController();
  var skuController = TextEditingController();
  //var posicionController = TextEditingController();
  CalidadDetalleModel clasiModel = CalidadDetalleModel(
      bulto: "", bultos: 0, bultosPendientes: 0, mocaco: "");
  late FocusNode focusSKU;
  late FocusNode focusBulto;
  int contador = 0;
  String error = "";
  bool visible = true;
  bool alarm = true;
  int longitudBulto = 20;
  int longitudSku = 14;
  List<CalidadModelBulto> items = [];

  //late FocusNode focusUbication;

  @override
  void initState() {
    visible = true;
    alarm = true;
    FlutterRingtonePlayer.stop();

    super.initState();
    focusSKU = FocusNode();
    focusBulto = FocusNode();

    focusSKU.addListener(() {
      if (focusSKU.hasFocus) {
        skuController.selection = TextSelection(
            baseOffset: 0, extentOffset: skuController.text.length);
      }
    });

    focusBulto.addListener(() {
      if (focusBulto.hasFocus) {
        bultoController.selection = TextSelection(
            baseOffset: 0, extentOffset: bultoController.text.length);
      }
    });
  }

  void bultoEnd() {
    Service service = Service();
    String bulto = bultoController.text;
    if (bulto.length != longitudBulto) {
      errorDialog(
          "Error el bulto no puede estar vacio o la longitud es no es  de $longitudBulto");
      focusBulto.requestFocus();
      return;
    }
    setState(() {
      visible = false;
    });

    service
        .fetchRevisionCalidadPendientesByBultos(widget.nombre, bulto)
        .then((value) {
      setState(() {
        if (value.isEmpty) {
          errorDialog("Error: No se ha encontrado el bulto");
          focusBulto.requestFocus();
          visible = true;
          return;
        }
        visible = true;
        items = value;
        skuController.text = "";
        focusSKU.requestFocus();
      });
    }).catchError((e) {
      errorDialog("Error: $e");
      setState(() {
        visible = true;
        focusSKU.requestFocus();
      });
    });

    focusSKU.requestFocus();
    /* var op = clasiModel.where((e) => e.mocaco == pos).toList();

    if (op.isEmpty) {
      if (alarm) {
        FlutterRingtonePlayer.playAlarm();
      }
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'No se ha encontrado el SKU',
        //btnCancelOnPress: () {},
        btnOkOnPress: () {
          FlutterRingtonePlayer.stop();

          //Navigator.pop(context);
        },
      ).show();
      setState(() {
        //error = 'ERROR SKU NO EXISTE';
        focusSKU.requestFocus();
      });
    } else {
      setState(() {
        // String pos = op[0].posicion;

        //posicionController.text = op[0].posicion;
        focusBulto.requestFocus();
      });
    }*/
  }

  void errorDialog(String error) {
    if (alarm) {
      FlutterRingtonePlayer.playAlarm();
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: error,
      //btnCancelOnPress: () {},
      btnOkOnPress: () {
        FlutterRingtonePlayer.stop();

        //Navigator.pop(context);
      },
    ).show();
  }

  void updateCtaLeida(CalidadDetalleModel cModel) {
    int index = items.indexWhere((element) => element.mocaco == cModel.mocaco);
    if (index == -1) {
      String model = cModel.mocaco.split('/')[0];
      String calidad = cModel.mocaco.split('/')[1];
      String color = cModel.mocaco.split('/')[2];
      String talla = cModel.mocaco.split('/')[3];
      items.add(CalidadModelBulto(
          modelo: model,
          calidad: calidad,
          talla: talla,
          color: color,
          cantidad: cModel.bultos,
          cantidadLeida: cModel.bultos - cModel.bultosPendientes,
          mocaco: cModel.mocaco));
    } else {
      items[index].cantidadLeida = cModel.bultos - cModel.bultosPendientes;
    }
    /*items
        .firstWhere((element) => element.mocaco == cModel.mocaco)
        .cantidadLeida = cModel.bultos - cModel.bultosPendientes;*/
  }

  void logInsert() async {
    Service service = Service();

    String sku = skuController.text;
    String bulto = bultoController.text;
    if (bulto.length != longitudBulto) {
      errorDialog(
          "Error el bulto no puede estar vacio o la longitud es no es  de $longitudBulto");
      focusBulto.requestFocus();
      return;
    }
    if (sku.length != longitudSku) {
      errorDialog(
          "Error el sku no puede estar vacío o la longitud es no es  de $longitudSku");
      focusSKU.requestFocus();
      return;
    }
/*
    String matri = matriculaController.text;
    String posicion = posicionController.text;

    if (posicion.isEmpty) {
      errorDialog("Error no se ha encontrado la posicion");
      focusmatricula.requestFocus();
      return;
    }

    if (longitudMatricula > 0) {
      if (longitudMatricula != matri.length) {
        errorDialog(
            "Error el tamaño de la matricula es de : ${matri.length} y está configurado para $longitudMatricula");
        focusmatricula.requestFocus();
        return;
      }
    } else if (matri.length != 10 && matri.length != 20) {
      errorDialog("Error el tamaño de la matricula es de : ${matri.length}");
      focusmatricula.requestFocus();
      return;
    }*/
    setState(() {
      visible = false;
    });
    LogCalidaModel log = LogCalidaModel(
      bulto: bulto,
      mocaco: sku,
      usuario: widget.usuario.usuarioId,
      nombre: widget.nombre,
    );
    service.saveLogCalidad(log).then((value) {
      setState(() {
        if (value.isEmpty) {
          errorDialog("Error: No se ha encontrado el SKU");
          focusSKU.requestFocus();
          visible = true;
          return;
        }
        visible = true;
        clasiModel = value[0];
        updateCtaLeida(clasiModel);
        skuController.text = "";
        focusSKU.requestFocus();
      });
    }).catchError((e) {
      errorDialog("Error: $e");
      setState(() {
        visible = true;
        focusSKU.requestFocus();
      });
    });
  }

  void resetBulto() async {
    Service service = Service();
    setState(() {
      visible = false;
    });
    LogCalidaModel log = LogCalidaModel(
      bulto: bultoController.text,
      mocaco: clasiModel.mocaco,
      usuario: widget.usuario.usuarioId,
      nombre: widget.nombre,
    );
    service.resetBultoCalidad(log).then((value) {
      setState(() {
        if (value.isEmpty) {
          errorDialog("Error: No se ha encontrado el SKU");
          focusSKU.requestFocus();
          visible = true;
          return;
        }
        visible = true;
        // clasiModel = value[0];
        items = value;
        skuController.text = "";
        focusSKU.requestFocus();
      });
    }).catchError((e) {
      errorDialog("Error: $e");
      setState(() {
        visible = true;
        focusSKU.requestFocus();
      });
    });
  }

  void resetMocacota() async {
    Service service = Service();
    setState(() {
      visible = false;
    });
    LogCalidaModel log = LogCalidaModel(
      bulto: clasiModel.bulto,
      mocaco: clasiModel.mocaco,
      usuario: widget.usuario.usuarioId,
      nombre: widget.nombre,
    );
    service.resetMocacoCalidad(log).then((value) {
      setState(() {
        if (value.isEmpty) {
          errorDialog("Error: No se ha encontrado el SKU");
          focusSKU.requestFocus();
          visible = true;
          return;
        }
        visible = true;
        clasiModel = value[0];
        updateCtaLeida(clasiModel);
        skuController.text = "";
        focusSKU.requestFocus();
      });
    }).catchError((e) {
      errorDialog("Error: $e");
      setState(() {
        visible = true;
        focusSKU.requestFocus();
      });
    });
  }

  void borrarBulto() async {
    Service service = Service();
    setState(() {
      visible = false;
    });
    BorrarBultoCalidaModel log = BorrarBultoCalidaModel(
      bulto: bultoController.text,
      nombre: widget.nombre,
    );
    service.borrarBultoCalidad(log).then((value) {
      setState(() {
        visible = true;

        bultoController.text = "";
        items = [];
        focusBulto.requestFocus();
      });
    }).catchError((e) {
      errorDialog("Error: $e");
      setState(() {
        visible = true;
        focusSKU.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    bultoController.dispose();
    skuController.dispose();
    focusSKU.dispose();
    focusBulto.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.email),
            tooltip: 'Finalizar',
            onPressed: () {
              showAlertDialog(context, widget.nombre, widget.usuario);
            },
          ),
          IconButton(
            icon: const Icon(Icons.difference),
            tooltip: 'Envio Diferencias',
            onPressed: () {
              showAlertDialogDiferencias(
                  context, widget.nombre, widget.usuario);
            },
          ),
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Login',
            onPressed: () {
              popAllandPush(context, const LoginScreen());
            },
          ),
        ],
        title: const Text('Entrada de datos'),
      ),
      body: SafeArea(
          child: !visible
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            child: Text(
                              widget.nombre,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          SizedBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.usuario.usuarioId.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: alarm
                                    ? const Icon(Icons.volume_up)
                                    : const Icon(Icons.volume_mute),
                                tooltip: 'Increase volume by 10',
                                onPressed: () {
                                  setState(() {
                                    alarm = !alarm;
                                  });
                                },
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              //width: 60,
                              child: TextFormField(
                                onEditingComplete: () {
                                  bultoEnd();
                                },

                                //  textInputAction: TextInputAction.done,
                                autofocus: true,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                controller: bultoController,
                                focusNode: focusBulto,

                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "No puede estar vacio";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: 'BULTO',
                                  //icon: Icon(Icons.bar_chart_sharp),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            child: ElevatedButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "¿Estas seguro de resetear el bulto ${bultoController.text} ?"),
                                        actions: <Widget>[
                                          TextButton(
                                            /* style: TextButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                            ),*/
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "Cancelar",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.blue,
                                            ),
                                            child: const Text(
                                              "OK",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              borrarBulto();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Borrar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                enabled: true,
                                onEditingComplete: () {
                                  logInsert();
                                },
                                autofocus: false,
                                focusNode: focusSKU,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                controller: skuController,
                                decoration: const InputDecoration(
                                  labelText: 'MOCACOTA',
                                  //icon: Icon(Icons.bar_chart_sharp),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Acción
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "¿Estas seguro de resetear las lecturas del mocacota ${clasiModel.mocaco} ?"),
                                        actions: <Widget>[
                                          TextButton(
                                            /* style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                          ),*/
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "Cancelar",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.blue,
                                            ),
                                            child: const Text(
                                              "OK",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              resetMocacota();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Reset Moca.',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Mocacota : ${clasiModel.mocaco}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            width: 125,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Acción
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "¿Estas seguro de resetear todo el bulto ${bultoController.text} ?"),
                                        actions: <Widget>[
                                          TextButton(
                                            /* style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                          ),*/
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "Cancelar",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.blue,
                                            ),
                                            child: const Text(
                                              "OK",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              resetBulto();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Reset bulto',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                          child: Text(
                        'Total: ${clasiModel.bultos} Pendientes: ${clasiModel.bultosPendientes} Leidos: ${clasiModel.bultos - clasiModel.bultosPendientes}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 250,
                        child: items.isNotEmpty
                            ? SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(
                                        Colors.blueAccent), // Color de cabecera
                                    dataRowColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        return states.contains(
                                                MaterialState.selected)
                                            ? Colors.lightBlue
                                                .shade100 // Color al seleccionar fila
                                            : null; // Color por defecto
                                      },
                                    ),
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                            "Modelo/Calidad/Color/Talla",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      DataColumn(
                                        label: Text("Ct",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      DataColumn(
                                        label: Text("Ct le",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                    rows: List.generate(items.length, (index) {
                                      bool isEvenRow = index % 2 == 0;
                                      return DataRow(
                                        color: MaterialStateProperty.all(
                                            isEvenRow
                                                ? Colors.grey[200]
                                                : Colors.white),
                                        cells: [
                                          DataCell(Text(
                                              items[index].mocaco.toString())),
                                          DataCell(Text(items[index]
                                              .cantidad
                                              .toString())),
                                          DataCell(Text(items[index]
                                              .cantidadLeida
                                              .toString())),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                                // Permite desplazamiento horizontal
                              )
                            : const Text(''),
                      ),
                      /* SizedBox(
                        height: 250,
                        child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    'Modelo: ${items[index].modelo} Calidad: ${items[index].calidad} Talla: ${items[index].talla} Color: ${items[index].color} Cantidad: ${items[index].cantidad} Leida: ${items[index].cantidadLeida}'),
                              );
                            }),
                      ),*/
                    ]),
                  ),
                )),
    );
  }
}

showAlertDialog(BuildContext context, String nombre, UserModel usuario) {
  // set up the buttons
  Service service = Service();
  bool visible = false;
  String contentText = "Desea Cerrar la revisión de calidad de $nombre?";
  Widget cancelButton = TextButton(
    child: const Text("Cancelar"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Aceptar"),
    onPressed: () {
      service
          .cerrarRevision(nombre)
          .then((value) => {})
          .catchError((e) => null);

      Navigator.of(context).pop();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Calidad(
                usuario: usuario,
              )));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("AlertDialog"),
    content: Column(
      children: [
        visible
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
            : Text("Desea Cerrar la revisión de calidad de $nombre?"),
      ],
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text("AlertDialog"),
          content: visible
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
              : Text(contentText),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  visible = true;
                });
                service
                    .cerrarRevision(nombre)
                    .then((value) => {
                          setState(() {
                            visible = false;
                          }),
                          Navigator.of(context).pop(),
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Calidad(
                                        usuario: usuario,
                                      )))
                        })
                    // ignore: invalid_return_type_for_catch_error
                    .catchError((e) => {
                          setState(() {
                            contentText = e;
                            visible = false;
                          })
                        });
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      });
    },
  );
}

showAlertDialogDiferencias(
    BuildContext context, String nombre, UserModel usuario) {
  // set up the buttons
  Service service = Service();
  bool visible = false;
  String contentText = "Desea enviar por correo las diferencias $nombre?";
  Widget cancelButton = TextButton(
    child: const Text("Cancelar"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Aceptar"),
    onPressed: () {
      service
          .enviarDiferencias(nombre)
          .then((value) => {})
          .catchError((e) => null);

      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("AlertDialog"),
    content: Column(
      children: [
        visible
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
            : Text("Desea enviar por correo las diferencias de $nombre?"),
      ],
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text("AlertDialog"),
          content: visible
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
              : Text(contentText),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  visible = true;
                });
                service
                    .enviarDiferencias(nombre)
                    .then((value) => {
                          setState(() {
                            visible = false;
                          }),
                          Navigator.of(context).pop(),
                          /* Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Calidad(
                                        usuario: usuario,
                                      )))*/
                        })
                    // ignore: invalid_return_type_for_catch_error
                    .catchError((e) => {
                          setState(() {
                            contentText = e;
                            visible = false;
                          })
                        });
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      });
    },
  );
}
