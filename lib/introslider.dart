import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';


class IntoSlider extends StatefulWidget {
  const IntoSlider({Key? key}) : super(key: key);

  @override
  State<IntoSlider> createState() => _IntoSliderState();
}

class _IntoSliderState extends State<IntoSlider> {
  List<ContentConfig> listContentConfig = [];
  void initState() {
    super.initState();
    listContentConfig.add(
      const ContentConfig(
        title: "ECHOSENTRY",

        description:
        "A COMPLETE MOBILE APPLICATION FOR ALL AGRICULTURE SOLUTIONS",
        //pathImage: "intro2.png",
        backgroundColor: Color(0xff7885f7),
      ),
    );

    listContentConfig.add(
      const ContentConfig(
        title: "ECHOSENTRY",
        description:
        "FARMING IS A PROFESSION OF HOPE",
        // pathImage: "intro1.png",
        backgroundColor: Color(0xff7885f7),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "ECHOSENTRY",

        description:
        "IT’S YOUR FARM;IT’S YOUR STORY.TAKE THE OPPORTUNITY TO SHARE IT.",
        //pathImage: "intro2.png",
        backgroundColor: Color(0xff7885f7),
      ),
    );


  }

  void onDonePress() {
    print("End of slides");
    // Navigator.pushNamed(context, '/login');
  }
  @override
  Widget build(BuildContext context) {


    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      renderSkipBtn:Text("SKIP",style: TextStyle(color: Colors.white),),
      renderDoneBtn:Text("DONE",style: TextStyle(color: Colors.white),),
      renderNextBtn:Text("NEXT",style: TextStyle(color: Colors.white),),
      onDonePress: onDonePress,
    );
  }
}