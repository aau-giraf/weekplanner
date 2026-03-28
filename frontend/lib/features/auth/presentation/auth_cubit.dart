import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/domain/auth_state.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';
import 'package:weekplanner/shared/utils/jwt_decode.dart';

final _log = Logger('AuthCubit');

/// Manages global authentication state.
///
/// Owns all auth transitions and distributes tokens to API services.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final CoreApiService _coreApiService;
  final ActivityApiService _activityApiService;

  AuthCubit({
    required AuthRepository repository,
    required CoreApiService coreApiService,
    required ActivityApiService activityApiService,
  })  : _repository = repository,
        _coreApiService = coreApiService,
        _activityApiService = activityApiService,
        super(const AuthUnknown());

  /// Whether the current state is [AuthAuthenticated].
  bool get isAuthenticated => state is AuthAuthenticated;

  /// Attempt to restore a previous session.
  ///
  /// Tries three strategies in order:
  /// 1. Non-expired stored access token
  /// 2. Refresh token exchange (access expired but refresh still valid)
  /// 3. Auto-login with saved credentials
  Future<void> tryRestoreSession() async {
    // 1. Try non-expired stored access token.
    final tokenResult = await _repository.tryGetStoredToken();
    final restored = tokenResult.fold(
      (_) => false,
      (token) {
        authenticated(token);
        return true;
      },
    );
    if (restored) return;

    // 2. Try refreshing with stored refresh token.
    final refreshResult = await _repository.tryRefreshToken();
    final refreshed = refreshResult.fold(
      (_) => false,
      (token) {
        authenticated(token);
        return true;
      },
    );
    if (refreshed) return;

    // 3. Fall back to saved credentials.
    final autoLoginResult = await _repository.tryAutoLogin();
    autoLoginResult.fold(
      (_) => emit(const AuthUnauthenticated()),
      (tokens) => authenticated(tokens.access),
    );
  }

  /// Transition to authenticated state with the given [token].
  ///
  /// Parses the JWT to extract user data and distributes the token
  /// to API services.
  void authenticated(String token) {
    final userId = JwtDecode.getUserId(token);
    final orgRoles = JwtDecode.getOrgRoles(token);
    _distributeToken(token);
    emit(AuthAuthenticated(
      accessToken: token,
      userId: userId,
      orgRoles: orgRoles,
    ));
  }

  /// Log out the current user.
  Future<void> logout() async {
    final result = await _repository.logout();
    result.fold(
      (failure) => _log.warning('Logout failed: ${failure.message}'),
      (_) {},
    );
    _clearTokens();
    emit(const AuthUnauthenticated());
  }

  void _distributeToken(String token) {
    _coreApiService.setAuthToken(token);
    _activityApiService.setAuthToken(token);
  }

  void _clearTokens() {
    _coreApiService.clearAuthToken();
    _activityApiService.clearAuthToken();
  }
}
