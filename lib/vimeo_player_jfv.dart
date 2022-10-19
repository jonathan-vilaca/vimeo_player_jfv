library vimeo_player_jfv;

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VimeoPlayerUrl extends StatefulWidget {
  final String url;
  final double? progress;
  const VimeoPlayerUrl({
    Key? key,
    required this.url,
    this.progress,
  }) : super(key: key);

  @override
  State<VimeoPlayerUrl> createState() => _VimeoPlayerUrlState();
}

class _VimeoPlayerUrlState extends State<VimeoPlayerUrl> {
  bool _loading = true;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: true,
    ),
    android: AndroidInAppWebViewOptions(
      useWideViewPort: false,
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      enableViewportScale: false,
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * .9,
        height: size.width * .52,
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.dataFromString(
                  '''<html><body>
                    <div data-vimeo-url=${widget.url} data-vimeo-defer id="divVideo"></div>
                    <script src="https://player.vimeo.com/api/player.js"></script>
                    <script>
                      const options = {
                          responsive: true,
                          autoplay: false,
                          maxwidth: ${size.width}
                      };

                      const player = new Vimeo.Player('divVideo', options);
                    </script>
                      </body></html>''',
                  mimeType: 'text/html',
                ),
              ),
              onWebViewCreated: (controller) {
                debugPrint('CREATE');
                Future.delayed(const Duration(milliseconds: 1500), () {
                  setState(() {
                    _loading = false;
                  });
                });
                webViewController = controller;
                webViewController!.addUserScripts(userScripts: [
                  UserScript(
                    source: '''
                      player.setCurrentTime(${widget.progress ?? 0}).then(function(seconds) {
                          // seconds = the actual time that the player seeked to
                      });
                    ''',
                    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                  ),
                  UserScript(
                    source: '''
                      player.on('play', function() {
                          console.log('played the video!');
                      });
                    ''',
                    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                  ),
                  UserScript(
                    source: '''
                      player.on('timeupdate', function(time) {
                        console.log('timeupdate: '+ time);
                        window.flutter_inappwebview.callHandler('timeCurrent', time);
                      });
                    ''',
                    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                  ),
                ]);
                webViewController!.addJavaScriptHandler(
                  handlerName: "timeCurrent",
                  callback: (args) {
                    debugPrint('timeupdate: ' + args[0].toString());
                    // widget.setProgress!(args[0]);
                  },
                );
              },
            ),
            _loading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Stack()
          ],
        ),
      ),
    );
  }
}
