import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final String text;
  final Function onPressed; // Pe

  const BotonAzul({
    super.key,
    required this.text,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
        onPressed: () => onPressed(),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text( text , style: const TextStyle( color: Colors.white, fontSize: 17 )),
          ),
        ),
    );
  }

}