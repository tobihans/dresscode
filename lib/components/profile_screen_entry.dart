import 'package:flutter/material.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

class ProfileScreenEntry extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool editable;
  final bool showBottomSeparator;
  final Function(String?)? valueChanged;

  const ProfileScreenEntry(
      {Key? key,
      required this.icon,
      required this.label,
      this.value = '',
      this.valueWidget,
      this.valueChanged,
      this.editable = true,
      this.showBottomSeparator = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(5.0),
                child: Icon(icon, size: 22.0)),
            Expanded(
                child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(label,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w200)),
                              valueWidget != null
                                  ? valueWidget!
                                  : Text(value!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                              iconSize: 18.0,
                              onPressed: () {
                                showFlexibleBottomSheet(
                                  minHeight: 0,
                                  initHeight: 0.2,
                                  maxHeight: 1,
                                  anchors: [0, 0.5, 1],
                                  context: context,
                                  builder: (BuildContext context,
                                      ScrollController scrollController,
                                      double bottomSheetOffset) {
                                    return SafeArea(
                                      child: Material(
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 5.0),
                                            child: TextFormField(
                                                decoration: InputDecoration(
                                                    label: Text(
                                                        "Editer $label")))),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(editable ? Icons.edit : null),
                              color: Theme.of(context).colorScheme.primary),
                        ]),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.25))))))
          ],
        ));
  }
}
