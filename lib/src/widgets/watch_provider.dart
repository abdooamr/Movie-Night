import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/components/Temp_text.dart';
import 'package:Movie_Night/src/models/video_prov_model.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class watch_provider_widget extends StatefulWidget {
  const watch_provider_widget(
      {Key? key, required this.id, required this.isTvShow})
      : super(key: key);
  final int id;
  final bool isTvShow;

  @override
  State<watch_provider_widget> createState() => _watch_provider_widgetState();
}

class _watch_provider_widgetState extends State<watch_provider_widget> {
  late Future<Watchprovider?> watchfuture;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    watchfuture =
        getprovider(widget.id, widget.isTvShow, dropdownProvider.selectedValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Watchprovider?>(
      future: watchfuture,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          var data = snapshot.data?.results!.us!.flatrate;
          var link = snapshot.data?.results!.us!.link;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).watchon,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              AspectRatio(
                aspectRatio: 2.1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:
                      data!.length > 20 ? 20 : data.length, //max length = 20
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 40,
                            child: GestureDetector(
                              onTap: () {
                                launchUrlString(
                                  link!,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: ClipOval(
                                child: FadeInImage(
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      '$imageUrl${data[index]!.logoPath}'),
                                  placeholder: const NetworkImage(
                                      'http://www.familylore.org/images/2/25/UnknownPerson.png'),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return CachedImageCustom(
                                        'http://www.familylore.org/images/2/25/UnknownPerson.png');
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              data[index]!.providerName!,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return TemporaryText(
            text: S.of(context).nowatchmovieon,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
