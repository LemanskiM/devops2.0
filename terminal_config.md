# 🗒️ NOTATKI KONFIGURACYJNE (notes.md)
# Projekt: DevOps 2.0 - Stacja Robocza Inżyniera SRE / DataOps
# Właściciel: Mateusz
# Ostatnia aktualizacja: 15.06.2026

---

## 💻 1. Środowisko Terminala i Skryptowania
*   **Cel:** Instalacja nowoczesnego i bezpiecznego silnika skryptowego używanego przez zespoły DevOps, który działa identycznie na Windowsie, Linuxie oraz w chmurze.
*   **Komenda wykonana w starym PowerShellu:**
    ```powershell
    winget install --id Microsoft.PowerShell --source winget
    ```
*   **Status:** Zainstalowano **PowerShell 7** (Wersja 7.6.2.0). Stary, systemowy niebieski PowerShell (5.1) został wycofany z użycia.

---

## 🎨 2. Personalizacja Terminala (Windows Terminal + Oh My Posh)
*   **Cel:** Konfiguracja zaawansowanego wizualnie środowiska pracy z automatycznym renderowaniem ikon technologicznych oraz dynamicznym śledzeniem statusu repozytoriów Git.
*   **Komendy i akcje wykonane w PowerShell 7:**
    1. Weryfikacja instalacji Windows Terminal (pakiet obecny w systemie).
    2. Pobranie i rejestracja paczki czcionek ikonograficznych (Nerd Fonts):
       ```powershell
       oh-my-posh font install meslo
       ```
    3. Ręczna zmiana czcionki w ustawieniach profilu Windows Terminal (`Ctrl + ,` -> Wygląd) na: `MesloLGM Nerd Font`.
    4. Instalacja silnika graficznego Oh My Posh:
       ```powershell
       winget install JanDeDobbeleer.OhMyPosh --source winget
       ```
    5. Rozwiązanie problemu braku folderu profilu przy użyciu komendy:
       ```powershell
       New-Item -Path \$PROFILE -Type File -Force
       ```
    6. Rozwiązanie blokady bezpieczeństwa systemu Windows (`PSSecurityException`) uniemożliwiającej uruchamianie lokalnych skryptów:
       ```powershell
       Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
       ```
    7. Powiązanie silnika graficznego z profilem startowym za pomocą komendy `code $PROFILE`.
*   **Status:** SUKCES. Konsola PowerShell 7 prawidłowo wyświetla prompt inżynierski, logo GitHub, nazwę gałęzi (`main`) oraz liczbę zmodyfikowanych plików w katalogu roboczym.

---

## 🛠️ 3. Środowisko Chmurowe (Korekta Architektury po błędzie OS)
*   **Wyzwanie:** Trwałe uszkodzenie klas COM/OLE w wersji Windows 11 Insider Preview (błąd systemu operacyjnego `REGDB_E_CLASSNOTREG` podczas prób użycia `wsl --update`). Narzędzia naprawcze `DISM /RestoreHealth` oraz `sfc /scannow` potwierdziły pełną integralność plików, wskazując na nienaprawialny błąd bazy rejestrów instalatora MSI dla WSL.
*   **Decyzja architektoniczna:** W celu eliminacji marnowania czasu na błędy systemu hosta, podjęto decyzję o zmianie strategii – porzucono izolację w kontenerach (Docker/Devcontainers) na rzecz natywnego uruchamiania narzędzi directly on Windows.
*   **Akcja:** Pobrano i zainstalowano oficjalną paczkę instalatora Azure CLI (`.msi`) dla Windows ze źródeł Microsoftu.
*   **Status:** Przygotowano środowisko do natywnego wykonywania komend Terraform oraz uwierzytelniania z chmurą publiczną Azure.

---

## 🤖 4. Inteligentne Funkcje Konsoli (PSReadLine, Z, Posh-Git)
*   **Cel:** Wdrożenie mechanizmów autouzupełniania komend z historii (IntelliSense) na wzór nowoczesnych IDE oraz błyskawicznej nawigacji po katalogach bez wpisywania pełnych ścieżek `cd`.
*   **Rozwiązany błąd konfliktu poleceń:** Starszy menedżer pakietów blokował instalację modułu `z` z powodu potencjalnego nadpisania aliasów systemowych. Problem rozwiązano flagą `-AllowClobber`.
*   **Komendy wykonane w PowerShell 7:**
    ```powershell
    Install-Module PSReadLine -Force -SkipPublisherCheck -Scope CurrentUser
    Install-Module z -Force -SkipPublisherCheck -Scope CurrentUser -AllowClobber
    Install-Module posh-git -Force -SkipPublisherCheck -Scope CurrentUser -AllowClobber
    ```
*   **Zawartość pliku profilu (`code $PROFILE`):**
    ```powershell
    # 1. Initialize Oh My Posh
    oh-my-posh init pwsh | Invoke-Expression

    # 2. Import engineering modules
    Import-Module z
    Import-Module posh-git

    # 3. Configure intelligent autocompletion from history
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView

    # 4. Set standard keybindings for history search
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    ```
*   **Status:** Konsola w pełni zautomatyzowana. Wyszukiwanie komend strzałkami (Up/Down) oraz inteligentne podpowiedzi z historii (InlineView) działają poprawnie.



# 🗒️ COMPREHENSIVE ENGINEERING PLAYBOOK (terminal_config.md)
# Projekt: DevOps 2.0 - Odizolowane Środowisko Inżynierii Chmurowej
# Właściciel: Mateusz (ML)
# Ostatnia aktualizacja: 16.06.2026

---

## 💻 1. Silnik Skryptowy (PowerShell 7 Core)
*   **Cel:** Wdrożenie nowoczesnego, wieloplatformowego silnika skryptowego używanego w standardach SRE/DataOps.
*   **Komenda wdrożeniowa (Windows Host):**
    ```powershell
    winget install --id Microsoft.PowerShell --source winget
    ```
*   **Status:** Aktywny. Wykorzystywana wersja PowerShell 7 (v7.6.2.0). Systemowy PowerShell 5.1 został wycofany z użycia.

---

## 🎨 2. Wygląd i Śledzenie Git (Oh My Posh & Nerd Fonts)
*   **Cel:** Wizualizacja statusu repozytoriów Git oraz renderowanie ikon technologicznych bezpośrednio w znaku zachęty.
*   **Procedura konfiguracyjna:**
    1. Rejestracja czcionki ikonograficznej: `oh-my-posh font install meslo` (Wymagane ręczne ustawienie profilu `MesloLGM Nerd Font` w Windows Terminal).
    2. Instalacja silnika graficznego: `winget install JanDeDobbeleer.OhMyPosh --source winget`.
    3. Ominięcie blokady skryptowej systemu Windows (`PSSecurityException`):
       ```powershell
       Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
       ```
*   **Status:** Prompt poprawnie renderuje gałęzie Git (`main`) oraz liczbę zmodyfikowanych plików na dysku hosta.

---

## 🛠️ 3. Inteligentna Konsola (PSReadLine Predictive IntelliSense)
*   **Cel:** Podpowiedzi komend na podstawie historii oraz nawigacja skrócona `z` bez wpisywania pełnych ścieżek `cd`.
*   **Rozwiązanie problemu środowiskowego:** Wymuszono instalację w zasięgu `AllUsers` z flagą `-AllowClobber`, co naprawiło brak widoczności modułów w terminalu wbudowanym VS Code.
*   **Składnia profilu startowego (`code $PROFILE`):**
    ```powershell
    oh-my-posh init pwsh | Invoke-Expression
    Import-Module z
    Import-Module posh-git
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    ```

---

## ☁️ 4. Subskrypcja Chmurowa i Restrykcje Azure AKS Quota
*   **Wyzwanie 1:** Błąd `No subscriptions found` podczas pierwszej autoryzacji `az login`.
    *   *Naprawa:* Aktywacja subskrypcji Azure Free Trial na portalu Microsoft. Czyszczenie tokenów: `az account clear` i ponowny `az login`.
*   **Wyzwanie 2 (Infrastruktura):** Błąd `BadRequest` podczas stawiania klastra – darmowe konta mają zablokowaną domyślną serię maszyn (`Standard_D2s_v3`) w regionie `northeurope`.
    *   *Naprawa:* Zmiana rozmiaru maszyn w kodzie na akceptowalny, ekonomiczny SKU zoptymalizowany pod pamięć: **`Standard_EC2as_v5`** [No Fluff Jobs].

---

## 🐳 5. Pancerny Devcontainer (Bypass Proxy i Blokad HTTP 429)
*   **Wyzwanie:** Środowisko sieciowe oraz firewallowe odrzucało automatyczne żądania budowania kontenera przez VS Code (błędy `buildx features`), a serwery Cloudflare blokowały komendy `curl` uderzające w domeny główne (błąd `429 Too Many Requests`).
*   **Rozwiązanie inżynieryjne (Bypass):** 
    1. Rezygnacja z wtyczek `"features"` w `devcontainer.json` na rzecz czystego, lokalnego pliku `Dockerfile`.
    2. Wykorzystanie flagi `curl -LO`, która automatycznie podąża za przekierowaniami CDN oraz pobieranie bezpośrednich archiwów binarnych `.zip` zamiast repozytoriów `apt-get` [No Fluff Jobs].
    3. Dodanie pakietu `lsb-release` do warstwy bazowej Ubuntu, co umożliwiło dynamiczne podstawianie nazwy dystrybucji (`jammy`) przez makro `$(lsb_release -cs)` przy manualnej rejestracji kluczy Microsoftu.

---

## 🚨 6. Awaria Dysku WSL i Procedura Garbage Collection (SRE Incident)
*   **Symptomy:** Błędy krytyczne wtyczek VS Code, awarie zapisu curl, permanentne ignorowanie zmian w kodzie.
*   **Diagnoza:** Całkowite przepełnienie (100% Storage Utilization) wirtualnego dysku VHDX podsystemu WSL 2 / Docker Desktop.
*   **Procedura SRE (Twardy Reset Zasobów):**
    ```powershell
    docker system prune --all --volumes --force
    wsl --shutdown
    ```
*   **Status:** Zwolniono zasoby dyskowe hosta. Środowisko odzyskało pełną sprawność operacji wejścia/wyjścia (I/O).

---

## 🌐 7. Architektura Wolumenu i Automatyzacja K9s
*   **Cel:** Bezpieczne współdzielenie certyfikatów dostępu do klastra z poziomu Windowsa do wnętrza kontenera, bez ryzyka wycieku sekretów do repozytorium Git [No Fluff Jobs].
*   **Wdrożenie (Volume Binding):** Sztywne zmapowanie lokalnego katalogu `.kube` użytkownika Windows do katalogu domowego kontenera użytkownika `ML`.
*   **Ostateczny, stabilny plik `.devcontainer/devcontainer.json`:**
    ```json
    {
        "name": "DevOps Toolbox Engine",
        "build": { "dockerfile": "Dockerfile" },
        "customizations": {
            "vscode": {
                "extensions": [
                    "hashicorp.terraform", "ms-kubernetes-tools.vscode-kubernetes-tools",
                    "ms-azuretools.vscode-docker", "eamodio.gitlens", "redhat.vscode-yaml",
                    "humao.rest-client", "ms-vscode.makefile-tools", "esbenp.prettier-vscode"
                ]
            }
        },
        "mounts": [
            "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind",
            "source=c:/Users/mateu/.kube,target=/home/ML/.kube,type=bind"
        ],
        "remoteUser": "ML"
    }
    ```
*   **Status:** Pełna operacyjność. Interfejs tekstowy K9s wstaje automatycznie wewnątrz kontenera i natychmiast autoryzuje inżyniera w chmurze Azure.

---

## 🏛️ 8. Dekonstrukcja Monolitu IaC (Multi-Project Architecture)
*   **Cel:** Rozwiązanie błędów `Kubernetes cluster unreachable` wywoływanych próbą jednoczesnego stawiania maszyn chmurowych i aplikacji w jednym pliku `main.tf`.
*   **Struktura docelowa projektu (Katalog roboczy `devops2.0`):**
    ```text
    devops2.0/
    ├── infra/                  # Warstwa Sprzętowa (Hardware Layer)
    │   └── aks.tf              # Grupa zasobów, VNet, Subnet, Klaster AKS
    └── apps/                   # Warstwa Aplikacyjna (Delivery Layer)
        ├── helm.tf             # Definicja providera Helm (config_path = "~/.kube/config")
        └── app.yaml            # Manifesty Kubernetes aplikacji webowej (Deployment, SVC, Ingress)
    ```
*   **Synchronizacja stanu po podziale:** Skopiowano wczorajszy plik pamięci stanu do nowego katalogu sieciowego, aby zapobiec konfliktom dublowania zasobów: `cp terraform.tfstate infra/`.
*   **Wynik:** Wdrożenie kontrolera `ingress-nginx` przez Helma zakończone sukcesem w 50 sekund. Klaster otrzymał publiczny adres IP: **`4.208.1.91`**.

---

## 📖 9. Słownik i Pojęcia Architektury Chmurowej (FinOps / Core)
*   **RG (Resource Group):** Logiczny, darmowy folder organizacyjny w Azure wiążący ze sobą zasoby projektu.
*   **VNet (Virtual Network):** Prywatna, odizolowana sieć wirtualna (serwerownia) w chmurze (np. nasza pula `10.0.0.0/16`). Odpowiednik VPC w chmurze AWS.
*   **Subnet:** Wydzielony pokój wewnątrz sieci VNet (np. `snet-aks-prod` `10.0.1.0/24`) izolujący konkretny typ ruchu sieciowego.
*   **AKS (Azure Kubernetes Service):** Zarządzana usługa Kubernetes w Azure. Odpowiednik EKS w AWS oraz GKE w chmurze Google (GCP).
*   **VNet Subnet Binding:** Powiązanie interfejsu sieciowego klastra z gniazdkiem podsieci (`vnet_subnet_id = azurerm_subnet.aks_subnet.id`) w celu przydzielenia bezpiecznych wewnętrznych adresów IP dla maszyn klastra [No Fluff Jobs].
*   **State (`.tfstate`):** Baza prawdy i pamięć Terraforma w formacie JSON, mapująca kod HCL na realne ID zasobów w chmurze. W standardzie Enterprise przechowywana zdalnie z blokadą zapisu (Remote State Locking).
*   **FinOps (Zasada Skalowania Dev do Zera):** Oszczędzanie budżetu chmurowego poprzez zatrzymywanie maszyn roboczych na noc/weekend za pomocą polecenia:
    ```bash
    az aks nodepool scale --resource-group rg-devops-2-0-mateusz --cluster-name aks-devops-szkolenie --name default --node-count 0
    ```

