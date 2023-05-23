import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:tabler_icons/tabler_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchRank extends StatefulWidget {
  const SearchRank({Key? key}) : super(key: key);

  @override
  State<SearchRank> createState() => _SearchRankState();
}

class _SearchRankState extends State<SearchRank> {
  final StreamController<List<String>> _dataStreamController =
      StreamController<List<String>>();

  @override
  void initState() {
    super.initState();
    extractData();
  }

  bool isLoading = false;

  Future<void> extractData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.Client().get(Uri.parse(
        'https://search.zum.com/search.zum?method=uni&option=accu&rd=1&query=&qm=f_typing.top'));

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);

      try {
        var responseString1 = document
            .getElementsByClassName("ranking is_rolling")[0]
            .children[0]
            .children[0]
            .children[1]
            .children[1];

        var responseString2 = document
            .getElementsByClassName("ranking is_rolling")[0]
            .children[1]
            .children[0]
            .children[1]
            .children[1];

        var responseString3 = document
            .getElementsByClassName("ranking is_rolling")[0]
            .children[2]
            .children[0]
            .children[1]
            .children[1];

        var responseString11 = document
            .getElementsByClassName("ranking is_rolling")[0]
            .children[0]
            .children[0]
            .children[1]
            .children[2];

        var responseString12 = document
            .getElementsByClassName("ranking is_rolling")[0]
            .children[1]
            .children[0]
            .children[1]
            .children[2];

        var responseString13 = document
            .getElementsByClassName("ranking is_rolling")[0]
            .children[2]
            .children[0]
            .children[1]
            .children[2];

        List<String> responseData = [
          responseString1.text.trim(),
          responseString2.text.trim(),
          responseString3.text.trim(),
          responseString11.text.trim(),
          responseString12.text.trim(),
          responseString13.text.trim(),
        ];

        _dataStreamController.sink.add(responseData);
      } catch (e) {
        _dataStreamController.sink.addError(e);
      }
    } else {
      _dataStreamController.sink.addError(response.statusCode);
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget showStatus(rankingStatus) {
    switch (rankingStatus) {
      case '상승':
        return SizedBox(
            height: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 4),
                Icon(TablerIcons.triangle,
                    color: Color.fromARGB(255, 255, 63, 63), size: 11)
              ],
            ));
      case '하락':
        return SizedBox(
            height: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 4),
                Icon(TablerIcons.triangle_inverted,
                    color: Color.fromARGB(255, 50, 154, 239), size: 11)
              ],
            ));
      default:
        return SizedBox(
            height: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 4),
                Icon(TablerIcons.minus,
                    color: Color.fromARGB(255, 119, 119, 119), size: 11)
              ],
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<String>>(
        stream: _dataStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: 500,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          '실시간 검색어',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query=${snapshot.data![0]}')),
                            child: SizedBox(
                              width: 160,
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(' 1    ${snapshot.data![0]}',
                                                style: const TextStyle(
                                                    fontFamily: 'SFProDisplay',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: 20,
                                          height: 30,
                                          child: showStatus(snapshot.data![3])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query=${snapshot.data![1]}')),
                            child: SizedBox(
                              width: 160,
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(' 2    ${snapshot.data![1]}',
                                                style: const TextStyle(
                                                    fontFamily: 'SFProDisplay',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: 20,
                                          height: 30,
                                          child: showStatus(snapshot.data![4])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query=${snapshot.data![2]}')),
                            child: SizedBox(
                              width: 160,
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(' 3    ${snapshot.data![2]}',
                                                style: const TextStyle(
                                                    fontFamily: 'SFProDisplay',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: 20,
                                          height: 30,
                                          child: showStatus(snapshot.data![5])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10)
                  ]),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
        },
      ),
    );
  }
}
