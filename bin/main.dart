import 'package:prompter_sg/prompter_sg.dart';
import 'dart:io';
import 'package:converter/src/converter.dart';

void main(List<String> args) {
  final prompter = Prompter();
  final choice = prompter.askBinary('Are you here to convert an image?');
  if (!choice) {
    exit(0);
  }
  final format = prompter.askMultiple('Select format:', buildFormatOptions());
  final selectedFile =
      prompter.askMultiple('Select an image to convert', buildFileOptions());
  final newPath = convertImage(selectedFile, format);
  final shouldOpen = prompter.askBinary('Open the image?');
  if (shouldOpen) {
    Process.run('open', [newPath]);
  }
}

List<Option> buildFormatOptions() {
  return [
    Option('Convert to jpeg', 'jpeg'),
    Option('Convert to png', 'png'),
  ];
}

List<Option> buildFileOptions() {
  final currentDirectory = Directory.current;
  return currentDirectory.listSync().where((entity) {
    return FileSystemEntity.isFileSync(entity.path) &&
        entity.path.contains(new RegExp(r'\.(png|jpg|jpeg)'));
  }).map((entity) {
    final filename = entity.path.split(Platform.pathSeparator).last;
    return Option(filename, entity);
  }).toList();
}
