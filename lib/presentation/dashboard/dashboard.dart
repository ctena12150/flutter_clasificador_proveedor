import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clasificacion_proveedor/data/model/clasi_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/bloc/add_log/add_log_cubit.dart';
import 'package:flutter_clasificacion_proveedor/presentation/bloc/add_log/add_log_state.dart';
import 'package:flutter_clasificacion_proveedor/presentation/screens/login/login_screen.dart';
import 'package:flutter_clasificacion_proveedor/services/services.dart';
import 'package:flutter_clasificacion_proveedor/utils/navigation_utils.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class DashBoard extends StatefulWidget {
  final UserModel usuario;
  DashBoard({Key? key, required this.usuario}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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

  //late FocusNode focusUbication;

  @override
  void initState() {
    visible = true;
    alarm = true;
    FlutterRingtonePlayer.stop();
    BlocProvider.of<AddLogCubit>(context).fetchPosiciones();

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
  }

  void skuEnd() {
    String pos = skuController.text;
    pos = pos.substring(0, pos.length - 1);
    var op = clasiModel.where((e) => e.mocacota == pos).toList();
    if (op.isEmpty) {
      if (alarm) {
        FlutterRingtonePlayer.playAlarm();
      }
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
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

        posicionController.text = op[0].posicion;
        focusmatricula.requestFocus();
      });
    }
  }

  void errorDialog(String error) {
    if (alarm) {
      FlutterRingtonePlayer.playAlarm();
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
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

    if (matri.length != 10 && matri.length != 20) {
      errorDialog("Error el tamaño de la matricula es de : ${matri.length}");
      focusmatricula.requestFocus();
      return;
    }
    setState(() {
      visible = false;
    });
    LogModel log = LogModel(
        matricula: matri,
        mocacota: sku,
        posicion: posicion,
        usuario: widget.usuario.usuarioId);
    service.saveLog(log).then((String value) {
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
        child: BlocConsumer<AddLogCubit, AddLogState>(
          listener: (context, state) {
            if (state.status == ListStatus.failure) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Error',
                desc: state.error,
                //btnCancelOnPress: () {},
                btnOkOnPress: () {
                  //Navigator.pop(context);
                },
              ).show();
            }
            if (state.status == ListStatus.success) {
              clasiModel = state.items;
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case ListStatus.failure:
                return const Center(
                    child: SizedBox(height: 0, child: Text('')));
              case ListStatus.loading:
                return const Center(child: CircularProgressIndicator());

              default:
                return !visible
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
                      ]);
            }
          },
        ),
      ),
    );
  }
}
