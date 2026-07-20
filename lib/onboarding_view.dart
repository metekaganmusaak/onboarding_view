/// A modern, highly customizable onboarding package for Flutter.
///
/// Multiple visual styles (glassmorphism, Apple liquid glass, minimal,
/// material, adaptive), rich page + indicator transitions, network / GIF /
/// asset / icon / custom media, and zero-dependency local persistence.
library onboarding_view;

// Models
export 'src/models/onboarding_media.dart';
export 'src/models/onboarding_page.dart';

// Controller
export 'src/controller/onboarding_controller.dart';

// Theme & styles
export 'src/theme/glass_decoration.dart';
export 'src/theme/onboarding_style.dart';
export 'src/theme/onboarding_theme.dart';

// Indicators & transitions
export 'src/indicators/onboarding_indicator.dart';
export 'src/transitions/page_transitions.dart';

// Storage (JSON file impl resolved per-platform to stay web-safe)
export 'src/storage/onboarding_storage.dart';
export 'src/storage/json_file_storage.dart'
    if (dart.library.html) 'src/storage/json_file_storage_stub.dart';

// Widgets
export 'src/widgets/onboarding_buttons.dart';
export 'src/widgets/onboarding_footer.dart' show OnboardingButtonBuilder;
export 'src/widgets/onboarding_flow.dart';
