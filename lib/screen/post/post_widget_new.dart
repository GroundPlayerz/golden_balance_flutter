import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_balance_flutter/bloc/cubit/home_feed_cubit.dart';
import 'package:golden_balance_flutter/bloc/state/home_feed_state.dart';
import 'package:golden_balance_flutter/constant/color.dart';
import 'package:golden_balance_flutter/constant/textstyle.dart';
import 'package:golden_balance_flutter/model/post/post.dart';
import 'package:golden_balance_flutter/screen/post/comment_screen.dart';
import 'package:golden_balance_flutter/screen/post/video_network_viewer.dart';

class PostWidgetNew extends StatefulWidget {
  final int postIndex;
  PostWidgetNew({required this.postIndex});

  @override
  _PostWidgetNewState createState() => _PostWidgetNewState();
}

class _PostWidgetNewState extends State<PostWidgetNew> {
  late int postIndex;

  final double _titleAreaHeight = 56;
  bool _isTitleStretched = false;

  @override
  void initState() {
    super.initState();
    postIndex = widget.postIndex;
  }

  Widget _videoWidget({required String url, required String thumbnailUrl}) {
    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          //alignment: Alignment.center,
          child: VideoNetworkViewer(
            videoUrl: url,
            thumbnailUrl: thumbnailUrl,
          ),
        ),
      ),
    );
  }

  Widget _imageWidget({required String url}) {
    return Stack(children: [
      Positioned.fill(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
        ),
      ),
      _topBlackGradient,
      _bottomBlackGradient,
    ]);
  }

  Widget _likeButtonDeactivated(Post post) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 35,
              color: kWhiteColor.withOpacity(0.4),
            ),
            SizedBox(width: 11),
            Text(
              post.likeCount.toString(),
              style: kPostInfoNumberTextStyle.copyWith(
                  color: kWhiteColor.withOpacity(0.4)),
            ),
          ],
        ),
      );
  Widget _likeButton(Post post) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (post.userLikeCount == 0) {
              //ToDo: ???????????? ???????????????!
              BlocProvider.of<HomeFeedCubit>(context)
                  .pressLikeButton(postIndex: postIndex);
            } else {
              //ToDo: ???????????? ????????? ????????????!
              BlocProvider.of<HomeFeedCubit>(context)
                  .pressLikeButton(postIndex: postIndex);
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              post.userLikeCount == 0
                  ? Icon(Icons.favorite_border_rounded,
                      size: 35, color: kWhiteColor)
                  : Icon(Icons.favorite_rounded,
                      size: 35, color: kAccentYellowColor),
              SizedBox(width: 11),
              Text(post.likeCount.toString()),
            ],
          ),
        ),
      );
  Widget _commentButtonDeactivated(Post post) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.mode_comment_outlined,
                size: 30, color: kWhiteColor.withOpacity(0.4)),
            SizedBox(width: 11),
            Text((post.commentCount).toString(),
                style: kPostInfoNumberTextStyle.copyWith(
                    color: kWhiteColor.withOpacity(0.4))),
          ],
        ),
      );
  Widget _commentButton(Post post) => GestureDetector(
        onTap: () {
          //Todo : ?????? ???????????? ????????????
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CommentScreen()));
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.mode_comment_outlined, size: 30, color: kWhiteColor),
              SizedBox(width: 11),
              Text((post.commentCount).toString(),
                  style: kPostInfoNumberTextStyle),
            ],
          ),
        ),
      );
  Widget _postInfoWidgetArea(BuildContext context, {required Post post}) =>
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          top: 11,
          bottom: MediaQuery.of(context).padding.bottom, //?????? ????????? ??? ????????????..
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //?????????
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text('??????', style: kPostInfoTextStyle),
                  SizedBox(width: 4),
                  Text(
                      (post.firstContentVoteCount + post.secondContentVoteCount)
                          .toString(),
                      style: kPostInfoNumberTextStyle.copyWith(fontSize: 14)),
                  SizedBox(width: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Container(
                      width: 20,
                      height: 20,
                      child: Image.asset('images/default_profile_photo.png'),
                    ),
                  ),
                  SizedBox(width: 11),
                  Text(post.profileName),
                ],
              ),
            ),
            //?????????
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                post.userVoteChoice == null
                    ? _likeButtonDeactivated(post)
                    : _likeButton(post),
                post.userVoteChoice == null
                    ? _commentButtonDeactivated(post)
                    : _commentButton(post),
              ],
            ),
          ],
        ),
      );
  Widget _postTitleAreaWidget(BuildContext context, {required Post post}) =>
      Stack(
        children: [
          Container(
              color: kBackgroundNavyColor,
              width: MediaQuery.of(context).size.width,
              height: _titleAreaHeight),
          Positioned(
            child: Container(
              height:
                  !_isTitleStretched ? _titleAreaHeight : _titleAreaHeight + 30,
              decoration: BoxDecoration(gradient: kPostGradient70),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 15, bottom: 15),
                      child: Text(
                        post.title,
                        maxLines: !_isTitleStretched ? 1 : 2,
                        style: kPostTitleTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: IconButton(
                        icon: !_isTitleStretched
                            ? Icon(Icons.keyboard_arrow_down_rounded)
                            : Icon(Icons.keyboard_arrow_up_rounded),
                        onPressed: () {
                          setState(() {
                            if (!_isTitleStretched) {
                              _isTitleStretched = true;
                            } else {
                              _isTitleStretched = false;
                            }
                          });
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  final Widget _topBlackGradient = Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0, -0.7),
            colors: [
              Color(0x40000000),
              Colors.transparent,
            ]),
      ),
    ),
  );
  final Widget _bottomBlackGradient = Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment(0, 0.7),
            colors: [
              Color(0x40000000),
              Colors.transparent,
            ]),
      ),
    ),
  );

  Widget _voteResultWidget(
      {required int firstContentVoteCount,
      required int secondContentVoteCount}) {
    var firstPercent = 100 *
        (firstContentVoteCount /
            (firstContentVoteCount + secondContentVoteCount));
    int firstPercentInt = firstPercent.toInt();
    int secondPercentInt = 100 - firstPercentInt;
    return Positioned.fill(
      top: _titleAreaHeight,
      child: Stack(
        children: [
          //?????? ??????
          Column(
            children: [
              Expanded(
                flex: firstPercentInt,
                child: Container(
                  color: Color(0xff0000BF).withOpacity(0.6),
                ),
              ),
              Expanded(
                flex: secondPercentInt,
                child: Container(
                  color: Color(0xffBF0000).withOpacity(0.6),
                ),
              ),
            ],
          ),
          //????????? ?????????
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    firstPercentInt.toString() + '%',
                    style: kPostVoteResultPercentTextStyle,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    secondPercentInt.toString() + '%',
                    style: kPostVoteResultPercentTextStyle,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _voteCompleteIconWidget(int whichContent, {required Post post}) {
    if (post.userVoteChoice != null && post.userVoteChoice == whichContent) {
      return Container(
          height: 40,
          width: 40,
          child: Image.asset('images/icon_check_circle.png'));
    } else {
      return Container();
    }
  }

  Widget _voteButton(int whichContent) {
    return GestureDetector(
      onTap: () {
        if (whichContent == 1) {
          BlocProvider.of<HomeFeedCubit>(context)
              .voteToPost(postIndex: postIndex, choice: 1);
        } else if (whichContent == 2) {
          BlocProvider.of<HomeFeedCubit>(context)
              .voteToPost(postIndex: postIndex, choice: 2);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text('??????'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeFeedCubit, HomeFeedState>(
      builder: (context, state) {
        if (state is Loaded) {
          Post post = state.feed[postIndex];
          List<Map<String, dynamic>> mediaList = [{}, {}];

          if (post.mediaContentOrders != null) {
            List<String> mediaContentOrdersList =
                post.mediaContentOrders!.split(',');
            List<String> mediaTypesList = post.mediaTypes!.split(',');
            List<String> mediaUrlsList = post.mediaUrls!.split(',');

            for (int i = 0; i < mediaContentOrdersList.length; i++) {
              if (mediaTypesList[i] == 'thumbnail') {
                mediaList[int.parse(mediaContentOrdersList[i]) - 1]
                    ['thumbnail_url'] = mediaUrlsList[i];
              } else {
                mediaList[int.parse(mediaContentOrdersList[i]) - 1]['type'] =
                    mediaTypesList[i];
                mediaList[int.parse(mediaContentOrdersList[i]) - 1]['url'] =
                    mediaUrlsList[i];
              }
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    //?????? ??????
                    Container(
                      decoration: BoxDecoration(gradient: kPostGradient50),
                    ),
                    //???????????????
                    Positioned.fill(
                      top: _titleAreaHeight,
                      child: Column(
                        children: [
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (mediaList[0]['type'] == 'video') {
                                  return _videoWidget(
                                      url: mediaList[0]['url'],
                                      thumbnailUrl: mediaList[0]
                                          ['thumbnail_url']);
                                } else if (mediaList[0]['type'] == 'image') {
                                  return _imageWidget(url: mediaList[0]['url']);
                                }
                                return Container();
                              },
                            ),
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (mediaList[1]['type'] == 'video') {
                                  return _videoWidget(
                                      url: mediaList[1]['url'],
                                      thumbnailUrl: mediaList[1]
                                          ['thumbnail_url']);
                                } else if (mediaList[1]['type'] == 'image') {
                                  return _imageWidget(url: mediaList[1]['url']);
                                }
                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    //??????????????????
                    post.userVoteChoice != null
                        ? _voteResultWidget(
                            firstContentVoteCount: post.firstContentVoteCount,
                            secondContentVoteCount: post.secondContentVoteCount)
                        : Container(),
                    //?????? ??????
                    Positioned.fill(
                      top: _titleAreaHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 6, bottom: 8, left: 20, right: 20),
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text(
                                    post.firstContentText,
                                    style: kPostContentTextStyle,
                                  ),
                                ),
                                SizedBox(height: 40.0),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 40.0),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 6, bottom: 8, left: 20, right: 20),
                                color: Colors.black.withOpacity(0.5),
                                child: Text(
                                  post.secondContentText,
                                  style: kPostContentTextStyle,
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      top: _titleAreaHeight - 10,
                      child: Center(
                        child: Text(
                          'vs',
                          style: kPostVSTextStyle.copyWith(fontSize: 55),
                        ),
                      ),
                    ),
                    //?????? ??????
                    Positioned.fill(
                      top: _titleAreaHeight,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: post.userVoteChoice == null
                                  ? _voteButton(1)
                                  : _voteCompleteIconWidget(1, post: post),
                            ),
                          ),
                          //??????2
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: post.userVoteChoice == null
                                  ? _voteButton(2)
                                  : _voteCompleteIconWidget(2, post: post),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _postTitleAreaWidget(context, post: post),
                  ],
                ),
              ),
              _postInfoWidgetArea(context, post: post),
            ],
          );
        } else {
          //????????????
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    //?????? ??????
                    Container(
                      decoration: BoxDecoration(gradient: kPostGradient50),
                    ),
                    //???????????????
                    Positioned.fill(
                      top: _titleAreaHeight,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                    //??????????????????
                    //post.isVoted ? _voteResultWidget(firstContentVoteCount: post.firstContentVoteCount, secondContentVoteCount: post.secondContentVoteCount) : Container(),
                    //?????? ??????
                    Positioned.fill(
                      top: _titleAreaHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 6, bottom: 8, left: 20, right: 20),
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text(
                                    '...',
                                    //post.firstContentText,
                                    style: kPostContentTextStyle,
                                  ),
                                ),
                                SizedBox(height: 40.0),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 40.0),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 6, bottom: 8, left: 20, right: 20),
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text(
                                    '...',
                                    //post.secondContentText,
                                    style: kPostContentTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      top: _titleAreaHeight - 10,
                      child: Center(
                        child: Text(
                          'vs',
                          style: kPostVSTextStyle.copyWith(fontSize: 55),
                        ),
                      ),
                    ),
                    //?????? ?????? ????????????
                    Stack(
                      children: [
                        Container(
                            color: kBackgroundNavyColor,
                            width: MediaQuery.of(context).size.width,
                            height: _titleAreaHeight),
                        Positioned(
                          child: Container(
                            height: !_isTitleStretched
                                ? _titleAreaHeight
                                : _titleAreaHeight + 30,
                            decoration:
                                BoxDecoration(gradient: kPostGradient70),
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 15, bottom: 15),
                                child: Text(
                                  '...',
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //postInfo ??????
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  top: 11,
                  bottom:
                      MediaQuery.of(context).padding.bottom, //?????? ????????? ??? ????????????..
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //?????????
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text('...', style: kPostInfoTextStyle),
                          SizedBox(width: 4),
                          Text('...',
                              style: kPostInfoNumberTextStyle.copyWith(
                                  fontSize: 14)),
                          SizedBox(width: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Container(
                              width: 20,
                              height: 20,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 11),
                          Text('...'),
                        ],
                      ),
                    ),
                    //?????????
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //?????????
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_border_rounded,
                                size: 35,
                                color: kWhiteColor.withOpacity(0.4),
                              ),
                              SizedBox(width: 11),
                              Text(
                                '...',
                                style: kPostInfoNumberTextStyle.copyWith(
                                    color: kWhiteColor.withOpacity(0.4)),
                              ),
                            ],
                          ),
                        ),
                        //??????
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.mode_comment_outlined,
                                  size: 30,
                                  color: kWhiteColor.withOpacity(0.4)),
                              SizedBox(width: 11),
                              Text('...',
                                  style: kPostInfoNumberTextStyle.copyWith(
                                      color: kWhiteColor.withOpacity(0.4))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
