import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clasificacion_proveedor/data/model/calidad_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/dashboard/panel.dart';
import 'package:flutter_clasificacion_proveedor/presentation/quality/calidadDetalles.dart';
import 'package:flutter_clasificacion_proveedor/presentation/quality/calidadDetalles_diferencias.dart';
import 'package:flutter_clasificacion_proveedor/utils/navigation_utils.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../../services/services.dart';

class CalidadDiferencias extends StatefulWidget {
  final UserModel usuario;
  const CalidadDiferencias({Key? key, required this.usuario}) : super(key: key);

  @override
  State<CalidadDiferencias> createState() => _PendienteState();
}

class _PendienteState extends State<CalidadDiferencias> {
  TextEditingController textController = TextEditingController();
  bool loading = false;
  List<CalidadModel> items = [];
  //List<UsuarioAlmacen> usuariosAlmacenes = [];
  String? selectedAlmacen;
  //List<AlmacenModel> _almacenes = [];
  bool visible = true;
  @override
  void initState() {
    visible = false;

    getdata();
    visible = true;
    super.initState();
  }

  void errorDialog(String error) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.leftSlide,
      title: 'Error',
      desc: error,
      //btnCancelOnPress: () {},
      btnOkOnPress: () {
        //Navigator.pop(context);
      },
    ).show();
  }

  getdata() async {
    Service service = Service();
    service.fetchRevisionCalidadPendientesDiferencias().then(
      (value) {
        setState(() {
          items = value;
        });
      },
    ).catchError(
      (e) {
        errorDialog("Error en la comunicación");
        setState(() {
          loading = false;
        });
      },
    );
  }

  /* List<Lectura2Model> parseReadings(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    var headers = parsed
        .map<Lectura2Model>((json) => Lectura2Model.fromJson(json))
        .toList();

    return headers;
  }*/

  setError(String error) {
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

/*
  void fetchSearch(String svalue) {
    String search = svalue;
    if (search.isEmpty) return;
    setState(() {
      loading = true;
    });
    ServiceReception service = ServiceReception();
    service
        .createReceptionFromPurchOrder(search)
        .then((ReceptionHeader? value) async {
      loading = false;
      if (value == null) {
        errorDialog("Error en recoger los datos");
      } else {
        final result = await Navigator.push(
            context,
            // Crearemos la SelectionScreen en el siguiente paso!
            MaterialPageRoute(
                builder: (context) => ReceptionList(reception: value!)));

        if (result.toString().substring(0, 2) == "Al") {
          setState(() {
            loading = false;
            fechData();

            // widget.items.removeAt(index);
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      }
    }).catchError(
      (e) {
        errorDialog("Error en la comunicación");
        setState(() {
          loading = false;
        });
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(
        usuario: widget.usuario,
      ),
      body: Column(
        children: [
          loading
              ? Container(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ItemView(items: items, usuario: widget.usuario)
        ],
      ),
    );
  }
}

class ItemView extends StatefulWidget {
  ItemView({Key? key, required this.items, required this.usuario})
      : super(key: key);

  final List<CalidadModel> items;
  final UserModel usuario;

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  TextEditingController textController = TextEditingController();
  List<CalidadModel> itemsResult = [];
  String enteredKeyword = "";
  void _runFilter(String enteredKeyword) {
    /*
    List<CabeceraPickingModel> results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.items;
    } else {
      results = widget.items
          .where((user) => user.sourceNo
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      itemsResult = results;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    itemsResult = widget.items;
    /*if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      itemsResult = widget.items;
    } else {
      itemsResult = widget.items
          .where((user) => user.ordenTrabajo
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }*/

    return Expanded(
      flex: 1,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          /*  Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 50,
              child: TextField(
                onChanged: (value) => {
                  setState(() {
                    enteredKeyword = value;
                  })
                },
                decoration: const InputDecoration(
                    labelText: 'Filtro descripción',
                    suffixIcon: Icon(Icons.filter_alt)),
              ),
            ),
          ),*/
          Expanded(
            child: itemsResult.isEmpty
                ? const Center(child: Text('vacio'))
                : ListView.builder(
                    // scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(index.toString()),
                        background: slideRightBackground(),
                        secondaryBackground: slideLeftBackground(),
                        child: InkWell(
                          child: ItemTile2(
                            item: itemsResult[index],
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            final bool? res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const Text(
                                        "¿Estas seguro de realizar la revisión de calidad?"),
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
                                          foregroundColor: Colors.blue,
                                        ),
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CalidadDetallesDiferencias(
                                                        usuario: widget.usuario,
                                                        nombre:
                                                            itemsResult[index]
                                                                .descripcion,
                                                      )));
                                        },
                                      ),
                                    ],
                                  );
                                });
                            return res;
                          }

                          if (direction == DismissDirection.startToEnd) {}
                        },
                      );
                    },
                    itemCount: itemsResult.length,
                  ),
          ),
        ],
      ),
    );
  }
}

class ItemTile2 extends StatelessWidget {
  const ItemTile2({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CalidadModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8),
      elevation: 10,
      child: Column(
        children: <Widget>[
          // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
            title: Text('Nombre: ${item.descripcion}'),
            subtitle: Text(
              'Bultos: ${item.bultos}  Pendientes: ${item.bultosPendientes} Leidos: ${item.bultosLeidos} ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            trailing: const Icon(Icons.arrow_forward),
          ),

          // Usamos una fila para ordenar los botones del card
        ],
      ),
    );
  }
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.green,
    child: const Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            "Editar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    ),
  );
}

Widget slideRightBackground() {
  return Container();
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  UserModel usuario;
  _AppBar({required this.usuario});
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.dashboard),
          tooltip: 'DashBoard',
          onPressed: () {
            popAllandPush(
                context,
                Panel(
                  usuario: usuario,
                ));
          },
        ),
      ],
      title: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' ',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          SizedBox(width: 4, height: 4),
          Text(
            "Lista de packings pendientes",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

typedef CallBackFechData = Future<void> Function();
