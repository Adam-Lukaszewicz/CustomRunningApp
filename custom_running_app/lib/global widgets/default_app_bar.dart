import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String text;
  const DefaultAppBar(this.text, {super.key});

  @override

  Widget build(BuildContext context){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      foregroundColor: Colors.white,
      centerTitle: true,
      title: Text(text),
    );
  }
  
  @override
  Size get preferredSize => AppBar().preferredSize;
}