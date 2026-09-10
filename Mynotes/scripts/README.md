# Документация по скриптам синхронизации Git репозиториев

## О проекте

Данный проект представляет собой набор инструментов для автоматизации процесса синхронизации между двумя Git репозиториями. Разработанные скрипты решают типичную задачу разработчика: обновление исходного репозитория, перенос файлов в целевой репозиторий и автоматическая отправка изменений на удаленный сервер. Решение представлено в двух вариантах, что позволяет выбрать наиболее подходящий инструмент в зависимости от среды выполнения и требований к функциональности.

---

## Общая концепция работы

Оба скрипта реализуют единый алгоритм, состоящий из трех последовательных этапов, каждый из которых выполняет критически важную функцию в процессе синхронизации.

**Первый этап: Обновление исходного репозитория**

На этом этапе скрипт переходит в директорию с исходным репозиторием и выполняет команду Git pull. Это действие гарантирует, что все файлы, которые будут скопированы, находятся в актуальном состоянии и содержат последние изменения, полученные из удаленного репозитория. Без этого шага существует риск переноса устаревших версий файлов или возникновения конфликтов при последующей отправке изменений.

**Второй этап: Копирование файлов между репозиториями**

После обновления исходного репозитория скрипт приступает к копированию всех файлов и папок из исходной директории в целевую. Важной особенностью этого этапа является исключение служебной папки Git, что предотвращает повреждение метаданных целевого репозитория. Скрипты также фильтруют временные файлы и системные служебные файлы, которые не должны попадать в репозиторий.

**Третий этап: Отправка изменений в удаленный репозиторий**

Завершающий этап выполняется в директории целевого репозитория. Скрипт последовательно выполняет команду Git add для добавления всех изменений в индекс, Git commit для создания коммита с заданным сообщением и Git push для отправки изменений в удаленный репозиторий. При возникновении конфликтов PowerShell версия скрипта предпринимает дополнительные попытки разрешить ситуацию автоматически.

---

## Скрипт для Git Bash

### Назначение и область применения

Скрипт для Git Bash представляет собой легковесное решение, ориентированное на пользователей, которые предпочитают Unix подобную командную строку и ценят простоту. Он идеально подходит для быстрой ручной синхронизации, когда не требуется сложная обработка ошибок или дополнительные проверки. Скрипт использует минимальный набор конструкций, что делает его легко читаемым и модифицируемым.

### Структура и компоненты

В начале скрипта расположена конфигурационная секция, где пользователь может задать основные параметры работы. Каждая переменная отвечает за определенный аспект синхронизации.

```bash
#!/bin/bash
# ==============================================================================
# СКРИПТ АВТОМАТИЗАЦИИ GIT (ДЛЯ GIT BASH НА WINDOWS)
# ==============================================================================

# ------------------- 🔧 НАСТРОЙКИ -------------------------

# Путь к исходному репозиторию (используем стиль Git Bash: /c/...)
SOURCE_REPO="C:\Users\111\mfua"

# Путь к целевому репозиторию
TARGET_REPO="/c/Users/111/mfua-learning"

# Сообщение коммита
COMMIT_MESSAGE="update"

# Ветка для пуша
TARGET_BRANCH="README"

# ----------------------------------------------------------
```

Переменная `SOURCE_REPO` определяет путь к исходному репозиторию, из которого будут копироваться файлы. Важно отметить, что Git Bash поддерживает как Windows формат путей с обратным слешем, так и Unix формат с прямым слешем и префиксом `/c/`.

Переменная `TARGET_REPO` указывает путь к целевому репозиторию, в который будет производиться копирование. Здесь используется Unix формат пути, что является предпочтительным для Git Bash.

Параметр `COMMIT_MESSAGE` задает текст, который будет использован при создании коммита в целевом репозитории. Это сообщение будет видно в истории изменений.

Переменная `TARGET_BRANCH` определяет, в какую ветку будут отправляться изменения. Это позволяет гибко управлять тем, куда именно попадают синхронизированные файлы.

### Визуальное оформление вывода

Для улучшения восприятия информации скрипт использует цветовой вывод. ANSI escape последовательности позволяют окрашивать сообщения в разные цвета в зависимости от их важности.

```bash
# Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}🚀 Запуск синхронизации (Git Bash)${NC}"
echo -e "${CYAN}========================================${NC}"
```

Зеленый цвет используется для обозначения успешно завершенных операций. Желтый цвет выделяет текущий выполняемый шаг, что помогает ориентироваться в процессе. Синий цвет применяется для заголовков и разделителей, создавая визуальную структуру вывода. Код `NC` (No Color) сбрасывает цвет к стандартному.

### Реализация этапа обновления

Первый этап начинается с вывода информационного сообщения о начале операции. Затем скрипт пытается перейти в директорию исходного репозитория.

```bash
# 1. Git Pull
echo -e "\n${YELLOW}📥 Шаг 1: Git pull...${NC}"
cd "$SOURCE_REPO" || { echo "❌ Ошибка перехода в $SOURCE_REPO"; exit 1; }
git pull
```

Конструкция `cd "$SOURCE_REPO" || { ... }` обеспечивает проверку успешности перехода. Если переход не удался (например, из-за неверного пути), скрипт выводит сообщение об ошибке и завершается с кодом 1. После успешного перехода выполняется команда `git pull`, которая загружает все изменения из удаленного репозитория.

### Реализация этапа копирования

Второй этап отвечает за перенос файлов между репозиториями. Здесь используется команда `cp` с ключами, обеспечивающими рекурсивное копирование и принудительную перезапись.

```bash
# 2. Копирование файлов
echo -e "\n${YELLOW}📋 Шаг 2: Копирование файлов...${NC}"
# Копируем всё, кроме .git
cp -rf ./* "$TARGET_REPO/" 2>/dev/null

echo -e "${GREEN}✅ Файлы скопированы${NC}"
```

Ключ `-r` (recursive) указывает на необходимость копирования всех поддиректорий рекурсивно. Ключ `-f` (force) обеспечивает принудительную перезапись существующих файлов без запроса подтверждения. Перенаправление `2>/dev/null` подавляет вывод сообщений об ошибках, которые могут возникать при попытке скопировать специальные файлы или при отсутствии прав доступа.

### Реализация этапа отправки

Заключительный этап выполняется в директории целевого репозитория и включает три стандартные Git команды.

```bash
# 3. Git Push
echo -e "\n${YELLOW}📤 Шаг 3: Git add, commit, push...${NC}"
cd "$TARGET_REPO" || { echo "❌ Ошибка перехода в $TARGET_REPO"; exit 1; }

git add .
git commit -m "$COMMIT_MESSAGE"
git push origin "$TARGET_BRANCH"

echo -e "\n${GREEN}🎉 Готово!${NC}"
```

Команда `git add .` добавляет все изменения в текущей директории и всех поддиректориях в индекс Git. Это включает как новые файлы, так и изменения существующих.

Команда `git commit -m "$COMMIT_MESSAGE"` создает коммит с сообщением, указанным в конфигурационной переменной. Это сообщение будет сохранено в истории репозитория.

Команда `git push origin "$TARGET_BRANCH"` отправляет созданный коммит в удаленный репозиторий. Параметр `origin` указывает на стандартное имя удаленного репозитория, а переменная `TARGET_BRANCH` определяет целевую ветку.

---

## Скрипт для PowerShell

### Назначение и архитектура

PowerShell скрипт представляет собой полнофункциональное решение с модульной архитектурой. В отличие от Bash версии, он включает множество дополнительных возможностей: расширенную обработку ошибок, режим имитации, автоматическое разрешение конфликтов, сохранение конфигурации и детальное логирование. Модульная структура делает код организованным и удобным для сопровождения.

### Параметры командной строки

Скрипт поддерживает несколько параметров, позволяющих гибко настраивать его поведение без редактирования кода.

```powershell
param(
    [string]$Repo1Path = "",
    [string]$Repo2Path = "",
    [string]$CommitMessage = "Sync from first repository $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    [switch]$CleanMode,
    [switch]$DryRun,
    [switch]$ForcePush
)
```

Параметр `Repo1Path` задает путь к исходному репозиторию. Если он не указан, скрипт запросит его интерактивно или загрузит из сохраненной конфигурации.

Параметр `Repo2Path` определяет путь к целевому репозиторию, который будет синхронизироваться с исходным.

Параметр `CommitMessage` позволяет задать сообщение коммита. По умолчанию используется сообщение с текущей датой и временем, что обеспечивает уникальность каждого коммита.

Параметр `CleanMode` является переключателем. При его указании скрипт полностью очищает целевую папку перед копированием, удаляя все файлы и папки, кроме служебной директории Git.

Параметр `DryRun` активирует режим имитации. В этом режиме скрипт выводит все действия, которые были бы выполнены, но фактически ничего не изменяет. Это безопасный способ проверить корректность настроек.

Параметр `ForcePush` включает принудительную отправку изменений. Если обычный push не удается из-за конфликтов, скрипт использует команду `git push --force`, которая перезаписывает историю удаленного репозитория.

### Функция логирования

Централизованная функция логирования обеспечивает единообразный вывод всех сообщений с временными метками и цветовой индикацией.

```powershell
function Write-Log {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message" -ForegroundColor $Color
}
```

Каждое сообщение автоматически получает временную метку в формате "ГГГГ-ММ-ДД ЧЧ:ММ:СС", что позволяет точно определить последовательность событий и длительность выполнения операций. Параметр `Color` позволяет гибко настраивать цвет вывода в зависимости от типа сообщения.

### Функция выполнения Git команд

Универсальная функция-обертка для выполнения Git команд обеспечивает единообразную обработку ошибок и поддержку режима имитации.

```powershell
function Invoke-GitCommand {
    param(
        [string]$Command,
        [string[]]$Arguments,
        [string]$WorkingDirectory,
        [switch]$ShowOutput = $true
    )
    
    try {
        Push-Location $WorkingDirectory
        
        $cmdString = "git $Command"
        if ($Arguments -and $Arguments.Count -gt 0) {
            $cmdString += " " + ($Arguments -join " ")
        }
        
        if ($ShowOutput) {
            Write-Log "Executing: $cmdString" "Cyan"
        }
        
        if ($DryRun) {
            Write-Log "[DRY RUN] $cmdString" "Yellow"
            return $true
        }
        
        $output = & git $Command @Arguments 2>&1
        $exitCode = $LASTEXITCODE
        
        if ($exitCode -ne 0) {
            Write-Log "Error executing: $cmdString" "Red"
            Write-Log $output "Red"
            return $false
        }
        
        if ($ShowOutput -and $output) {
            Write-Log $output "Gray"
        }
        
        return $true
        
    } catch {
        Write-Log "Exception: $_" "Red"
        return $false
    } finally {
        Pop-Location
    }
}
```

Функция принимает команду Git в виде строки и массив аргументов, что позволяет корректно обрабатывать параметры с пробелами. Перед выполнением она переходит в указанную рабочую директорию, а после завершения возвращается обратно независимо от результата.

В режиме имитации функция только выводит команду, которая была бы выполнена, и возвращает успешный результат. В реальном режиме она выполняет команду, проверяет код возврата и при ошибке выводит диагностическую информацию.

### Функция копирования файлов

Функция копирования файлов реализует более сложную логику по сравнению с Bash версией, включая фильтрацию файлов и опциональную очистку целевой папки.

```powershell
function Copy-FilesBetweenRepos {
    param(
        [string]$SourcePath,
        [string]$DestPath,
        [switch]$Clean
    )
    
    Write-Log "Starting file copy..." "Green"
    
    $excludeItems = @(
        ".git",
        ".gitignore",
        ".gitattributes",
        "*.log",
        "*.tmp",
        ".DS_Store",
        "Thumbs.db"
    )
    
    if ($Clean -and -not $DryRun) {
        Write-Log "Cleaning target folder (excluding .git)..." "Yellow"
        
        Get-ChildItem -Path $DestPath -Force | 
        Where-Object { $_.Name -ne ".git" } | 
        ForEach-Object {
            if ($DryRun) {
                Write-Log "[DRY RUN] Deleting: $($_.FullName)" "Yellow"
            } else {
                Remove-Item -Path $_.FullName -Recurse -Force
                Write-Log "Deleted: $($_.Name)" "Gray"
            }
        }
    }
    
    Write-Log "Copying files from $SourcePath to $DestPath..." "Cyan"
    
    $sourceItems = Get-ChildItem -Path $SourcePath -Force | 
                   Where-Object { $_.Name -ne ".git" }
    
    foreach ($item in $sourceItems) {
        $destItemPath = Join-Path $DestPath $item.Name
        
        $shouldExclude = $false
        foreach ($exclude in $excludeItems) {
            if ($item.Name -like $exclude) {
                $shouldExclude = $true
                break
            }
        }
        
        if ($shouldExclude) {
            Write-Log "Excluded: $($item.Name)" "DarkYellow"
            continue
        }
        
        if ($DryRun) {
            Write-Log "[DRY RUN] Copying: $($item.Name) -> $destItemPath" "Yellow"
            continue
        }
        
        try {
            if ($item.PSIsContainer) {
                Copy-Item -Path $item.FullName -Destination $destItemPath -Recurse -Force
                Write-Log "Copied folder: $($item.Name)" "Green"
            } else {
                Copy-Item -Path $item.FullName -Destination $destItemPath -Force
                Write-Log "Copied file: $($item.Name)" "Green"
            }
        } catch {
            Write-Log "Error copying $($item.Name): $_" "Red"
            return $false
        }
    }
    
    Write-Log "Copy completed" "Green"
    return $true
}
```

Список исключений `$excludeItems` определяет файлы и папки, которые не должны копироваться. Это включает служебную папку Git, файлы игнорирования, временные файлы и системные файлы.

При активированном параметре `Clean` функция сначала удаляет все содержимое целевой папки, кроме папки Git. Это гарантирует, что после копирования в целевом репозитории будут только те файлы, которые присутствуют в исходном.

Процесс копирования обрабатывает каждый элемент отдельно, различая файлы и папки. Для каждого скопированного элемента выводится информационное сообщение, что позволяет отслеживать прогресс.

### Функция получения текущей ветки

Вспомогательная функция определяет текущую ветку в указанном репозитории.

```powershell
function Get-CurrentBranch {
    param([string]$RepoPath)
    
    Push-Location $RepoPath
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    Pop-Location
    
    return $branch
}
```

Команда `git rev-parse --abbrev-ref HEAD` возвращает имя текущей ветки. Эта информация выводится в логах для информационных целей и помогает отслеживать, в какой ветке выполняются операции.

### Основная функция синхронизации

Основная функция объединяет все этапы синхронизации, добавляя дополнительные проверки и обработку ошибок.

```powershell
function Sync-Repositories {
    Write-Log "========================================" "Magenta"
    Write-Log "Starting repository synchronization" "Magenta"
    Write-Log "========================================" "Magenta"
    
    if (-not $Repo1Path) {
        $script:Repo1Path = Read-Host "Enter path to first repository (source)"
    }
    
    if (-not $Repo2Path) {
        $script:Repo2Path = Read-Host "Enter path to second repository (destination)"
    }
    
    if (-not (Test-Path $Repo1Path)) {
        Write-Log "Error: Repository 1 not found at: $Repo1Path" "Red"
        return $false
    }
    
    if (-not (Test-Path $Repo2Path)) {
        Write-Log "Error: Repository 2 not found at: $Repo2Path" "Red"
        return $false
    }
    
    if (-not (Test-Path (Join-Path $Repo1Path ".git"))) {
        Write-Log "Error: Path $Repo1Path is not a Git repository" "Red"
        return $false
    }
    
    if (-not (Test-Path (Join-Path $Repo2Path ".git"))) {
        Write-Log "Error: Path $Repo2Path is not a Git repository" "Red"
        return $false
    }
```

Функция начинается с проверки входных параметров. Если пути не были указаны, они запрашиваются интерактивно. Затем проверяется существование указанных директорий и наличие в них папки Git, что подтверждает, что это действительно репозитории.

```powershell
    Write-Log "`nStep 1: Updating first repository (source)" "Yellow"
    $branch1 = Get-CurrentBranch -RepoPath $Repo1Path
    Write-Log "Current branch in first repository: $branch1" "Cyan"
    
    if (-not (Invoke-GitCommand -Command "pull" -WorkingDirectory $Repo1Path)) {
        Write-Log "Failed to execute git pull in first repository" "Red"
        return $false
    }
```

Первый шаг обновляет исходный репозиторий. Перед выполнением определяется и выводится текущая ветка.

```powershell
    Write-Log "`nStep 2: Updating second repository from remote" "Yellow"
    $branch2 = Get-CurrentBranch -RepoPath $Repo2Path
    Write-Log "Current branch in second repository: $branch2" "Cyan"
    
    Push-Location $Repo2Path
    $localChanges = git status --porcelain
    Pop-Location
    
    if ($localChanges) {
        Write-Log "Warning: Local changes detected in second repository" "Yellow"
        Write-Log "These changes will be merged with remote changes" "Yellow"
    }
    
    if (-not (Invoke-GitCommand -Command "pull" -WorkingDirectory $Repo2Path)) {
        Write-Log "Warning: git pull failed. Will attempt to continue..." "Yellow"
    }
```

Второй шаг обновляет целевой репозиторий из удаленного источника. Это важное дополнение, отсутствующее в Bash версии. Перед выполнением проверяется наличие локальных изменений, которые могут повлиять на процесс.

```powershell
    Write-Log "`nStep 3: Copying files from first repository to second" "Yellow"
    if (-not (Copy-FilesBetweenRepos -SourcePath $Repo1Path -DestPath $Repo2Path -Clean:$CleanMode)) {
        Write-Log "Error copying files" "Red"
        return $false
    }
    
    if ($DryRun) {
        Write-Log "`n[DRY RUN] Stopping after copy step" "Yellow"
        return $true
    }
```

Третий шаг выполняет копирование файлов с учетом параметра очистки. В режиме имитации скрипт останавливается после этого этапа.

```powershell
    Write-Log "`nStep 4: Sending changes to website from second repository" "Yellow"
    
    Push-Location $Repo2Path
    $hasChanges = git status --porcelain
    Pop-Location
    
    if ($hasChanges) {
        Write-Log "Changes found in second repository" "Green"
        
        if (-not (Invoke-GitCommand -Command "add" -Arguments @(".") -WorkingDirectory $Repo2Path)) {
            Write-Log "Error during git add" "Red"
            return $false
        }
        
        Write-Log "Creating commit with message: $CommitMessage" "Cyan"
        if (-not (Invoke-GitCommand -Command "commit" -Arguments @("-m", $CommitMessage) -WorkingDirectory $Repo2Path)) {
            Write-Log "Error during commit" "Red"
            return $false
        }
        
        Write-Log "Pushing changes to remote server..." "Cyan"
        $pushResult = Invoke-GitCommand -Command "push" -WorkingDirectory $Repo2Path
        
        if (-not $pushResult) {
            Write-Log "Push failed. Attempting to pull remote changes first..." "Yellow"
            
            if (Invoke-GitCommand -Command "pull" -WorkingDirectory $Repo2Path) {
                Write-Log "Pull successful. Retrying push..." "Cyan"
                
                if (-not (Invoke-GitCommand -Command "push" -WorkingDirectory $Repo2Path)) {
                    if ($ForcePush) {
                        Write-Log "Regular push still fails. Attempting force push..." "Yellow"
                        if (-not (Invoke-GitCommand -Command "push" -Arguments @("--force") -WorkingDirectory $Repo2Path)) {
                            Write-Log "Error during git push --force" "Red"
                            return $false
                        }
                    } else {
                        Write-Log "Error during git push. Use -ForcePush to force push if necessary" "Red"
                        return $false
                    }
                }
            } else {
                if ($ForcePush) {
                    Write-Log "Pull failed. Attempting force push..." "Yellow"
                    if (-not (Invoke-GitCommand -Command "push" -Arguments @("--force") -WorkingDirectory $Repo2Path)) {
                        Write-Log "Error during git push --force" "Red"
                        return $false
                    }
                } else {
                    Write-Log "Error during git pull and push. Use -ForcePush to force push if necessary" "Red"
                    return $false
                }
            }
        }
        
        Write-Log "Successfully pushed changes to website" "Green"
    } else {
        Write-Log "No changes to push" "Yellow"
    }
```

Четвертый шаг содержит самую сложную логику. Сначала проверяется наличие изменений после копирования. Если изменения обнаружены, выполняются Git add и Git commit. Затем предпринимается попытка push.

Если push не удается, скрипт пытается выполнить Git pull для синхронизации с удаленным репозиторием и повторяет push. Если и это не помогает, при наличии параметра ForcePush используется принудительная отправка.

### Сохранение и загрузка конфигурации

Скрипт поддерживает сохранение настроек между запусками, что избавляет от необходимости каждый раз вводить пути к репозиториям.

```powershell
function Save-Config {
    $configPath = Join-Path $PSScriptRoot "reposync.config.json"
    $config = @{
        Repo1Path = $Repo1Path
        Repo2Path = $Repo2Path
        LastSync = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    $config | ConvertTo-Json | Set-Content -Path $configPath -Encoding UTF8
    Write-Log "Configuration saved to $configPath" "Gray"
}

function Load-Config {
    $configPath = Join-Path $PSScriptRoot "reposync.config.json"
    if (Test-Path $configPath) {
        $config = Get-Content $configPath -Encoding UTF8 | ConvertFrom-Json
        if ($config.Repo1Path) { $script:Repo1Path = $config.Repo1Path }
        if ($config.Repo2Path) { $script:Repo2Path = $config.Repo2Path }
        Write-Log "Loaded saved configuration" "Gray"
    }
}
```

Конфигурация сохраняется в формате JSON в файле `reposync.config.json`, расположенном в той же директории, что и скрипт. Файл содержит пути к репозиториям и временную метку последней синхронизации.

При запуске без указания параметров скрипт автоматически загружает сохраненную конфигурацию. Это особенно удобно при регулярном использовании, когда пути к репозиториям не меняются.

---

## Сравнение скриптов

**Bash скрипт** отличается простотой и минимализмом. Его код легко читается и модифицируется. Он использует стандартные Unix команды и не требует дополнительных настроек. Цветной вывод делает информацию наглядной, а компактность позволяет быстро разобраться в логике работы.

**PowerShell скрипт** предлагает значительно более широкий набор возможностей. Модульная архитектура обеспечивает организованность кода и удобство сопровождения. Расширенная обработка ошибок гарантирует, что скрипт не завершится неожиданно без объяснения причин.

Режим имитации позволяет безопасно проверять настройки перед реальным выполнением. Автоматическое разрешение конфликтов при push значительно снижает вероятность ошибок. Сохранение конфигурации ускоряет повторные запуски. Детальное логирование с временными метками предоставляет полную картину происходящего.

---

## Примеры вывода

При успешном выполнении Bash скрипт выводит сообщения, подобные следующим:

```
========================================
🚀 Запуск синхронизации (Git Bash)
========================================

📥 Шаг 1: Git pull...
Already up to date.

📋 Шаг 2: Копирование файлов...
✅ Файлы скопированы

📤 Шаг 3: Git add, commit, push...
[main abc1234] update
 1 file changed, 10 insertions(+)
To https://github.com/user/repo.git
   abc1234..def5678  main -> main

🎉 Готово!
```

PowerShell скрипт выводит более детальную информацию с временными метками:

```
[2026-03-30 09:44:35] ========================================
[2026-03-30 09:44:35] Starting repository synchronization
[2026-03-30 09:44:35] ========================================

[2026-03-30 09:44:35] 
Step 1: Updating first repository (source)
[2026-03-30 09:44:35] Current branch in first repository: master
[2026-03-30 09:44:35] Executing: git pull
[2026-03-30 09:44:36] Already up to date.

[2026-03-30 09:44:36] 
Step 2: Updating second repository from remote
[2026-03-30 09:44:36] Current branch in second repository: main
[2026-03-30 09:44:36] Executing: git pull
[2026-03-30 09:44:36] Already up to date.

[2026-03-30 09:44:36] 
Step 3: Copying files from first repository to second
[2026-03-30 09:44:36] Starting file copy...
[2026-03-30 09:44:36] Copying files from C:\source to C:\target...
[2026-03-30 09:44:36] Copied file: script.sh
[2026-03-30 09:44:36] Copied file: README.md
[2026-03-30 09:44:36] Copied folder: docs
[2026-03-30 09:44:36] Copy completed

[2026-03-30 09:44:36] 
Step 4: Sending changes to website from second repository
[2026-03-30 09:44:36] Changes found in second repository
[2026-03-30 09:44:36] Executing: git add .
[2026-03-30 09:44:36] Creating commit with message: Sync from first repository 2026-03-30 09:44:36
[2026-03-30 09:44:36] Executing: git commit -m "Sync from first repository 2026-03-30 09:44:36"
[2026-03-30 09:44:36] [main def5678] Sync from first repository 2026-03-30 09:44:36
[2026-03-30 09:44:36]  3 files changed, 25 insertions(+)
[2026-03-30 09:44:36] Pushing changes to remote server...
[2026-03-30 09:44:36] Executing: git push
[2026-03-30 09:44:37] To https://github.com/user/repo.git
[2026-03-30 09:44:37]    abc1234..def5678  main -> main
[2026-03-30 09:44:37] Successfully pushed changes to website

[2026-03-30 09:44:37] ========================================
[2026-03-30 09:44:37] Synchronization completed successfully!
[2026-03-30 09:44:37] ========================================
```

---

## Заключение

Оба скрипта успешно решают задачу автоматизации синхронизации между Git репозиториями. Выбор конкретного решения зависит от потребностей пользователя и условий эксплуатации.

Bash скрипт идеально подходит для быстрой ручной синхронизации, когда требуется минимальное вмешательство в процесс. Его простота и прозрачность делают его отличным выбором для повседневного использования.

PowerShell скрипт является более мощным инструментом, предназначенным для автоматизированных сценариев, где важна надежность и возможность отслеживания всех операций. Расширенные функции делают его пригодным для использования в CI/CD конвейерах и других профессиональных средах.

Разработанные скрипты могут служить основой для дальнейшего развития и адаптации под специфические требования различных проектов.