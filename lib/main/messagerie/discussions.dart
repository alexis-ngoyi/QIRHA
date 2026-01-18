import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/main/messagerie/discussions_open.dart';
import 'package:qirha/model/discussion.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class MessagerieDiscussions extends StatefulWidget {
  const MessagerieDiscussions({super.key});

  @override
  State<MessagerieDiscussions> createState() => _MessagerieDiscussionsState();
}

class _MessagerieDiscussionsState extends State<MessagerieDiscussions> {
  List<DiscussionModel> discussions = [
    DiscussionModel(
      isCommande: false,
      sender: 'qirha AI 🤖',
      img:
          'https://icons.iconarchive.com/icons/diversity-avatars/avatars/128/robot-03-icon.png',
      time: '11:00 PM',
      pending: 2,
      msg:
          "Hey! Bienvennu sur qirha, Veuillez decouvrir notre game de produits",
    ),
    DiscussionModel(
      isCommande: false,
      sender: 'qirha Assistant 🔥',
      img:
          'https://icons.iconarchive.com/icons/aha-soft/standard-portfolio/128/Receptionist-icon.png',
      time: '01:00 AM',
      pending: 0,
      msg: "Hey! Votre commande en en phase expedition",
    ),
    DiscussionModel(
      isCommande: true,
      sender: "Pantalon blue",
      img: img_bazard3,
      time: '01:00 AM',
      pending: 0,
      msg: "J'ai recu mon affaire, c'est tres joli",
    ),
    DiscussionModel(
      isCommande: true,
      sender: "TV samsung",
      img: img_bazard6,
      time: '01:00 AM',
      pending: 0,
      msg: "J'ai recu mon affaire, mais ca ne s'allume pas ",
    ),
    DiscussionModel(
      isCommande: true,
      sender: "Lacoste",
      img: img_bazard5,
      time: '01:00 AM',
      pending: 0,
      msg:
          "J'ai recu mon affaire, c'est tres joli mais la taille n'est pas bonne",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: BLUE,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: HeroIcon(HeroIcons.plus, color: WHITE),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            espacementWidget(height: 10),
            for (var i = 0; i < discussions.length; i++)
              GestureDetector(
                onTap: () => CustomPageRoute(
                  MessagerieDiscussionsOpen(data: discussions[i]),
                  context,
                ),
                child: Column(
                  children: [
                    discussionItem(data: discussions[i]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black.withOpacity(.03),
                      ),
                    ),
                  ],
                ),
              ),
            espacementWidget(height: 10),
            Center(
              child: customText(
                'Plus aucun message',
                style: TextStyle(fontSize: 12, color: LIGHT),
              ),
            ),
            espacementWidget(height: 30),
          ],
        ),
      ),
    );
  }

  Container discussionItem({required DiscussionModel data}) {
    return Container(
      color: WHITE,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: customNetWorkImage(image: data.img, radius: 100),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            !data.isCommande
                                ? Expanded(
                                    child: customText(
                                      data.sender,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Row(
                                      children: [
                                        cardStatus(
                                          hide: data.isCommande,
                                          color: BLUE,
                                          label: 'Commande',
                                          icon: HeroIcons.banknotes,
                                        ),
                                        HeroIcon(
                                          HeroIcons.chevronRight,
                                          size: 14,
                                          color: LIGHT,
                                        ),
                                        customText(
                                          data.sender,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: customText(
                                data.time,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: data.pending != 0 ? BLUE : DARK,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 100,
                                child: customText(
                                  data.msg,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(.7),
                                  ),
                                ),
                              ),
                              if (data.pending != 0)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: BLUE,
                                    ),
                                    child: Center(
                                      child: customText(
                                        "${data.pending}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: WHITE,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (data.isCommande) espacementWidget(height: 4),
                        if (data.isCommande)
                          Row(
                            children: [
                              cardStatus(
                                color: GREEN,
                                label: 'Paye',
                                icon: HeroIcons.banknotes,
                              ),
                              espacementWidget(width: 8),
                              cardStatus(
                                color: ORANGE,
                                label: 'En preparation',
                                icon: HeroIcons.arrowRightOnRectangle,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
