#Загрузка и активация необходимых пакетов
library(tidyverse)
library(ggplot2)
library(e1071)
library(pwr)

#Добавляем датасет
wvs <- read_csv("wvs.csv")

#Предобработка данных

#отбор нужных колонок
wvs_d <- wvs %>% 
  select(Q181, Q152, Q153, Q154, Q155, Q156, Q157)
#удаление пропущенных значений
wvs_d <- wvs_d %>% 
  filter(if_all(c(Q181, Q152, Q153, Q154, Q155, Q156, Q157), ~ !(.x %in% c(-1, -2, -3, -5, -4))))
#ренейминг колонок
wvs_d <- wvs_d %>% 
  rename(Corruption = Q181)
#перезапись значений
wvs_d <- wvs_d %>% 
  mutate(Q152 = case_when(Q152 %in% c(1, 2) ~ 0, Q152 %in% c(3, 4) ~ 1, TRUE ~ Q152)) %>% 
  mutate(Q153 = case_when(Q153 %in% c(1, 2) ~ 0, Q153 %in% c(3, 4) ~ 0.5, TRUE ~ Q153)) %>% 
  mutate(across(c(Q154, Q156), ~ case_when(.x %in% c(1, 3) ~ 0, .x %in% c(2, 4) ~ 1, TRUE ~ .x))) %>% 
  mutate(across(c(Q155, Q157), ~ case_when(.x %in% c(1, 3) ~ 0, .x %in% c(2, 4) ~ 0.5, TRUE ~ .x)))
#создание новой колонки с индексом постматериализма и удаление ненужных колонок
wvs_d <- wvs_d %>% 
  mutate(Index_PM = Q152 + Q153 + Q154 + Q155 + Q156 + Q157) %>% 
  select(-(2:7))

#Описательные статитсики

#минимум, максимум, среднее, медиана
summary(wvs_d$Corruption)
summary(wvs_d$Index_PM)
#размах
range(wvs_d$Corruption)
range(wvs_d$Index_PM) 
#стандартное отклонение
sd(wvs_d$Corruption) 
sd(wvs_d$Index_PM) 
#межквартильный размах
IQR(wvs_d$Corruption)
IQR(wvs_d$Index_PM)
#асимметрия
skewness(wvs_d$Corruption)
skewness(wvs_d$Index_PM)
#эксцесс
kurtosis(wvs_d$Corruption)
kurtosis(wvs_d$Index_PM)

#Описательные визуализации

wvs_d %>% 
  ggplot(aes(x = Corruption)) +
  geom_bar(fill = "skyblue") +
  theme_minimal()
wvs_d %>% 
  ggplot(aes(x = Index_PM)) +
  geom_bar(fill = "blue") +
  theme_minimal()

#Статистический анализ - гипотеза 1
cor.test(wvs_d$Corruption, wvs_d$Index_PM, method = 'spearman')

#Визуализации различий
heatmap_data <- table(wvs_d$Index_PM, wvs_d$Corruption)
heatmap_df <- as.data.frame(as.matrix(heatmap_data))  
ggplot(heatmap_df, aes(x = Var1, y = Var2, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Зависимость Corruption от Index_PM", x = "Index_PM", y = "Corruption") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#расчет мощности 
pwr.r.test(n = 86697, r = 0.02341926)
