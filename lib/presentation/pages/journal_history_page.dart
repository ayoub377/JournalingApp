import 'package:emotions_journaling/shared/widgets/custom_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/themes/app_theme.dart';
import '../providers/journal_history_model.dart';
import '../providers/theme_model.dart';
import '../widgets/custom_journal_widget.dart';
import '../widgets/history_page_custom_app_bar.dart';
import 'main_navigation_page.dart';


class JournalHistoryPage extends StatelessWidget {
  const JournalHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    JournalHistoryModel model = Provider.of<JournalHistoryModel>(context);
    final themeModel = Provider.of<ThemeModel>(context);

    return CustomScaffold(
      body: model.searchedEntries.isNotEmpty ?  Consumer<JournalHistoryModel>(builder: (context, model, child) {
        return CustomScrollView(
          slivers: [
            const HistoryAppBar(),
            const SliverPadding(
              padding: EdgeInsets.only(top: 20.0),
              sliver:SliverToBoxAdapter(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Dismissible(
                    key: Key(model.searchedEntries[index].createdAt!.second.toString()),
                    onDismissed: (direction) {
                      model.removeEntryAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Journal entry deleted",style: TextStyle( color: themeModel.isDarkTheme ? Colors.white : Colors.black),),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Theme.of(context).secondaryHeaderColor,
                        ),
                      );
                    },
                    background: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        color: Theme.of(context).errorColor, // Muted rose
                        child: Icon(Icons.delete, color: themeModel.isDarkTheme ? Colors.white : Colors.black)
                    ),
                    child: Consumer<ThemeModel>(
                        builder: (context,child,themeModel) {
                          return customJournalTile(model.searchedEntries[index],context);
                        }
                    ),
                  );
                },
                childCount: model.searchedEntries.length,
              ),
            ),
          ],
        );
      },)  :   model.searchedEntries.isEmpty && model.isSearching == true ? Consumer<JournalHistoryModel>(builder: (context, model, child) {
        return RefreshIndicator(
          onRefresh: () =>model.clearFilter(),
          child: const CustomScrollView(
              slivers: [
                HistoryAppBar(),
                SliverToBoxAdapter(child: Center(child: Text("No entries found"),))
              ]),
        );}) :  model.filteredEntries.isNotEmpty ? Consumer<JournalHistoryModel>(builder: (context, model, child) {
        return RefreshIndicator(
          onRefresh: () =>model.clearFilter(),
          child: CustomScrollView(
            slivers: [
              const HistoryAppBar(),
              const SliverPadding(
                padding: EdgeInsets.only(top: 20.0),
                sliver:SliverToBoxAdapter(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Dismissible(
                      key: Key(model.filteredEntries[index].createdAt!.second.toString()),
                      onDismissed: (direction) {
                        model.removeEntryAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Journal entry deleted",style: TextStyle( color: themeModel.isDarkTheme ? Colors.white : Colors.black),),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Theme.of(context).secondaryHeaderColor,
                          ),
                        );
                      },
                      background: Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          color: Theme.of(context).errorColor, // Muted rose
                          child: Icon(Icons.delete, color: themeModel.isDarkTheme ? Colors.white : Colors.black)
                      ),
                      child: Consumer<ThemeModel>(
                          builder: (context,child,themeModel) {
                            return customJournalTile(model.filteredEntries[index],context);
                          }
                      ),
                    );
                  },
                  childCount: model.filteredEntries.length,
                ),
              ),
            ],
          ),
        );
      },) : model.filteredEntries.isEmpty && model.isFiltered == true ? Consumer<JournalHistoryModel>(builder: (context, model, child) {
    return RefreshIndicator(
      onRefresh: () =>model.clearFilter(),
      child: const CustomScrollView(
      slivers: [
        HistoryAppBar(),
        SliverToBoxAdapter(child: Center(child: Text("No entries found"),))
      ]),
    );}) : FutureBuilder(
        future: model.loadEntries(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), // Soft muted teal
              ),
            );
          }
          else if (model.errorMessage != null) {
            return Center(
              child: Text(
                model.errorMessage!,
                style: TextStyle(
                  fontFamily: 'Lato', // Using the Lato font
                  color: Theme.of(context).errorColor, // Muted rose
                ),
              ),
            );
          }
          else {
            return Consumer<JournalHistoryModel>(
              builder: (context, model, child) {
                return CustomScrollView(
                  slivers: [
                    Consumer<ThemeModel>(
                      builder: (context,themeModel,child) {
                        return const HistoryAppBar();
                      }
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 50.0),
                      sliver:SliverToBoxAdapter(),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return Dismissible(
                            key: Key(model.entries[index].createdAt!.second.toString()),
                            onDismissed: (direction) {
                              model.removeEntryAt(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Journal entry deleted",style: TextStyle(fontFamily: 'Lato',color: themeModel.isDarkTheme ? Colors.white : Colors.black ),),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                                ),
                              );
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(bottom: 16.0),
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              color: Theme.of(context).errorColor, // Muted rose
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: customJournalTile(model.entries[index],context),
                          );
                        },
                        childCount: model.entries.length,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigationPage()));
        },
        backgroundColor: AppTheme.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
