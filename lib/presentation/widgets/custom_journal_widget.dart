import 'package:emotions_journaling/domain/entities/journal_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../shared/utils/journal_utils.dart';
import '../pages/journal_detail_page.dart';
import '../providers/theme_model.dart';

Widget customJournalTile(JournalEntry entry,BuildContext context) {
  final themeModel = Provider.of<ThemeModel>(context);
  return Container(
    margin: const EdgeInsets.only(bottom: 16.0), // spacing between tiles
    decoration: BoxDecoration(
      color: themeModel.isDarkTheme ? Colors.grey[900] : Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(10.0), // rounded corner
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            DateFormat.yMMMMd().format(entry.createdAt!), // "September 17, 2023"
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: themeModel.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        const Divider(color: Colors.grey), // the horizontal line
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    JournalUtils.getEmojiForEmotion(entry.emotion),  // emoji emotion
                    style: TextStyle(fontSize: 24, color: themeModel.isDarkTheme ? Colors.white : Colors.black),
                  ),
                  const SizedBox(width: 8), // spacing between emoji and text
                  Text(
                    JournalUtils.getSnippet(entry.content[0]["insert"],25), // Journal text
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: themeModel.isDarkTheme ? Colors.white : Colors.black),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> JournalDetails(entry: entry,)));
                },
                child: Text(
                  "View ➔",
                  style: TextStyle(color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
