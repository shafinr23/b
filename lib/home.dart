import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:url_launcher/url_launcher.dart';

import 'details.dart';

//https://demo.wp-api.org/wp-json/wp/v2/
class Home extends StatelessWidget {
  wp.WordPress wordPress = wp.WordPress(
    baseUrl: 'http://blog.shafinrahman.com/',
  );

  _fetchPosts() {
    Future<List<wp.Post>> posts = wordPress.fetchPosts(
      postParams: wp.ParamsPostList(
        context: wp.WordPressContext.view,
        pageNum: 1,
        perPage: 10,
      ),
      fetchAuthor: true,
      fetchFeaturedMedia: true,
      fetchComments: true,
    );
    return posts;
  }

  _getPostImage(wp.Post post) {
    if (post.featuredMedia == null) {
      return SizedBox();
    }
    return Image.network(post.featuredMedia.sourceUrl);
  }

  _luncherUrl(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'cannot lanch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Image.asset('images/logo.png'),
        centerTitle: true,
        backgroundColor: Color(0xFFf6f8fc),
      ),
      backgroundColor: Color(0xFFf6f8fc),
      body: Container(
        child: FutureBuilder(
          future: _fetchPosts(),
          builder:
              (BuildContext context, AsyncSnapshot<List<wp.Post>> snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                wp.Post post = snapshot.data[index];
                return InkWell(
                  enableFeedback: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(post),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        width: 240.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      post.title.rendered
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color:
                                                            Color(0xFF383838),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Html(
                                                      data:
                                                          post.excerpt.rendered,
                                                      onLinkTap: (String url) {
                                                        _luncherUrl(url);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      post.author.name,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        color:
                                                            Color(0xFF383838),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      post.dateGmt,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        color:
                                                            Color(0xFF383838),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 80.0,
                                            height: 120,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: _getPostImage(post),
                                                ),
                                                Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.pinkAccent,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

//
//
//Column(
//children: <Widget>[
//Column(
//children: <Widget>[
//Padding(
//padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
//child: Card(
//color: Colors.white,
//elevation: 5.0,
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(5.0),
//),
//child: Padding(
//padding: EdgeInsets.all(5.0),
//child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
//children: <Widget>[
//Padding(
//padding: EdgeInsets.all(0.0),
//child: Container(
//width: 290.0,
//child: Column(
//mainAxisAlignment:
//MainAxisAlignment.spaceBetween,
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Column(
//children: <Widget>[
//Column(
//crossAxisAlignment:
//CrossAxisAlignment.start,
//children: <Widget>[
//Text(
//'My year abroad in Paris',
//textAlign: TextAlign.left,
//style: TextStyle(
//fontSize: 20.0,
//color: Color(0xFF383838),
//fontWeight: FontWeight.bold,
//),
//),
//Text(
//'It is a long established fact that a reader will be distracted by the readable content of a page ',
//textAlign: TextAlign.justify,
//style: TextStyle(
//fontSize: 15.0,
//color: Color(0xFF383838),
//),
//),
//],
//),
//],
//),
//SizedBox(
//height: 15.0,
//),
//Row(
//crossAxisAlignment:
//CrossAxisAlignment.start,
//children: <Widget>[
//CircleAvatar(
//backgroundImage: NetworkImage(
//'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
//),
//SizedBox(
//width: 10.0,
//),
//Column(
//crossAxisAlignment:
//CrossAxisAlignment.start,
//children: <Widget>[
//Text(
//'ShafinRahman',
//textAlign: TextAlign.left,
//style: TextStyle(
//fontSize: 15.0,
//color: Color(0xFF383838),
//fontWeight: FontWeight.bold,
//),
//),
//Text(
//' 8post',
//textAlign: TextAlign.justify,
//style: TextStyle(
//fontSize: 15.0,
//color: Color(0xFF383838),
//),
//),
//],
//),
//],
//)
//],
//),
//),
//),
//Padding(
//padding: EdgeInsets.all(5.0),
//child: Column(
//// mainAxisAlignment: MainAxisAlignment.center,
//children: <Widget>[
//Container(
//width: 80.0,
//height: 120,
//child: Column(
//mainAxisAlignment:
//MainAxisAlignment.spaceBetween,
//crossAxisAlignment: CrossAxisAlignment.end,
//children: <Widget>[
//ClipRRect(
//borderRadius:
//BorderRadius.circular(5.0),
//child: Image.network(
//'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//),
//),
//Icon(
//Icons.favorite_border,
//color: Colors.pinkAccent,
//)
//],
//),
//)
//],
//),
//),
//],
//),
//),
//),
//),
//],
//)
//],
//),
//
//
