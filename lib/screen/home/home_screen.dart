import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_balance_flutter/bloc/cubit/auth_cubit.dart';
import 'package:golden_balance_flutter/bloc/cubit/home_feed_cubit.dart';
import 'package:golden_balance_flutter/bloc/state/auth_state.dart';
import 'package:golden_balance_flutter/bloc/state/home_feed_state.dart';
import 'package:golden_balance_flutter/constant/color.dart';
import 'package:golden_balance_flutter/constant/textstyle.dart';
import 'package:golden_balance_flutter/screen/home/following_feed_screen.dart';
import 'package:golden_balance_flutter/screen/home/post_widget.dart';
import 'package:golden_balance_flutter/screen/notification_screen.dart';
import 'package:golden_balance_flutter/screen/profile/my_profile_screen.dart';
import 'package:golden_balance_flutter/screen/upload/upload_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isForYouSelected = true;
  bool isStateChecked = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeFeedCubit>(context).getUserHomeFeed();
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kBackgroundNavyColor,
          leadingWidth: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    '추천',
                    style: isForYouSelected
                        ? kHomeScreenSelectedTabTextStyle
                        : kHomeScreenUnselectedTabTextStyle,
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FollowingFeedScreen()));
                  },
                  child: Text('팔로잉',
                      style: !isForYouSelected
                          ? kHomeScreenSelectedTabTextStyle
                          : kHomeScreenUnselectedTabTextStyle)),
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadScreen()));
                }),
            IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                }),
            IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfileScreen()));
                }),
          ],
        ),
        backgroundColor: kBackgroundNavyColor,
        body: BlocBuilder<HomeFeedCubit, HomeFeedState>(
            builder: (context, feedState) {
          if (feedState is Loaded) {
            return PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              itemCount: feedState.feed.length,
              itemBuilder: (BuildContext context, int index) {
                return PostWidget(
                  post: feedState.feed[index],
                );
              },
            );
          } else if (feedState is FeedError) {
            print(feedState.message);
          } else if (feedState is Loading) {
            return Text('스켈레톤 띄우기');
          }

          return Text(feedState.toString());
        }),
      );
    });
  }
}
