import 'package:flutter/material.dart';

AppBar adminAppBar(BuildContext context) => AppBar(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Admin Site",
          ),
          Text(
            "OLOPSC Alumni Tracking System (OATS)",
          ),
        ],
      ),
    );
