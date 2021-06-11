import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_balance_flutter/bloc/cubit/comment_screen_cubit.dart';
import 'package:golden_balance_flutter/bloc/state/comment_screen_state.dart';
import 'package:golden_balance_flutter/constant/color.dart';
import 'package:golden_balance_flutter/constant/textstyle.dart';
import 'package:golden_balance_flutter/model/comment/comment.dart';
import 'package:golden_balance_flutter/screen/post/nested_comment_screen.dart';

class CommentWidget extends StatefulWidget {
  //Comment comment;
  int commentIndex;
  CommentWidget({required this.commentIndex});
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  //Todo: 나중에 실제 Comment에 맞게 바꾸기
  // late Comment comment;
  late int commentIndex;

  final double leftPadding = 16;
  final double photoWidth = 20;
  final double sizeboxWidthBetweenPhotoAndName = 11;
  final double sizeboxWidthBetweenTextAndLikeButton = 8;
  final double likebuttonWidth = 8 + 20 + 16;
  late double sumConstantsWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentIndex = widget.commentIndex;

    sumConstantsWidth = leftPadding +
        photoWidth +
        sizeboxWidthBetweenPhotoAndName +
        sizeboxWidthBetweenTextAndLikeButton +
        likebuttonWidth;
  }

  String _createdOrUpdatedAt({required Comment comment}) {
    if (comment.updatedAt == null) {
      return comment.createdAt;
    } else {
      return comment.updatedAt!;
    }
  }

  Widget _likeButton({required Comment comment}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            BlocProvider.of<CommentScreenCubit>(context).pressLikeButton(
              commentIndex: commentIndex,
              memberLikeCount: comment.memberLikeCount,
            );
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              comment.memberLikeCount == 0
                  ? Icon(Icons.favorite_border_rounded,
                      size: photoWidth, color: kIconGreyColor_CBCBCB)
                  : Icon(Icons.favorite_rounded,
                      size: photoWidth, color: kAccentPinkColor),
              SizedBox(width: 10),
              (comment.likeCount == 0)
                  ? Text('')
                  : Text(comment.likeCount.toString(),
                      style: kCommentTextTextStyle.copyWith(
                          color: kGreyColor1_767676)),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentScreenCubit, CommentScreenState>(
        builder: (context, state) {
      if (state is CommentScreenLoaded) {
        Comment comment = state.commentList[commentIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            child: comment.profilePhotoUrl != null
                                ? Image.network(comment.profilePhotoUrl!)
                                : Image.asset(
                                    'images/default_profile_photo.png'),
                          ),
                          SizedBox(width: sizeboxWidthBetweenPhotoAndName),
                          RichText(
                            text: TextSpan(
                              text: comment.profileName + '     ',
                              style: kCommentTextTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: _createdOrUpdatedAt(comment: comment)
                                      .split(' ')[0]
                                      .split('T')[0]
                                      .replaceAll('-', '.'),
                                  style: kCommentInfoTextStyle.copyWith(
                                      color: kGreyColor2_999999),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //더보기 버튼
                          GestureDetector(
                            onTap: () {
                              //Todo
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 10),
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Icon(
                                  Icons.more_horiz_sharp,
                                  color: kIconGreyColor_CBCBCB,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    comment.text,
                    style: kCommentTextTextStyle,
                    softWrap: true,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _likeButton(comment: comment),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NestedCommentScreen(
                                  commentId: comment.id,
                                  commentIndex: commentIndex,
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.mode_comment_outlined,
                            size: photoWidth, color: kIconGreyColor_CBCBCB),
                        SizedBox(width: 10),
                        (comment.nestedCommentCount == 0)
                            ? Text('')
                            : Text(comment.likeCount.toString() + '개 답글',
                                style: kCommentTextTextStyle),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      } else {
        //Todo: 스켈레톤
        return Container();
      }
    });
  }
}
