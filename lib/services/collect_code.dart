import 'dart:io';

void main() async {
  final output = File('all_code.txt');
  final sink = output.openWrite();

  Future<void> processDirectory(Directory dir) async {
    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final relativePath = entity.path.replaceFirst('${Directory.current.path}${Platform.pathSeparator}', '');
        sink.writeln('==== $relativePath ====');
        sink.writeln(await entity.readAsString());
        sink.writeln('\n');
      }
    }
  }

  final libDir = Directory('lib');
  if (await libDir.exists()) {
    await processDirectory(libDir);
    print('✅ كود المشروع اتجمع في all_code.txt');
  } else {
    print('❌ مجلد lib مش موجود!');
  }

  await sink.flush();
  await sink.close();
}
