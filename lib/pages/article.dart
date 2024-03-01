import 'package:flutter/material.dart';

import '../components/MyAppBar.dart';

class ArticlePage extends StatefulWidget {
  late String imgUrl ;
  late String text ;
  late String titre ;
  ArticlePage({super.key, required this.imgUrl , required this.text , required this.titre});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  CustomAppBar(leading: Image.asset('lib/images/logo.png'),),
      backgroundColor: Colors.transparent,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF00818c).withOpacity(0.6),
                      Colors.white.withOpacity(0.6), // Second color - #4ca2d2
                    ],
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top : 18,left: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.titre,style: const TextStyle(
                                fontFamily: "KoHo", // Replace with your font family
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                ),),
                          const SizedBox(width : 30),
                        ],
                      ),
                    ),
                    Hero(
                      tag: widget.imgUrl,
                      child: Image.network(
                        widget.imgUrl,
                        width: double.infinity,
                        height: 300
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                      child: Text(
                        widget.text,
                        style: const TextStyle(
                          fontFamily: "InterTight",
                          fontSize: 20 ,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          letterSpacing: 2,
                          height: 1.5
                        )
                     ,),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
