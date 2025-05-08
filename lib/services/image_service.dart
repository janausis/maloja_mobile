import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maloja_mobile/widgets/app_snackbar.dart';
import 'package:maloja_mobile/widgets/chart_widgets.dart';

class ImageService {

  static String buildImageUrl(String selectedUrl, int artistId, ChartType type) {
    Map<ChartType, String> maps = {
      ChartType.ARTIST: "artist_id",
      ChartType.ALBUM: "album_id",
      ChartType.TRACK: "track_id"
    };

    String? id = maps[type];

    // Remove trailing slashes from the URL
    final sanitizedUrl = selectedUrl.replaceAll(RegExp(r'\/+$'), '');
    return '$sanitizedUrl/image?$id=$artistId';
  }

  static Widget buildImage(int artistId, String selectedUrl, ChartType idSelector, {Widget? placeholder, Widget? errorWidget}) {
   return buildImageWithResolution(artistId, 300, selectedUrl, idSelector, placeholder: placeholder, errorWidget: errorWidget);
  }

  static Widget buildImageWithResolution(int artistId, int res, String selectedUrl, ChartType idSelector, {Widget? placeholder, Widget? errorWidget}) {
    return CachedNetworkImage(
      imageUrl: buildImageUrl(selectedUrl, artistId, idSelector),
      fadeInDuration: Duration.zero,
      cacheKey: "${artistId}_${idSelector.name}_$res",
      memCacheHeight: res,
      memCacheWidth: res,
      maxHeightDiskCache: res,
      maxWidthDiskCache: res,
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
      placeholder: (context, url) => placeholder ?? const SizedBox(),
      errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error),
    );

  }

  static Widget buildArtistImage(int artistId, String selectedUrl, {Widget? placeholder, Widget? errorWidget}) {
    return buildImage(artistId, selectedUrl, ChartType.ARTIST, placeholder: placeholder, errorWidget: errorWidget);
  }

  static Widget buildAlbumImage(int albumId, String selectedUrl, {Widget? placeholder, Widget? errorWidget}) {
    return buildImage(albumId, selectedUrl, ChartType.ALBUM, placeholder: placeholder, errorWidget: errorWidget);
  }

  static Widget buildTrackImage(int albumId, String selectedUrl, {Widget? placeholder, Widget? errorWidget}) {

    return buildImage(albumId, selectedUrl, ChartType.TRACK, placeholder: placeholder, errorWidget: errorWidget);
  }


}
