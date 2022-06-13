import 'package:flutter/material.dart';

class GenLoginSignupHeader extends StatelessWidget {
  const GenLoginSignupHeader({required this.headerName});

  final String headerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        Text(
          headerName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
        ),
        const SizedBox(height: 10.0),
        Image.asset(
          'assets/images/logo.png',
          scale: 3.0,
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
