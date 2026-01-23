# Wdrożenie n8n na Hostingerze (Node.js)

Instrukcja wdrożenia n8n jako aplikacji Node.js w Hostingerze.

## Wymagania

- Hostinger z dostępem do Node.js hosting
- Dostęp SSH (opcjonalnie, ale zalecane)

## Metoda 1: Przez panel Hostingera (Git)

1. Zaloguj się do panelu Hostingera (hPanel)
2. Przejdź do **Node.js** → **Dodaj aplikację**
3. Wybierz **"Z repozytorium Git"**
4. Podaj URL: `https://github.com/PiotrSobiecki/n8n.git`
5. Branch: `main`
6. Hostinger automatycznie:
   - Sklonuje repo
   - Zainstaluje zależności (`npm install`)
   - Uruchomi aplikację (`npm start`)

## Metoda 2: Przez SSH (jeśli dostępne)

```bash
# 1. Zaloguj się przez SSH
ssh -p 65002 u586234842@46.202.142.124

# 2. Przejdź do katalogu aplikacji Node.js (lub utwórz nowy)
cd ~/domains/twoja-domena.pl/public_html
# lub
mkdir -p ~/n8n && cd ~/n8n

# 3. Sklonuj repo
git clone https://github.com/PiotrSobiecki/n8n.git .
# lub jeśli katalog już istnieje:
git clone https://github.com/PiotrSobiecki/n8n.git n8n
cd n8n

# 4. Zainstaluj zależności
npm install

# 5. Uruchom aplikację
npm start
```

## Konfiguracja w panelu Hostingera

Po wdrożeniu, w konfiguracji aplikacji Node.js ustaw:

- **Start Command:** `npm start`
- **Port:** Hostinger przypisze automatycznie (sprawdź w panelu)
- **Zmienne środowiskowe:**
  ```
  N8N_PORT=<PORT_PRZYPISANY_PRZEZ_HOSTINGERA>
  N8N_HOST=0.0.0.0
  N8N_PROTOCOL=https
  ```

## Uruchomienie w tle (PM2)

Jeśli Hostinger pozwala na instalację PM2:

```bash
# Zainstaluj PM2 globalnie
npm install -g pm2

# Uruchom aplikację
pm2 start server.js --name n8n

# Zapisz konfigurację (auto-restart po reboot)
pm2 save
pm2 startup
```

## Dostęp do n8n

Po uruchomieniu n8n będzie dostępne pod adresem:
- `https://twoja-domena.pl:PORT` (jeśli Hostinger przypisał port)
- Lub przez subdomenę przypisaną przez Hostingera

## Troubleshooting

### Aplikacja nie startuje
- Sprawdź logi w panelu Hostingera
- Upewnij się, że Node.js >= 18.0.0
- Sprawdź czy port jest otwarty

### Błąd "Cannot find module"
- Uruchom `npm install` ponownie
- Sprawdź czy `node_modules/` istnieje

### Port nie działa
- Sprawdź w panelu Hostingera jaki port został przypisany
- Ustaw zmienną środowiskową `N8N_PORT` na przypisany port

## Aktualizacja

```bash
# Przez Git
git pull origin main
npm install
npm start

# Lub restart w panelu Hostingera
```
