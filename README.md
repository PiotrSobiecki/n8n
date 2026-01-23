# n8n na Hostingerze

Instrukcja instalacji n8n jako aplikacji Node.js w Hostingerze.

## Instalacja

### Metoda 1: Przez repozytorium Git

1. Wrzuć ten projekt do repozytorium Git (GitHub, GitLab, Bitbucket)
2. W panelu Hostingera (hPanel) → Node.js → Dodaj aplikację
3. Wybierz "Z repozytorium Git"
4. Podaj URL do repo
5. Hostinger automatycznie zainstaluje zależności (`npm install`)

### Metoda 2: Przez wgranie plików

1. Wgraj wszystkie pliki z tego projektu do katalogu aplikacji Node.js
2. W terminalu Hostingera (jeśli dostępny) lub przez SSH wykonaj:
   ```bash
   npm install
   ```

## Konfiguracja

### Zmienne środowiskowe w Hostingerze

W panelu Node.js aplikacji ustaw zmienne środowiskowe:

```
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://twoja-domena.pl/
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=twoje_haslo
```

### Port

Hostinger zwykle przypisuje port automatycznie. Sprawdź w panelu aplikacji Node.js jaki port został przypisany i użyj go w zmiennej `N8N_PORT`.

## Uruchomienie

Aplikacja powinna uruchomić się automatycznie po instalacji. Jeśli nie:

1. W panelu Hostingera → Node.js → Twoja aplikacja → Uruchom
2. Lub użyj komendy: `npm start`

## Dostęp do n8n

Po uruchomieniu n8n będzie dostępne pod adresem:
- `https://twoja-domena.pl:PORT` (jeśli Hostinger przypisał port)
- Lub przez subdomenę przypisaną przez Hostingera

## Backup workflow

Workflow są zapisywane w katalogu `.n8n/` (lub `n8n_data/` w zależności od wersji).
Regularnie rób backup tego katalogu!

## Uwagi

- Hostinger może mieć limity czasowe wykonywania (30-60s) - dla długich workflow może być problem
- Sprawdź limity pamięci - n8n potrzebuje minimum 512MB RAM
- Jeśli aplikacja się wyłącza, użyj PM2 (jeśli dostępny) lub skonfiguruj auto-restart w Hostingerze
