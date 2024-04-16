import 'package:flutter/material.dart';
import 'package:seventh_project/Shared/Screen/mushaf_screen.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Boarding_screen extends StatefulWidget {
  final bool firstOnce;
  const Boarding_screen({super.key, required this.firstOnce});

  @override
  State<Boarding_screen> createState() => _Boarding_screenState();
}

class _Boarding_screenState extends State<Boarding_screen> {
  PageController pageController = PageController();
  int page = 0;
  List<Map> pages = [
    {
      'image': ['select', 'selectEnd'],
      'data':
          'لدخول لوضع الحفظ يجدب الضغط ضغة مطولة علي الاية ولتحديد نهاية القال يتم الضغط ضغطة واحدة علي الاية يمكن تحديد عدد من القوال اقصاها 4 قوالب ثم الضغط علي بدء الحفظ ويمكنك الغاء التحديد بالضغط علي زر الالغاء'
    },
    {
      'image': ['startMode'],
      'data':
          'عند بدء وضع الحفظ سيبدا الموقت لحساب مدة الحفظ وسيظهر لك القوالب التي تم تحديدها وستم تشغيل القراءة بصوت القارئ الذي تفضلة ويمكنك تحديد القالب بالضغط عليه ويمكنك ايضا التحكم في سرعة القراءة و الايه التي تقراء وتكرار القالب ام لا'
    },
    {
      'image': ['end', 'time'],
      'data':
          'اذا اردت الخروج من وضع الحفظ يمكنك الضغط علي زر الانتهاء وعند الضغط علي نعم سيظهر لك مدة الحفظ'
    },
    {
      'image': ['pageDetail', 'drawer', 'hizb'],
      'data':
          'في اعلي الصفحة يوجد معلومات عن الصفحة الحالية مثل اسم السورة والحزب إلخ.. عند علي هذا الجزء يطهر لك الفهرس ويمكن عرض الاحزاب ويمكن البحث عن اسماء السور والنتقال ال بداية الجزء والحزب والسورة '
    },
    {
      'image': ['more'],
      'data':
          'يمكنك عرض المزيد من الاضافات عن الضغط ضغطة واحد علي الشاشة مثل البحث وصفحة القراء والانتقال بين وضعي المصحف والتفسير والترجمة ويمكن الرجوع الس هذة الصفحة مرة اخري'
    },
    {
      'image': ['qari'],
      'data': 'يمكنك من خلالها تحديد القارئ الذي تفضل ان تستمع له'
    },
    {
      'image': ['search'],
      'data':
          'يمكنك الوصول لها عند الضغط علي زر البحث او سحب الشاشة لاسفل تستطيع البحث عن السورة والاية والانتقال الي الصفحة التي توجد بها'
    },
    {
      'image': ['tafsser'],
      'data':
          'في هذا الوضع يتم عرض الصفحة مقسمة الي الاية وتفسرها ( التفسير الميسر ) والترجمة باللغة الإنجليزية'
    },
    {
      'image': ['history'],
      'data':
          'يمكنك حفظ سجلات الحفظ الخاصة بك عن تريج تسجيل الدخول بواسطة الهاتف او جوجل ومن ثم عن بدء الحقظ يمكنك اضافة سجل الحفظ الذي يحتوي علي اسم السورة رقم الصفحة إلخ..'
    },
    {
      'image': ['surahBar', 'surahInfo'],
      'data':
          'يمكن عرض معلومات عن السورة القرانية مثل اسمها ,عدداياتها ,مكان النزول ,المقصد من السورة وسبب التسمية في بعض السور'
    },
    {
      'image': ['landscape'],
      'data': 'يمكنك تدوير الشاشة للوضع الافقي للحصول علي خط اكبر حجما'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: widget.firstOnce
            ? TextButton(
                style: TextButton.styleFrom(
                    fixedSize: Size(
                        context.ScreenWidth / 3, context.ScreenHeight / 16),
                    alignment: Alignment.centerRight,
                    shape: RoundedRectangleBorder()),
                onPressed: () => goToMushaf(),
                child: Text('تخطي',
                    style: TextStyle(
                        color: context.defaultColor,
                        fontSize: context.LargeFont)),
              )
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < pages.length; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 0, 0, 15),
              child: Icon(i == page ? Icons.circle : Icons.circle_outlined,
                  color: Colors.grey, size: context.IconSize / 1.5),
            )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          pageController.nextPage(
              duration: Duration(microseconds: 500), curve: Curves.bounceInOut);
          if (page == pages.length - 1) goToMushaf();
        },
        child: PageView.builder(
          itemCount: pages.length,
          controller: pageController,
          onPageChanged: (value) {
            page = value;
            setState(() {});
          },
          itemBuilder: (context, index) => pagesWidget(index),
        ),
      ),
    );
  }

  Padding pagesWidget(int index) {
    List images = pages[index]['image'];
    return Padding(
      padding: EdgeInsets.only(
          top: 35,
          left: context.ScreenWidth / 15,
          right: context.ScreenWidth / 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...images.map(
                (e) => Expanded(
                  child: Image.asset(
                    'assets/boarding/${context.isDark ? 'dark' : ''}$e.png',
                    height: context.ScreenHeight / 2.5,
                  ),
                ),
              ),
            ],
          ),
          Text('\n' + pages[index]['data'].toString().replaceFarsi,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.MiddleFont))
        ],
      ),
    );
  }

  void goToMushaf() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    if (widget.firstOnce) {
      shared.setBool('showBoarding', false).then((value) =>
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Mushaf_screen()),
              (route) => false));
    } else {
      Navigator.pop(context);
    }
  }
}
