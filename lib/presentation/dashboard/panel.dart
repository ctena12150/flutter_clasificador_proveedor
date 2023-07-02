import 'package:flutter/material.dart';
import 'package:flutter_clasificacion_proveedor/data/model/user_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/dashboard/dashboard.dart';
import 'package:flutter_clasificacion_proveedor/presentation/dashboard/dashboard_reparto.dart';

class Panel extends StatelessWidget {
  final UserModel usuario;
  const Panel({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificador'),
      ),
      body: MainMenuBody(
        usuario: usuario,
      ),
    );
  }
}

class MainMenuBody extends StatelessWidget {
  final UserModel usuario;
  MainMenuBody({Key? key, required this.usuario}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<MenuData> menu = [
      // MenuData(Icons.add_shopping_cart, 'CLASIFICADOR'),
      MenuData(Icons.rule, 'CLASIFICADOR REPARTO PROVEEDOR'),
    ];

    return Container(
        child: Scrollbar(
      thickness: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                          /* case 0: // Enter this block if mark == 0
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DashBoard(
                                      usuario: usuario,
                                    )));
                            break;*/
                          case 0: // Enter this block if mark == 0
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DashBoardReparto(
                                      usuario: usuario,
                                    )));
                            break;
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
      ),
    ));
  }
}

class MenuData {
  MenuData(this.icon, this.title);
  final IconData icon;
  final String title;
}
