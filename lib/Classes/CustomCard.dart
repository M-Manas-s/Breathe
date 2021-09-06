import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final double inkwellRadius;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool shadow;
  final BoxShadow boxShadow;
  final Function onTap;

  CustomCard(
      {@required this.child,
        this.color = const Color(0xFF282B4E),
        this.radius,
        this.borderRadius,
        this.padding,
        this.margin,
      this.shadow = false,
      this.boxShadow, this.inkwellRadius, this.onTap });

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
        margin: margin == null ? EdgeInsets.only(top: 5, bottom: 5) : margin,
        decoration: BoxDecoration(
          color: color,

          borderRadius: this.radius==null ?
          (borderRadius == null ? BorderRadius.all(Radius.circular(0.0)) : borderRadius)
              : BorderRadius.all(Radius.circular(radius)),

          boxShadow: shadow ? [
            boxShadow == null ? BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3),
            ) : boxShadow,
          ] : null,
        ),
        child: Container(

          child: InkWell(
            borderRadius: radius == null ? BorderRadius.circular(inkwellRadius == null ? 0.0 : inkwellRadius ) : BorderRadius.circular(radius),
            splashColor: Color(0xFF1E7777).withAlpha(30),
            onTap: () {},
            child: Container(
              padding: padding == null
                  ? EdgeInsets.fromLTRB(
                  query.width * (1 / 20),
                  query.width * (1 / 40),
                  query.width * (1 / 20),
                  query.width * (1 / 40))
                  : padding,
              child: Center(child: child),
            ),
          ),
        ));
  }
}
