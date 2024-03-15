import 'package:appbirthdaycake/config/approute.dart';
import 'package:flutter/material.dart';

class HomeBodyPage extends StatefulWidget {
  @override
  State<HomeBodyPage> createState() => _HomeBodyPageState();
}

class _HomeBodyPageState extends State<HomeBodyPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage('assets/images/preview2.png')),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(10, 158, 216, 1),
              Color.fromRGBO(226, 231, 241, 1.0),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 110,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Cake to Order',
                        //   style: TextStyle(
                        //       fontFamily: 'Bebas',
                        //       fontSize: 40,
                        //       color: Colors.pink[200]),
                        // ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'Home',
                          style: TextStyle(fontFamily: 'Bebas', fontSize: 26),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoute.CakeRoute);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'choose \nbirthday cake',
                                      style: TextStyle(
                                          fontFamily: 'Bebas',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      maxLines: 2,
                                    ),
                                    const Text(
                                      'เลือกเค้กวันเกิด',
                                      style: TextStyle(
                                          fontFamily: 'Bebas',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            AspectRatio(
                              aspectRatio: 0.90,
                              child: Image.asset(
                                'assets/images/cake_home_blue.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: 310,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade500,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoute.CakeDesignRoute);
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                          height: 15,
                                        ),
                                        const Text(
                                          'Cake Design',
                                          style: TextStyle(
                                            fontFamily: 'Bebas',
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          'ออกแบบเค้ก',
                                          style: TextStyle(
                                            fontFamily: 'bebas',
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: .59,
                                    child: Image.asset(
                                      'assets/images/cake_home_blue2.png',
                                      fit: BoxFit.cover,
                                      alignment: Alignment.bottomLeft,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade500,
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0),
                                BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-4.0, -4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0)
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Cake Sung Dai \nShop',
                                    style: TextStyle(
                                      fontFamily: 'Bebas',
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 15 / 20,
                                  child: Image.asset(
                                    'assets/images/cupcake.png',
                                    fit: BoxFit.cover,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        height: 120,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0),
                              const BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0)
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //Navigator.pushNamed(context, AppRoute.LoginRoute);
                      },
                      child: Text(
                        'Daily deals for you',
                        style: const TextStyle(
                          fontFamily: 'Bebas',
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: 300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/promotion_1.jpg'),
                              fit: BoxFit.cover),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/promotion_2.jpg'),
                                fit: BoxFit.cover),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/promotion_3.jpg'),
                                fit: BoxFit.cover),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/promotion_4.jpg'),
                                fit: BoxFit.cover),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
