import 'package:flutter/material.dart';

Future<void> normalDialog2(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Container(
        width: 200,
        child: ListTile(
          leading: Image.asset('assets/images/order_ss.jpg'),
          title: Text(
            title,
            style: TextStyle(
                fontFamily: 'Bebas', fontSize: 25, color: Colors.blue[500]),
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

Future<void> normalDialogRegis(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Container(
        width: 200,
        child: ListTile(
          leading: Image.asset('assets/images/okay.png'),
          title: Text(
            title,
            style: TextStyle(
                fontFamily: 'Bebas', fontSize: 40, color: Colors.blue[300]),
          ),
          subtitle: Text(message),
        ),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}
