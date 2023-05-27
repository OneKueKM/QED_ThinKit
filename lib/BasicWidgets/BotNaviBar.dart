import 'package:flutter/material.dart';
import '../Main/1_Room/RoomScreen.dart';
import '../Main/2_Calendar/CalendarScreen.dart';
import '../Main/3_Home/HomeScreen.dart';
import '../Main/4_Friends/FriendsScreen.dart';
import '../Main/5_Account/AccountScreen.dart';
import 'package:tabler_icons/tabler_icons.dart';

class MyPage extends StatefulWidget {
  int currentIndex;

  MyPage({super.key, this.currentIndex = 2});
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int currentIndex = 2;
  final screens = [
    const RoomScreen(),
    const CalendarScreen(),
    const HomeScreen(),
    const ThirdScreen(),
    const AccountScreen(),
  ];

  late List<GlobalKey<NavigatorState>> _navigatorKeyList = [];

  @override
  void initState() {
    currentIndex = widget.currentIndex;
    // TODO: implement initState
    super.initState();
    _navigatorKeyList =
        List.generate(screens.length, (index) => GlobalKey<NavigatorState>());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[currentIndex]
            .currentState!
            .maybePop());
      },
      child: Scaffold(
        body: (currentIndex == 3 || currentIndex == 4)
            ? screens[currentIndex]
            : Navigator(
                key: _navigatorKeyList[currentIndex],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => screens[currentIndex],
                  );
                },
              ),
        bottomNavigationBar: BottomNavigationBar(
            mouseCursor: null,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (((index) {
              if (currentIndex == index) {
                // Get.offAll(MyPage(currentIndex: index));
                // //여기서는 그냥 pop을 해버리면 context를 파악해야 하므로 getX 사용 필수
              } else {
                setState(() => currentIndex = index);
              }
            })),
            items: const [
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  TablerIcons.layers_subtract,
                  size: 30,
                  color: Colors.grey,
                ),
                activeIcon: Icon(
                  TablerIcons.layers_subtract,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  TablerIcons.calendar,
                  size: 30,
                  color: Colors.grey,
                ),
                activeIcon: Icon(
                  TablerIcons.calendar,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  TablerIcons.smart_home,
                  size: 30,
                  color: Colors.grey,
                ),
                activeIcon: Icon(
                  TablerIcons.smart_home,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  TablerIcons.color_filter,
                  size: 27,
                  color: Colors.grey,
                ),
                activeIcon: Icon(
                  TablerIcons.color_filter,
                  size: 27,
                  color: Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  TablerIcons.user_circle,
                  size: 30,
                  color: Colors.grey,
                ),
                activeIcon: Icon(
                  TablerIcons.user_circle,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ]),
      ),
    );
  }
}
