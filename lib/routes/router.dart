import 'package:un/models/visit.dart';
import 'package:un/pages/privates/cameraBanner.dart';
import 'package:un/pages/privates/cameraVoucher.dart';
import 'package:un/pages/privates/comentary.dart';
import 'package:un/pages/privates/home.dart';
import 'package:un/pages/privates/information_agent.dart';
import 'package:un/pages/privates/information_agent_secondary.dart';
import 'package:un/pages/privates/procces_visit.dart';
import 'package:un/pages/privates/question.dart';
import 'package:un/pages/privates/question_four.dart';
import 'package:un/pages/privates/question_one.dart';
import 'package:un/pages/privates/question_three.dart';
import 'package:un/pages/privates/question_two.dart';
import 'package:un/pages/privates/state_agent.dart';
import 'package:un/pages/privates/visit_agente.dart';
import 'package:un/pages/publics/login.dart';
import 'package:un/pages/publics/undefined.dart';

import 'package:flutter/material.dart';
import '../pages/privates/location.dart';
import 'routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  bool? isDown;
  Visit? visit;
  String? username;
  String? message;
  String? codeStore;
  // if(settings.arguments is bool){
  //   isDown = (settings.arguments==null) ? null:settings.arguments;
  // }
  // if(settings.arguments is bool){
  //   isDown = (settings.arguments==null) ? null:settings.arguments;
  // }
  Map<dynamic, dynamic>? obj = settings.arguments as Map?;
  if (obj != null) {
    // Param of Visit
    if (obj['visit'] != null) {
      visit = obj['visit'];
    }
    // Param of stateStore
    if (obj['stateStore'] != null) {
      isDown = obj['stateStore'];
    }
    if (obj['username'] != null) {
      username = obj['username'];
    }
    if (obj['message'] != null) {
      message = obj['message'];
    }
    if (obj['codeStore'] != null) {
      codeStore = obj['codeStore'];
    }
  }

  switch (settings.name) {
    case LoginViewRoute:
      return MaterialPageRoute(
          builder: (context) => LoginView(message: message ?? ''));
    case HomeViewRoute:
      return MaterialPageRoute(
          builder: (context) => HomeView(username: username ?? ''));
    case VisitAgentRoute:
      return MaterialPageRoute(builder: (context) => VisitAgent());
    case StateAgentViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              StateAgentView(isDown: isDown ?? false, codeStore: codeStore ?? '', visitReceived: visit ?? Visit()));
    case ProccesVisitViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              ProccesVisitView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case InformationAgentViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              InformationAgentView(codeStore: codeStore ?? '', isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case InformationAgentSecondaryViewRoute:
      return MaterialPageRoute(
          builder: (context) => InformationAgentSecondaryView(
              codeStore: codeStore ?? '', isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case QuestionOneViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              QuestionOneView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case QuestionTwoViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              QuestionTwoView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case QuestionThreeViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              QuestionThreeView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case QuestionFourViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              QuestionFourView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case LocationAgentViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              LocationAgentView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case RegisterPhotoBannerViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              RegisterPhotoBannerView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case RegisterPhotoVoucherViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              RegisterPhotoVoucherView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case ComentaryViewRoute:
      return MaterialPageRoute(
          builder: (context) =>
              ComentaryView(isDown: isDown ?? false, visitReceived: visit ?? Visit()));
    case QuestionViewRoute:
      return MaterialPageRoute(builder: (context) => QuestionView());
    default:
      return MaterialPageRoute(builder: (context) => UndefinedView());
  }
}
