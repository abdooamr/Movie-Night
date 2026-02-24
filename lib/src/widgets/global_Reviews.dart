import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/global_review_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:provider/provider.dart';

class GlobalReviewsWidget extends StatefulWidget {
  const GlobalReviewsWidget(
      {Key? key, required this.isTvShow, required this.id})
      : super(key: key);
  final int id;
  final bool isTvShow;
  @override
  State<GlobalReviewsWidget> createState() => _GlobalReviewsWidgetState();
}

class _GlobalReviewsWidgetState extends State<GlobalReviewsWidget> {
  late Future<Review> _future;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    _future =
        getReviews(widget.id, widget.isTvShow, dropdownProvider.selectedValue);
    super.initState();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Review>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          var data = snapshot.data?.results;
          return AspectRatio(
            aspectRatio: 1,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data!.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.all(5),
                    child: Card(
                      color: Colors.black38,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 40,
                          child: ClipOval(
                            child: FadeInImage(
                              width: 60,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  '$imageUrl${data[index].authorDetails.avatarPath}'),
                              placeholder: const NetworkImage(
                                  'http://www.familylore.org/images/2/25/UnknownPerson.png'),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return CachedImageCustom(
                                    'http://www.familylore.org/images/2/25/UnknownPerson.png');
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          data[index].author,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: isExpanded
                                  ? const BoxConstraints()
                                  : const BoxConstraints(maxHeight: 120),
                              child: Text(
                                data[index].content,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            isExpanded
                                ? const SizedBox.shrink()
                                : Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isExpanded = true;
                                          });
                                        },
                                        child:
                                            Text(S.of(context).readmorelabel)),
                                  ),
                            Text(
                              data[index].createdAt.toString().substring(0, 10),
                              style: const TextStyle(color: Colors.white54),
                            )
                          ],
                        ),
                      ),
                    ));
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
