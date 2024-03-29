import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:time_machine/time_machine.dart';
import 'package:web_apk_news/constant/constants.dart';
import 'package:web_apk_news/models/publicationModel.dart';
import 'package:web_apk_news/shared/imageCard.dart';
import 'clientTokenApiService.dart';

class PublicationApiService {
  Future<List<ImageListCard>> getAll([bool present]) async {
    Dio _dio = new Dio();
    List<ImageListCard> result = [];

    try {
      var token = await ClientTokenApiService().getToken();

      Response response = await _dio.get('$URL_API/publicaciones',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          queryParameters: {'flag': true});

      if (response.statusCode == 200) {
        var responseData = (response.data['publicaciones'] as List)
            .map((news) => PublicationModel.fromJson(news))
            .toList();

        responseData.asMap().forEach((key, value) {
          result.add(
            new ImageListCard(
              value.title,
              value.datePublication,
              this.differenceDate(value.dateFullPublication),
              (value.view),
              value.publicationImageModel
                  .map((e) => '$LOCALHOST' + e.urlImage)
                  .toList(),
              (value.idPublication),
            ),
          );
        });
        return result;
      } else {
        throw new Exception("Image publication failed ...");
      }
    } on DioError catch (ex) {
      throw new Exception(ex);
    }
  }

  Future<bool> setViews(String views, String idPublication) async {
    Dio _dio = new Dio();

    try {
      int viewParse = int.parse(views);
      var token = await ClientTokenApiService().getToken();
      var params = {"views": viewParse += 1, "id_publicacion": idPublication};

      Response response = await _dio.post('$URL_API/publicaciones/view',
          data: params,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            'Authorization': 'Bearer $token'
          }));

      if (response.statusCode == 200) {
        return Future.value(true);
      } else {
        throw new Exception("Failed update views ...");
      }
    } on DioError catch (ex) {
      throw new Exception(ex);
    }
  }

  String differenceDate(String date) {
    try {
      LocalDateTime dateTimeNow = LocalDateTime.now();
      LocalDateTime dateTimePublication =
          LocalDateTime.dateTime(DateTime.parse(date));

      print(
          'Date Time Now ${dateTimeNow}  Date Time Publication ${dateTimePublication} ');

      Period diff = dateTimePublication.periodSince(dateTimeNow);
      print(
          "years: ${diff.years}; months: ${diff.months}; days: ${diff.days}; hours: ${diff.hours}; minutes: ${diff.minutes}; seconds: ${diff.seconds}");

      if (diff.months > 0 && diff.weeks >= 0) {
        return "${diff.months} mes ${diff.weeks} semana";
      } else if (diff.months > 0 && diff.days >= 0) {
        return "${diff.months} mes ${diff.days} días";
      } else if (diff.weeks > 0 && diff.days > 0) {
        return "${diff.weeks} semana ${diff.days} días";
      } else if (diff.days > 0 && diff.hours > 0) {
        return "${diff.days} días ${diff.hours} horas";
      } else if (diff.hours > 0 && diff.minutes > 0) {
        return "${diff.hours} horas ${diff.minutes} minutos";
      } else if (diff.minutes > 0) {
        return "${diff.minutes} minutos";
      } else {
        return "1 min";
      }
    } on Exception catch (ex) {
      return "10 min";
    }
  }
}
