import 'package:flutter/material.dart';

class ReportDialogHelper {
  static BuildContext? _loaderContext;

  /// 🔄 Loader
  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (ctx) {
        _loaderContext = ctx;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// ❌ Close Loader safely
  static void _closeLoader() {
    if (_loaderContext != null) {
      Navigator.of(_loaderContext!, rootNavigator: true).pop();
      _loaderContext = null;
    }
  }

  /// 🚩 Report Dialog (PUBLIC METHOD)
  static void showReportDialog(BuildContext parentContext) {
    List<String> selectedReasons = [];
    TextEditingController otherController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isOtherSelected = selectedReasons.contains('Other');

            Widget reasonTile(String title) {
              return CheckboxListTile(
                title: Text(title),
                value: selectedReasons.contains(title),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      selectedReasons.add(title);
                    } else {
                      selectedReasons.remove(title);
                    }
                  });
                },
              );
            }

            return AlertDialog(
              title: const Text(
                'Report This!',
                style: TextStyle(color: Colors.black),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Reason',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    reasonTile('Nudity or Sexual Content'),
                    reasonTile('Hate Speech or Violence'),
                    reasonTile('Harassment or Bullying'),
                    reasonTile('Illegal Activities'),
                    reasonTile('Other'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: otherController,
                       style: const TextStyle(
                        color: Colors.black, // 👈 typed text color
                      ),
                      enabled: isOtherSelected,
                      decoration: InputDecoration(
                        hintText: 'Type Reason',
                        filled: true,
                        fillColor:
                            isOtherSelected
                                ? Colors.white
                                : Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      selectedReasons.isEmpty
                          ? null
                          : () async {
                            // 1️⃣ Close report dialog
                            Navigator.pop(dialogContext);

                            // 2️⃣ Show loader
                            _showLoadingDialog(parentContext);

                            // 3️⃣ Fake delay / API wait
                            await Future.delayed(const Duration(seconds: 2));

                            // 4️⃣ Close loader
                            _closeLoader();

                            // 5️⃣ Success dialog
                            showDialog(
                              context: parentContext,
                              useRootNavigator: true,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text(
                                    'Report Submitted',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: const Text(
                                    'Your report will be reviewed by admin within 24 hours, but it may take longer depending on the volume of reports we receive. Thank you for helping us keep our community safe.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(
                                                parentContext,
                                                rootNavigator: true,
                                              ).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );

                            debugPrint('Reasons: $selectedReasons');
                            debugPrint('Other: ${otherController.text}');
                          },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
