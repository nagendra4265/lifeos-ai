import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/core/models/note.dart';
import 'package:flutter_application_1/core/models/expense.dart';
import 'package:flutter_application_1/core/models/task.dart';
import 'package:flutter_application_1/core/models/reminder.dart';
import 'package:flutter_application_1/core/models/contact.dart';
import 'package:flutter_application_1/core/models/document.dart';
import 'package:flutter_application_1/core/models/health_metric.dart';
import 'package:flutter_application_1/core/models/password_entry.dart';
import 'package:flutter_application_1/core/models/journal_entry.dart';
import 'package:flutter_application_1/core/models/memory.dart';

import 'package:flutter_application_1/core/models/file_item.dart';

class PersistenceService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(ReminderAdapter());
    Hive.registerAdapter(ContactAdapter());
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(HealthMetricAdapter());
    Hive.registerAdapter(PasswordEntryAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(MemoryAdapter());
    Hive.registerAdapter(FileItemAdapter());
  }

  static Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }
}
