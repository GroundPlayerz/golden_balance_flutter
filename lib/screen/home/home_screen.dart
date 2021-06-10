import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:golden_balance_flutter/bloc/cubit/auth_cubit.dart';
import 'package:golden_balance_flutter/bloc/cubit/home_feed_cubit.dart';
import 'package:golden_balance_flutter/bloc/state/auth_state.dart';
import 'package:golden_balance_flutter/bloc/state/home_feed_state.dart';
import 'package:golden_balance_flutter/constant/color.dart';
import 'package:golden_balance_flutter/screen/post/feed_post_widget.dart';
import 'package:golden_balance_flutter/screen/profile/auth_profile_screen.dart';
import 'package:golden_balance_flutter/screen/profile/unauth_profile_screen.dart';
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
    BlocProvider.of<HomeFeedCubit>(context).getInitialUserHomeFeed();
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
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: authState is FirebaseSignedIn
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadScreen()));
                      }
                    : () {
                        Fluttertoast.showToast(
                          msg: '업로드를 하기 위해서는 로그인 해야합니다.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }),
            IconButton(
                icon: Icon(Icons.person),
                onPressed: authState is FirebaseSignedIn
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthProfileScreen()));
                      }
                    : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UnauthProfileScreen()));
                      }),
          ],
        ),
        backgroundColor: kBackgroundNavyColor,
        body: BlocBuilder<HomeFeedCubit, HomeFeedState>(
            builder: (context, feedState) {
          if (feedState is HomeFeedLoaded) {
            if (feedState.feed.isEmpty) {
              return Expanded(
                child: Container(
                  //height: 100,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.red,
                  child: Text('게시물을 모두 시청했습니다.'),
                ),
              );
            }
            return PageView.builder(
              allowImplicitScrolling: true,
              scrollDirection: Axis.horizontal,
              controller: pageController,
              itemCount: feedState.feed.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < feedState.feed.length) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await BlocProvider.of<AuthCubit>(context)
                          .getAccessTokenByState()
                          .then((_) {
                        BlocProvider.of<HomeFeedCubit>(context)
                            .getInitialUserHomeFeed();
                      });
                    },
                    child: ListView(children: [
                      Container(
                        height: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).padding.top +
                                AppBar().preferredSize.height),
                        width: double.infinity,
                        child: FeedPostWidget(
                          postIndex: index,
                        ),
                      ),
                    ]),
                  );
                }

                if (!feedState.isLoadingMore && feedState.hasMore) {
                  BlocProvider.of<HomeFeedCubit>(context).getUserHomeFeed();
                }
                if (feedState.hasMore) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print(feedState.hasMore);
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('게시물을 모두 확인했습니다.'),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('새로고침'),
                            IconButton(
                                onPressed: () {
                                  BlocProvider.of<HomeFeedCubit>(context)
                                      .getInitialUserHomeFeed();
                                },
                                icon: Icon(Icons.restart_alt)),
                          ])
                    ],
                  ));
                }
              },
            );
          } else if (feedState is HomeFeedError) {
            print(feedState.message);
          } else if (feedState is HomeFeedInitialLoading) {
            return Center(child: CircularProgressIndicator());
            //Text('스켈레톤 띄우기');
          }
          return Text(feedState.toString());
        }),
      );
    });
  }
}
