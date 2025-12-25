import 'dart:io';

import 'package:circle_marker/viewModels/map_detail_view_model.dart';
import 'package:circle_marker/views/widgets/editable_image.dart';
import 'package:circle_marker/views/widgets/editable_label.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class CircleBottomSheet extends ConsumerWidget {
  const CircleBottomSheet(
    this.mapId,
    this.selectedCircleId, {
    required this.circleId,
    super.key,
  });

  final int mapId;
  final int circleId;
  final int? selectedCircleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapDetailViewModelProvider(mapId));
    final viewModel = ref.read(mapDetailViewModelProvider(mapId).notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return switch (state) {
      AsyncData(:final value)
          when value.circles.any((c) => c.circleId == circleId) =>
        Builder(
          builder: (context) {
            final circle = value.circles.firstWhere(
              (c) => c.circleId == circleId,
            );

            final ImageProvider circleImage =
                circle.imagePath != null && File(circle.imagePath!).existsSync()
                    ? FileImage(File(circle.imagePath!))
                    : const AssetImage('assets/no_image.png');

            final ImageProvider menuImage =
                circle.menuImagePath != null &&
                    File(circle.menuImagePath!).existsSync()
                ? FileImage(File(circle.menuImagePath!))
                : const AssetImage('assets/no_image.png');
            return GestureDetector(
              behavior: HitTestBehavior.translucent, // タップを透過して検知
              onTap: () {
                FocusScope.of(context).unfocus(); // フォーカスを外す
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.3,
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CircleName: '),
                                EditableLabel(
                                  initialText: circle.circleName ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onSubmit: (value) async {
                                    if (value.isEmpty) {
                                      return;
                                    }
                                    await viewModel.updateCircleName(
                                      circle.circleId!,
                                      value,
                                    );
                                  },
                                ),
                                const Gap(8),
                                const Text('Space No:'),
                                EditableLabel(
                                  initialText: circle.spaceNo ?? 'No Space No',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onSubmit: (value) async {
                                    if (value.isEmpty) {
                                      return;
                                    }
                                    await viewModel.updateCircleSpaceNo(
                                      circle.circleId!,
                                      value,
                                    );
                                  },
                                ),
                                const Gap(8),
                                const Text('Note:'),
                                EditableLabel(
                                  initialText: circle.note ?? 'No Note',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: null,
                                  onSubmit: (value) async {
                                    if (value.isEmpty) {
                                      return;
                                    }
                                    await viewModel.updateCircleNote(
                                      circle.circleId!,
                                      value,
                                    );
                                  },
                                ),
                                const Gap(8),
                                const Text('Description:'),
                                EditableLabel(
                                  initialText:
                                      circle.description ?? 'No Description',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: null,
                                  onSubmit: (value) async {
                                    if (value.isEmpty) {
                                      return;
                                    }
                                    await viewModel.updateCircleDescription(
                                      circle.circleId!,
                                      value,
                                    );
                                  },
                                ),
                                const Gap(8),
                                const Text('Circle Thumbnail (Map):'),
                                const Gap(4),
                                EditableImage(
                                  image: circleImage,
                                  onChange: (value) async {
                                    if (value.isEmpty) {
                                      return;
                                    }
                                    await viewModel.updateCircleImage(
                                      circle.circleId!,
                                      value,
                                    );
                                  },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PhotoView(imageProvider: circleImage),
                                      ),
                                    );
                                  },
                                ),
                                const Gap(8),
                                const Text('Menu/Product Image:'),
                                const Gap(4),
                                EditableImage(
                                  image: menuImage,
                                  onChange: (value) async {
                                    if (value.isEmpty) {
                                      return;
                                    }
                                    await viewModel.updateCircleMenuImage(
                                      circle.circleId!,
                                      value,
                                    );
                                  },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PhotoView(imageProvider: menuImage),
                                      ),
                                    );
                                  },
                                ),
                                const Gap(8),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await viewModel.removeCircle(
                                      selectedCircleId!,
                                    );

                                    if (!context.mounted) {
                                      return;
                                    }
                                    
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    '削除',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: circle.isDone == 1,
                                  onChanged: (value) async {
                                    await viewModel.updateIsDone(
                                      circle.circleId!,
                                      value ?? false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      AsyncError(:final error) => Center(
        child: Text('Something went wrong: $error'),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
