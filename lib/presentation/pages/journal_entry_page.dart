import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../shared/themes/app_theme.dart';
import '../../shared/widgets/date.dart';
import '../../shared/widgets/journalAppBar.dart';
import '../../shared/widgets/custom_scafold.dart';
import '../controllers/journal_controller.dart';
import '../providers/emotions_model.dart';
import 'package:tuple/tuple.dart';
import '../widgets/emotion_selector.dart';


class JournalEntryPage extends StatefulWidget {

  const JournalEntryPage({super.key});

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {

  final _controller = locator<JournalController>();

  TextEditingController titleController = TextEditingController();

  final quill.QuillController _quillController = quill.QuillController.basic();

  final FocusNode _focusNode = FocusNode();

  PickedFile? pickedFile;

  String? imageUrl;

  InterstitialAd? _interstitialAd;

  bool? isLoading = false;


  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
          },
        ),
        request: const AdRequest()
    );
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    EmotionsModel emotionsModel = Provider.of<EmotionsModel>(context);

    return CustomScaffold(
      appBar: const JournalAppBar(title: "Journal Entry"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
            builder: (context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                     isLoading == true ? const Center(
                        child: CircularProgressIndicator()
                      ) : Container(),
                      const Date(),
                      const SizedBox(height: 30.0),
                      Consumer<EmotionsModel>(
                          builder: (context, emotionsModel, child) {
                            return const EmotionSelector();
                          }),
                      const SizedBox(height: 16.0),
                      TextField(
                          controller: titleController,
                          style: AppTheme.titleText,
                          decoration: InputDecoration(
                            hintText: "Title",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Lato',
                            ),
                            filled: true,
                            fillColor: Theme
                                .of(context)
                                .secondaryHeaderColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 16.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .secondary,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          )
                      ),
                      const SizedBox(height: 16.0),
                      _buildWelcomeEditor(context),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, // This makes the BottomAppBar transparent
        elevation: 0, // Removes any shadow
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
              ),
              onPressed: () async {
                configureLoadingStyle();
                EasyLoading.show(status: 'Saving...');
                var contentJson = _quillController.document.toDelta().toJson();  // This gives you the Map<String, dynamic>
                String title = titleController.text;
                _controller.setEmotion(emotionsModel.selectedEmotion);
                await _controller.saveEntry(contentJson, title, imageUrl,emotionsModel).then((
                    value) {
                  configureSuccessStyle();
                  EasyLoading.showSuccess('Saved!');
                  titleController.clear();
                  _quillController.clear();

                }).onError((error, stackTrace) {
                  configureErrorStyle();
                  EasyLoading.showError('Error, Please fill all fields');
                });
                _interstitialAd!.show();
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white,fontFamily: 'Merriweather',),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    Widget quillEditor = quill.QuillEditor(

      controller: _quillController,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: true,
      readOnly: false,
      placeholder: 'Add content',
      expands: false,
      padding: EdgeInsets.zero,
      customStyles: quill.DefaultStyles(
        h1: quill.DefaultTextBlockStyle(
            const TextStyle(
              fontSize: 32,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
           const Tuple2(16,0),
             const Tuple2(0,0),
            null),
        sizeSmall: const TextStyle(fontSize: 9),
      ),
    );

    var toolbar = quill.QuillToolbar.basic(
      controller: _quillController,
      // Default and UI settings
      toolbarIconSize: quill.kDefaultIconSize,
      toolbarSectionSpacing: 4,
      toolbarIconAlignment: WrapAlignment.center,
      showDividers: true,
      multiRowsDisplay: true,
      onImagePickCallback: (file) async {
        setState(() {
          isLoading = true;
        });
        final pickedFile = await _controller.pickImage();
        if (pickedFile?.path != null) {
          var snapshot = await FirebaseStorage.instance.ref('images/${DateTime.now().toIso8601String()}.png').putFile(File(pickedFile!.path));
          // Get the URL of the uploaded image
          String imageURL = await snapshot.ref.getDownloadURL();
          if(!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image picked and uploaded successfully!'))
          );
          setState(() {
            imageUrl = imageURL;
            isLoading = false;
          });
        }
        return null;
      },
      // Disable attributes you don't need
      showAlignmentButtons: true,
      showLeftAlignment: false,
      showCenterAlignment: false,
      showRightAlignment: false,
      showJustifyAlignment: false,
      showHeaderStyle: false,
      showListNumbers: false,
      showListBullets: false,
      showListCheck: false,
      showCodeBlock: false,
      showQuote: false,
      showIndent: false,
      showLink: false,

      showVideoButton: false,
      showFormulaButton: false,
      showCameraButton: false,
      showDirection: false,
      showSearchButton: false,

      showBoldButton: true,
      showUnderLineButton: true,
      showColorButton: true,
      showUndo: true,
      showRedo: true,
      showImageButton: true,

    );
    return SafeArea(
      child: Column(
        children: [
           toolbar,
          Container(
            height: 300,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              // shadowed border
              borderRadius: BorderRadius.circular(10.0), // rounded corner
            ),
            child: quillEditor,
          ),
        ],
      ),
    );
  }

}
