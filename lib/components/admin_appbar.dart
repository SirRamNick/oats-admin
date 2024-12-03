import 'package:flutter/material.dart';

AppBar adminAppBar(BuildContext context, {bool displayHeader = true}) => AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Admin Site",
          ),
          displayHeader == true 
          ? Image.network(
            'https://lh3.googleusercontent.com/d/1Pvw1263aRn8HeUPDy1IWAvNyuZ6lMpGA',
            cacheWidth: 176,
            cacheHeight: 56,
          )
          : const SizedBox(),
        ],
      ),
    );
