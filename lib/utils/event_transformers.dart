import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Event transformers, written with the rxdart already in the project
/// instead of pulling in `package:bloc_concurrency`.
///
/// A transformer decides how *several* events of one type are handled, not
/// what the handler does. Bloc's default is flatMap — every event starts its
/// handler immediately and they all run at once.

/// Keeps only the newest event: a new one cancels the handler still running
/// for the previous one. `bloc_concurrency` calls this `restartable()`.
///
/// Right for search, and for any handler that subscribes to a stream.
EventTransformer<E> restartable<E>() =>
    (events, mapper) => events.switchMap(mapper);

/// Waits for [duration] of silence, then runs [restartable].
///
/// Typing `a`, `an`, `ann` quickly runs the handler once, with `ann`.
EventTransformer<E> debounce<E>(Duration duration) =>
    (events, mapper) => restartable<E>()(events.debounceTime(duration), mapper);
