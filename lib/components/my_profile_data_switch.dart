import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/firestore_child.dart';

class ProfileDataSwitch extends StatefulWidget {
  final String text;
  final String sectionName;
  final String field;
  final String childcode;




 ProfileDataSwitch({
    super.key,
    required this.text,
    required this.sectionName,
    required this.field,
    required this.childcode,
  });






  @override
  State<ProfileDataSwitch> createState() => _ProfileDataSwitchState();
}

class _ProfileDataSwitchState extends State<ProfileDataSwitch> {

bool isSwitchedfalse  = false;
bool isSwitchedtrue  = true;


void updateEinwilligungen (String childcode, bool isSwitched, String field) async {
    final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();
    if (isSwitched == true) {
      firestoreDatabaseChild.updateChildEinwilligungen(
        childcode, field, "erlaubt",);
      isSwitched = true;
    }
    else {
      firestoreDatabaseChild.updateChildEinwilligungen(
        childcode, field, "nicht erlaubt",);
      isSwitched = false;
    }
  }







  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    return  StatefulBuilder
        (builder: (context, setState)
    {
      return new Container(
        width: mediaQuery.size.width * 1,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.only(left: 15,),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.sectionName,
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .inversePrimary,),
                ),

                Column(
                  children: [
                    if (widget.text == "erlaubt")
                    Switch(
                        value: isSwitchedtrue,
                        onChanged: (value)  {
                          updateEinwilligungen(widget.childcode, value, widget.field);
                          isSwitchedtrue = value;
                          setState(() {
                          });
                        }
                    ),
                    if (widget.text == "nicht erlaubt")
                      Switch(
                          value: isSwitchedfalse,
                          onChanged: (value)  {
                            updateEinwilligungen(widget.childcode, value, widget.field);
                            isSwitchedfalse = value;
                            setState(() {
                            });
                          }
                      ),
                  ],
                )
              ],
            ),
            /*
            Text(widget.text,
              style: TextStyle(color: Colors.black,
                fontSize: 12,
              ),
            ),
            */
          ],
        ),
      );
    }
    );
  }



  }


