import 'package:flutter/material.dart';
import 'package:slide_transition_app/core/constants/color_constants.dart';
import 'package:slide_transition_app/core/constants/constants.dart';
import 'package:slide_transition_app/core/constants/string_constants.dart';
import 'package:slide_transition_app/core/models/movie_items.dart';
import 'package:slide_transition_app/core/constants/color_constants.dart';

class MovieDetailView extends StatefulWidget {
  final Results movieDataModel;

  const MovieDetailView({Key? key, required this.movieDataModel})
      : super(key: key);

  @override
  _MovieDetailViewState createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 40, right: 20),
                //color: Colors.blue,
                child: Column(
                  children: [
                    _buildAppBarTitle(),
                    SizedBox(
                      height: 30,
                    ),
                    _buildMovieBanner(widget.movieDataModel),
                    SizedBox(
                      height: 40,
                    ),
                    _buildMovieTitle(),
                    SizedBox(
                      height: 12,
                    ),
                    _buildRatingBar(),
                    SizedBox(
                      height: 20,
                    ),
                    _buildTypeOfSeries(),
                    SizedBox(
                      height: 20,
                    ),
                    _buildMovieDescriptions(),
                  ],
                ),
              ),
            ),
          ),
          _buildBuyTicketButton(),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              //color: Colors.blueGrey,
              width: 48,
              height: 48,
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Color(ColorConstants.black1),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.movieDataModel.title!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Icon(
            Icons.turned_in_not_sharp,
            size: 18,
            color: Color(ColorConstants.black1),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieBanner(Results movieItems) {
    return Container(
      height: 380,
      //color: Colors.pinkAccent,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            child: Container(
              height: 350,
              width: 240,
              margin: EdgeInsets.only(left: 28, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Color(ColorConstants.saphire_blue2),
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Container(
              height: 350,
              width: 250,
              margin: EdgeInsets.only(left: 22, right: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Color(ColorConstants.cobaltBlue),
              ),
            ),
          ),
          Container(
            height: 350,
            width: 260,
            margin: EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                Constants.IMAGE_BASE_URL +
                    Constants.IMAGE_SIZE_1 +
                    widget.movieDataModel.posterPath!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        widget.movieDataModel.title!,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  Widget _buildRatingBar() {
    return Container(
      child: Row(
        children: [
          Text(
            StringConstants.release,
            style:
                TextStyle(color: Colors.black, fontSize: 15),
          ),
          Text(
            ' ${widget.movieDataModel.releaseDate!}',
            style:
                TextStyle(color: Colors.black, fontSize: 15),
          ),
          Container(
              height: 15,
              child: VerticalDivider(
                color: Colors.black,
              )),
          Text(
            '${widget.movieDataModel.voteAverage ?? 0}',
            style:
                TextStyle(color: Colors.black, fontSize: 15),
          ),
          Icon(
            Icons.star,
            color: Color(ColorConstants.orange),
            size: 15,
          )
        ],
      ),
    );
  }

  Widget _buildTypeOfSeries() {
    return Row(
      children: [
        Container(
          height: 35,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),

          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
                side: BorderSide(width: 1, color: Colors.green)
            ),
            child: Center(
              child: Text(
                "Crime",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 35,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(width: 1, color: Colors.green)
            ),
            child: Center(
              child: Text(
                "Horror",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 35,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(width: 1, color: Colors.green)
            ),
            child: Center(
              child: Text(
                "Drama",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 35,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(width: 1, color: Colors.green)
            ),
            child: Center(
              child: Text(
                "Comedy",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieDescriptions() {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Overview",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.movieDataModel.overview!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyTicketButton() {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          //alignment: Alignment.bottomCenter,
          height: 40,
          width: 150,
          decoration: BoxDecoration(
              color: Color(0xff546ee5),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Center(
            child: Text(
              "Buy Ticket",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
