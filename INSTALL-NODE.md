# Instalacja Node.js i npm na Hostingerze

Jeśli masz błąd `npm: command not found`, wykonaj poniższe kroki:

## Krok 1: Sprawdź czy Node.js jest zainstalowany

```bash
# Sprawdź wersję Node.js
node --version

# Sprawdź wersję npm
npm --version

# Sprawdź gdzie są zainstalowane
which node
which npm
```

## Krok 2: Jeśli Node.js nie jest zainstalowany - zainstaluj przez NVM

### Instalacja NVM (Node Version Manager)

```bash
# Pobierz i zainstaluj NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Załaduj NVM do bieżącej sesji
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Sprawdź instalację
nvm --version
```

### Instalacja Node.js przez NVM

```bash
# Zainstaluj najnowszą wersję LTS Node.js
nvm install --lts

# Użyj zainstalowanej wersji
nvm use --lts

# Ustaw jako domyślną
nvm alias default node

# Sprawdź wersje
node --version
npm --version
```

## Krok 3: Dodaj NVM do .bashrc (żeby działało po restarcie)

```bash
# Dodaj do .bashrc
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

# Załaduj ponownie
source ~/.bashrc
```

## Krok 4: Teraz możesz zainstalować n8n

```bash
cd ~/n8n
npm install
npm start
```

## Alternatywa: Jeśli masz dostęp do root/sudo

```bash
# Dla Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Sprawdź
node --version
npm --version
```

## Szybka komenda (wszystko naraz) - BEZ SUDO

```bash
# Skopiuj i wklej całą sekwencję (działa bez sudo):
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
nvm alias default node
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
source ~/.bashrc
node --version
npm --version
```

## Użyj gotowego skryptu setup

```bash
# Sklonuj repo (jeśli jeszcze nie)
git clone https://github.com/PiotrSobiecki/n8n.git
cd n8n

# Uruchom skrypt setup
chmod +x setup-hostinger.sh
./setup-hostinger.sh
```

## WAŻNE: Na Hostingerze NIE MA SUDO

Na współdzielonym hostingu Hostingera **nie masz dostępu do sudo**. Wszystkie komendy muszą być wykonywane bez sudo. NVM i Node.js można zainstalować bez sudo w katalogu użytkownika.
