import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:url_launcher/url_launcher.dart';

class Details extends StatelessWidget {
  wp.Post post;
  Details(this.post);
  getPostImage() {
    if (post.featuredMedia == null) {
      return SizedBox(
        height: 10.0,
      );
    } else {
      return Image.network(post.featuredMedia.sourceUrl);
    }
  }

  launchUrl(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'can not show any thing from $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        title: Image.asset('images/logo.png'),
        centerTitle: true,
        backgroundColor: Color(0xFFf6f8fc),
      ),
      backgroundColor: Color(0xFFf6f8fc),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.title.rendered.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF383838),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'BY',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Color(0xFF383838),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  post.author.name.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF383838),
                  ),
                ),
                Text(
                  post.date.replaceAll('T', '  '),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF383838),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: getPostImage(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Html(
                  data: post.content.rendered,
                  onLinkTap: (String url) {
                    launchUrl(url);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
