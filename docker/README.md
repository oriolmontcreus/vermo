# Docker Setup for Vermo Laravel Project

This Docker setup provides a complete development environment for the Vermo Laravel application with React frontend, eliminating the need to install PHP on your local machine.

## What's Included

- **MySQL 8.0**: Database server
- **PHP 8.2-FPM**: PHP runtime with all necessary extensions
- **Nginx**: Web server for serving the application
- **Node.js 18**: For frontend asset compilation (Vite)
- **Redis**: For caching and sessions
- **Supervisor**: Process manager for queue workers

## Prerequisites

- Docker Desktop
- Docker Compose
- Node.js (for running npm commands locally)

## Quick Start

1. **Start the application**:
   ```bash
   npm run dev
   ```
   This command will:
   - Copy the environment template if `.env` doesn't exist
   - Build and start all Docker containers
   - Generate application key
   - Run database migrations

2. **Access the application**:
   - Main application: http://localhost
   - Frontend dev server (Vite): http://localhost:5173
   - MySQL: localhost:3306

## Available npm Commands

### Main Commands
- `npm run dev` - Start the full Docker environment (recommended)
- `npm run dev:local` - Run Vite locally (original command)
- `npm run dev:docker` - Start Docker containers with build
- `npm run dev:watch` - Start Docker containers without build

### Docker Management
- `npm run docker:up` - Start containers in detached mode
- `npm run docker:down` - Stop and remove containers
- `npm run docker:logs` - View container logs
- `npm run docker:shell` - Access PHP container shell

### Laravel Commands (via Docker)
- `npm run docker:artisan` - Run artisan commands
- `npm run docker:composer` - Run composer commands
- `npm run docker:migrate` - Run database migrations
- `npm run docker:seed` - Run database seeders
- `npm run docker:fresh` - Fresh migration with seeding

## Environment Configuration

The setup includes a template environment file at `docker/env-example`. This file is automatically copied to `.env` if it doesn't exist when you run `npm run dev`.

### Key Docker Environment Variables
```env
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=vermo
DB_USERNAME=vermo_user
DB_PASSWORD=vermo_password

CACHE_STORE=redis
QUEUE_CONNECTION=redis
REDIS_HOST=redis
```

## Container Details

### MySQL Container
- **Image**: mysql:8.0
- **Port**: 3306
- **Database**: vermo
- **Username**: vermo_user
- **Password**: vermo_password
- **Root Password**: rootpassword

### PHP Container
- **Image**: Custom PHP 8.2-FPM with extensions
- **Extensions**: PDO, MySQL, GD, Zip, Redis, OPCache, etc.
- **Process Manager**: Supervisor (handles queue workers)

### Nginx Container
- **Image**: nginx:alpine
- **Port**: 80
- **Configuration**: Optimized for Laravel

### Node Container
- **Image**: node:18-alpine
- **Port**: 5173 (Vite dev server)
- **Auto-installs**: npm dependencies

### Redis Container
- **Image**: redis:alpine
- **Port**: 6379

## Development Workflow

### First Time Setup
```bash
# Clone the repository
git clone <repository-url>
cd vermo

# Start the development environment
npm run dev

# The application should now be available at http://localhost
```

### Daily Development
```bash
# Start the environment
npm run docker:up

# View logs if needed
npm run docker:logs

# Stop when done
npm run docker:down
```

### Running Laravel Commands
```bash
# Generate a new controller
npm run docker:artisan make:controller ExampleController

# Install a new package
npm run docker:composer require vendor/package

# Run tests
npm run docker:artisan test
```

## Troubleshooting

### Port Conflicts
If you encounter port conflicts, you can modify the ports in `docker-compose.yml`:
- MySQL: Change `3306:3306` to `3307:3306`
- Nginx: Change `80:80` to `8080:80`
- Vite: Change `5173:5173` to `5174:5173`

### Permission Issues
If you encounter permission issues with storage or cache:
```bash
npm run docker:shell
chown -R www-data:www-data storage bootstrap/cache
chmod -R 755 storage bootstrap/cache
```

### Database Connection Issues
1. Ensure the MySQL container is running:
   ```bash
   docker-compose ps
   ```

2. Check if the `.env` file has the correct database configuration

3. Wait for MySQL to fully initialize (first run takes longer)

### Clear Caches
```bash
npm run docker:artisan config:clear
npm run docker:artisan cache:clear
npm run docker:artisan view:clear
npm run docker:artisan route:clear
```

## File Structure
```
docker/
├── mysql/
│   └── init/           # MySQL initialization scripts
├── nginx/
│   ├── conf.d/         # Nginx virtual host configs
│   └── nginx.conf      # Main Nginx configuration
├── php/
│   └── php.ini         # Custom PHP configuration
├── supervisor/
│   └── supervisord.conf # Process manager configuration
├── env-example         # Environment template
└── README.md           # This file
```

## Production Considerations

This setup is optimized for development. For production:

1. Disable debug mode in `.env`
2. Use production-ready secrets
3. Enable SSL/TLS
4. Configure proper logging
5. Use multi-stage Docker builds
6. Implement health checks
7. Configure backup strategies

## Support

If you encounter any issues with the Docker setup, please check:
1. Docker Desktop is running
2. No port conflicts exist
3. Sufficient disk space is available
4. The latest Docker images are pulled

For Laravel-specific issues, refer to the [Laravel documentation](https://laravel.com/docs). 