import 'dart:io';

import 'package:bookque/data/models/categories.dart';
import 'package:bookque/presentation/pages/upload/select_category.dart';
import 'package:bookque/presentation/provider/account_provider.dart';
import 'package:bookque/presentation/provider/upload_provider.dart';
import 'package:bookque/presentation/widgets/scroll_behavior_without_glow.dart';
import 'package:bookque/presentation/widgets/upload/type_upload.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';

import '../../../common/localizations.dart';
import '../../../common/styles.dart';
import '../../../data/items.dart';
import '../../../data/models/full_items.dart';
import '../../widgets/custom/full_button.dart';
import '../../widgets/custom/text_input.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/upload/choose_categories.dart';
import '../../widgets/upload/image_picker.dart';
import '../../widgets/upload/list_categories_selected.dart';

class Upload extends StatelessWidget {
  Upload({Key? key, this.items, this.isUpdateModule = false}) : super(key: key);
  final FullItems? items;
  final bool isUpdateModule;

  TextEditingController url = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController desc = TextEditingController();

  GroupButtonController type = GroupButtonController()..selectIndex((1));

  // final CategoriesSelectCount count = CategoriesSelectCount(items: []);

  @override
  Widget build(BuildContext context) {
    List<String>? buffer;
    if (items != null) {
      buffer = items!.categories;
      url.text = items!.url;
      title.text = items!.title;
      nama.text = items!.author;
      desc.text = items!.longdesc;

      /// if type and categories want to change
      buffer.removeAt(0);
      context.read<UploadUpdateItemProvider>().itemCat.items.addAll(buffer);
    }

    return CustomScaffold(
      title: AppLocalizations.of(context)!.appBarUploadText,
      child: ScrollConfiguration(
        behavior: ScrollBehaviorWithoutGlow(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                isUpdateModule
                    ? Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.imageUploadText,
                              style: subText,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff63B1F2),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                                  CachedNetworkImage(imageUrl: items!.imageid),
                            ),
                          ],
                        ),
                      )
                    : const ImagePick(),
                Container(
                  // color: Colors.amber,
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: TypeUpload(itemsName: uploadType, controller: type),
                  ),
                ),
                TextInput(
                  controller: url,
                  title: AppLocalizations.of(context)!.linkUploadText,
                  textHint:
                      AppLocalizations.of(context)!.linkUploadPlaceholderText,
                ),
                TextInput(
                  controller: title,
                  title: AppLocalizations.of(context)!.titleUploadText,
                  textHint:
                      AppLocalizations.of(context)!.titleUploadPlaceholderText,
                ),
                TextInput(
                  controller: nama,
                  title: AppLocalizations.of(context)!.authorUploadText,
                  textHint:
                      AppLocalizations.of(context)!.authorUploadPlaceholderText,
                ),
                TextInput(
                  controller: desc,
                  title: AppLocalizations.of(context)!.descriptionText,
                  textHint: AppLocalizations.of(context)!
                      .descriptionploadPlaceholderText,
                  minLines: 6,
                  maxLines: 6,
                ),
                ChooseCategories(
                  onTap: () {
                    if (!isUpdateModule) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectCategory(
                            count: context
                                .read<UploadUpdateItemProvider>()
                                .itemCat,
                            onFinish: () {
                              context
                                  .read<UploadUpdateItemProvider>()
                                  .updateCache();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
                FullButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    if (!isUpdateModule) {
                      Map result = await context
                          .read<UploadUpdateItemProvider>()
                          .upload(context.read<AccountProv>().userData!.uid,
                              type: type.selectedIndex!,
                              url: url.text,
                              title: title.text,
                              author: nama.text,
                              longDesc: desc.text);
                      Navigator.pop(context);
                      if (!result['error']) {
                        context.read<UploadUpdateItemProvider>().clearCache();
                        Navigator.pop(
                            context,
                            Items(
                                itemid: result['items']['itemid'],
                                shortdesc: 'ShortDesc',
                                imageid: result['items']['imageid'],
                                author: nama.text,
                                title: title.text));
                      }
                    } else {
                      /// If categories and type want to change
                      /// Algoritma
                      /// bool isTypeChange = (uploadType[type.selectedIndex!] == items!.categories[0]);
                      /// bool checkItems = false;
                      /// var updateCategories = context.read<UploadUpdateItemProvider>().itemCat.items;
                      /// int sourceLength = items!.categories.length;
                      /// for (int i = 1; i < sourceLength; i++) {
                      ///   checkItems = checkItems || updateCategories.contains(items!.categories[i]);
                      /// }
                      /// bool isCategoriesChange = ((updateCategories.length != sourceLength- 1) ||checkItems );
                      await context
                          .read<UploadUpdateItemProvider>()
                          .updateData(
                            idUser: context.read<AccountProv>().userData!.uid,
                            id: items!.itemid,
                            url: (url.text != items!.url) ? url.text : 'none',
                            author: (nama.text != items!.author)
                                ? nama.text.replaceAll('"', '\'')
                                : 'none',
                            title: (title.text != items!.title)
                                ? title.text.replaceAll('"', '\'')
                                : 'none',
                            longDesc: (desc.text != items!.longdesc)
                                ? desc.text.replaceAll('"', '\'')
                                : 'none',
                          )
                          .then((value) => Navigator.pop(context));
                      Navigator.pop(context);
                    }
                  },
                  text: (isUpdateModule)
                      ? 'Update'
                      : AppLocalizations.of(context)!.appBarUploadText,
                  marginBottom: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
