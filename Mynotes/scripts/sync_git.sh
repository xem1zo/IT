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

# Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}🚀 Запуск синхронизации (Git Bash)${NC}"
echo -e "${CYAN}========================================${NC}"

# 1. Git Pull
echo -e "\n${YELLOW}📥 Шаг 1: Git pull...${NC}"
cd "$SOURCE_REPO" || { echo "❌ Ошибка перехода в $SOURCE_REPO"; exit 1; }
git pull

# 2. Копирование файлов
echo -e "\n${YELLOW}📋 Шаг 2: Копирование файлов...${NC}"
# Копируем всё, кроме .git
cp -rf ./* "$TARGET_REPO/" 2>/dev/null
# Исключаем .git вручную, если cp скопировал лишнее
# rm -rf "$TARGET_REPO/.git" 2>/dev/null

echo -e "${GREEN}✅ Файлы скопированы${NC}"

# 3. Git Push
echo -e "\n${YELLOW}📤 Шаг 3: Git add, commit, push...${NC}"
cd "$TARGET_REPO" || { echo "❌ Ошибка перехода в $TARGET_REPO"; exit 1; }

git add .
git commit -m "$COMMIT_MESSAGE"
git push origin "$TARGET_BRANCH"

echo -e "\n${GREEN}🎉 Готово!${NC}"