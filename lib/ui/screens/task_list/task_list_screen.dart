import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/common_colors.dart';
import '../../../providers/task_provider.dart';
import '../../../routes/app_routes.dart';
import '../../widgets/task_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/task_filter_bar.dart';
import '../../widgets/task_status_bar.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${getGreetingMessage()}, Alex',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: AppColors.subTitle
                    ),
                  ),const Text(
                    'My Tasks',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28
                    ),
                  )
                ],
              ),
              centerTitle: false,
              elevation: 0,
              backgroundColor: AppColors.background,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(AppAssets.profileImage),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
            floatingActionButton: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primary,
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x332563EB),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.addEditTask);
                },
                child: const Icon(Icons.add, size: 28, color: Colors.white),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TaskStatusBar(
                    pendingCount: context.watch<TaskProvider>().pendingCount,
                    dueTodayCount: context.watch<TaskProvider>().dueTodayCount,
                      yesterdayCount: context.watch<TaskProvider>().yesterdayCount,
                  ),
                ),
                const TaskFilterBar(),
                const SizedBox(height: 8),
                Expanded(
                  child: Consumer<TaskProvider>(
                    builder: (context, provider, _) {
                      final tasks = provider.filteredTasks;

                      if (tasks.isEmpty) {
                        return EmptyState(
                          image: AppAssets.noTask,
                          title: provider.filter==TaskFilter.all?'No tasks yet':"No ${provider.filter==TaskFilter.completed?"Completed":"Pending"} tasks",
                          subtitle: provider.filter==TaskFilter.all?'Tap + to add your first task':"Tap + to add your task",
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: tasks.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 0),
                        itemBuilder: (context, index) {
                        final task = tasks[index];

                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 400 + (index * 80)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: TaskItemCard(
                            title: task.title,
                            subtitle: task.description,
                            status: task.isCompleted ? 'Completed' : 'Pending',
                            dueDate: task.dueDate,
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.addEditTask,
                                arguments: task,
                              );
                            },
                            onDelete: () async {
                              final isConfirmed = await showDeleteConfirmationDialog(context);

                              if (isConfirmed == true) {
                                context.read<TaskProvider>().deleteTask(task.id);
                              }
                            },
                            onMarkCompleted: () {
                              context.read<TaskProvider>().toggleTaskStatus(task);
                              _confettiController.play();
                            },
                          ),
                        );
                      },

                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }


  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Exit App'),
          content: const Text(
            'Are you sure you want to exit?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Exit',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );

    return shouldExit ?? false;
  }

}

Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: const Text(
          'Delete Task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: AppColors.subTitle),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Cancel
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.subTitle),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true); // Confirm
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}


