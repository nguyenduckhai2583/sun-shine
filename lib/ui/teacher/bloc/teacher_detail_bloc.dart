import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/teacher_repository.dart';
import '../../../domain/models/teacher.dart';

sealed class TeacherDetailEvent extends Equatable {
  const TeacherDetailEvent();

  @override
  List<Object?> get props => const [];
}

final class TeacherDetailSubscribed extends TeacherDetailEvent {
  const TeacherDetailSubscribed();
}

final class TeacherDetailRequested extends TeacherDetailEvent {
  const TeacherDetailRequested();
}

final class TeacherDetailState extends Equatable {
  const TeacherDetailState({this.teacher});

  final Teacher? teacher;

  TeacherDetailState copyWith({Teacher? Function()? teacher}) =>
      TeacherDetailState(teacher: teacher == null ? this.teacher : teacher());

  @override
  List<Object?> get props => [teacher];
}

class TeacherDetailBloc extends Bloc<TeacherDetailEvent, TeacherDetailState> {
  TeacherDetailBloc({
    required String teacherId,
    required TeacherRepository repository,
  }) : _teacherId = teacherId,
       _repository = repository,
       super(const TeacherDetailState()) {
    on<TeacherDetailSubscribed>(_onSubscribed);
    on<TeacherDetailRequested>(_onRequested);

    add(const TeacherDetailSubscribed());
    add(const TeacherDetailRequested());
  }

  final String _teacherId;
  final TeacherRepository _repository;

  Future<void> _onSubscribed(
    TeacherDetailSubscribed event,
    Emitter<TeacherDetailState> emit,
  ) => emit.forEach(
    _repository.watchTeacher(_teacherId),
    onData: (teacher) => state.copyWith(teacher: () => teacher),
  );

  Future<void> _onRequested(
    TeacherDetailRequested event,
    Emitter<TeacherDetailState> emit,
  ) => _repository.loadTeacher(_teacherId);
}
