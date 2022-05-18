import 'package:flutter/material.dart';

class CopyrightWidget extends StatelessWidget {
  const CopyrightWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Copyright © DressCode 2022'),
        IconButton(
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: 'Dresscode',
              applicationVersion: '1.0',
              applicationLegalese:
                  '© Projet Développement d\'applications Mobiles 2022',
              applicationIcon: Image.asset(
                'assets/icon.png',
                height: size.height / 5,
                width: size.width / 5,
              ),
              children: <Widget>[
                const Text(
                  'Membres du groupe',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                const Text('GBANGBOCHE Olabissi'),
                const Text('KPANOU Gilles'),
                const Text('TOGNON Hans'),
                const Text('BONOU SELEGBE Klaus'),
                const Text('AKOTENOU Généreux'),
                const Text('SOSSOU Jessica'),
                const Text('AVADEME Harold'),
                const Text('MIGAN Boris'),
              ],
            );
          },
          icon: const Icon(Icons.info_outlined),
        )
      ],
    );
  }
}
