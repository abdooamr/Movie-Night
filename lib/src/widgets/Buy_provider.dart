import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/components/Temp_text.dart';
import 'package:Movie_Night/src/models/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class buy_provider_widget extends StatefulWidget {
  const buy_provider_widget(
      {Key? key, required this.id, required this.isTvShow})
      : super(key: key);
  final int id;
  final bool isTvShow;

  @override
  State<buy_provider_widget> createState() => _buy_provider_widgetState();
}

class _buy_provider_widgetState extends State<buy_provider_widget> {
  late Future<Watchprovider?> providerfuture;
  @override
  void initState() {
    providerfuture = getprovider(widget.id, widget.isTvShow);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Watchprovider?>(
      future: providerfuture,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          var link = snapshot.data?.results!.us;
          var data = snapshot.data?.results!.us!.buy;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buy movie on',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              AspectRatio(
                aspectRatio: 2.1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: data!.length, //max length = 20
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              launchUrlString(link!.link.toString(),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              child: ClipOval(
                                child: FadeInImage(
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  image: (data[index] == null)
                                      ? NetworkImage("")
                                      : NetworkImage(
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
            text: "No platform offering to buy the movie yet",
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
