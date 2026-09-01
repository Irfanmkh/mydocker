FROM php:8.4-fpm

# 1. Instal library 
# 1. Instal library pendukung level OS + Node.js + Depedencies Browser (Playwright/Chromium)
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    # --- Tambahan library untuk Playwright/Chromium ---
    libnspr4 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    # --------------------------------------------------
    && rm -rf /var/lib/apt/lists/*


# Jalankan install berdasarkan env path di atas
RUN npx playwright install chromium --with-deps


# 2. Konfigurasi dan instal ekstensi PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip

# 3. Ambil Composer terbaru
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# 4. INSTAL NODEJS & NPM (Terbaru)
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - \
    && apt-get install -y nodejs

# 5. Daftarkan safe directory untuk Git
RUN git config --global --add safe.directory /var/www

WORKDIR /var/www

