import 'package:flutter/material.dart';

import '../components/MyAppBar.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Parameter> parameters = [
    Parameter(title: 'Confidentialité', hasSwitch: false),
    Parameter(title: 'News', hasSwitch: false),
    Parameter(title: 'Notification', hasSwitch: true),
    Parameter(title: 'Mise à jour', hasSwitch: true),
    Parameter(title: 'Langage', hasSwitch: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent ,
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFF2FDDAE), // First color - #80edc7
              Color(0xFF00818c),
              Color(0xFF2FDDAE), // Second color - #4ca2d2
            ],
          ),
        ),
        child: Stack(
          children: [
            Image.asset("lib/images/background.png") ,
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "PARAMETRE",
                        style: TextStyle(
                          fontFamily: "KoHo",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 5,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Divider(height: 1, thickness: 1, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      children: [
                        _buildSection(
                          title: 'Infos',
                          icon: Icons.info_rounded,
                          parameters: parameters.sublist(0, 2),
                        ),
                        const SizedBox(height: 16.0),
                        _buildSection(
                          title: 'Notification',
                          icon: Icons.notifications,
                          parameters: parameters.sublist(2, 4),
                        ),
                        const SizedBox(height: 16.0),
                        _buildSection(
                          title: 'Autre',
                          icon: Icons.settings_rounded,
                          parameters: parameters.sublist(4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Parameter> parameters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF24306F),
              ),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF24306F),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: parameters.length,
          itemBuilder: (context, index) {
            final parameter = parameters[index];
            return Column(
              children: [
                ListTile(
                  title: Text(parameter.title),
                  trailing: parameter.hasSwitch
                      ? Switch(
                    value: parameter.isSwitched,
                    onChanged: (value) {
                      setState(() {
                        parameter.isSwitched = value;
                      });
                    },
                  )
                      : null,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 170.0, left: 15.0),
                  child: Divider(
                    thickness: 1,
                    color: Colors.black26,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class Parameter {
  final String title;
  final bool hasSwitch;
  bool isSwitched;

  Parameter({
    required this.title,
    required this.hasSwitch,
    this.isSwitched = false,
  });
}
