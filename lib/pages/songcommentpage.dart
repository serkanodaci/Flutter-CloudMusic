import 'package:cloudmusic/actions/Adapt.dart';
import 'package:cloudmusic/actions/cloudmusicapihelper.dart';
import 'package:cloudmusic/model/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SongCommentPage extends StatefulWidget {
  final int id;
  SongCommentPage({this.id});
  @override
  SongCommentState createState() => new SongCommentState();
}

class SongCommentState extends State<SongCommentPage> {
  int id;
  int offset = 0;
  int limit = 50;
  int commentcount = 0;
  int hotCommentCount = 0;
  bool isBusy = false;
  var formatter = new DateFormat('yyyy年MM月dd日');
  ScrollController scrollController = new ScrollController();
  SongCommentModel _songCommentModel;
  void loadComment() async {
    setState(() {
      isBusy = true;
    });
    var r = await CloudMusicApiHelper.songComments(id, limit, offset);
    if (_songCommentModel == null) {
      setState(() {
        _songCommentModel = r;
        commentcount = r.total;
        hotCommentCount = r.hotComments.length;
      });
    } else {
      setState(() {
        _songCommentModel.comments.addAll(r.comments);
      });
    }
    setState(() {
      isBusy = false;
      offset += 50;
    });
  }

  void scrollUpover() {
    bool isBottom = scrollController.position.pixels ==
        scrollController.position.maxScrollExtent;
    if (isBottom && _songCommentModel.comments.length < commentcount) {
      loadComment();
    }
  }

  Widget getCommentCell(SongComment c) {
    return Container(
        padding: EdgeInsets.only(left: Adapt.px(30), bottom: Adapt.px(30)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(30)),
              child: FadeInImage.assetNetwork(
                width: Adapt.px(60),
                placeholder: 'images/CacheBG.jpg',
                image: c.user.avatarUrl,
              ),
            ),
            SizedBox(
              width: Adapt.px(15),
            ),
            Container(
              width: Adapt.screenW() * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    c.user.nickname,
                    style: TextStyle(fontSize: Adapt.px(24)),
                  ),
                  Text(
                    formatter
                        .format(DateTime.fromMillisecondsSinceEpoch(c.time)),
                    style: TextStyle(fontSize: Adapt.px(18)),
                  ),
                  SizedBox(
                    height: Adapt.px(10),
                  ),
                  Text(
                    c.content,
                    softWrap: true,
                    style:
                        TextStyle(height: Adapt.px(3), color: Colors.black, fontSize: Adapt.px(28)),
                  ),
                  SizedBox(
                    height: Adapt.px(20),
                  ),
                  Container(
                    color: Colors.grey[200],
                    height: 1,
                  )
                ],
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    id = widget.id;
    scrollController.addListener(scrollUpover);
    loadComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          '评论($commentcount)',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
                padding: EdgeInsets.only(
                    left: Adapt.px(30),
                    top: Adapt.px(30),
                    bottom: Adapt.px(20)),
                child: Text(
                  '精彩评论',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                )),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return getCommentCell(_songCommentModel.hotComments[index]);
            }, childCount: hotCommentCount),
          ),
          SliverToBoxAdapter(
              child: Container(
                  padding:
                      EdgeInsets.only(left: Adapt.px(30), bottom: Adapt.px(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '最新评论',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(commentcount.toString(),
                          style: TextStyle(
                            fontSize: Adapt.px(20),
                            color: Colors.grey[600],
                          )),
                    ],
                  ))),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return getCommentCell(_songCommentModel.comments[index]);
            }, childCount: offset),
          ),
          SliverToBoxAdapter(
              child: Container(
            height: Adapt.px(80),
            padding: EdgeInsets.all(Adapt.px(5)),
            child: Center(
              child: isBusy
                  ? CircularProgressIndicator(
                      strokeWidth: Adapt.px(3),
                    )
                  : null,
            ),
          ))
        ],
      ),
    );
  }
}
