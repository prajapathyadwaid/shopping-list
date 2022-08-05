import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTiles extends StatefulWidget {
  final String name;

  const CustomTiles(this.name, {Key? key}) : super(key: key);
  @override
  State<CustomTiles> createState() => _CustomTilesState();
}

class _CustomTilesState extends State<CustomTiles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.name,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
