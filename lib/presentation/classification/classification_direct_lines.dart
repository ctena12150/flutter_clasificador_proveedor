import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clasificacion_proveedor/data/model/clasi_cabecera_directo_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/clasi_lineas_directo_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/classification/classification_direct.dart';
import 'package:flutter_clasificacion_proveedor/services/services.dart';

class ClassificationDirectLines extends StatefulWidget {
  final UserModel usuario;
  final ClasiCabeceraDirectoModel header;
  const ClassificationDirectLines(
      {super.key, required this.usuario, required this.header});

  @override
  _ClassificationDirectLinesState createState() =>
      _ClassificationDirectLinesState();
}

class _ClassificationDirectLinesState extends State<ClassificationDirectLines> {
  final TextEditingController lecturaController = TextEditingController();
  late String title1;
  late String title2;
  late String lastRead;
  late String lastPosition;
  String control1Value = "";
  String control2Value = "";
  bool visible = true;
  late FocusNode focusSKU;

  @override
  void initState() {
    super.initState();
    title1 = widget.usuario.usuarioId.toString();
    title2 = widget.header.nombre;
    lastRead = "";
    lastPosition = "";
    focusSKU = FocusNode();
    focusSKU.addListener(() {
      if (focusSKU.hasFocus) {
        lecturaController.selection = TextSelection(
            baseOffset: 0, extentOffset: lecturaController.text.length);
      }
    });
  }

  @override
  void dispose() {
    lecturaController.dispose();
    focusSKU.dispose();
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
    Service service = Service();

    String sku = lecturaController.text;

    if (sku.isEmpty) {
      errorDialog("Error no se ha encontrado la posicion");

      return;
    }

    setState(() {
      visible = false;
    });
    ClasiLineaDirectoModel log = ClasiLineaDirectoModel(
      idLinea: 0,
      item: sku,
      posicion: 0,
      idCabecera: widget.header.idCabecera,
    );
    service.saveLogLineDirecto(log).then((value) {
      setState(() {
        visible = true;
        if (value.isEmpty) {
          errorDialog("Error no se ha encontrado la posicion");
        } else {
          lecturaController.clear();
          lastRead = value[0].item;
          lastPosition = value[0].posicion.toString();
          focusSKU.requestFocus();
        }
      });
    }).catchError((e) {
      errorDialog("Error en la comunicación");
      setState(() {
        visible = true;
        focusSKU.requestFocus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Clasificación Directa'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.email),
            tooltip: 'Finalizar',
            onPressed: () {
              showAlertDialog(context, widget.header, widget.usuario);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics:
            const ClampingScrollPhysics(), //NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Usuario",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                title1,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Orden de trabajo",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                title2,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              !visible
                  ? const Center(child: CircularProgressIndicator())
                  : TextFormField(
                      controller: lecturaController,
                      focusNode: focusSKU,
                      onEditingComplete: () {
                        logInsert();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Edición de la lectura',
                      ),
                    ),
              const SizedBox(height: 4),
              const Text(
                "Posición",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                lastPosition,
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Última lectura",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                lastRead,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertDialog(
    BuildContext context, ClasiCabeceraDirectoModel nombre, UserModel usuario) {
  // set up the buttons
  Service service = Service();
  bool visible = false;
  String contentText =
      "Desea Cerrar la revisión de calidad de ${nombre.nombre}?";
  Widget cancelButton = TextButton(
    child: const Text("Cancelar"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Aceptar"),
    onPressed: () {
      service.CerrarClasificacionDirecta(nombre.idCabecera)
          .then((value) => {})
          .catchError((e) => null);

      Navigator.of(context).pop();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ClassificationDirect(
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
            : const Text("Desea Cerrar la clasificacion?"),
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
                service.CerrarClasificacionDirecta(nombre.idCabecera)
                    .then((value) => {
                          setState(() {
                            visible = false;
                          }),
                          Navigator.of(context).pop(),
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => ClassificationDirect(
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
