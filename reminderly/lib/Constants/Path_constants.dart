import 'package:flutter/cupertino.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';

class Clipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 896;
    path.lineTo(415 * _xScaling, 1 * _yScaling);
    path.cubicTo(
      415 * _xScaling,
      1 * _yScaling,
      398 * _xScaling,
      254 * _yScaling,
      204 * _xScaling,
      152 * _yScaling,
    );
    path.cubicTo(
      10 * _xScaling,
      50 * _yScaling,
      1 * _xScaling,
      284 * _yScaling,
      1 * _xScaling,
      284 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class TopClipPath extends StatelessWidget {
  final double height;
  final Color clr;
  final CustomClipper custClip;
  TopClipPath(this.height, this.clr, this.custClip);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: clr,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 30))
          ],
          color: kBLue.withOpacity(0.2),
        ),
      ),
      clipper: custClip as CustomClipper<Path>,
    );
  }
}

class BottomClipPath extends StatelessWidget {
  final double height;
  final Color clr;
  final CustomClipper custClip;
  BottomClipPath(this.height, this.clr, this.custClip);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(width: double.infinity, color: clr, height: height),
      clipper: custClip as CustomClipper<Path>,
    );
  }
}

class BottomLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 375;
    final double _yScaling = size.height / 812;
    path.lineTo(-85.8912 * _xScaling, 289.388 * _yScaling);
    path.cubicTo(
      -34.0201 * _xScaling,
      277.413 * _yScaling,
      11.0669 * _xScaling,
      238.676 * _yScaling,
      66.5766 * _xScaling,
      249.544 * _yScaling,
    );
    path.cubicTo(
      122.119 * _xScaling,
      260.418 * _yScaling,
      168.648 * _xScaling,
      312.375 * _yScaling,
      218.439 * _xScaling,
      348.97 * _yScaling,
    );
    path.cubicTo(
      267.351 * _xScaling,
      384.919 * _yScaling,
      324.885 * _xScaling,
      410.894 * _yScaling,
      358.91 * _xScaling,
      464.401 * _yScaling,
    );
    path.cubicTo(
      392.814 * _xScaling,
      517.716 * _yScaling,
      393.723 * _xScaling,
      582.808 * _yScaling,
      405.784 * _xScaling,
      643.579 * _yScaling,
    );
    path.cubicTo(
      417.205 * _xScaling,
      701.128 * _yScaling,
      430.011 * _xScaling,
      758.078 * _yScaling,
      428.401 * _xScaling,
      814.544 * _yScaling,
    );
    path.cubicTo(
      426.713 * _xScaling,
      873.733 * _yScaling,
      424.117 * _xScaling,
      935.854 * _yScaling,
      396.149 * _xScaling,
      981.472 * _yScaling,
    );
    path.cubicTo(
      368.2 * _xScaling,
      1027.06 * _yScaling,
      314.161 * _xScaling,
      1040.22 * _yScaling,
      272.099 * _xScaling,
      1069.49 * _yScaling,
    );
    path.cubicTo(
      227.569 * _xScaling,
      1100.47 * _yScaling,
      195.369 * _xScaling,
      1159.46 * _yScaling,
      139.219 * _xScaling,
      1160.24 * _yScaling,
    );
    path.cubicTo(
      82.9956 * _xScaling,
      1161.02 * _yScaling,
      31.44 * _xScaling,
      1104.24 * _yScaling,
      -22.6558 * _xScaling,
      1073.57 * _yScaling,
    );
    path.cubicTo(
      -72.2668 * _xScaling,
      1045.45 * _yScaling,
      -122.625 * _xScaling,
      1022.77 * _yScaling,
      -168.39 * _xScaling,
      985.865 * _yScaling,
    );
    path.cubicTo(
      -217.948 * _xScaling,
      945.903 * _yScaling,
      -275.289 * _xScaling,
      908.069 * _yScaling,
      -302.481 * _xScaling,
      847.928 * _yScaling,
    );
    path.cubicTo(
      -329.673 * _xScaling,
      787.785 * _yScaling,
      -312.924 * _xScaling,
      723.222 * _yScaling,
      -315.664 * _xScaling,
      660.137 * _yScaling,
    );
    path.cubicTo(
      -318.316 * _xScaling,
      599.081 * _yScaling,
      -330.1 * _xScaling,
      536.794 * _yScaling,
      -318.471 * _xScaling,
      479.749 * _yScaling,
    );
    path.cubicTo(
      -306.26 * _xScaling,
      419.851 * _yScaling,
      -289.302 * _xScaling,
      356.733 * _yScaling,
      -246.707 * _xScaling,
      321.87 * _yScaling,
    );
    path.cubicTo(
      -204.252 * _xScaling,
      287.122 * _yScaling,
      -139.631 * _xScaling,
      301.795 * _yScaling,
      -85.8912 * _xScaling,
      289.388 * _yScaling,
    );
    path.cubicTo(
      -85.8912 * _xScaling,
      289.388 * _yScaling,
      -85.8912 * _xScaling,
      289.388 * _yScaling,
      -85.8912 * _xScaling,
      289.388 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class DummyPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 896;
    path.lineTo(289 * _xScaling, 521 * _yScaling);
    path.cubicTo(
      273 * _xScaling,
      396 * _yScaling,
      531 * _xScaling,
      349 * _yScaling,
      531 * _xScaling,
      349 * _yScaling,
    );
    path.cubicTo(
      531 * _xScaling,
      349 * _yScaling,
      531 * _xScaling,
      1 * _yScaling,
      531 * _xScaling,
      1 * _yScaling,
    );
    path.cubicTo(
      531 * _xScaling,
      1 * _yScaling,
      239 * _xScaling,
      43 * _yScaling,
      240 * _xScaling,
      210 * _yScaling,
    );
    path.cubicTo(
      241 * _xScaling,
      377 * _yScaling,
      1 * _xScaling,
      371 * _yScaling,
      1 * _xScaling,
      371 * _yScaling,
    );
    path.cubicTo(
      1 * _xScaling,
      371 * _yScaling,
      1 * _xScaling,
      711 * _yScaling,
      1 * _xScaling,
      711 * _yScaling,
    );
    path.cubicTo(
      1 * _xScaling,
      711 * _yScaling,
      305 * _xScaling,
      646 * _yScaling,
      289 * _xScaling,
      521 * _yScaling,
    );
    path.cubicTo(
      289 * _xScaling,
      521 * _yScaling,
      289 * _xScaling,
      521 * _yScaling,
      289 * _xScaling,
      521 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class MiddleCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 896;
    path.lineTo(443 * _xScaling, 1 * _yScaling);
    path.cubicTo(
      443 * _xScaling,
      1 * _yScaling,
      449 * _xScaling,
      388 * _yScaling,
      215 * _xScaling,
      222 * _yScaling,
    );
    path.cubicTo(
      -19 * _xScaling,
      56 * _yScaling,
      0.999963 * _xScaling,
      466 * _yScaling,
      0.999963 * _xScaling,
      466 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
