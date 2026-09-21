import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/student_repository.dart';
import '../../../domain/models/student.dart';
import '../../../utils/event_transformers.dart';

sealed class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object?> get props => const [];
}

final class StudentsSubscribed extends StudentsEvent {
  const StudentsSubscribed();
}

final class StudentsRequested extends StudentsEvent {
  const StudentsRequested();
}

final class StudentsSearchChanged extends StudentsEvent {
  const StudentsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class StudentsState extends Equatable {
  const StudentsState({this.students = const [], this.query = ''});

  /// Everything the local service holds.
  final List<Student> students;

  final String query;

  /// What the list actually renders. Derived, so it is never stale and
  /// never stored twice.
  List<Student> get visibleStudents {
    if (query.isEmpty) return students;

    final needle = query.toLowerCase();
    return students
        .where(
          (student) =>
              student.name.toLowerCase().contains(needle) ||
              student.className.toLowerCase().contains(needle),
        )
        .toList();
  }

  StudentsState copyWith({List<Student>? students, String? query}) =>
      StudentsState(
        students: students ?? this.students,
        query: query ?? this.query,
      );

  @override
  List<Object?> get props => [students, query];
}

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc({required StudentRepository repository})
    : _repository = repository,
      super(const StudentsState()) {
    on<StudentsSubscribed>(_onSubscribed);
    on<StudentsRequested>(_onRequested);
    on<StudentsSearchChanged>(
      _onSearchChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );

    add(const StudentsSubscribed());
    add(const StudentsRequested());
  }

  final StudentRepository _repository;

  /// Follow the source of truth. Any later write to the local service
  /// arrives here without another fetch.
  Future<void> _onSubscribed(
    StudentsSubscribed event,
    Emitter<StudentsState> emit,
  ) => emit.forEach(
    _repository.students,
    onData: (students) => state.copyWith(students: students),
  );

  Future<void> _onRequested(
    StudentsRequested event,
    Emitter<StudentsState> emit,
  ) => _repository.loadStudents();

  /// Filters what is already in memory — no api call. Only the query moves;
  /// `visibleStudents` does the rest.
  void _onSearchChanged(
    StudentsSearchChanged event,
    Emitter<StudentsState> emit,
  ) {
    debugPrint('[students] search -> "${event.query}"');
    emit(state.copyWith(query: event.query));
  }
}
