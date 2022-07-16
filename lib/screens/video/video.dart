import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnath_agritech_web/responsive.dart';
import 'package:omnath_agritech_web/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

import '../../constants.dart';

class Videopanel extends StatefulWidget {
  @override
  State<Videopanel> createState() => _VideopanelState();
}

class _VideopanelState extends State<Videopanel> {
  TextEditingController tag = TextEditingController();
  bool? loader = false;
  first() {}
  @override
  void initState() {
    super.initState();
  }

  String key = 'd';

  @override
  Widget build(BuildContext context) {
    List l = [];
    final Stream title = FirebaseFirestore.instance
        .collection('Providers')
        .doc('videos')
        .snapshots();
    const player = YoutubePlayerIFrame();

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: loader == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                key: Key(key),
                stream: title,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading');
                  }
                  List l = snapshot.data['list'];

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: size.height * 0.1,
                              width: size.width * 0.30,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  tag.text = value;
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 10.0),
                                    labelText: 'Video Tag',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                                maxLines: 5,
                                minLines: 3,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (tag.text.toString().length > 3) {
                              Map map = {
                                'url': tag.text,
                              };
                              l.add(map.toString());
                              FirebaseFirestore.instance
                                  .collection('Providers')
                                  .doc('videos')
                                  .set({
                                'list': FieldValue.arrayUnion([map]),
                              }, SetOptions(merge: true));
                            } else {
                              var snackBar =
                                  SnackBar(content: Text('check fields'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            setState(() {
                              key = 'sd';
                            });
                          },
                          child: Text(
                            'Add Video',
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: size.height * 0.7,
                          width: size.width * 0.2,
                          child: ListView.builder(
                              itemCount: l.length,
                              controller: ScrollController(),
                              itemBuilder: (context, index) {
                                List<String> le = [];
                                String tk = '${l[index]['url']}';
                                le.add(tk);
                                late YoutubePlayerController _controller;
                                _controller = YoutubePlayerController(
                                  initialVideoId: '${l[index]['url']}',
                                  params: YoutubePlayerParams(
                                    playlist: ['$tk'],
                                    startAt:
                                        const Duration(minutes: 0, seconds: 1),
                                    showControls: true,
                                    showFullscreenButton: true,
                                    desktopMode: false,
                                    privacyEnhanced: true,
                                    useHybridComposition: true,
                                  ),
                                );
                                _controller.onEnterFullscreen = () {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeLeft,
                                    DeviceOrientation.landscapeRight,
                                  ]);
                                  log('Entered Fullscreen');
                                };
                                _controller.onExitFullscreen = () {
                                  log('Exited Fullscreen');
                                };
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('Providers')
                                              .doc('videos')
                                              .set(
                                            {
                                              'list': FieldValue.arrayRemove(
                                                  [l[index]]),
                                            },
                                            SetOptions(merge: true),
                                          );
                                          setState(() {
                                            key = 'sd';
                                          });
                                        },
                                        icon: Icon(Icons.delete),
                                        label: Text('Delete'),
                                      ),
                                      YoutubePlayerControllerProvider(
                                          // Passing controller to widgets below.
                                          controller: _controller,
                                          child: Container(
                                            height: size.height * 0.24,
                                            width: size.width * 0.1,
                                            child: ListView(
                                              children: [
                                                Stack(
                                                  children: [
                                                    player,
                                                    Positioned.fill(
                                                      child:
                                                          YoutubeValueBuilder(
                                                        controller: _controller,
                                                        builder:
                                                            (context, value) {
                                                          return AnimatedCrossFade(
                                                            firstChild:
                                                                const SizedBox
                                                                    .shrink(),
                                                            secondChild:
                                                                Material(
                                                              child:
                                                                  DecoratedBox(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      YoutubePlayerController
                                                                          .getThumbnail(
                                                                        videoId: _controller
                                                                            .params
                                                                            .playlist
                                                                            .first,
                                                                        quality:
                                                                            ThumbnailQuality.medium,
                                                                      ),
                                                                    ),
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              ),
                                                            ),
                                                            crossFadeState: value
                                                                    .isReady
                                                                ? CrossFadeState
                                                                    .showFirst
                                                                : CrossFadeState
                                                                    .showSecond,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // const Controls(),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                                // return Container(
                                //   width: size.width * 0.7,
                                //   height: size.height * 0.4,
                                //   child: Column(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.start,
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       GestureDetector(
                                //           child: Container(
                                //         margin: EdgeInsets.all(5),
                                //         decoration: BoxDecoration(
                                //             border: Border.all(
                                //                 color: Colors.black
                                //                     .withOpacity(0.7)),
                                //             borderRadius:
                                //                 BorderRadius.all(
                                //                     Radius.circular(
                                //                         6))),
                                //         child: ListTile(
                                //           title: Text(
                                //             '${l[index]['companyEN']} \n${l[index]['companyHN']}',
                                //           ),
                                //           trailing: IconButton(
                                //             onPressed: () {
                                //               FirebaseFirestore.instance
                                //                   .collection(
                                //                       'Providers')
                                //                   .doc('companies')
                                //                   .set(
                                //                 {
                                //                   'companies':
                                //                       FieldValue
                                //                           .arrayRemove([
                                //                     l[index]
                                //                   ]),
                                //                 },
                                //                 SetOptions(merge: true),
                                //               );
                                //             },
                                //             icon: Icon(Icons.close),
                                //           ),
                                //         ),
                                //       )),
                                //       Container(
                                //           width: size.width * 0.14,
                                //           height: size.height * 0.2,
                                //           child: "${l[index]['tag']}" ==
                                //                   "null"
                                //               ? InkWell(
                                //                   onTap: () {
                                //                     print(index);
                                //                     setState(() {
                                //                       name = l[index][
                                //                               'companyEN']
                                //                           .toString()
                                //                           .substring(
                                //                               1, 2);
                                //                       items = l[index];
                                //                     });
                                //                     pickPhotoFromGallery();
                                //                   },
                                //                   child: Center(
                                //                       child: Icon(
                                //                     Icons.image_sharp,
                                //                   )),
                                //                 )
                                //               : Image.network(
                                //                   l[index]['icon']))
                                //     ],
                                //   ),
                                // );
                              }),
                        ),
                        // HomePage()
                      ]);
                },
              ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'Ltc4ZzQN_vE',
      params: const YoutubePlayerParams(
        playlist: [
          'Ltc4ZzQN_vE',
          'WhOrIUlrnPo',
          'K18cpp_-gP8',
        ],
        startAt: const Duration(minutes: 0, seconds: 1),
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      log('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    Size size = MediaQuery.of(context).size;
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: _controller,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (kIsWeb && constraints.maxWidth > 800) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: player),
                const SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                      // child: Controls(),
                      ),
                ),
              ],
            );
          }
          return Container(
            height: size.height * 0.36,
            child: ListView(
              children: [
                Stack(
                  children: [
                    player,
                    Positioned.fill(
                      child: YoutubeValueBuilder(
                        controller: _controller,
                        builder: (context, value) {
                          return AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Material(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      YoutubePlayerController.getThumbnail(
                                        videoId:
                                            _controller.params.playlist.first,
                                        quality: ThumbnailQuality.medium,
                                      ),
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            crossFadeState: value.isReady
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // const Controls(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

// ///
// class Controls extends StatelessWidget {
//   ///
//   const Controls();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _space,
//           MetaDataSection(),
//           _space,
//           SourceInputSection(),
//           _space,
//           PlayPauseButtonBar(),
//           _space,
//           VolumeSlider(),
//           _space,
//           PlayerStateSection(),
//         ],
//       ),
//     );
//   }

//   Widget get _space => const SizedBox(height: 10);
// }
