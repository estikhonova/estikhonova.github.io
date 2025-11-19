## Документация базы данных yousell (e-commerce)

### customers	

| customer_id | gender    | birth_date | customer_zip_code | customer_city | created_at | preferred_categories |
|:------------|:----------|:-----------|:-----------------|:--------------|:-----------|:---------------------|
| 25          | Мужской   | 12/03/73   | 252.631          | Волгоград     | 01/01/24   | ["Обувь"]            |
| 26          | Женский   | 11/06/52   | 678.123          | Казань        | 01/01/24   | ["Музыкальные инструменты", "Обувь и ремесла"] 


- customer_id – уникальный идентификатор пользователя
- gender – пол пользователя
- birth_date – дата рождения пользователя
- customer_zip_code – почтовый индекс пользователя
- customer_city – город пользователя
- created_at – дата регистрации пользователя
- preferred_categories – предпочтительные категории товаров

---

### orders

| order_id | customer_id | order_created_time | order_delivered_customer_time | order_estimated_delivered_time | order_status |
|:---------|:------------|:-------------------|:------------------------------|:-------------------------------|:-------------|
| 1        | 26          | 01/01/24 17:06     | 04/01/24 05:04                | 05/01/24 01:04                 | Delivered    |

- order_id – уникальный идентификатор заказа
- customer_id – идентификатор пользователя
- order_created_time – дата и время создания заказа
- order_delivered_customer_time – дата и время доставки заказа
- order_estimated_delivered_time – предполагаемая дата и время доставки
- order_status – статус заказа

---

### order_items

| order_id | order_item_id | product_id | price    |
|:---------|:--------------|:-----------|:---------|
| 1        | 1             | 969        | 10,708.73|
| 1        | 2             | 996        | 4,722.03 |

- order_id – идентификатор заказа
- order_item_id – идентификатор позиции в заказе
- product_id – идентификатор товара
- price – цена товара

---

### products

| product_id | product_category_name | product_weight_g | product_length_cm | product_height_cm | product_width_cm | product_brand |
|:-----------|:----------------------|:-----------------|:------------------|:------------------|:-----------------|:--------------|
| 969        | Дом и кухня           | 465.00           | 123               | 46                | 22               | ЭнергоТекикс  |
| 996        | Мебель                | 939.00           | 24                | 45                | 168              | ЭнергоТрендикс|

- product_id – уникальный идентификатор товара
- product_category_name – категория товара
- product_weight_g – вес товара в граммах
- product_length_cm – длина товара в см
- product_height_cm – высота товара в см
- product_width_cm – ширина товара в см
- product_brand – бренд товара

---

### customer_actions

| customer_id | event_timestamp | event_type | product_id | order_id |
|:------------|:----------------|:-----------|:-----------|:---------|
| 26          | 01/01/24 17:00  | Page View  | 435        |          |
| 26          | 01/01/24 17:00  | Page View  | 888        |          |
| 26          | 01/01/24 17:01  | Add to Cart| 969        |          |
| 26          | 01/01/24 17:04  | Checkout   |            |          |
| 26          | 01/01/24 17:05  | Add to Cart| 996        |          |
| 26          | 01/01/24 17:06  | Checkout   |            |          |
| 26          | 01/01/24 17:06  | Purchase   |            | 1        |

- customer_id – идентификатор пользователя
- event_timestamp – временная метка события
- event_type – тип события (просмотр страницы, добавление в корзину, оформление заказа, покупка)
- product_id – идентификатор товара
- order_id – идентификатор заказа

---

Тестовую базу данных можно [скачать](https://github.com/lprosh/junior-analyst-portfolio/blob/main/sql/mts/prd_sbx_general.db)
или [создать с помощью запроса](https://github.com/lprosh/junior-analyst-portfolio/blob/main/sql/mts/prd_sbx_general.sql).
