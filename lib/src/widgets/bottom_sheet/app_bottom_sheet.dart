// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class AppBottomSheetProps {
  final String title;
  final Widget body;
  final double? initialChildSize;
  final double? minChildSize;
  final double? maxChildSize;
  final Widget? bottom;
  final bool hasAnnouce;
  final double sizeReduce;
  final ValueNotifier<bool>? isShowBottom;

  AppBottomSheetProps({
    required this.title,
    required this.body,
    this.initialChildSize,
    this.maxChildSize,
    this.minChildSize,
    this.bottom,
    this.hasAnnouce = false,
    this.sizeReduce = 60,
    this.isShowBottom,
  });
}

class AppBottomSheet extends StatelessWidget {
  final AppBottomSheetProps props;

  const AppBottomSheet({
    Key? key,
    required this.props,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
            initialChildSize:
                props.initialChildSize ?? (size.height - props.sizeReduce) / size.height, // ขนาดแสดงเริ่มต้น 50%
            minChildSize: props.minChildSize ?? 0.25, // ปรับขนาดน้อยสุด 25% น้อยกว่านี้จะเป็นการปิด
            maxChildSize: (size.height - props.sizeReduce) / size.height, // ขยายสูงสุดแค่ 90%
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                height: props.maxChildSize ?? 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: CustomScrollView(
                  controller: scrollController, // ใช้งาน controller
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: true,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 5, // Set the height of the drag handle here
                                    width: 63, // Set the width of the drag handle here
                                    margin: const EdgeInsets.symmetric(vertical: 14), // Adjust as needed
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  Text(
                                    props.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.grey,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (props.isShowBottom != null)
                            ValueListenableBuilder(
                              valueListenable: props.isShowBottom!,
                              builder: (context, value, child) {
                                if (value) {
                                  return Container(
                                    height: double.infinity,
                                    margin: const EdgeInsets.only(top: 16),
                                    padding: EdgeInsets.only(
                                        bottom: value && props.hasAnnouce
                                            ? 120
                                            : value
                                                ? 80
                                                : props.hasAnnouce
                                                    ? 20
                                                    : 0,
                                        top: 32),
                                    child: props.body,
                                  );
                                }

                                return child ?? Container();
                              },
                              child: Container(
                                height: double.infinity,
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.only(bottom: 0, top: 32),
                                child: props.body,
                              ),
                            ),
                          if (props.isShowBottom == null)
                            Container(
                              height: double.infinity,
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.only(bottom: 0, top: 32),
                              child: props.body,
                            ),
                          if (props.bottom != null)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(color: Colors.white, child: SafeArea(child: props.bottom!)),
                            ),
                        ],
                      ),
                    ),
                    // SliverFixedExtentList(
                    //   itemExtent: 50.0,
                    //   delegate: SliverChildBuilderDelegate(
                    //     (BuildContext context, int index) {
                    //       return Container(
                    //         alignment: Alignment.center,
                    //         color: Colors.lightBlue[100 * (index % 9)],
                    //         child: SafeArea(child: props.bottom!),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // if (props.bottom != null)
                    //   SliverFillRemaining(
                    //     hasScrollBody: false,
                    //     fillOverscroll: true,
                    //     child: SafeArea(child: props.bottom!),
                    //   ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

// class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;

//   StickyHeaderDelegate({required this.child});

//   @override
//   double get minExtent => 0;

//   @override
//   double get maxExtent => 100; // Adjust this value according to your needs

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return child;
//   }

//   @override
//   bool shouldRebuild(covariant StickyHeaderDelegate oldDelegate) {
//     return child != oldDelegate.child;
//   }
// }

// SliverPersistentHeader(
//   pinned: true,
//   delegate: _StickyHeaderDelegate(
//     child: Container(
//       alignment: Alignment.center,
//       color: Colors.blue,
//       padding: const EdgeInsets.all(20),
//       child: const Text(
//         'Heading',
//         style: TextStyle(color: Colors.white),
//       ),
//     ),
//   ),
// ),
// SliverList(
//   delegate: SliverChildBuilderDelegate(
//     (BuildContext context, int index) {
//       return ListTile(
//         leading: Text((index + 5).toString()),
//       );
//     },
//     childCount: 20,
//   ),
// ),
