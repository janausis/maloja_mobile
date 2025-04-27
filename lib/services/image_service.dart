import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ImageService {

  static String buildImageUrl(String selectedUrl, int artistId, String id) {
    // Remove trailing slashes from the URL
    final sanitizedUrl = selectedUrl.replaceAll(RegExp(r'\/+$'), '');
    return '$sanitizedUrl/image?$id=$artistId';
  }

  static Future<String> getArtistImageUrlByIdAsync(int artistId, String id) async {
    try {
      final box = await Hive.openBox('settings');
      final selectedUrl = box.get('selectedUrl', defaultValue: '');


      return buildImageUrl(selectedUrl, artistId, id);
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error retrieving artist image URL: $e');
      return "";
    }
  }

  static Widget buildArtistImage(int artistId, {Widget? placeholder, Widget? errorWidget}) {
    return FutureBuilder<String>(
      future: ImageService.getArtistImageUrlByIdAsync(artistId, "artist_id"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return errorWidget ?? Icon(Icons.error);
        } else {
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => placeholder ?? SizedBox(),
            errorWidget: (context, url, error) => errorWidget ?? Icon(Icons.error),
          );
        }
      },
    );
  }

  static Widget buildAlbumImage(int albumId, {Widget? placeholder, Widget? errorWidget}) {
    return FutureBuilder<String>(
      future: ImageService.getArtistImageUrlByIdAsync(albumId,"album_id"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return errorWidget ?? Icon(Icons.error);
        } else {
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => placeholder ?? SizedBox(),
            errorWidget: (context, url, error) => errorWidget ?? Icon(Icons.error),
          );
        }
      },
    );
  }


}
