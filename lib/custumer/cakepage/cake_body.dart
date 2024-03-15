import 'package:flutter/material.dart';
import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/services/network.dart';

class CakeBody extends StatelessWidget {
  const CakeBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Container(
          child: FutureBuilder<CakeNModel>(
            future: NetworkService().getAllCakeNDio(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: snapshot.data.cakens.length,
                  itemBuilder: (context, index) {
                    var cake = snapshot.data.cakens[index];
                    return Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.CakeDetailRoute,
                            arguments: cake,
                          );
                        },
                        child: Card(
                          color: Colors.blue[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: Image(
                                    image: NetworkImage(
                                      API.CN_IMAGE + cake.cnImages,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text('ชื่อเค้ก : ' + cake.cnCakename),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ),
    );
  }
}
