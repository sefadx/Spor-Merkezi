import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.mahalleAdi,
    required this.ada,
    required this.parsel,
    this.backgroundColor,
    this.onTap,
  });

  final String mahalleAdi, ada, parsel;
  final Color? backgroundColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              color: backgroundColor ?? Colors.black26,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(mahalleAdi, style: const TextStyle(color: Colors.black)),
              Text("$ada/$parsel", style: const TextStyle(color: Colors.black))
            ],
          ),
        ),
      ),
    );
  }
}
