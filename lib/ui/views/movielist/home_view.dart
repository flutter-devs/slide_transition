import 'package:custom_radio_grouped_button/CustomButtons/CustomCheckBoxGroup.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:movie_app/core/constants/color_constants.dart';
import 'package:movie_app/core/constants/constants.dart';
import 'package:movie_app/core/models/movie_items.dart';
import 'package:movie_app/core/viewmodels/views/login/home_viewmodel.dart';
import 'package:movie_app/ui/views/movielist/movie_detail_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>with SingleTickerProviderStateMixin {
  int counter = 0;
  double _rating = 3;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? prefs;
  HomeViewModel? model;
  var radioButtonItem = 'Left';
  late AnimationController controller;
  late Animation<Offset> offset;


  @override
  void initState() {
    initPrefs();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      model = Provider.of<HomeViewModel>(context, listen: false);
      model!.getPopularMovies();
    });

    super.initState();
    controller =
        AnimationController(vsync:this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    print('HomeView: build()');
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildSlideTransition(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [

                    _buildPopularSection(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Container(
      //height: 300,
      padding: EdgeInsets.only(left: 20, top: 5),
      width: MediaQuery.of(context).size.width,
      child: model != null && model!.isPopularLoading
          ? Center(child: CircularProgressIndicator())
          : Provider.value(
              value: Provider.of<HomeViewModel>(context),
              child: Consumer(
                builder: (context, value, child) => Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),

                    itemCount: model != null && model!.popularMovies != null
                        ? model!.popularMovies!.results!.length
                        : 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return _buildPopularItem(
                          index, model!.popularMovies!.results![index]);
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPopularItem(int index, Results result) {
    return GestureDetector(
      onTap: () {
        if (radioButtonItem == "Left") {
          Navigator.push(
            context, SlideLeftRoute(widget: MovieDetailView(movieDataModel: result)),
          );
        } else if (radioButtonItem == "Right") {
          /*Navigator.push(
            context, SlideRightRoute(widget: MovieDetailView(movieDataModel: result)),
          );*/

          Navigator.push(
            context,
            PageRouteBuilder<dynamic>(
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => MovieDetailView(movieDataModel: result),
              transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                  ) {
                final Tween<Offset> offsetTween = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
                final Animation<Offset> slideInFromTheRightAnimation = offsetTween.animate(animation);
                return SlideTransition(
                    position: slideInFromTheRightAnimation,
                    child: child
                );
              },
            ),
          );

        } else if (radioButtonItem == "Top") {
          Navigator.push(
            context, SlideTopRoute(widget: MovieDetailView(movieDataModel: result)),
          );

        } else if (radioButtonItem == "Bottom") {
          Navigator.push(
            context, SlideBottomRoute(widget: MovieDetailView(movieDataModel: result)),
          );
        }
        else if (radioButtonItem == "InOut") {
          Navigator.push(
            context, ScaleRoute(widget: MovieDetailView(movieDataModel: result)),
          );
        }
        else if (radioButtonItem == "Bot-Right") {
          Navigator.push(
            context, SlideSideMoveRoute(widget: MovieDetailView(movieDataModel: result)),
          );
        }
        else {
          print("Nothing matched");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(right: 16),
                // color: Colors.pinkAccent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.network(
                    Constants.IMAGE_BASE_URL +
                        Constants.IMAGE_SIZE_1 +
                        '${result.posterPath}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 150,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  height: 50,
                  width: 325,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E3311).withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(27),
                      bottomRight: Radius.circular(27),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          result.title!,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        child: GFRating(
                          value: _rating,
                          color: Color(ColorConstants.orange),
                          size: 16,
                          onChanged: (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildSlideTransition() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          //color: Colors.pinkAccent,
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.only(
            left: 20,
          ),

          child: Text(
            "Slide Transition:",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
           //color: Colors.green,
          width: MediaQuery.of(context).size.width,
          //margin: EdgeInsets.all(10),
          child: Column(
            children: [
              CustomRadioButton(
                enableShape: true,
                elevation: 0,
                defaultSelected: "Left",
                enableButtonWrap: true,
                width: 100,
                autoWidth: false,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: [
                  "Left",
                  "Right",
                  "Top",
                  "Bottom",
                  "InOut",
                  "Bot-Right",

                ],
                buttonValues: [
                  "Left",
                  "Right",
                  "Top",
                  "Bottom",
                  "InOut",
                  "Bot-Right",
                ],
                radioButtonValue: (value) {
                  radioButtonItem=value.toString();
                  print("Value:$value");
                  print("radioButtonItem:$radioButtonItem");
                },
                selectedColor: Theme.of(context).accentColor,
              ),

            ],
          ),
        ),
      ],
    );
  }
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget widget;
  SlideLeftRoute({required this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        Tween<Offset> offsetTween = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
        final Animation<Offset> slideInFromTheRightAnimation = offsetTween.animate(animation);
        return SlideTransition(position: slideInFromTheRightAnimation, child: child);
      }
  );
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({required this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }
  );
}

class SlideTopRoute extends PageRouteBuilder {
  final Widget widget;
  SlideTopRoute({required this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }
  );
}

class SlideBottomRoute extends PageRouteBuilder {
  final Widget widget;
  SlideBottomRoute({required this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
       // transitionDuration:Duration(seconds: 1);
      }

  );
}




class ScaleRoute extends PageRouteBuilder {
  final Widget widget;

  ScaleRoute({required this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new ScaleTransition(
            scale: new Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 1.5,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Interval(
                    0.50,
                    1.00,
                    curve: Curves.linear,
                  ),
                ),
              ),
              child: child,
            ),
          );
        });
}

class SlideSideMoveRoute extends PageRouteBuilder {
  final Widget widget;
  SlideSideMoveRoute({required this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        Animation<Offset> custom= Tween<Offset>(
            begin:Offset(1.0,1.0),end: Offset(0.0,0.0)).animate(animation);
        return SlideTransition(
            position: custom,
        child: child);
      }
  );
}

//  class SwitcherS extends State<Switcher> {
//   bool state = false;
//
//   buildChild (index) => Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         width: index == 0 ? 100 : 150,
//         height: index == 0 ? 200 : 150,
//         color:index == 0 ? Colors.deepPurple : Colors.deepOrange,
//       ),
//       key: ValueKey('$index'));
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () => setState(() { state = !state; }),
//     child: Padding(
//     padding: EdgeInsets.all(24),
//     child: AnimatedSwitcher(
//     duration: const Duration(seconds: 1),
//     transitionBuilder: (Widget child, Animation<double> animation) {
//     return SlideTransition(
//     position: Tween(
//     begin: Offset(1.0, 1.0),
//     end: Offset(0.0, 0.0),
//     ).animate(animation),
//     child: child,
//     );
//     },
//     child: buildChild(state ? 0 : 1),
//     ),
//     );
//   }
// }

// class _SlideInOutWidgetState extends State<SlideInOutWidget>
//     with SingleTickerProviderStateMixin {
//   double startPos = -1.0;
//   double endPos = 0.0;
//   Curve curve = Curves.elasticOut;
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder(
//       tween: Tween<Offset>(begin: Offset(startPos, 0), end: Offset(endPos, 0)),
//       duration: Duration(seconds: 1),
//       curve: curve,
//       builder: (context, offset, child) {
//         return FractionalTranslation(
//           translation: offset,
//           child: Container(
//             width: double.infinity,
//             child: Center(
//               child: child,
//             ),
//           ),
//         );
//       },
//       child: Text('animated text', textScaleFactor: 3.0,),
//       onEnd: () {
//         print('onEnd');
//         Future.delayed(
//           Duration(milliseconds: 500),
//               () {
//             curve = curve == Curves.elasticOut
//                 ? Curves.elasticIn
//                 : Curves.elasticOut;
//             if (startPos == -1) {
//               setState(() {
//                 startPos = 0.0;
//                 endPos = 1.0;
//               });
//             }
//           },
//         );
//       },
//     );
//   }
// }
//
// child: Align(
// alignment: Alignment.topCenter,
// child: Provider.of<UserWidgets>(context, listen: false).renderWidget(context),
// )
