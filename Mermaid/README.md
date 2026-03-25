# Mermaind
Бакшилов Никита ИПо8482

                            Ex. 1 Начальный

Ex. 1.1

```mermaid
flowchart TD
    A([Начало]) --> B[Кипячение воды]
    B --> C{Есть ли чай?}
    C -->|Да| D[Заварить чай]
    C -->|Нет| E[Купить чай]
    E --> D
    D --> F[Пить чай]
    F --> G([Конец])
```
Ex. 1.2

```mermaid
sequenceDiagram
    title Заказ такси
    participant Клиент
    participant Приложение
    participant Сервер
    participant Водитель

    Клиент->>Приложение: Вызвать такси
    activate Приложение
    Приложение->>Сервер: Отправить запрос
    activate Сервер
    Сервер->>Водитель: Искать водителя
    activate Водитель
    Водитель-->>Сервер: Принять заказ
    deactivate Водитель
    Сервер-->>Приложение: Подтвердить заказ
    deactivate Сервер
    Приложение-->>Клиент: Уведомить о принятии
    deactivate Приложение
    Водитель->>Клиент: Забрать клиента
```
                          Ex. 2 Средний

Ex. 2.1

```mermaid
classDiagram
    class Book {
        +String title
        +String author
        +String ISBN
        +Boolean isAvailable
    }

    class User {
        +String name
        +String userId
        +List~Book~ borrowedBooks
    }

    class Library {
        +List~Book~ books
        +List~User~ users
    }

    User "1" *-- "0..*" Book : заимствует >
    Library "1" o-- "0..*" Book : содержит >
    Library "1" o-- "0..*" User : регистрирует >
```

Ex. 2.2

```mermaid
gantt
    title Разработка мобильного приложения
    dateFormat  YYYY-MM-DD
    axisFormat  %d.%m

    section Подготовка
    Подготовка       :a1, 2025-12-04, 5d

    section Дизайн
    Дизайн           :a2, after a1, 7d

    section Фронтенд
    Фронтенд-разработка :a3, after a2, 10d

    section Бэкенд
    Бэкенд-разработка   :a4, after a1, 12d

    section Тестирование
    Тестирование      :a5, after a3, 5d
    Тестирование      :a6, after a4, 5d
```

                            Ex. 3 Продвинутый

Ex. 3.1

```mermaid
graph LR
    subgraph Frontend
        A[React]
        B[Redux]
        C[Router]
    end

    subgraph Backend
        D[Node.js]
        E[Express]
        F[MongoDB]
    end

    subgraph External
        G[Stripe]
        H[SendGrid]
    end

    A --> D
    B --> D
    D --> F
    D --> G
    D --> H
    C --> A
```
Ex. 3.2

```mermaid
stateDiagram-v2
    [*] --> Новый
    Новый --> Подтвержденный : клиент подтверждает
    Подтвержденный --> Оплаченный : оплата прошла
    Подтвержденный --> Отмененный : клиент отменяет

    state Оплаченный {
        [*] --> Ожидание_оплаты
        Ожидание_оплаты --> Успешная_оплата : карта принята
        Ожидание_оплаты --> Отклонённая_оплата : ошибка
    }

    Оплаченный --> Отправленный : склад отгружает
    Отправленный --> Доставленный : курьер доставил
    Доставленный --> Возвращенный : клиент возвращает

    Отмененный --> [*]
    Возвращенный --> [*]
```

                            Ex. 4 Экспертный уровень

Ex. 4.1

```mermaid
journey
    title Покупка билетов в кино
    section Поиск фильма
      Пользователь: 5: Интересуется новинками
    section Выбор сеанса
      Пользователь: 4: Удобное время
    section Выбор мест
      Пользователь: 3: Интерфейс неочевиден
    section Оплата
      Пользователь: 2: Задержка при оплате
    section Получение билетов
      Пользователь: 5: Билет в приложении — удобно
    section Оценка
      Пользователь: 4: В целом доволен
```

Ex. 4.2

```mermaid
erDiagram
    USERS ||--o{ POSTS : "пишет"
    USERS ||--o{ COMMENTS : "оставляет"
    USERS ||--o{ LIKES : "ставит"
    USERS ||--o{ SUBSCRIPTIONS : "подписывается"
    
    POSTS ||--o{ COMMENTS : "содержит"
    POSTS ||--o{ LIKES : "получает"

    USERS {
        string id PK
        string name
        string email
    }
    
    POSTS {
        string id PK
        string content
        string author_id FK
    }
    
    COMMENTS {
        string id PK
        string content
        string post_id FK
        string author_id FK
    }
    
    LIKES {
        string user_id FK
        string post_id FK
    }
    
    SUBSCRIPTIONS {
        string follower_id FK
        string followee_id FK
    }
```
                            Ex. 5 Блок-схема
                            
Ex. 5.1

```mermaid
flowchart TD
    S([Старт]) --> A[Выбор ресторана]
    A --> B[Выбор блюд]
    B --> C{Есть ли скидка?}
    C -->|Да| D[Применить промокод]
    C -->|Нет| E[Перейти к оплате]
    D --> E
    E --> F[Выбор способа оплаты]
    F --> G[Оформление заказа]
    G --> H[Ожидание доставки]
    H --> I[Получение заказа]
    I --> J{Доволен?}
    J -->|Да| K[Оставить отзыв]
    J -->|Нет| L[Связаться с поддержкой]
    K --> M([Конец])
    L --> M
```

                        Ex. 6 Круговая диаграмма

```mermaid
pie title Распределение автомобилей на российском рынке
    "Иномарки" : 65
    "Отечественные" : 25
    "Совместное производство" : 10
```