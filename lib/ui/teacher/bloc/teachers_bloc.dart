import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/teacher_repository.dart';
import '../../../domain/models/teacher.dart';
import '../../../utils/event_transformers.dart';

sealed class TeachersEvent extends Equatable {
  const TeachersEvent();

  @override
  List<Object?> get props => const [];
}

final class TeachersSubscribed extends TeachersEvent {
  const TeachersSubscribed();
}

final class TeachersRequested extends TeachersEvent {
  const TeachersRequested();
}

final class TeachersSearchChanged extends TeachersEvent {
  const TeachersSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class TeachersState extends Equatable {
  /// [filteredTeachers] is a real field, but it is computed here in the
  /// initializer rather than passed in. That is what keeps a stored derived
  /// value honest: there is no constructor that can set it out of step with
  /// [teachers] and [query].
  ///
  /// The cost is that this constructor can no longer be `const`.
  TeachersState({this.teachers = const [], this.query = ''})
    : filteredTeachers = _filter(teachers, query);

  /// Everything the local service holds.
  final List<Teacher> teachers;

  final String query;

  /// What the list renders. Computed once per state instead of on every
  /// build — the trade for losing `const`.
  final List<Teacher> filteredTeachers;

  static List<Teacher> _filter(List<Teacher> teachers, String query) {
    if (query.isEmpty) return teachers;

    final needle = query.toLowerCase();
    return teachers
        .where(
          (teacher) =>
              teacher.name.toLowerCase().contains(needle) ||
              teacher.subject.toLowerCase().contains(needle),
        )
        .toList();
  }

  TeachersState copyWith({List<Teacher>? teachers, String? query}) =>
      TeachersState(
        teachers: teachers ?? this.teachers,
        query: query ?? this.query,
      );

  /// Only the inputs. [filteredTeachers] is a function of these two, so
  /// comparing it as well would be redundant work.
  @override
  List<Object?> get props => [teachers, query];
}

class TeachersBloc extends Bloc<TeachersEvent, TeachersState> {
  TeachersBloc({required TeacherRepository repository})
    : _repository = repository,
      super(TeachersState()) {
    on<TeachersSubscribed>(_onSubscribed);
    on<TeachersRequested>(_onRequested);
    on<TeachersSearchChanged>(
      _onSearchChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );

    add(const TeachersSubscribed());
    add(const TeachersRequested());
  }

  final TeacherRepository _repository;

  /// Follow the source of truth. Any later write to the local service
  /// arrives here without another fetch.
  Future<void> _onSubscribed(
    TeachersSubscribed event,
    Emitter<TeachersState> emit,
  ) => emit.forEach(
    _repository.teachers,
    onData: (teachers) => state.copyWith(teachers: teachers),
  );

  Future<void> _onRequested(
    TeachersRequested event,
    Emitter<TeachersState> emit,
  ) => _repository.loadTeachers();

  /// Filters what is already in memory — no api call. Only the query moves;
  /// `filteredTeachers` does the rest.
  void _onSearchChanged(
    TeachersSearchChanged event,
    Emitter<TeachersState> emit,
  ) {
    debugPrint('[teachers] search -> "${event.query}"');
    emit(state.copyWith(query: event.query));
  }
}
