import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maloja_mobile/widgets/app_snackbar.dart';

class ImageService {

  static String buildImageUrl(String selectedUrl, int artistId, String id) {
    // Remove trailing slashes from the URL
    final sanitizedUrl = selectedUrl.replaceAll(RegExp(r'\/+$'), '');
    return '$sanitizedUrl/image?$id=$artistId';
  }

  static Widget buildImage(int artistId, String selectedUrl, String idSelector, {Widget? placeholder, Widget? errorWidget}) {
   return CachedNetworkImage(
            imageUrl: buildImageUrl(selectedUrl, artistId, idSelector),
            fadeInDuration: Duration.zero,
            memCacheHeight: 500,
            memCacheWidth: 500,
            maxHeightDiskCache: 500,
            maxWidthDiskCache: 500,
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
            placeholder: (context, url) => placeholder ?? Center(child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(),)),
            errorWidget: (context, url, error) => errorWidget ?? Icon(Icons.error),
          );

  }

  static Widget buildArtistImage(int artistId, String selectedUrl, {Widget? placeholder, Widget? errorWidget}) {
    return buildImage(artistId, selectedUrl, "artist_id", placeholder: placeholder, errorWidget: errorWidget);
  }

  static Widget buildAlbumImage(int albumId, String selectedUrl, {Widget? placeholder, Widget? errorWidget}) {
    return buildImage(albumId, selectedUrl, "album_id", placeholder: placeholder, errorWidget: errorWidget);
  }

  static Widget buildTrackImage(int albumId, String selectedUrl, {Widget? placeholder, Widget? errorWidget}) {

    return buildImage(albumId, selectedUrl, "track_id", placeholder: placeholder, errorWidget: errorWidget);
  }


}
