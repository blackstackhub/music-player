import 'dart:convert';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.blackstackhub/musicplayer');

class Musics {
  String id;
  int size;
  String data;
  String album;
  String title;
  String artist;
  int duration;
  bool play;
  String image;

  Musics(
      {required this.id,
      required this.size,
      required this.data,
      required this.album,
      required this.title,
      required this.artist,
      required this.duration,
      required this.image,
      this.play = false});
  factory Musics.fromMap(Map<String, dynamic> json) => Musics(
        id: json["id"],
        size: int.parse(json["size"]),
        data: json["data"],
        album: json["album"],
        title: json["title"],
        artist: json["artist"],
        image: json["image"] ?? "",
        duration: int.parse(json["duration"]),
      );
}

Future<String> permission() async {
  String answer = "yes";
  await platform.invokeMethod("checkPermission").then(
    (v) async {
      if (v == "PERMISSIONS_GRANTED") {
        answer = "yes";
      } else if (v != "PERMISSIONS_GRANTED") {
        await platform.invokeMethod("requestPermission").then(
          (value) {
            if (value == "PERMISSIONS_GRANTED") {
              answer = "yes";
            } else {
              answer = "no";
            }
          },
        );
      } else if (v == "PERMISSIONS_DENIED") {
        await platform.invokeMethod("requestPermission").then(
          (value) {
            if (value == "PERMISSIONS_GRANTED") {
              answer = "yes";
            } else {
              answer = "no";
            }
          },
        );
      } else if (v == "PERMISSION_DENIED_PERMANENTLY") {
        answer = "no";
      }
    },
  );

  return answer;
}

Future<List<Musics>> getOfflineMusics() async {
  List<Musics> musics = [];
  await permission().then(
    (value) async {
      //if (value == "yes") {
      await platform.invokeMethod('getAllAudioFiles').then(
        (value) {
          var result = value;
          for (int i = 0; i < result.length; i++) {
            result[i] = result[i].replaceAll("{", "{\"");
            result[i] = result[i].replaceAll("}", "\"}");
            result[i] = result[i].replaceAll("=", "\" : \"");
            result[i] = result[i].replaceAll("_,", "_");
            result[i] = result[i].replaceAll(",_", "_");
            result[i] = result[i].replaceAll("-,", "-");
            result[i] = result[i].replaceAll(",-", "-");
            result[i] = result[i].replaceAll(", ", "\" , \"");
            result[i] = result[i].replaceAll("\" ", "\"");
          }
          for (int i = 0; i < result.length; i++) {
            var ms = json.decode(result[i]);
            var mus = Musics.fromMap(ms);
            musics.add(mus);
          }
        },
      );
      //}
    },
  );

  return musics;
}

Future<List> getOfflineAudioAlbums() async {
  List albums = [];
  await permission().then(
    (value) async {
      //if (value == "yes") {
      await platform.invokeMethod('getAudioAlbums').then(
        (value) {
          var album = value.toSet().toList();
          for (int i = 0; i < album.length; i++) {
            albums.add(album[i]);
          }
        },
      );
      //}
    },
  );

  return albums;
}

Future<List> getOnlineAudioAlbums() async {
  List albums = [];
  return albums;
}

Future<List<Musics>> getOnlineMusics() async {
  List<Musics> musics = [];
  await platform.invokeMethod('getAllAudioFiles').then(
    (value) {
      var result = value;
      for (int i = 0; i < result.length; i++) {
        result[i] = result[i].replaceAll("{", "{\"");
        result[i] = result[i].replaceAll("}", "\"}");
        result[i] = result[i].replaceAll("=", "\" : \"");
        result[i] = result[i].replaceAll("_,", "_");
        result[i] = result[i].replaceAll(",_", "_");
        result[i] = result[i].replaceAll("-,", "-");
        result[i] = result[i].replaceAll(",-", "-");
        result[i] = result[i].replaceAll(", ", "\" , \"");
        result[i] = result[i].replaceAll("\" ", "\"");
      }
      for (int i = 0; i < result.length; i++) {
        var ms = json.decode(result[i]);
        var mus = Musics.fromMap(ms);
        musics.add(mus);
      }
    },
  );
  return musics;
}
