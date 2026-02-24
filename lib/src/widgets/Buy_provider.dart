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

class BuyProviderWidget extends StatefulWidget {
  const BuyProviderWidget({Key? key, required this.id, required this.isTvShow})
      : super(key: key);
  final int id;
  final bool isTvShow;

  @override
  State<BuyProviderWidget> createState() => _BuyProviderWidgetState();
}

class _BuyProviderWidgetState extends State<BuyProviderWidget> {
  late Future<Watchprovider?> providerFuture;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    providerFuture =
        getprovider(widget.id, widget.isTvShow, dropdownProvider.selectedValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Watchprovider?>(
      future: providerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data?.results != null &&
            snapshot.data!.results!.us != null &&
            snapshot.data!.results!.us!.buy!.isNotEmpty) {
          // var link = snapshot.data!.results!.us!.link ?? '';
          var data = snapshot.data!.results!.us!.buy ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).buyon,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).poweredby,
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
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            // onTap: () {
                            //   launchUrlString(
                            //     link,
                            //     mode: LaunchMode.externalApplication,
                            //   );
                            // },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              child: ClipOval(
                                child: FadeInImage(
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  image: (data[index].logoPath != null)
                                      ? NetworkImage(
                                          '$imageUrl${data[index].logoPath}')
                                      : NetworkImage(''),
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
                              data[index].providerName ?? '',
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
            text: S.of(context).nobuyon,
          );
        }
      },
    );
  }
}
