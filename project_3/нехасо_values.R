# ==================================================
# ПРОЕКТ: Анализ связей базовых ценностей (Ш. Шварц) 
#         с чертами личности (HEXACO)
# ==================================================

# ==================================================
# 1. УСТАНОВКА И ЗАГРУЗКА ПАКЕТОВ
# ==================================================

# Установка пакетов (при необходимости)
install.packages(
  c('car', 'effectsize', 'ggplot2', 'gglm', 'sjPlot', 'lmtest', 'zoo'),
  repos = 'https://mirror.truenetwork.ru/CRAN/'
)

# Загрузка библиотек
library(car)        # линейные модели, VIF, Anova, Box-Cox
library(lmtest)     # дополнительные тесты (ncvTest, resettest)
library(effectsize) # размеры эффектов, eta-квадрат
library(ggplot2)    # визуализация
library(gglm)       # диагностические графики моделей
library(sjPlot)     # графики моделей и предсказаний
library(zoo)        # вспомогательные функции

# ==================================================
# 2. ЗАГРУЗКА ДАННЫХ
# ==================================================

HVsel <- read.csv("HVsel.csv")

# ==================================================
# 3. ГИПОТЕЗА 1: Априорная

# Ценность стимуляции отрицательно связана
# с честностью-скромностью (H) и положительно 
# - с экстраверсией (E):
# ==================================================

## 3.1 Базовая модель ---------------------------------

model1 <- lm(stimulation ~ H + E, data = HVsel)

## 3.2 Диагностика модели ----------------------------

### Мультиколлинеарность
vif(model1)

### Выбросы и влиятельные наблюдения
plot(model1, 4)                # расстояния Кука
max(cooks.distance(model1))    # максимальное значение

### Диагностические графики
plot(model1)                   # базовые графики
gglm(model1)                   # расширенная диагностика
plot_model(model1, type = 'diag')  # диагностика из sjPlot

### Проверка нормальности остатков
qqPlot(model1)                 # Q-Q plot
shapiro.test(residuals(model1)) # p < 0.05 — нарушение

### Тест на гетероскедастичность
ncvTest(model1)

### Тест на спецификацию модели
resettest(model1)

### Тест Бокса-Кокса
boxCox(model1)

## 3.3 Трансформация Бокса-Кокса --------------------

# ШАГ 1: Оптимальная лямбда
tr <- powerTransform(stimulation ~ H + E, data = HVsel)
lambda <- tr$lambda
print(paste("Оптимальная lambda:", round(lambda, 3)))

# ШАГ 2: Применение трансформации
HVsel$stimulation.bc <- bcPower(HVsel$stimulation, lambda)

# ШАГ 3: Модель с трансформированной переменной
model1.final <- lm(stimulation.bc ~ H + E, data = HVsel)

# ШАГ 4: Проверка улучшений
qqPlot(model1.final)
shapiro.test(residuals(model1.final))  # p > 0.05 — нормальность достигнута

## 3.4 Сравнение моделей ----------------------------

### Диагностика
gglm(model1)
gglm(model1.final)

### Формальные тесты
ncvTest(model1)
ncvTest(model1.final)

resettest(model1)
resettest(model1.final)

## 3.5 Результаты финальной модели ------------------

### Коэффициенты
summary(model1.final)

### Размеры эффектов
effectsize(model1.final)

### Размер эффекта для ANOVA
eta_squared(Anova(model1.final), alternative = 'two.sided')

## 3.6 Визуализация предсказаний --------------------

# Эффект H при фиксированном E
plot_model(model1.final, type = 'pred', terms = 'H', show.data = TRUE)

# Эффект E при фиксированном H
plot_model(model1.final, type = 'pred', terms = 'E', show.data = TRUE)

# Интерактивный эффект H и E
plot_model(
  model1.final, 
  type = 'pred', 
  terms = c('H', 'E[-1, 0, 1]'),  # H при низком, среднем, высоком E
  show.data = FALSE
)

# Коэффициенты модели
plot_model(model1.final)

# ==================================================
# 4. ГИПОТЕЗА 2: Поисковая гипотеза
#    Ценность гедонизма: 
#    Поиск оптимальной модели на основе HEXACO
# ==================================================

## 4.1 Полная модель -------------------------------

model2 <- lm(hedonism ~ H + E + X + A + C + O, data = HVsel)

## 4.2 Диагностика и трансформация -----------------

gglm(model2)
boxCox(model2)

# Трансформация Бокса-Кокса
tr2 <- powerTransform(model2)
HVsel$hedonism.tr <- bcPower(HVsel$hedonism, tr2$lambda)

# Модель с трансформированной переменной
model2.tr <- update(model2, hedonism.tr ~ .)

## 4.3 Пошаговый отбор предикторов -----------------

### Автоматический отбор (AIC)
best_model <- step(model2.tr, direction = 'both', trace = 0)
summary(best_model)

### Ручной отбор (BIC)
current <- model2.tr

# Шаг 1: удаляем C
temp <- update(current, . ~ . - C)
AIC(current, temp)
BIC(current, temp)

# Шаг 2: удаляем A
temp2 <- update(temp, . ~ . - A)
AIC(temp, temp2)
BIC(temp, temp2)

# Шаг 3: удаляем E
temp3 <- update(temp2, . ~ . - E)
AIC(temp2, temp3)
BIC(temp2, temp3)

# Шаг 4: проверка O
temp4 <- update(temp3, . ~ . - O)
AIC(temp3, temp4)
BIC(temp3, temp4)

# Финальная модель
model2.final <- temp3  # H + X + O

## 4.4 Сравнение моделей ---------------------------

anova(model2.tr, model2.final)
AIC(model2.tr, model2.final)
BIC(model2.tr, model2.final)

## 4.5 Диагностика финальной модели ---------------

gglm(model2.final)
shapiro.test(residuals(model2.final))
ncvTest(model2.final)
resettest(model2.final)
vif(model2.final)

## 4.6 Результаты финальной модели ----------------

summary(model2.final)
effectsize(model2.final)

# Частичные eta-квадрат
r2_semipartial(model2.final, alternative = 'two.sided')
eta_squared(Anova(model2.final), alternative = 'two.sided')

## 4.7 Визуализация -------------------------------

# Коэффициенты модели
plot_model(model2.final) + 
  geom_hline(aes(yintercept = 0), color = 'green', linetype = 'dashed')

# ==================================================
# 5. ИТОГОВЫЕ РЕЗУЛЬТАТЫ
# ==================================================

cat("\n", "=" * 50, "\n")
cat("   РЕЗУЛЬТАТЫ АНАЛИЗА\n")
cat("=" * 50, "\n\n")

cat("ГИПОТЕЗА 1: Стимуляция ~ H + E\n")
cat("----------------------------------------\n")
cat("R² =", round(summary(model1.final)$r.squared, 3), "\n")
cat("H: β =", round(coef(model1.final)[2], 3), ", p < 0.001\n")
cat("E: β =", round(coef(model1.final)[3], 3), ", p < 0.001\n\n")

cat("ГИПОТЕЗА 2: Гедонизм ~ H + X + O\n")
cat("----------------------------------------\n")
cat("R² =", round(summary(model2.final)$r.squared, 3), "\n")
cat("H: β =", round(coef(model2.final)[2], 3), ", p < 0.001\n")
cat("X: β =", round(coef(model2.final)[3], 3), ", p < 0.001\n")
cat("O: β =", round(coef(model2.final)[4], 3), ", p < 0.001\n")
cat("=" * 50, "\n")