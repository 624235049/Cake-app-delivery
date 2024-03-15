import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/custumer/model/review_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _rating = 0;
  List<ReviewModel> reviewModels = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: Text('Review'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/preview.png'),
              SizedBox(height: 200),
              Text(
                'ให้คะแนนหลังการใช้งาน',
                style: TextStyle(
                    fontFamily: 'Bebas', fontSize: 20, color: Colors.blue),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => setState(() => _rating = 1),
                    icon: Icon(Icons.star_border),
                    color: _rating >= 1 ? Colors.orange : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () => setState(() => _rating = 2),
                    icon: Icon(Icons.star_border),
                    color: _rating >= 2 ? Colors.orange : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () => setState(() => _rating = 3),
                    icon: Icon(Icons.star_border),
                    color: _rating >= 3 ? Colors.orange : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () => setState(() => _rating = 4),
                    icon: Icon(Icons.star_border),
                    color: _rating >= 4 ? Colors.orange : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () => setState(() => _rating = 5),
                    icon: Icon(Icons.star_border),
                    color: _rating >= 5 ? Colors.orange : Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue.shade100), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    // เปลี่ยนสีตัวอักษรเป็นสีขาว
                  ),
                  onPressed: () => _submitRating(),
                  child: Text('Submit'),
                ),
              ),
              Image.asset('assets/images/design.png'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRating() async {
    // Validate the rating
    if (_rating == 0) {
      final snackBar = SnackBar(content: Text('Please select a rating'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Create a ReviewModel from the rating and current time
    final review = ReviewModel(score: _rating.toString());

    // Send the review to the server
    String url =
        '${API.BASE_URL}/flutterapi/src/addreview.php?isAdd=true&score=${review.score}';

    try {
      await Dio().get(url);

      // Update the state and reset the rating
      setState(() {
        reviewModels.add(review);
        _rating = 0;
      });

      // Show a SnackBar to indicate success

      // Show a pop-up dialog to indicate success
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Success',
              style: TextStyle(color: Colors.blue.shade200),
            ),
            content: Text(
              'Review successfully!',
              style: TextStyle(color: Colors.blue.shade200),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle any errors that occur during the API call
      final snackBar = SnackBar(
          content: Text('Failed to submit review. Please try again later.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
