# Deployment Guide

This comprehensive deployment guide covers the modernized Laravel 11 + Vue 3 application with all recent migrations completed. Follow this guide for successful production deployments.

## Table of Contents

1. [Production Environment Requirements](#production-environment-requirements)
2. [Pre-deployment Checklist](#pre-deployment-checklist)
3. [Build and Deployment Process](#build-and-deployment-process)
4. [Server Configuration](#server-configuration)
5. [Database Migration Procedures](#database-migration-procedures)
6. [Asset and CDN Configuration](#asset-and-cdn-configuration)
7. [Environment Configuration](#environment-configuration)
8. [Performance Optimization](#performance-optimization)
9. [Monitoring and Health Checks](#monitoring-and-health-checks)
10. [Rollback Procedures](#rollback-procedures)
11. [Troubleshooting](#troubleshooting)

## Production Environment Requirements

### Server Requirements

#### Minimum Hardware Specifications
- **CPU**: 4 cores, 2.4GHz or higher
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: SSD with 100GB free space
- **Network**: 1Gbps connection

#### Software Requirements
- **Operating System**: Ubuntu 20.04 LTS or higher, CentOS 8+
- **PHP**: 8.2 or higher
- **Node.js**: 18.0 or higher
- **NPM**: 8.0 or higher
- **Composer**: 2.4 or higher
- **Web Server**: Nginx 1.18+ or Apache 2.4+
- **Database**: MySQL 8.0+ or PostgreSQL 13+
- **Redis**: 6.0+ (for caching and sessions)

#### PHP Extensions Required
```bash
# Install required PHP extensions
sudo apt-get install php8.2-fpm php8.2-mysql php8.2-redis php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-gd php8.2-intl php8.2-bcmath
```

#### Node.js and Build Tools
```bash
# Install Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify versions
node --version  # Should be 18.0+
npm --version   # Should be 8.0+
```

## Pre-deployment Checklist

### Code Quality Verification
- [ ] All tests pass (unit, feature, integration)
- [ ] Code coverage meets requirements (>80%)
- [ ] ESLint and PHP CS Fixer pass
- [ ] No security vulnerabilities in dependencies
- [ ] Performance tests meet benchmarks

### Build Verification
- [ ] Production build completes successfully
- [ ] Bundle analysis shows acceptable sizes
- [ ] All assets are properly versioned
- [ ] Source maps are generated for debugging

### Configuration Verification
- [ ] Environment variables are set correctly
- [ ] Database connection is configured
- [ ] Mail configuration is tested
- [ ] File storage configuration is verified
- [ ] CDN configuration is ready

### Security Verification
- [ ] SSL certificates are valid and installed
- [ ] Security headers are configured
- [ ] CSRF protection is enabled
- [ ] API rate limiting is configured
- [ ] File upload restrictions are in place

## Build and Deployment Process

### 1. Automated Build Script

Create a deployment script `deploy.sh`:

```bash
#!/bin/bash
set -e

echo "🚀 Starting deployment process..."

# Configuration
APP_DIR="/var/www/html"
BACKUP_DIR="/var/backups/app"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"

# Create backup
echo "📦 Creating backup..."
mkdir -p $BACKUP_DIR
cp -r $APP_DIR $BACKUP_PATH

# Pull latest code
echo "📥 Pulling latest code..."
cd $APP_DIR
git pull origin production

# Install dependencies
echo "📦 Installing dependencies..."
composer install --no-dev --optimize-autoloader
npm ci

# Build assets
echo "🔨 Building assets..."
npm run build:production

# Run migrations
echo "🗄️ Running database migrations..."
php artisan migrate --force

# Optimize application
echo "⚡ Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# Clear caches
echo "🧹 Clearing caches..."
php artisan cache:clear
php artisan queue:restart

# Set permissions
echo "🔐 Setting permissions..."
chown -R www-data:www-data $APP_DIR
chmod -R 755 $APP_DIR
chmod -R 775 $APP_DIR/storage
chmod -R 775 $APP_DIR/bootstrap/cache

# Run health checks
echo "🏥 Running health checks..."
php artisan health:check

echo "✅ Deployment completed successfully!"
```

### 2. Manual Deployment Steps

```bash
# 1. Prepare the environment
cd /var/www/html
git checkout production
git pull origin production

# 2. Install PHP dependencies
composer install --no-dev --optimize-autoloader

# 3. Install Node.js dependencies
npm ci

# 4. Build production assets
npm run build:production

# 5. Run database migrations
php artisan migrate --force

# 6. Optimize Laravel application
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# 7. Clear application caches
php artisan cache:clear
php artisan queue:restart

# 8. Set proper permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chmod -R 775 /var/www/html/storage
sudo chmod -R 775 /var/www/html/bootstrap/cache

# 9. Test the deployment
curl -f http://localhost/health-check || exit 1
```

### 3. Zero-Downtime Deployment

For zero-downtime deployments, use a symlink strategy:

```bash
#!/bin/bash
# Zero-downtime deployment script

RELEASES_DIR="/var/www/releases"
CURRENT_DIR="/var/www/html"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RELEASE_DIR="$RELEASES_DIR/release_$TIMESTAMP"

# Create new release directory
mkdir -p $RELEASE_DIR

# Clone code to release directory
git clone --branch production --depth 1 https://github.com/your-repo/app.git $RELEASE_DIR

cd $RELEASE_DIR

# Install dependencies and build
composer install --no-dev --optimize-autoloader
npm ci
npm run build:production

# Copy environment file
cp /var/www/.env $RELEASE_DIR/.env

# Create symlinks for storage and other shared directories
ln -nfs /var/www/storage $RELEASE_DIR/storage
ln -nfs /var/www/storage/app/public $RELEASE_DIR/public/storage

# Run migrations
php artisan migrate --force

# Optimize application
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Switch to new release
ln -nfs $RELEASE_DIR $CURRENT_DIR

# Reload services
sudo systemctl reload php8.2-fpm
sudo systemctl reload nginx

# Clean up old releases (keep last 5)
ls -1 $RELEASES_DIR | head -n -5 | xargs -I {} rm -rf $RELEASES_DIR/{}

echo "✅ Zero-downtime deployment completed!"
```

## Server Configuration

### Nginx Configuration

Create `/etc/nginx/sites-available/app`:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name your-domain.com www.your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name your-domain.com www.your-domain.com;
    root /var/www/html/public;

    index index.php;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/your-domain.com/chain.pem;

    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_timeout 10m;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;

    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'; frame-ancestors 'self';" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_min_length 10240;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types
        application/atom+xml
        application/javascript
        application/json
        application/rss+xml
        application/vnd.ms-fontobject
        application/x-font-ttf
        application/x-web-app-manifest+json
        application/xhtml+xml
        application/xml
        font/opentype
        image/svg+xml
        image/x-icon
        text/css
        text/plain
        text/x-component;

    # Asset caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Vite assets
    location /build/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
        try_files $uri =404;
    }

    # PHP handling
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
        
        fastcgi_buffer_size 128k;
        fastcgi_buffers 4 256k;
        fastcgi_busy_buffers_size 256k;
        fastcgi_temp_file_write_size 256k;
        fastcgi_read_timeout 300;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }

    # Health check endpoint
    location /health-check {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
```

### PHP-FPM Configuration

Edit `/etc/php/8.2/fpm/pool.d/www.conf`:

```ini
[www]
user = www-data
group = www-data
listen = /var/run/php/php8.2-fpm.sock
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 50
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
pm.max_requests = 500

; Performance tuning
php_admin_value[memory_limit] = 256M
php_admin_value[max_execution_time] = 60
php_admin_value[upload_max_filesize] = 10M
php_admin_value[post_max_size] = 10M
php_admin_value[max_input_vars] = 3000
php_admin_value[opcache.enable] = 1
php_admin_value[opcache.memory_consumption] = 128
php_admin_value[opcache.max_accelerated_files] = 10000
php_admin_value[opcache.revalidate_freq] = 2
```

## Database Migration Procedures

### Pre-migration Backup

```bash
# Create database backup
mysqldump -u root -p --single-transaction --routines --triggers database_name > backup_$(date +%Y%m%d_%H%M%S).sql

# Verify backup
mysql -u root -p -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'database_name';"
```

### Migration Execution

```bash
# 1. Check migration status
php artisan migrate:status

# 2. Run migrations with backup
php artisan migrate --force

# 3. Verify migrations
php artisan migrate:status

# 4. Seed production data if needed
php artisan db:seed --class=ProductionSeeder
```

### Rollback Procedures

```bash
# Rollback last batch of migrations
php artisan migrate:rollback

# Rollback specific number of batches
php artisan migrate:rollback --step=3

# Complete database restore from backup
mysql -u root -p database_name < backup_20231215_143022.sql
```

## Asset and CDN Configuration

### Asset Optimization

```bash
# Build optimized assets
npm run build:production

# Verify build output
ls -la public/build/

# Check bundle sizes
npm run analyze
```

### CDN Configuration (CloudFlare Example)

```php
// config/filesystems.php
'disks' => [
    'public' => [
        'driver' => 'local',
        'root' => storage_path('app/public'),
        'url' => env('APP_URL').'/storage',
        'visibility' => 'public',
    ],
    
    'cdn' => [
        'driver' => 's3',
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION'),
        'bucket' => env('AWS_BUCKET'),
        'url' => env('AWS_URL'),
    ],
],
```

## Environment Configuration

### Production .env Template

```env
# Application
APP_NAME="QuizTime Pro"
APP_ENV=production
APP_KEY=base64:your-app-key-here
APP_DEBUG=false
APP_URL=https://your-domain.com

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=production_db
DB_USERNAME=prod_user
DB_PASSWORD=secure_password

# Redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# Cache
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

# Mail
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailgun.org
MAIL_PORT=587
MAIL_USERNAME=your-username
MAIL_PASSWORD=your-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@your-domain.com
MAIL_FROM_NAME="${APP_NAME}"

# File Storage
FILESYSTEM_DISK=public
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-bucket

# Vite (for asset compilation)
VITE_APP_NAME="${APP_NAME}"
VITE_APP_ENV="${APP_ENV}"

# Monitoring
LOG_CHANNEL=stack
LOG_STACK=single,errorlog

# Performance
OCTANE_SERVER=swoole
TELESCOPE_ENABLED=false
DEBUGBAR_ENABLED=false
```

## Performance Optimization

### Laravel Optimization

```bash
# Cache configuration
php artisan config:cache

# Cache routes
php artisan route:cache

# Cache views
php artisan view:cache

# Cache events
php artisan event:cache

# Optimize autoloader
composer install --optimize-autoloader --no-dev

# Enable OPCache
echo "opcache.enable=1" >> /etc/php/8.2/fpm/php.ini
echo "opcache.memory_consumption=128" >> /etc/php/8.2/fpm/php.ini
echo "opcache.max_accelerated_files=10000" >> /etc/php/8.2/fpm/php.ini
```

### Database Optimization

```sql
-- Add indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_exam_submissions_user_exam ON exam_submissions(user_id, exam_id);
CREATE INDEX idx_questions_exam_type ON questions(exam_id, type);
CREATE INDEX idx_settings_key ON settings(key);

-- Analyze tables
ANALYZE TABLE users, exams, questions, exam_submissions;
```

### Redis Configuration

```bash
# Edit /etc/redis/redis.conf
maxmemory 256mb
maxmemory-policy allkeys-lru
save 900 1
save 300 10
save 60 10000
```

## Monitoring and Health Checks

### Health Check Endpoint

Create `routes/health.php`:

```php
<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;

Route::get('/health-check', function () {
    $checks = [
        'database' => false,
        'cache' => false,
        'storage' => false,
        'queue' => false,
    ];
    
    try {
        // Database check
        DB::connection()->getPdo();
        $checks['database'] = true;
        
        // Cache check
        Cache::put('health-check', 'ok', 60);
        $checks['cache'] = Cache::get('health-check') === 'ok';
        
        // Storage check
        $checks['storage'] = is_writable(storage_path());
        
        // Queue check (simplified)
        $checks['queue'] = true; // Implement queue health check
        
    } catch (Exception $e) {
        return response()->json([
            'status' => 'error',
            'checks' => $checks,
            'error' => $e->getMessage()
        ], 503);
    }
    
    $allHealthy = !in_array(false, $checks, true);
    
    return response()->json([
        'status' => $allHealthy ? 'healthy' : 'degraded',
        'checks' => $checks,
        'timestamp' => now()->toISOString()
    ], $allHealthy ? 200 : 503);
});
```

### Monitoring Setup

```bash
# Install monitoring tools
sudo apt-get install htop iotop nethogs

# Setup log rotation
sudo nano /etc/logrotate.d/laravel

# Content of logrotate config:
/var/www/html/storage/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 www-data www-data
    postrotate
        /usr/bin/systemctl reload php8.2-fpm > /dev/null 2>&1 || true
    endscript
}
```

### Performance Monitoring Script

Create `monitor.sh`:

```bash
#!/bin/bash

# Performance monitoring script
LOG_FILE="/var/log/app-monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Check system resources
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
MEMORY_USAGE=$(free | grep Mem | awk '{printf("%.2f"), $3/$2 * 100.0}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)

# Check application health
APP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/health-check)

# Log results
echo "[$TIMESTAMP] CPU: ${CPU_USAGE}% | Memory: ${MEMORY_USAGE}% | Disk: ${DISK_USAGE}% | App: ${APP_STATUS}" >> $LOG_FILE

# Alert if thresholds exceeded
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "HIGH CPU USAGE: ${CPU_USAGE}%" | mail -s "Server Alert" admin@your-domain.com
fi

if (( $(echo "$MEMORY_USAGE > 85" | bc -l) )); then
    echo "HIGH MEMORY USAGE: ${MEMORY_USAGE}%" | mail -s "Server Alert" admin@your-domain.com
fi

if [[ "$APP_STATUS" != "200" ]]; then
    echo "APPLICATION DOWN: HTTP ${APP_STATUS}" | mail -s "Critical Alert" admin@your-domain.com
fi
```

## Rollback Procedures

### Quick Rollback

```bash
#!/bin/bash
# Quick rollback to previous release

RELEASES_DIR="/var/www/releases"
CURRENT_DIR="/var/www/html"

# Find previous release
PREVIOUS_RELEASE=$(ls -1t $RELEASES_DIR | sed -n '2p')

if [[ -z "$PREVIOUS_RELEASE" ]]; then
    echo "❌ No previous release found!"
    exit 1
fi

echo "🔄 Rolling back to: $PREVIOUS_RELEASE"

# Switch symlink to previous release
ln -nfs "$RELEASES_DIR/$PREVIOUS_RELEASE" $CURRENT_DIR

# Clear caches
cd $CURRENT_DIR
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Reload services
sudo systemctl reload php8.2-fpm
sudo systemctl reload nginx

echo "✅ Rollback completed!"
```

### Database Rollback

```bash
# Database rollback procedure
BACKUP_FILE="/var/backups/db/backup_$(date +%Y%m%d_%H%M%S).sql"

# Create current backup before rollback
mysqldump -u root -p --single-transaction database_name > $BACKUP_FILE

# Restore from previous backup
mysql -u root -p database_name < /var/backups/db/backup_20231215_143022.sql

echo "Database rolled back successfully"
```

## Troubleshooting

### Common Issues and Solutions

#### Issue: Assets not loading
```bash
# Solution: Rebuild assets and clear cache
npm run build:production
php artisan cache:clear
```

#### Issue: Database connection error
```bash
# Solution: Check database configuration
php artisan tinker
>>> DB::connection()->getPdo();
```

#### Issue: File permission errors
```bash
# Solution: Fix permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chmod -R 775 /var/www/html/storage
sudo chmod -R 775 /var/www/html/bootstrap/cache
```

#### Issue: High memory usage
```bash
# Solution: Optimize PHP configuration
echo "memory_limit = 512M" >> /etc/php/8.2/fpm/php.ini
sudo systemctl restart php8.2-fpm
```

### Log Analysis

```bash
# Laravel logs
tail -f /var/www/html/storage/logs/laravel.log

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# PHP-FPM logs
tail -f /var/log/php8.2-fpm.log

# System logs
tail -f /var/log/syslog
```

### Performance Debugging

```bash
# Enable query logging
php artisan tinker
>>> DB::enableQueryLog();
>>> // Run some operations
>>> DB::getQueryLog();

# Check slow queries
sudo tail -f /var/log/mysql/slow.log

# Monitor system resources
htop
iotop
nethogs
```

## Security Considerations

### SSL/TLS Configuration
- Use Let's Encrypt for free SSL certificates
- Configure HSTS headers
- Implement proper cipher suites

### File Upload Security
- Validate file types and sizes
- Scan uploads for malware
- Store uploads outside web root

### Rate Limiting
- Implement API rate limiting
- Configure login attempt limits
- Use fail2ban for brute force protection

### Backup Strategy
- Daily automated backups
- Test restore procedures regularly
- Store backups in multiple locations

---

This deployment guide should be updated with environment-specific details and tested thoroughly in a staging environment before production deployment.
