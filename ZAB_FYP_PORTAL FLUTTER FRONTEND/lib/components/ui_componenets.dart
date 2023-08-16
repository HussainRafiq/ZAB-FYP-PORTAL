import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:skeletons/skeletons.dart';

import '../utils/responsive.dart';

class Loading extends StatefulWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}

class ConnectionFailedUI extends StatelessWidget {
  final VoidCallback? onReload;
  const ConnectionFailedUI({
    Key? key,
    this.onReload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: Colors.grey[400],
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "NO CONNECTION",
              style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  fontWeight: FontWeight.bold),
            ),
            Text(CHECK_NETWORK_CONNECTIVITY),
            SizedBox(
              height: 15,
            ),
            this.onReload != null
                ? MaterialButton(
                    onPressed: onReload,
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    child: Container(
                        child: Text(
                      "Retry",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    )),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class TextLogoWidget extends StatelessWidget {
  const TextLogoWidget({
    Key? key,
    required this.context,
    required this.productName,
    this.backColor,
    this.textColor,
  }) : super(key: key);

  final BuildContext context;
  final String productName;

  final Color? backColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var short = productName.split(" ").map((k) => k.isNotEmpty ? k[0] : "");
    return Container(
      color: backColor == null
          ? Theme.of(context).colorScheme.primary
          : backColor!,
      alignment: Alignment.center,
      child: Text(
        short.join(" ").toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: textColor == null
                ? Theme.of(context).colorScheme.onPrimary
                : textColor!),
      ),
    );
  }
}

class SkeletonLoadingContent extends StatelessWidget {
  const SkeletonLoadingContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        3,
        (index) => SkeletonListTile(
          hasLeading: false,
          hasSubtitle: true,
          verticalSpacing: 3,
        ),
      ),
    );
  }
}

class SkeletonLoadingListTile extends StatelessWidget {
  const SkeletonLoadingListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        6,
        (index) => SkeletonListTile(
          hasSubtitle: true,
          padding: EdgeInsets.all(16),
          trailing: SkeletonAvatar(
            style: SkeletonAvatarStyle(
                height: 32,
                width: 50,
                borderRadius: BorderRadius.circular(4),
                padding: EdgeInsetsDirectional.only(start: 16)),
          ),
        ),
      ),
    );
  }
}

class SkeletonLoadingDetail extends StatelessWidget {
  const SkeletonLoadingDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // padding: padding,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: SkeletonItem(
              child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      SkeletonAvatar(
                          style: SkeletonAvatarStyle(width: 72, height: 30)),
                      SizedBox(width: 15),
                      SkeletonAvatar(
                          style: SkeletonAvatarStyle(width: 72, height: 30)),
                      SizedBox(width: 15),
                      SkeletonAvatar(
                          style: SkeletonAvatarStyle(width: 72, height: 30)),
                      SizedBox(width: 15),
                    ],
                  ),
                  SkeletonAvatar(
                      style: SkeletonAvatarStyle(width: 72, height: 30)),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Column(
                children: List.generate(
                    6,
                    (index) => Padding(
                          padding: EdgeInsets.all(5),
                          child: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                width: double.infinity,
                                height: 40,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        )),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

AppBar CustomAppBar(BuildContext context, String title) {
  return AppBar(
    centerTitle: true,
    shape: RoundedRectangleBorder(),
    backgroundColor: Theme.of(context).colorScheme.primary,
    title: Responsive.isDesktop(context)
        ? SizedBox(
            height: 40,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.fitHeight,
              colorBlendMode: BlendMode.colorBurn,
              color: Colors.white,
            ),
          )
        : Text(
            "$title",
            style: TextStyle(fontSize: 18, fontFamily: "Circular Std"),
          ),
  );
}
