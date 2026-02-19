import 'package:flutter/material.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/res/alert_dialog.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/combo/custom_button.dart';
import 'package:qirha/widgets/input/text_input_widget.dart';

class AuthentificationScreen extends StatefulWidget {
  const AuthentificationScreen({super.key});

  @override
  State<AuthentificationScreen> createState() => _AuthentificationScreenState();
}

class _AuthentificationScreenState extends State<AuthentificationScreen> {
  final List<Tab> tabs = <Tab>[
    const Tab(text: 'Inscription'),
    const Tab(text: 'Connexion'),
  ];

  final formKeyLogin = GlobalKey<FormState>();
  final formKeyInscription = GlobalKey<FormState>();
  TextEditingController emailControllerLogin = TextEditingController(text: '');
  TextEditingController passwordControllerLogin = TextEditingController(
    text: '',
  );
  TextEditingController emailControllerInscription = TextEditingController(
    text: '',
  );
  TextEditingController passwordControllerInscription = TextEditingController(
    text: '',
  );

  //login
  loginProcess(BuildContext context) {
    if (emailControllerLogin.text.isNotEmpty &&
        passwordControllerLogin.text.isNotEmpty) {
      // Trigger login
      ApiServices().loginUser(
        context,
        prefs,
        login: emailControllerLogin.text,
        password: passwordControllerLogin.text,
      );
    } else {
      CustomAlertDialog.showCustomAlert(
        context: context,
        title: 'Erreur',
        message: 'Veuillez remplir tous les champs',
      );
    }
  }

  createAccountProcess(BuildContext context) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: WHITE,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: SizedBox(
              height: 40,
              child: Scrollbar(
                child: TabBar(
                  isScrollable: true,
                  tabs: tabs,
                  tabAlignment: TabAlignment.center,
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[inscription(), login()]),
      ),
    );
  }

  // Login
  Widget login() {
    return SingleChildScrollView(
      child: Form(
        key: formKeyLogin,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              espacementWidget(height: 20),
              TextInputWidget(
                controller: emailControllerLogin,
                formKey: formKeyLogin,
                labelText: 'Adresse e-mail ou Numero de mobile',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
              espacementWidget(height: 20),
              TextInputWidget(
                controller: passwordControllerLogin,
                formKey: formKeyLogin,
                labelText: 'Mot de Passe',
                isPassword: true,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
              ),
              espacementWidget(height: 20),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Expanded(
                  flex: 1,
                  child: MyButtonWidget(
                    onPressed: () => loginProcess(context),
                    label: 'SE CONNECTER',
                    bgColor: PRIMARY,
                    style: const TextStyle(fontSize: 12),
                    labelColor: WHITE,
                  ),
                ),
              ),
              AlternativeAuth(),
            ],
          ),
        ),
      ),
    );
  }

  // Inscription
  Widget inscription() {
    return SingleChildScrollView(
      child: Form(
        key: formKeyInscription,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              espacementWidget(height: 20),
              TextInputWidget(
                controller: emailControllerInscription,
                formKey: formKeyInscription,
                labelText: 'Adresse e-mail ou Numero de mobile',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
              espacementWidget(height: 20),
              TextInputWidget(
                controller: passwordControllerInscription,
                formKey: formKeyInscription,
                labelText: 'Mot de Passe',
                isPassword: true,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
              ),
              espacementWidget(height: 20),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Expanded(
                  flex: 1,
                  child: MyButtonWidget(
                    onPressed: () => createAccountProcess(context),
                    label: 'CREER MON COMPTE',
                    bgColor: PRIMARY,
                    labelColor: WHITE,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              AlternativeAuth(),
              espacementWidget(height: 20),
              customCenterText(
                "En cliquant sur CREER MON COMPTE, ou en vous CONNECTANT avec Facebook ou Google, vous acceptez la politique de confidentialites et les conditions d'utilisation de Qirha",
                maxLines: 5,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: DARK),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget AlternativeAuth() {
    return Column(
      children: [
        espacementWidget(height: 100),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: const Divider(),
              ),
            ),
            customText(
              "Ou Rejoignez-nous",
              style: TextStyle(fontSize: 11, color: LIGHT),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: const Divider(),
              ),
            ),
          ],
        ),
        espacementWidget(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.all(3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: GREY),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      facebook,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                    espacementWidget(width: 10),
                    customText(
                      'Facebook',
                      style: TextStyle(color: DARK, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.all(3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: GREY),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      google,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                    espacementWidget(width: 10),
                    customText(
                      'Google',
                      style: TextStyle(color: DARK, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
