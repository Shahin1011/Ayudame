import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../viewmodels/event_manager_viewmodel.dart';

class EventFaqScreen extends StatefulWidget {
  const EventFaqScreen({super.key});

  @override
  State<EventFaqScreen> createState() => _EventFaqScreenState();
}

class _EventFaqScreenState extends State<EventFaqScreen> {
  int? _expandedIndex;
  final EventManagerViewModel _viewModel = Get.put(EventManagerViewModel());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchFaq();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "FAQ"),
      backgroundColor: AppColors.bgColor,
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_viewModel.faqList.isEmpty) {
          return const Center(child: Text("No FAQ found."));
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _viewModel.faqList.length,
                itemBuilder: (context, index) {
                  final faq = _viewModel.faqList[index];
                  final isExpanded = _expandedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(
                            faq['question'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedIndex = expanded ? index : null;
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  faq['answer'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
