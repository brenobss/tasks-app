import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/screens/create_task_screen.dart';
import 'package:task_app/screens/edit_task_screen.dart';
import 'package:task_app/services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _filter = 'Todas';
  String _userInitials = '';

  final List<String> _filters = ['Todas', 'Pendentes', 'Concluídas'];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadUserInitials();
  }

  void _loadUserInitials() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? '';
    if (name.isNotEmpty) {
      final parts = name.trim().split(' ');
      setState(() {
        _userInitials = parts.length >= 2
            ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
            : parts[0][0].toUpperCase();
      });
    }
  }

  void _loadTasks() async {
    final tasks = await _taskService.findAllTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  List<Task> get _filteredTasks {
    if (_filter == 'Pendentes') {
      return _tasks.where((t) => !t.isCompleted).toList();
    }
    if (_filter == 'Concluídas') {
      return _tasks.where((t) => t.isCompleted).toList();
    }
    return _tasks;
  }

  int get _pendingCount => _tasks.where((t) => !t.isCompleted).length;

  void _completeTask(Task task) async {
    final success = await _taskService.completeTask(task);
    if (success) {
      setState(() {
        final index = _tasks.indexOf(task);
        _tasks[index] = task.copyWith(status: 'COMPLETED');
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao concluir tarefa')));
    }
  }

  void _uncompleteTask(Task task) async {
    final success = await _taskService.uncompleteTask(task);
    if (success) {
      setState(() {
        final index = _tasks.indexOf(task);
        _tasks[index] = task.copyWith(status: 'PENDING');
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao desmarcar tarefa')));
    }
  }

  void _deleteTask(Task task) async {
    final success = await _taskService.deleteTask(task.id!);
    if (!success) {
      _loadTasks();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao deletar tarefa')));
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Deletar tarefa'),
            content: const Text('Tem certeza que deseja deletar essa tarefa?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Deletar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minhas tarefas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '$_pendingCount pendentes hoje',
              style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFCCFF00),
              child: Text(
                _userInitials.isEmpty ? '?' : _userInitials,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilters(),
                Expanded(child: _buildList()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
          );
          _loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _filter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _filter = filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFCCFF00)
                      : const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.black : const Color(0xFFAAAAAA),
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildList() {
    final tasks = _filteredTasks;
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma tarefa aqui',
          style: TextStyle(color: Color(0xFFAAAAAA)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredTasks.length,
      itemBuilder: (context, index) {
        final task = _filteredTasks[index];
        return Dismissible(
          key: Key(task.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) => _showDeleteConfirmation(),
          onDismissed: (_) => _deleteTask(task),
          child: _buildTaskCard(task),
        );
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    String formattedDate = 'Sem data';
    if (task.createdAt != null && task.createdAt!.isNotEmpty) {
      int? timestamp = int.tryParse(task.createdAt!);

      if (timestamp != null) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        formattedDate =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } else {
        // Fallback caso a API mande no formato ISO
        DateTime? date = DateTime.tryParse(task.createdAt!);
        if (date != null) {
          formattedDate =
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
        }
      }
    }

    return GestureDetector(
      onTap: task.isCompleted
          ? null
          : () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(task: task),
                ),
              );
              _loadTasks();
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: task.isCompleted
                  ? (_) => _uncompleteTask(task)
                  : (_) => _completeTask(task),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted
                          ? const Color(0xFFAAAAAA)
                          : Colors.white,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                ],
              ),
            ),
            _buildStatusBadge(task),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Task task) {
    final isCompleted = task.isCompleted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF2A3D2A) : const Color(0xFF3D3A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? 'Feita' : 'Pendente',
        style: TextStyle(
          fontSize: 11,
          color: isCompleted ? Colors.greenAccent : const Color(0xFFCCFF00),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
