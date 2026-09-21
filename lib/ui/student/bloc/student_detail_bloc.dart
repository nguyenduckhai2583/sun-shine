import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/student_repository.dart';
import '../../../domain/models/student.dart';

sealed class StudentDetailEvent extends Equatable {
  const StudentDetailEvent();

  @override
  List<Object?> get props => const [];
}

final class StudentDetailSubscribed extends StudentDetailEvent {
  const StudentDetailSubscribed();
}

final class StudentDetailRequested extends StudentDetailEvent {
  const StudentDetailRequested();
}

final class StudentDetailState extends Equatable {
  const StudentDetailState({this.student});

  final Student? student;

  StudentDetailState copyWith({Student? Function()? student}) =>
      StudentDetailState(student: student == null ? this.student : student());

  @override
  List<Object?> get props => [student];
}

class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  StudentDetailBloc({
    required String studentId,
    required StudentRepository repository,
  }) : _studentId = studentId,
       _repository = repository,
       super(const StudentDetailState()) {
    on<StudentDetailSubscribed>(_onSubscribed);
    on<StudentDetailRequested>(_onRequested);

    add(const StudentDetailSubscribed());
    add(const StudentDetailRequested());
  }

  final String _studentId;
  final StudentRepository _repository;

  Future<void> _onSubscribed(
    StudentDetailSubscribed event,
    Emitter<StudentDetailState> emit,
  ) {
    return emit.forEach(
      _repository.watchStudent(_studentId),
      onData: (student) => state.copyWith(student: () => student),
    );
  }

  Future<void> _onRequested(
    StudentDetailRequested event,
    Emitter<StudentDetailState> emit,
  ) => _repository.loadStudent(_studentId);
}
