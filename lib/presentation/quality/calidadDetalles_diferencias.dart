// ignore_for_file: dead_code

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clasificacion_proveedor/data/model/borrar_bulto_calidad.dart';
import 'package:flutter_clasificacion_proveedor/data/model/calidad_detalle_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_calidad.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/quality/calidad.dart';
import 'package:flutter_clasificacion_proveedor/presentation/screens/login/login_screen.dart';
import 'package:flutter_clasificacion_proveedor/services/services.dart';
import 'package:flutter_clasificacion_proveedor/utils/navigation_utils.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CalidadDetallesDiferencias extends StatefulWidget {
  final UserModel usuario;
  final String nombre;
  const CalidadDetallesDiferencias(
      {Key? key, required this.usuario, required this.nombre})
      : super(key: key);

  @override
  State<CalidadDetallesDiferencias> createState() => _DashBoardState();
}

class _DashBoardState extends State<CalidadDetallesDiferencias> {
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
    String bulto = bultoController.text;
    if (bulto.length != longitudBulto) {
      errorDialog(
          "Error el bulto no puede estar vacio o la longitud es no es  de $longitudBulto");
      focusBulto.requestFocus();
      return;
    }
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
    service.saveLogCalidadDiferencias(log).then((value) {
      setState(() {
        if (value.isEmpty) {
          errorDialog("Error: No se ha encontrado el SKU");
          focusSKU.requestFocus();
          visible = true;
          return;
        }
        visible = true;
        clasiModel = value[0];
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
    service.resetMocacoCalidadDiferencias(log).then((value) {
      setState(() {
        if (value.isEmpty) {
          errorDialog("Error: No se ha encontrado el SKU");
          focusSKU.requestFocus();
          visible = true;
          return;
        }
        visible = true;
        clasiModel = value[0];
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
    service.borrarBultoCalidadDiferencias(log).then((value) {
      setState(() {
        visible = true;

        bultoController.text = "";
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.email),
            tooltip: 'Login',
            onPressed: () {
              showAlertDialog(context, widget.nombre, widget.usuario);
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
              : Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 10,
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
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.blue,
                                        ),
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(color: Colors.red),
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    alignment: Alignment.center,
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
                  const SizedBox(
                    height: 10,
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
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        width: 90,
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
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.blue,
                                        ),
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(color: Colors.red),
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
                            'Reset',
                            style: TextStyle(fontSize: 14, color: Colors.white),
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
                  ))
                ])),
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
          .cerrarRevisionDiferencias(nombre)
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
                    .cerrarRevisionDiferencias(nombre)
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
