import 'package:flutter/material.dart';

class LoaderBase extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const LoaderBase({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  _LoaderBaseState createState() => _LoaderBaseState();
}

class _LoaderBaseState extends State<LoaderBase>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.isLoading
          //     ? AnimatedBuilder(
          //   animation: _controller,
          //   builder: (context, child) {
          //     return Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Stack(
          //           alignment: Alignment.center,
          //           children: [
          //             Transform.rotate(
          //               angle: _rotationAnimation.value * 2.0 * 3.1415927,
          //               child: Container(
          //                 width: 50,
          //                 height: 50,
          //                 decoration: BoxDecoration(
          //                   color: Theme.of(context).primaryColor.withOpacity(0.5),
          //                 ),
          //               ),
          //             ),
          //             Transform.rotate(
          //               angle: -_rotationAnimation.value * 2.0 * 3.1415927,
          //               child: Container(
          //                 width: 50,
          //                 height: 50,
          //                 decoration: BoxDecoration(
          //                   color: Theme.of(context).primaryColor.withOpacity(0.5),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //         // SizedBox(height: 12),
          //         // TitleText(title: 'ehh- it\'s loading.'),
          //       ],
          //     );
          //   },
          // )
          ? Padding(
            padding: EdgeInsets.all(5.0),
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
            ),
          )
          : widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
