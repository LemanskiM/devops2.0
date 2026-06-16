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
