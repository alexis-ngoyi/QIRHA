import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

void downloadFile(String url) async {
  Dio dio = Dio();
  try {
    var dir = await getTemporaryDirectory();
    String savePath = "${dir.path}/downloaded_file.pdf";

    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print("${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );

    print("Download complete");
  } catch (e) {
    print("Error during download: $e");
  }
}
