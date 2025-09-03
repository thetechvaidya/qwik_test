# Environment Configuration

This directory contains environment-specific configuration for the QwikTest mobile application.

## EnvironmentConfig

The `EnvironmentConfig` class provides environment-aware configuration settings that automatically adjust based on the build mode and environment variables.

### Features

- **Automatic Environment Detection**: Automatically detects development, staging, and production environments
- **Environment Variable Support**: Supports `API_BASE_URL` environment variable for custom API endpoints
- **Build Mode Awareness**: Uses Flutter's build modes (debug, profile, release) to determine environment
- **Configurable Timeouts**: Provides environment-specific API timeout settings

### Usage

```dart
import 'package:your_app/core/config/environment_config.dart';

// Get the current base URL
String apiUrl = EnvironmentConfig.baseUrl;

// Check current environment
if (EnvironmentConfig.isDevelopment) {
  print('Running in development mode');
}

// Get environment-specific timeout
Duration timeout = EnvironmentConfig.apiTimeout;
```

### Environment Variables

You can override the default API base URL by setting the `API_BASE_URL` environment variable:

```bash
# For development
export API_BASE_URL=http://localhost:3000

# For custom staging
export API_BASE_URL=https://my-staging-api.example.com
```

### Build Configurations

- **Debug Mode** (`flutter run`): Uses development API URL
- **Profile Mode** (`flutter run --profile`): Uses staging API URL  
- **Release Mode** (`flutter run --release`): Uses production API URL

### Default URLs

- **Development**: `https://dev-api.qwiktest.com`
- **Staging**: `https://staging-api.qwiktest.com`
- **Production**: `https://api.qwiktest.com`

### Integration

The environment configuration is integrated with:

- `AppConstants`: Provides environment-aware constants
- `DioClient`: Uses environment-specific timeouts
- Service registration: Ensures all services use the correct API endpoints

### Best Practices

1. **Never hardcode API URLs** - Always use `EnvironmentConfig.baseUrl`
2. **Use environment variables** for local development overrides
3. **Test all environments** before releasing
4. **Keep sensitive data out** of the configuration - use secure storage for secrets