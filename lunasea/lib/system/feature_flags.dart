/// Centralized feature flags for staged rollouts.
///
/// These flags are intentionally compile-time constants so phase-based
/// rollouts are deterministic across iOS/Android builds and CI artifacts.
class LunaFeatureFlags {
  const LunaFeatureFlags._();

  /// Hosted cloud account/webhook flows are deferred for the Lunarr relaunch.
  static const bool cloudIntegrationsEnabled = false;
}
