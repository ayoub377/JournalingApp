import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/themes/app_theme.dart';
import '../providers/emotions_model.dart';
import '../providers/journal_history_model.dart';

class HistoryAppBar extends StatefulWidget {

  const HistoryAppBar({Key? key}) : super(key: key);

  @override
  State<HistoryAppBar> createState() => _HistoryAppBarState();
}

class _HistoryAppBarState extends State<HistoryAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalHistoryModel>(
      builder: (context, model, child) {
        return SliverAppBar(
          floating: true,
          pinned: true,
          backgroundColor: Colors.transparent, // Transparent AppBar
          elevation: 0, // No shadow
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     if(model.searchedEntries.isNotEmpty || model.filteredEntries.isNotEmpty)
                         ElevatedButton.icon(
                           icon: const Icon(Icons.refresh, color: Colors.white),
                           label: const Text("Show All", style: TextStyle(color: Colors.white)),
                           onPressed: () {
                             _searchController.clear();
                             model.clearSearch();
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: AppTheme.iconColor,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20),
                             ),
                           ),
                         ),
                     Padding(
                       padding: const EdgeInsets.only(top: 10.0),
                       child: SizedBox(
                         height: 40,
                         child: AnimSearchBar(
                           rtl: true,
                          width: model.searchedEntries.isEmpty ? MediaQuery.of(context).size.width-100 : MediaQuery.of(context).size.width-200,
                          textController: _searchController,
                          onSuffixTap: () {
                            _searchController.clear();
                            model.toggleSearch();
                          },
                          helpText: "Search by title or content",
                          suffixIcon: const Icon(Icons.close),
                         onSubmitted: (value)
                           {
                               model.search(value);
                           },
                         ),
                       ),
                     ),
                   ],
                 ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.sort,
                color: Colors.white,
              ),
              onSelected: (value) {
                if (value == "Date") {
                  _showDatePickerDialog(context);
                } else if (value == "Emotion") {
                  _showEmotionsFilterDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                 const PopupMenuItem<String>(
                  value: "Date",
                  child: Text('Sort by Date'),

                ),
                const PopupMenuItem<String>(
                  value: "Emotion",
                  child: Text('Sort by Emotion'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDatePickerDialog(BuildContext context) {
    final model = Provider.of<JournalHistoryModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final config = CalendarDatePicker2Config(
            selectedDayHighlightColor: Colors.amber[900],
            weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
            weekdayLabelTextStyle: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )
        );
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Text('Select a date:', style: TextStyle(fontSize: 20)),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CalendarDatePicker2(
                    config: config,
                    value: [DateTime.now()],
                    onValueChanged: (dates) {
                      model.setPickedDate(dates);
                      model.filterByDate(dates[0]!);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 25),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // You can add more buttons if needed
          ],
        );
      },
    );
  }

  void _showEmotionsFilterDialog(BuildContext context) {

    final emotionsModel = Provider.of<EmotionsModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Consumer<JournalHistoryModel>(
              builder: (context, model, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Filter By your emotion:', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    ...emotionsModel.emotions.map((emotion) => CheckboxListTile(
                      title: Text(emotion.name),
                      secondary: Text(emotion.emoji, style: const TextStyle(fontSize: 24)),
                      value: model.selectedEmotion == emotion.name,
                      onChanged: (bool? value) {
                        if(value == true) {
                          model.selectedEmotion = emotion.name;
                          model.filterByEmotions(emotion.name);
                        } else{
                          model.selectedEmotion = null;
                        }
                      },
                    )),
                    const SizedBox(height: 25),
                  ],
                );
              }
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // You can add more buttons if needed
          ],
        );
      },
    );
  }

}


