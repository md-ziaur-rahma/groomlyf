import 'package:flutter/material.dart';
import 'package:groomlyfe/models/categories.dart';
import 'package:groomlyfe/models/product.dart';
import 'package:groomlyfe/models/video.dart';
import 'package:video_player/video_player.dart';

List<Video> user_videos = [];

//device height and width
double device_width = 0.0;
double device_height = 0.0;

//animation variables
Color animation_color = Colors.white;
double animation_opacity = 0.0;

//background video controller
VideoPlayerController? background_video_controller;

//videos list info
late List<Categories> categories;
String? uploaded_video_category;
String? uploaded_video_title;
String? uploaded_video_description;
String? uploaded_video_tag;

//local user info
String? user_id;
String? user_firstname;
String? user_lastname;
String? user_email;
String? user_image_url;
String? user_create_at;

//tab manage variable
int tab_index = 0;
String title = "VENUE";

// for shop
bool isRegister = false;

bool agoraFlag = true;

//video search variables
List<String> searchData = [
  '',
  'Gaming',
  'Fashion',
  'Music',
  'Hair',
  'Sports',
  'Health and Fitness',
  'DIY',
  'Other'
];

//ad controller seconds
int ads_duration_seconds = 6;

//shop tab cart contain product
List<Product?> cartProducts = [];

//youtube video controller
var youtube_video_controller;
