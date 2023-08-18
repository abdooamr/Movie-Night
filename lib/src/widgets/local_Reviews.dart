import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:Movie_Night/src/models/local_review_model.dart';

class LocalReviewsWidget extends StatefulWidget {
  const LocalReviewsWidget({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<LocalReviewsWidget> createState() => _LocalReviewsWidgetState();
}

class _LocalReviewsWidgetState extends State<LocalReviewsWidget> {
  late ReviewProvider reviewProvider;
  List<bool> isExpandedList = [];
  final TextEditingController reviewController = TextEditingController();
  final currentuser = FirebaseAuth.instance.currentUser!;
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat('dd-MM-yyyy');
    reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<Localreviews>>(
          stream: reviewProvider.getReviews(widget.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final data = snapshot.data!;

              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        isExpandedList.add(false);

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
                                    image: NetworkImage(data[index].ProfilePic),
                                    placeholder: const NetworkImage(
                                        'http://www.familylore.org/images/2/25/UnknownPerson.png'),
                                  ),
                                ),
                              ),
                              title: Text(
                                data[index].displayname,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                    constraints: isExpandedList[index]
                                        ? const BoxConstraints()
                                        : const BoxConstraints(maxHeight: 120),
                                    child: Text(
                                      data[index].review!,
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  if (!isExpandedList[index])
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isExpandedList[index] = true;
                                          });
                                        },
                                        child: const Text('Read More...'),
                                      ),
                                    ),
                                  Text(
                                    data[index]
                                        .createdat
                                        .toString()
                                        .substring(0, 10),
                                    style:
                                        const TextStyle(color: Colors.white54),
                                  ),
                                  if (currentuser.uid == data[index].id)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () {
                                          reviewProvider.deleteReview(
                                            movieId: widget.id.toString(),
                                            userId: currentuser.uid,
                                          );
                                        },
                                        icon: const Icon(
                                          IconsaxBold.trash,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No Reviews',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              );
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: reviewController,
                decoration: InputDecoration(
                  focusColor: Colors.deepPurpleAccent,
                  hintText: 'Write a review',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                final localReview = Localreviews(
                  ProfilePic: currentuser.photoURL ?? '',
                  review: reviewController.text,
                  displayname: currentuser.displayName!,
                  email: currentuser.email!,
                  createdat: dateFormat.format(DateTime.now()),
                  id: currentuser.uid,
                );
                if (reviewController.text.isNotEmpty) {
                  reviewProvider.addReview(
                      movieId: widget.id.toString(),
                      userId: currentuser.uid,
                      localReview: localReview);
                  reviewController.clear();
                }
              },
              icon: const Icon(
                IconsaxBold.send_square,
                size: 40,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
