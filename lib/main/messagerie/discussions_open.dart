import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/model/discussion.dart';
import 'package:qirha/model/message.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/emoji.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class MessagerieDiscussionsOpen extends StatefulWidget {
  const MessagerieDiscussionsOpen({super.key, required this.data});
  final DiscussionModel data;

  @override
  State<MessagerieDiscussionsOpen> createState() =>
      _MessagerieDiscussionsOpenState();
}

class _MessagerieDiscussionsOpenState extends State<MessagerieDiscussionsOpen> {
  TextEditingController myTextController = TextEditingController();
  ScrollController myScrollController = ScrollController();
  bool triggerEmojis = false;

  List<MessageModel> messages = [
    MessageModel(
        img: '',
        msg:
            'Bonjour! Votre commande a bien ete valide et paye, veuillez attendre votre livraison dans les prochaines 24h',
        isPending: true,
        user: '',
        inbox: true,
        time: '10:00 PM')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WHITE,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const HeroIcon(
                HeroIcons.chevronLeft,
                size: 25,
              ),
            ),
            espacementWidget(
              width: 4,
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: customNetWorkImage(image: widget.data.img, radius: 100),
            ),
            espacementWidget(
              width: 4,
            ),
            Column(
              children: [
                customText(widget.data.sender,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19)),
                if (widget.data.isCommande) espacementWidget(height: 4),
                if (widget.data.isCommande)
                  Row(
                    children: [
                      cardStatus(
                          color: GREEN,
                          label: 'Paye',
                          icon: HeroIcons.banknotes),
                      espacementWidget(width: 8),
                      cardStatus(
                          color: ORANGE,
                          label: 'En preparation',
                          icon: HeroIcons.arrowRightOnRectangle),
                    ],
                  )
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => {},
            child: const HeroIcon(
              HeroIcons.phone,
              size: 24,
            ),
          ),
          espacementWidget(
            width: 15,
          ),
          GestureDetector(
            onTap: () => {},
            child: const HeroIcon(
              HeroIcons.videoCamera,
              size: 24,
            ),
          ),
          espacementWidget(
            width: 20,
          ),
        ],
      ),
      backgroundColor: WHITE,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              img_bg,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: myScrollController,
                  child: Column(
                    children: [
                      espacementWidget(height: 10),
                      for (var i = 0; i < messages.length; i++)
                        messages[i].inbox
                            ? receivedBox(data: messages[i])
                            : sendBox(data: messages[i]),
                      espacementWidget(height: 10),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: WHITE,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  children: [
                    messageInputBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // HeroIcon(HeroIcons.cog6Tooth),
                        GestureDetector(
                            onTap: () => setState(() {
                                  triggerEmojis = !triggerEmojis;
                                }),
                            child: HeroIcon(triggerEmojis
                                ? HeroIcons.xMark
                                : HeroIcons.faceSmile)),
                        HeroIcon(HeroIcons.photo),
                        HeroIcon(HeroIcons.camera),
                        HeroIcon(HeroIcons.microphone),
                        MyCartWidget(color: DARK)
                      ],
                    ),
                    if (triggerEmojis)
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        height: 200,
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: [
                              for (var i = 0; i < emojis_list.length; i++)
                                GestureDetector(
                                  onTap: () => setState(() {
                                    TextSelection textSelection =
                                        myTextController.selection;
                                    String newText = myTextController.text
                                        .replaceRange(textSelection.start,
                                            textSelection.end, emojis_list[i]);
                                    final emojiLength = emojis_list[i].length;
                                    myTextController.text = newText;
                                    myTextController.selection =
                                        textSelection.copyWith(
                                      baseOffset:
                                          textSelection.start + emojiLength,
                                      extentOffset:
                                          textSelection.start + emojiLength,
                                    );
                                  }),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: customText(emojis_list[i],
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    espacementWidget(height: 13)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Row messageInputBox() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: SingleChildScrollView(
              child: TextField(
                minLines: 1,
                maxLines: 1000,
                controller: myTextController,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Ecrire votre message',
                    hintStyle: TextStyle(fontSize: 13)),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: sendMessage,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: HeroIcon(
              HeroIcons.paperAirplane,
              size: 20,
              color: myTextController.text.isEmpty ? LIGHT : BLUE,
            ),
          ),
        )
      ],
    );
  }

  Row sendBox({required MessageModel data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        espacementWidget(width: 100),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            child: Container(
              constraints: BoxConstraints(minWidth: 30, maxWidth: 350),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7), color: WHITE),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText('Vous',
                            style: TextStyle(fontSize: 10, color: LIGHT)),
                        espacementWidget(width: 10),
                        customText(data.time,
                            style: TextStyle(fontSize: 10, color: LIGHT))
                      ],
                    ),
                    customText(data.msg,
                        maxLines: 1000,
                        style: TextStyle(fontSize: 13, color: DARK)),
                  ],
                ),
              ),
            ),
          ),
        ),
        espacementWidget(width: 6),
      ],
    );
  }

  Row receivedBox({required MessageModel data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          child: SizedBox(
            width: 30,
            height: 30,
            child: customNetWorkImage(image: widget.data.img, radius: 100),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            child: Container(
              constraints: BoxConstraints(
                  minWidth: 30,
                  maxWidth: MediaQuery.of(context).size.width * .6),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7), color: GREEN),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(widget.data.sender,
                              style: TextStyle(fontSize: 10, color: LIGHT)),
                          espacementWidget(width: 10),
                          customText(data.time,
                              style: TextStyle(fontSize: 10, color: LIGHT))
                        ],
                      ),
                      customText(data.msg,
                          maxLines: 1000,
                          style: TextStyle(fontSize: 13, color: WHITE)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        espacementWidget(width: 100)
      ],
    );
  }

  sendMessage() {
    myScrollController.jumpTo(myScrollController.position.maxScrollExtent);
    if (myTextController.text.trim().isNotEmpty) {
      final date =
          "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}";
      setState(() {
        messages.add(MessageModel(
            user: '',
            img: '',
            inbox: false,
            time: date,
            isPending: true,
            msg: myTextController.text.trim()));

        // Future.delayed(
        //     Duration(milliseconds: 50),
        //     () => {
        //           messages.add(MessageModel(
        //               user: '',
        //               img: '',
        //               inbox: true,
        //               time: date,
        //               isPending: true,
        //               msg: 'Ceci'))
        //         });

        myTextController.text = ""; // unset
      });
    }
  }
}
