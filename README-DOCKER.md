# n8n na Hostingerze przez Docker (SSH)

Instrukcja uruchomienia n8n w Dockerze na Hostingerze z dostępem SSH.

## Wymagania

- Dostęp SSH do serwera Hostingera
- Docker zainstalowany na serwerze
- Docker Compose (opcjonalnie, ale zalecane)

## Instalacja Dockera (jeśli nie ma)

```bash
# Zaloguj się przez SSH
ssh twoj-uzytkownik@twoj-serwer.hostinger.com

# Zainstaluj Docker (Ubuntu/Debian)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Dodaj użytkownika do grupy docker (aby nie używać sudo)
sudo usermod -aG docker $USER
newgrp docker

# Zainstaluj Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Sprawdź instalację
docker --version
docker-compose --version
```

## Wdrożenie

### Metoda 1: Przez Git (zalecane)

```bash
# Zaloguj się przez SSH
ssh twoj-uzytkownik@twoj-serwer.hostinger.com

# Sklonuj repozytorium
git clone https://github.com/PiotrSobiecki/n8n.git
cd n8n

# Uruchom Docker Compose
docker-compose up -d

# Sprawdź status
docker ps
```

### Metoda 2: Przez wgranie plików

1. Wgraj pliki `docker-compose.yml` i `Dockerfile` przez FTP/SSH
2. Zaloguj się przez SSH
3. Przejdź do katalogu z plikami
4. Uruchom: `docker-compose up -d`

### Metoda 3: Bezpośrednio Docker (bez Compose)

```bash
# Utwórz volume dla danych
docker volume create n8n_data

# Uruchom kontener
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e N8N_HOST=0.0.0.0 \
  -e N8N_PORT=5678 \
  -e N8N_PROTOCOL=https \
  --restart unless-stopped \
  docker.n8n.io/n8nio/n8n:latest
```

## Dostęp do n8n

Po uruchomieniu n8n będzie dostępne pod adresem:
- `http://twoja-domena.pl:5678` (jeśli port jest otwarty)
- Lub przez reverse proxy (nginx)

## Zarządzanie

### Zatrzymanie
```bash
docker-compose down
```

### Restart
```bash
docker-compose restart
```

### Logi
```bash
docker-compose logs -f
```

### Aktualizacja
```bash
docker-compose pull
docker-compose up -d
```

### Backup danych
```bash
# Backup volume
docker run --rm -v n8n_data:/data -v $(pwd):/backup ubuntu tar czf /backup/n8n_backup.tar.gz /data

# Przywracanie
docker run --rm -v n8n_data:/data -v $(pwd):/backup ubuntu tar xzf /backup/n8n_backup.tar.gz -C /
```

## Konfiguracja Reverse Proxy (nginx)

Jeśli chcesz dostęp przez domenę bez portu:

```nginx
server {
    listen 80;
    server_name twoja-domena.pl;

    location / {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Zmienne środowiskowe

Możesz edytować `docker-compose.yml` i dodać więcej zmiennych:

```yaml
environment:
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=admin
  - N8N_BASIC_AUTH_PASSWORD=twoje_haslo
  - WEBHOOK_URL=https://twoja-domena.pl/
```

## Troubleshooting

### Sprawdź czy kontener działa
```bash
docker ps | grep n8n
```

### Sprawdź logi
```bash
docker logs n8n
```

### Sprawdź porty
```bash
netstat -tulpn | grep 5678
```

### Usuń i zacznij od nowa
```bash
docker-compose down -v
docker-compose up -d
```
