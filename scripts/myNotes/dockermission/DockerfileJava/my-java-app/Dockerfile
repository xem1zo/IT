# ---- Этап 1: Сборка с Maven ----
# Используем образ с Maven и Eclipse Temurin JDK 17
FROM maven:3.8.5-eclipse-temurin-17 AS builder
WORKDIR /build
# Копируем файл проекта и исходный код
COPY pom.xml .
COPY src ./src
# Собираем приложение (без запуска тестов для скорости)
RUN mvn clean package -DskipTests
# ---- Этап 2: Финальный образ для запуска ----
# Используем минимальный JRE-образ от Eclipse Temurin
FROM eclipse-temurin:17-jre-alpine
# Создаём непривилегированного пользователя (рекомендация безопасности)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
# Копируем JAR-файл из первого этапа
COPY --from=builder --chown=appuser:appgroup /build/target/*.jar app.jar
USER appuser
ENTRYPOINT ["java", "-jar", "app.jar"]