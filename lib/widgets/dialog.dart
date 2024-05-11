import 'package:flutter/material.dart';

import '../custumer/HomeScreen/big_text.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: BigText(text: message),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: BigText(
                    text: 'OK',
                  )),
            ),
          ],
        )
      ],
    ),
  );
}

Future<void> normalDialog2(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Container(
        width: 150,
        child: ListTile(
          leading: Image.asset('assets/images/order_ss.jpg'),
          title: Text(
            title,
            style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade100),
          ),
          subtitle: Text(message),
        ),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue.shade300),
                )),
          ],
        )
      ],
    ),
  );
}
