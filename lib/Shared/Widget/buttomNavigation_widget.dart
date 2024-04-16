import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:seventh_project/Model/reciter_model.dart';
import 'package:seventh_project/Shared/Screen/boarding_screen.dart';
import 'package:seventh_project/Shared/Screen/reciter_screen.dart';
import 'package:seventh_project/Shared/Screen/search_screen.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/doneDialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtomNavigation_widget extends StatefulWidget {
  const ButtomNavigation_widget({super.key});

  @override
  State<ButtomNavigation_widget> createState() =>
      _ButtomNavigation_widgetState();
}

class _ButtomNavigation_widgetState extends State<ButtomNavigation_widget> {
  double speedNumber = 1.0;
  int from = 0;
  int to = 0;
  bool repeat = true;
  @override
  void initState() {
    getCacheReciter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (showStartButton && !showTimer) return startWidget();
    if (showMore) return moreFeatures();
    if (showTimer) return playingWidget();
    return SizedBox(
      height: context.ScreenHeight / 18,
    );
  }

  void playAudio() {
    // if selected ayah is one ayah
    if (fromVerseSelect == toVerseSelect) {
      ayahPlayer.setAudioSource(LockCachingAudioSource(
          Uri.parse(
              'https://cdn.islamic.network/quran/audio/${cacheReciter.code}/${cacheReciter.date}/$toVerseSelect.mp3'),
          tag: MediaItem(
              id: '$toVerseSelect',
              title: cacheReciter.name,
              artUri: Uri.parse(cacheReciter.image))));
    } else {
      final playlist = ConcatenatingAudioSource(
        // Start loading next item just before reaching it
        useLazyPreparation: true,
        // Customise the shuffle algorithm
        shuffleOrder: DefaultShuffleOrder(),
        // Specify the playlist items
        children: [
          for (int i = fromVerseSelect == 0 ? 1 : fromVerseSelect;
              i <= toVerseSelect;
              i++)
            LockCachingAudioSource(
                Uri.parse(
                    'https://cdn.islamic.network/quran/audio/${cacheReciter.code}/${cacheReciter.date}/$i.mp3'),
                tag: MediaItem(
                    id: '$i',
                    title: cacheReciter.name,
                    artUri: Uri.parse(cacheReciter.image)))
        ],
      );
      // Load and play the playlist
      ayahPlayer.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
    }
    if (repeat)
      ayahPlayer.setLoopMode(LoopMode.all);
    else
      ayahPlayer.setLoopMode(LoopMode.off);
    ayahPlayer.play();
    showTimer = true;
    showStartButton = false;
    from = fromVerseSelect;
    to = toVerseSelect;
  }

  Future getCacheReciter() async {
    // Get the name of the qari Selected by the user from the cache
    SharedPreferences shared = await SharedPreferences.getInstance();
    if (shared.getStringList('qari') != null) {
      List cache = shared.getStringList('qari')!;
      cacheReciter = Reciter_model(
          date: cache[0],
          englishName: cache[1],
          image: cache[2],
          code: cache[3],
          name: cache[4]);
    }
  }

  Row moreFeatures() {
    return Row(
      children: [
        IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Search_screen())),
            icon: Icon(Icons.search, size: context.IconSize)),
        IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Reciter_screen())),
            icon: Icon(Icons.menu, size: context.IconSize)),
        IconButton(
            onPressed: () => showTafsser = !showTafsser,
            icon: Icon(Icons.menu_book_rounded, size: context.IconSize)),
        IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Boarding_screen(firstOnce: false))),
            icon: Icon(Icons.info_outline, size: context.IconSize))
      ],
    );
  }

  Row startWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (itemsPositionList.isNotEmpty)
          IconButton(
              onPressed: () {
                itemsPositionList.clear();
                showStartButton = false;
                setState(() {});
              },
              icon: Icon(Icons.clear, size: context.IconSize))
        else
          Spacer(),
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).highlightColor,
              fixedSize:
                  Size(context.ScreenWidth / 1.8, context.ScreenHeight / 18),
              shape: BeveledRectangleBorder()),
          onPressed: () {
            if (itemsPositionList.length == 1)
              itemsPositionList.add(itemsPositionList[0]);
            showMore = false;
            if (itemsPositionList.length > 2) {
              fromVerseSelect = itemsPositionList[0];
              toVerseSelect = itemsPositionList[1];
            }
            if (toVerseSelect != 0) playAudio();
          },
          child:
              Text('بدء الحفظ', style: TextStyle(fontSize: context.MiddleFont)),
        ),
      ],
    );
  }

  Row playingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StreamBuilder(
          stream: ayahPlayer.playerStateStream,
          builder: (context, snapshot) {
            return Row(
              children: [
                IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => doneDialog_widget()),
                    icon: Icon(Icons.done, size: context.IconSize)),
                IconButton(
                    onPressed: () {
                      repeat = !repeat;
                      if (repeat)
                        ayahPlayer.setLoopMode(LoopMode.all);
                      else
                        ayahPlayer.setLoopMode(LoopMode.off);
                      setState(() {});
                    },
                    icon: Icon(
                        !repeat
                            ? Icons.report_off_outlined
                            : Icons.repeat_outlined,
                        size: context.IconSize)),
                Text('|', style: TextStyle(fontSize: context.LargeFont)),
                TextButton(
                    onPressed: () {
                      if (speedNumber < 5) {
                        speedNumber += 0.25;
                      } else {
                        speedNumber = 0.5;
                      }
                      ayahPlayer.setSpeed(speedNumber);
                    },
                    child: Text('$speedNumber x',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(fontSize: context.MiddleFont))),
                Text('|', style: TextStyle(fontSize: context.LargeFont)),
                IconButton(
                  onPressed: ayahPlayer.hasNext && !repeat
                      ? () => ayahPlayer.seekToNext()
                      : null,
                  icon: Icon(Icons.keyboard_double_arrow_right,
                      size: context.IconSize),
                ),
                IconButton(
                  onPressed: () {
                    if (snapshot.data!.processingState ==
                            ProcessingState.completed ||
                        (to != toVerseSelect && from != fromVerseSelect)) {
                      playAudio();
                    } else if (!snapshot.data!.playing) {
                      ayahPlayer.play();
                    } else {
                      ayahPlayer.pause();
                    }
                  },
                  icon: snapshot.data == null
                      ? Icon(Icons.play_arrow, size: context.IconSize)
                      : snapshot.data!.processingState ==
                              ProcessingState.loading
                          ? CircularProgressIndicator.adaptive()
                          : Icon(
                              snapshot.data!.processingState ==
                                          ProcessingState.completed &&
                                      (to == toVerseSelect &&
                                          from == fromVerseSelect)
                                  ? Icons.replay
                                  : to != toVerseSelect &&
                                          from != fromVerseSelect
                                      ? Icons.play_arrow
                                      : !snapshot.data!.playing ||
                                              !ayahPlayer.playerState.playing
                                          ? Icons.play_arrow
                                          : Icons.pause,
                              size: context.IconSize),
                ),
                IconButton(
                  onPressed: ayahPlayer.hasPrevious && !repeat
                      ? () => ayahPlayer.seekToPrevious()
                      : null,
                  icon: Icon(Icons.keyboard_double_arrow_left,
                      size: context.IconSize),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
