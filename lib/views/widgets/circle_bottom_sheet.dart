import 'dart:io';

import 'package:circle_marker/viewModels/map_detail_view_model.dart';
import 'package:circle_marker/views/widgets/editable_image.dart';
import 'package:circle_marker/views/widgets/editable_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class CircleBottomSheet extends ConsumerWidget {
  final int mapId;
  final int circleId;
  final int? selectedCircleId;

  const CircleBottomSheet(
    this.mapId,
    this.selectedCircleId, {
    required this.circleId,
    super.key,
  });

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

            final ImageProvider menuImage =
                circle.menuImagePath != null &&
                    File(circle.menuImagePath!).existsSync()
                ? FileImage(File(circle.menuImagePath!))
                : AssetImage('assets/no_image.png');
            return Padding(
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
                              Text('CircleName: '),
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
                              Gap(8),
                              Text('Space No:'),
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
                              Gap(8),
                              Text('Note:'),
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
                              Gap(8),
                              Text('Description:'),
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
                              Gap(8),
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
                              Gap(8),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await viewModel.removeCircle(
                                    selectedCircleId!,
                                  );
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
