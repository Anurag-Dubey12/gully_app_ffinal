import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FallbackImageProvider extends ImageProvider<FallbackImageProvider> {
  final String url;
  final String fallbackAssetPath;

  FallbackImageProvider(this.url, this.fallbackAssetPath);

  @override
  Future<FallbackImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<FallbackImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadBuffer(
      FallbackImageProvider key, DecoderBufferCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<FallbackImageProvider>('Image key', key);
      },
    );
  }

  Future<ui.Codec> _loadAsync(
      FallbackImageProvider key, DecoderBufferCallback decode) async {
    try {
      final http.Response response = await http.get(Uri.parse(key.url));
      if (response.statusCode != 200) {
        return _loadFallbackImage(decode);
      }
      if(response.statusCode ==403){
        return _loadFallbackImage(decode);
      }
      final Uint8List bytes = response.bodyBytes;
      if (bytes.lengthInBytes == 0) {
        throw Exception('NetworkImage is an empty file');
      }
      return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
    } catch (e) {
      return _loadFallbackImage(decode);
    }
  }

  Future<ui.Codec> _loadFallbackImage(DecoderBufferCallback decode) async {
    final ByteData data = await rootBundle.load(fallbackAssetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is FallbackImageProvider &&
        other.url == url &&
        other.fallbackAssetPath == fallbackAssetPath;
  }

  @override
  int get hashCode => Object.hash(url, fallbackAssetPath);
}
