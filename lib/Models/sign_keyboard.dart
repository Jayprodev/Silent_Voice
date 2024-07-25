import 'package:flutter/material.dart';

class SignKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;

  SignKeyboard({required this.onKeyPressed});

  final List<Map<String, String>> _letters = [
    {'letter': 'a', 'image': 'lib/assets/Letter A.png'},
    {'letter': 'b', 'image': 'lib/assets/Letter B.png'},
    {'letter': 'c', 'image': 'lib/assets/Letter C.png'},
    {'letter': 'd', 'image': 'lib/assets/Letter D.png'},
    {'letter': 'e', 'image': 'lib/assets/Letter E.png'},
    {'letter': 'f', 'image': 'lib/assets/Letter F.png'},
    {'letter': 'g', 'image': 'lib/assets/Letter G.png'},
    {'letter': 'h', 'image': 'lib/assets/Letter H.png'},
    {'letter': 'i', 'image': 'lib/assets/Letter I.png'},
    {'letter': 'j', 'image': 'lib/assets/Letter J.png'},
    {'letter': 'k', 'image': 'lib/assets/Letter K.png'},
    {'letter': 'l', 'image': 'lib/assets/Letter L.png'},
    {'letter': 'm', 'image': 'lib/assets/Letter M.png'},
    {'letter': 'n', 'image': 'lib/assets/Letter N.png'},
    {'letter': 'o', 'image': 'lib/assets/Letter O.png'},
    {'letter': 'p', 'image': 'lib/assets/Letter P.png'},
    {'letter': 'q', 'image': 'lib/assets/Letter Q.png'},
    {'letter': 'r', 'image': 'lib/assets/Letter R.png'},
    {'letter': 's', 'image': 'lib/assets/Letter S.png'},
    {'letter': 't', 'image': 'lib/assets/Letter T.png'},
    {'letter': 'u', 'image': 'lib/assets/Letter U.png'},
    {'letter': 'v', 'image': 'lib/assets/Lettter V.png'},
    {'letter': 'w', 'image': 'lib/assets/Letter W.png'},
    {'letter': 'x', 'image': 'lib/assets/Letter X.png'},
    {'letter': 'y', 'image': 'lib/assets/Letter Y.jpg'},
    {'letter': 'z', 'image': 'lib/assets/Letter Z.png'},
  ];

  final List<Map<String, String>> _numbers = [
    {'letter': '0', 'image': 'lib/assets/Number 0.png'},
    {'letter': '1', 'image': 'lib/assets/Number 1.png'},
    {'letter': '2', 'image': 'lib/assets/Number 2.png'},
    {'letter': '3', 'image': 'lib/assets/Number 3.png'},
    {'letter': '4', 'image': 'lib/assets/Number 4.png'},
    {'letter': '5', 'image': 'lib/assets/Number 5.png'},
    {'letter': '6', 'image': 'lib/assets/Number 6.png'},
    {'letter': '7', 'image': 'lib/assets/Number 7.png'},
    {'letter': '8', 'image': 'lib/assets/Number 8.png'},
    {'letter': '9', 'image': 'lib/assets/Number 9.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            "A-Z",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              childAspectRatio: 1,
            ),
            itemCount: _letters.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onKeyPressed(_letters[index]['letter']!);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    _letters[index]['image']!,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        const Divider(
          color: Colors.black,
          thickness: 2,
        ),
        const Center(
          child: Text(
            "0-9",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              childAspectRatio: 1,
            ),
            itemCount: _numbers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onKeyPressed(_numbers[index]['letter']!);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    _numbers[index]['image']!,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
