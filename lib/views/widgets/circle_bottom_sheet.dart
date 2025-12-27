import 'dart:io';

import 'package:circle_marker/viewModels/circle_view_model.dart';
import 'package:circle_marker/views/widgets/editable_image.dart';
import 'package:circle_marker/views/widgets/editable_label.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class CircleBottomSheet extends ConsumerWidget {
  const CircleBottomSheet(
    this.mapId,
    this.selectedCircleId, {
    required this.circleId,
    required this.width,
    required this.height,
    this.onDelete,
    super.key,
  });

  final int mapId;
  final int circleId;
  final double width;
  final double height;
  final int? selectedCircleId;
  final Function(int circleId)? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circleAsync = ref.watch(circleViewModelProvider(circleId));
    final circleViewModel = ref.read(
      circleViewModelProvider(circleId).notifier,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return circleAsync.when(
      data: (circle) {
        final ImageProvider menuImage =
            circle.menuImagePath != null &&
                File(circle.menuImagePath!).existsSync()
            ? FileImage(File(circle.menuImagePath!))
            : const AssetImage('assets/no_image.png');

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                SizedBox(
                  width: screenWidth * width,
                  height: screenHeight * height,
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
                                await circleViewModel.updateName(value);
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
                                await circleViewModel.updateSpaceNo(value);
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
                                await circleViewModel.updateNote(value);
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
                                await circleViewModel.updateDescription(value);
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
                                await circleViewModel.updateMenuImage(value);
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
                                await onDelete?.call(circle.circleId!);

                                if (!context.mounted) {
                                  return;
                                }

                                context.pop();
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
                                await circleViewModel.toggleDone();
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Something went wrong: $error')),
    );
  }
}
