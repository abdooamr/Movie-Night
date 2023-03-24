import 'package:Movie_Night/src/models/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
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
  @override
  void initState() {
    watchfuture = getprovider(widget.id, widget.isTvShow);
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
                'Watch movie on:',
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
                                    return Image.network(
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
          return Text(
            "No platform offering to watch the movie on yet",
            style: Theme.of(context).textTheme.titleLarge,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
