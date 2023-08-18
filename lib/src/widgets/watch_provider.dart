import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/components/Temp_text.dart';
import 'package:Movie_Night/src/models/video_prov_model.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class WatchProviderWidget extends StatefulWidget {
  const WatchProviderWidget(
      {Key? key, required this.id, required this.isTvShow})
      : super(key: key);
  final int id;
  final bool isTvShow;

  @override
  State<WatchProviderWidget> createState() => _WatchProviderWidgetState();
}

class _WatchProviderWidgetState extends State<WatchProviderWidget> {
  late Future<Watchprovider?> watchFuture;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    watchFuture =
        getprovider(widget.id, widget.isTvShow, dropdownProvider.selectedValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Watchprovider?>(
      future: watchFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data?.results != null &&
            snapshot.data!.results!.us != null &&
            snapshot.data!.results!.us!.flatrate!.isNotEmpty) {
          var data = snapshot.data!.results!.us!.flatrate ?? [];
          // var link = snapshot.data!.results!.us!.link ?? '';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).watchon,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "Powered by",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SvgPicture.network(
                          "https://widget.justwatch.com/assets/JW_logo_color_10px.svg",
                          colorFilter:
                              ColorFilter.mode(Colors.yellow, BlendMode.srcIn))
                    ],
                  )
                ],
              ),
              AspectRatio(
                aspectRatio: 2.1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: data.length > 20 ? 20 : data.length,
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
                              // onTap: () {
                              //   launchUrlString(
                              //     link,
                              //     mode: LaunchMode.externalApplication,
                              //   );
                              // },
                              child: ClipOval(
                                child: FadeInImage(
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      '$imageUrl${data[index].logoPath}'),
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
                              data[index].providerName!,
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
        } else {
          return TemporaryText(
            text: S.of(context).nowatchmovieon,
          );
        }
      },
    );
  }
}
