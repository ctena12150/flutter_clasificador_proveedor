import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clasificacion_proveedor/data/model/clasi_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/lod_model_reparto.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/reparto_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/reparto_posicion_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/bloc/add_log/add_log_cubit.dart';
import 'package:flutter_clasificacion_proveedor/presentation/bloc/add_log/add_log_state.dart';
import 'package:flutter_clasificacion_proveedor/presentation/screens/login/login_screen.dart';
import 'package:flutter_clasificacion_proveedor/services/services.dart';
import 'package:flutter_clasificacion_proveedor/utils/navigation_utils.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardReparto extends StatefulWidget {
  final UserModel usuario;
  DashBoardReparto({Key? key, required this.usuario}) : super(key: key);

  @override
  State<DashBoardReparto> createState() => _DashBoardStateReparto();
}

class _DashBoardStateReparto extends State<DashBoardReparto> {
  var matriculaController = TextEditingController();
  var skuController = TextEditingController();
  var posicionController = TextEditingController();
  List<ClasiModel> clasiModel = [];
  late FocusNode focusSKU;
  late FocusNode focusmatricula;
  int contador = 0;
  String error = "";
  bool visible = true;
  bool alarm = true;
  int longitudMatricula = 0;
  int longitudSku = 0;
  RepartoPosicionModel repartoReposicionModel = RepartoPosicionModel(
      id: 0, id_reparto: '', mocacota: '', pendiente: 0, posicion: '');

  List<RepartoModel> _repartos = [];

  String? selectedReparto;
  //late FocusNode focusUbication;

  @override
  void initState() {
    _retrieveValues();
    visible = false;
    alarm = true;
    selectedReparto = '';
    FlutterRingtonePlayer.stop();
    //BlocProvider.of<AddLogCubit>(context).fetchPosiciones();

    super.initState();
    focusSKU = FocusNode();
    focusmatricula = FocusNode();

    focusSKU.addListener(() {
      if (focusSKU.hasFocus) {
        skuController.selection = TextSelection(
            baseOffset: 0, extentOffset: skuController.text.length);
      }
    });

    focusmatricula.addListener(() {
      if (focusmatricula.hasFocus) {
        matriculaController.selection = TextSelection(
            baseOffset: 0, extentOffset: matriculaController.text.length);
      }
    });
    getData();
  }

  _retrieveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      longitudMatricula =
          int.parse(prefs.getString('longitudMatricula') ?? "0");
      //printer.text = prefs.getString('printer') ?? "";

      longitudSku = int.parse(prefs.getString('longuitudSku') ?? "0");
    });
  }

  getData() async {
    Service service = Service();
    service
        .fetchRepartos(widget.usuario.usuarioId)
        .then((List<RepartoModel> value) {
      setState(() {
        _repartos = value;
        visible = true;
        if (_repartos.isNotEmpty) {
          selectedReparto = _repartos[0].id_reparto;
        }
      });
    });
  }

  void skuEnd() {
    String pos = skuController.text;
    if (longitudSku > 0) {
      if (longitudSku != pos.length) {
        errorDialog(
            "La longitud del sku es de ${pos.length} y en configuración tiene puesto $longitudSku");
        focusSKU.requestFocus();
        return;
      }
    }

    pos = pos.substring(0, pos.length - 1);
    //var op = clasiModel.where((e) => e.mocacota == pos).toList();
    if (pos.isEmpty ||
        selectedReparto!
            .isEmpty /* ||        skuController.text.length != 18*/) {
      if (alarm) {
        FlutterRingtonePlayer.playAlarm();
      }
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc:
            'El código de barras está vacío o no está seleccionado el reparto',
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
        //error = 'ERROR SKU NO EXISTE';

        visible = false;
      });

      Service serviceReception = Service();
      serviceReception
          .fetchPosicion(pos, selectedReparto!, widget.usuario.usuarioId)
          .then((value) => {
                setState(
                  () {
                    visible = true;
                    repartoReposicionModel = value;
                    posicionController.text = repartoReposicionModel.posicion!;
                    focusmatricula.requestFocus();
                    visible = true;
                  },
                )
              })
          .onError((error, stackTrace) => {
                setState(
                  () {
                    visible = true;
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.bottomSlide,
                      title: 'Error',
                      desc: error.toString(),
                      //btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        FlutterRingtonePlayer.stop();

                        //Navigator.pop(context);
                      },
                    ).show();
                  },
                )
              });
    }
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
    String resul = "";
    String sku = skuController.text;

    String matri = matriculaController.text;
    String posicion = posicionController.text;

    if (longitudSku > 0) {
      if (longitudSku != sku.length) {
        errorDialog(
            "La longitud del sku es de ${sku.length} y en configuración tiene puesto $longitudSku");
        focusSKU.requestFocus();
        return;
      }
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
    }
    setState(() {
      visible = false;
    });
    LogModelReparto log = LogModelReparto(
        matricula: matri,
        mocacota: sku,
        posicion: posicion,
        usuario: widget.usuario.usuarioId,
        id_reparto: repartoReposicionModel.id_reparto!,
        id: repartoReposicionModel.id);
    service.saveLogReparto(log).then((String value) {
      setState(() {
        visible = true;
        if (value == "OK") {
          contador++;
          resul = value;
          matriculaController.text = "";
          skuController.text = "";
          posicionController.text = "";
          focusSKU.requestFocus();
        } else {
          errorDialog("Error en la alta");
          focusmatricula.requestFocus();
        }
      });
    }).catchError((e) {
      errorDialog("Error en la comunicación");
      setState(() {
        visible = true;
        focusmatricula.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    matriculaController.dispose();
    skuController.dispose();
    focusSKU.dispose();
    focusmatricula.dispose();
    posicionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Login',
            onPressed: () {
              popAllandPush(context, LoginScreen());
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
                const SizedBox(
                  height: 5,
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
                SizedBox(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        repartos(),
                        //  fecha(),
                      ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 60,
                  //width: 60,
                  child: TextFormField(
                    onEditingComplete: () {
                      skuEnd();
                    },
                    //  textInputAction: TextInputAction.done,
                    autofocus: true,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    controller: skuController,
                    focusNode: focusSKU,

                    validator: (val) {
                      if (val!.isEmpty) {
                        return "No puede estar vacio";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'SKU',
                      //icon: Icon(Icons.bar_chart_sharp),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    enabled: false,
                    onEditingComplete: () {},
                    autofocus: false,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    controller: posicionController,
                    decoration: const InputDecoration(
                      labelText: 'DESTINO',
                      //icon: Icon(Icons.bar_chart_sharp),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: TextFormField(
                    onEditingComplete: () {
                      logInsert();
                    },
                    autofocus: false,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    controller: matriculaController,
                    focusNode: focusmatricula,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "No puede estar vacio";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'MATRICULA',
                      //icon: Icon(Icons.bar_chart_sharp),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    child: Text(
                  'Cont : $contador',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ))
              ]),
      ),
    );
  }

  Widget repartos() {
    return SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Repartos'),
        DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          hint: const Text("Seleccionar departamento"),
          value: selectedReparto,
          isDense: true,
          onChanged: (String? newValue) {
            setState(() {
              selectedReparto = newValue!;
            });
          },
          items: _repartos.map((RepartoModel map) {
            return DropdownMenuItem<String>(
              value: map.id_reparto.toString(),
              child: new Text(map.id_reparto!,
                  style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
        )),
      ]),
    );
  }
}
