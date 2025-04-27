import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ImageService {

  static String buildImageUrl(String selectedUrl, int artistId) {
    // Remove trailing slashes from the URL
    final sanitizedUrl = selectedUrl.replaceAll(RegExp(r'\/+$'), '');
    return '$sanitizedUrl/image?artist_id=$artistId';
  }

  static Future<String> getArtistImageUrlByIdAsync(int artistId) async {
    try {
      final box = await Hive.openBox('settings');
      final selectedUrl = box.get('selectedUrl', defaultValue: '');


      return buildImageUrl(selectedUrl, artistId);
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error retrieving artist image URL: $e');
      return "";
    }
  }

  static FutureBuilder<String> getArtistImageById(int artistId) {
    return FutureBuilder<String>(
      future: getArtistImageUrlByIdAsync(artistId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Icon(Icons.error);
        } else {
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          );
        }
      },
    );
  }

  static Widget buildArtistImage(int artistId, {Widget? placeholder, Widget? errorWidget}) {
    return FutureBuilder<String>(
      future: ImageService.getArtistImageUrlByIdAsync(artistId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ?? Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return errorWidget ?? Icon(Icons.error);
        } else {
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => placeholder ?? Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => errorWidget ?? Icon(Icons.error),
          );
        }
      },
    );
  }


}
