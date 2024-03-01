import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modernlogintute/pages/addDemande.dart';
import 'package:modernlogintute/pages/compte.dart';
import 'package:modernlogintute/pages/sendMessage.dart';
import '../components/MyAppBar.dart';
import '../helpers/helpersVariables.dart';
import '../model/article.dart';
import '../model/user.dart';
import 'article.dart';
import 'package:http/http.dart' as http;

class ImageWithTextComponent extends StatefulWidget {
  final String imageUrl;
  final String text;
  final String titre ;
  const ImageWithTextComponent({super.key, required this.imageUrl, required this.text, required this.titre});

  @override
  _ImageWithTextComponentState createState() => _ImageWithTextComponentState();
}

class _ImageWithTextComponentState extends State<ImageWithTextComponent> {
  static const double componentHeight = 180;
  static const double componentWidth = double.infinity;
  static const double borderRadius = 20;
  String truncateText(String text) {
    const int maxLength = 100;

    if (text.length <= maxLength) {
      return text;
    } else {
      return "${text.substring(0, maxLength)} ...";
    }
  }



  @override
  Widget build(BuildContext context) {
    var simplifiedText = truncateText(widget.text) ;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: (){
          var imgurl = widget.imageUrl;
          var text =  widget.text;
          var titre = widget.titre ;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>ArticlePage(imgUrl: imgurl,text: text,titre:titre),
            ),
          ) ;
        },
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: componentHeight,
          width: componentWidth,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  bottomLeft: Radius.circular(borderRadius),
                ),
                child: Hero(
                  tag: widget.imageUrl,
                  child: Image.network(
                    widget.imageUrl,
                    height: componentHeight,
                    width: componentHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.titre,style: const TextStyle(
                          fontFamily: "KoHo", // Replace with your font family
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),),
                        Text(
                          simplifiedText,
                          style: const TextStyle(
                            fontFamily: "KoHo", // Replace with your font family
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
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


class FirstPage extends StatefulWidget {
  final User user;
  const FirstPage({required this.user, Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late List<Article> articles =[
    Article(
        id:0,
        imgURL:"https://img.freepik.com/premium-photo/isolated-3d-render-natural-leaf-recycling-symbol-with-white-background_533392-144.jpg?w=996",
        titre: "Recycling",
        text:"Recycling is the process of converting waste materials into new materials and objects. This concept often includes the recovery of energy from waste materials.") ,
    Article(
        id:1,
        imgURL:"https://media.istockphoto.com/id/943875208/photo/globe-on-moss-in-forest-environment-concept.jpg?s=612x612&w=0&k=20&c=GH0JZ9Kc_gi5TYe0hz43_PKdMbbYhJHU-RZZd8xcjBs=",
        titre: "Enviroment",
        text:"The recyclability of a material depends on its ability to reacquire the properties it had in its original state. It is an alternative to \"conventional\" waste disposal that can save material and help lower greenhouse gas emissions. It can also prevent th") ,
    Article(
        id:2,
        imgURL:"https://media.istockphoto.com/id/1181366400/photo/in-the-hands-of-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-on.jpg?s=612x612&w=0&k=20&c=jWUMrHgjMY9zQXsAwZFb1jfM6KxZE16-IXI1bvehjQM=",
        titre: "Plant",
        text:"Tree planting is the process of transplanting tree seedlings, generally for forestry, land reclamation, or landscaping purposes. It differs from the transplantation of larger trees in arboriculture and from the lower-cost but slower and less reliable dist")
  ] ;

 /* Future<List<Article>> getAllArticle() async{
    final response = await http.get(
      Uri.parse('${ENV_variables.API_PATH}/article/get.php'),
    );
    List<Article> articles = [];
    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> data = json.decode(response.body);
      for(var element in data['articles']) {
        var article = Article(id: element["id"],imgURL:element["img_url"] ,titre: element['titre'],text: element['text']) ;
        articles.add(article);
      }

    }
    return articles ;
  }*/

  /*void fetchData() async{
    var art =  await getAllArticle() ;
    setState(()  {
      articles =art;
    });
  }*/
  @override
  void initState()  {
    //fetchData() ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String name = widget.user.name ?? 'undefined';

    return Scaffold(
      appBar: CustomAppBar(leading: Image.asset('lib/images/logo.png'),showBackArrow: false,),
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
            Image.asset("lib/images/background.png"),
            Column(
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "ACCUEIL",
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
                const SizedBox(height: 30),
                // Create a ListView.builder to render the list of ImageWithTextComponent
                Expanded(
                  child: ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final imageUrl = articles[index].imgURL!;
                      final text = articles[index].text!;
                      final titre = articles[index].titre!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: ImageWithTextComponent(
                          titre: titre,
                          imageUrl: imageUrl,
                          text: text,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/*class ElementContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function() onPressed;

  const ElementContainer({
    required this.text,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0xFF24306F).withOpacity(0.7),
      onTap: onPressed,
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[400],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 58,
              color: const Color(0xFF24306F),
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1,
                color: Color(0xFF24306F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
