import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF5F5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xF5F5F5F5),
        title: Row(
          children: [
            Image.asset(
              'assets/icons/appbar/location.png',
              scale: 14,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Sulaymaniyah',
              style: GoogleFonts.amaranth(
                textStyle: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/icons/appbar/search.png',
                scale: 14,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 200,
                margin: EdgeInsets.all(8),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        tileMode: TileMode.mirror,
                        colors: [
                          Colors.orange,
                          Colors.deepOrange,
                          Colors.deepOrangeAccent,
                        ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/icons/02d.png',
                          height: 100,
                          fit: BoxFit.fill,
                          // color: whiteColor,
                        ),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.grey,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                            ).createShader(bounds);
                          },
                          child: Text(
                            '21°',
                            style: GoogleFonts.amaranth(
                              textStyle: TextStyle(
                                color: Colors
                                    .white, // This color is required but will be overridden by the gradient
                                fontSize: 70,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Few clouds',
                          style: GoogleFonts.amaranth(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Text(
                          'Monday, 12 Feb',
                          style: GoogleFonts.amaranth(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                margin: EdgeInsets.all(8),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    end: Alignment.topLeft,
                    tileMode: TileMode.mirror,
                    colors: [
                      Colors.orange,
                      Colors.deepOrange,
                      Colors.deepOrangeAccent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Mon',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '9:00 AM',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/icons/01d.png',
                            height: 50,
                            fit: BoxFit.fill,
                            // color: whiteColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '26 °',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            'Tue',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '7:00 AM',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/icons/02d.png',
                            height: 50,
                            fit: BoxFit.fill,
                            // color: whiteColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '22 °',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
