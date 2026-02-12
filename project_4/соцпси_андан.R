library(ggplot2)

#переименовываю
ecs <- ecs_Лист1
rm(ecs_Лист1)
contr <- contr_Лист1
rm(contr_Лист1)

#предобработка - файл
ecs <- ecs %>% 
  select(-1, -(4:8), -10, -12, -14, -16)

contr <- contr %>% 
  select(-1, -(4:8), -10, -12, -14, -16)

ecs <- ecs %>% 
  slice(-(39:45))

#предобработка - контроль 
ecs <- ecs %>%
  mutate(`_рах` = case_when(
    tolower(`_рах`) %in% c("прах") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

ecs <- ecs %>%
  mutate(мор_ = case_when(
    tolower(мор_) %in% c("морг") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

ecs <- ecs %>%
  mutate(`_и_ель` = case_when(
    tolower(`_и_ель`) %in% c("гибель") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

ecs <- ecs %>%
  mutate(гр_б = case_when(
    tolower(гр_б) %in% c("гроб") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

ecs <- ecs %>%
  mutate(тр_п = case_when(
    tolower(тр_п) %in% c("труп") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

contr <- contr %>%
  mutate(`_рах` = case_when(
    tolower(`_рах`) %in% c("прах") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

contr <- contr %>%
  mutate(мор_ = case_when(
    tolower(мор_) %in% c("морг") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

contr <- contr %>%
  mutate(`_и_ель` = case_when(
    tolower(`_и_ель`) %in% c("гибель") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

contr <- contr %>%
  mutate(гр_б = case_when(
    tolower(гр_б) %in% c("гроб") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

contr <- contr %>%
  mutate(тр_п = case_when(
    tolower(тр_п) %in% c("труп") ~ 1,  # проверка без учёта регистра
    TRUE ~ 0                           # всё остальное
  ))

#предобработка - контроль - подсчет

contr <- contr %>%
  mutate(Mстоматолог = rowSums(select(., 3:7)))

ecs <- ecs %>%
  mutate(Mсмерть = rowSums(select(., 3:7)))

M_стоматолог <- mean(contr$Mстоматолог)
М_смерть <- mean(ecs$Mсмерть)

M <- bind_rows(
  data.frame(условие = "Mсмерть", значение = ecs$Mсмерть), 
  data.frame(условие = "Mстоматолог", значение = contr$Mстоматолог))

M %>% 
  ggplot(aes(x = значение)) +
  geom_density() +
  theme_minimal()
  
#контроль - анализ

levels(as.factor(M$условие))
t.test(M$значение ~ M$условие, data = M, alternative = "greater", conf.level = 0.95)
wilcox.test(M$значение ~ M$условие, alternative = "greater", conf.level = 0.95)

#визуализация анализа контроля
M %>%
  ggplot(aes(x = условие, y = значение, fill = условие)) +
  geom_boxplot() +
  theme_minimal()

#предобработка - основной анализ

#переименовываем колонки по индексу ибо нехуй
ecs <- ecs %>% 
  rename(depv1 = 8) # переименовываем 8-ю колонку в "depv1"
ecs <- ecs %>% 
  rename(depv2 = 9)
ecs <- ecs %>% 
  rename(depv3_1 = 10)
ecs <- ecs %>% 
  rename(depv3_2 = 11)
ecs <- ecs %>% 
  rename(depv3_3 = 12)
ecs <- ecs %>% 
  rename(depv3_4 = 13)
ecs <- ecs %>% 
  rename(depv3_5 = 14)

contr <- contr %>%
  rename(depv1 = 8)  # переименовываем 8-ю колонку в "depv1"
contr <- contr %>%
  rename(depv2 = 9)
contr <- contr %>%
  rename(depv3_1 = 10)
contr <- contr %>%
  rename(depv3_2 = 11)
contr <- contr %>%
  rename(depv3_3 = 12)
contr <- contr %>% 
  rename(depv3_4 = 13)
contr <- contr %>% 
  rename(depv3_5 = 14)

#меняем значения на нормальные
ecs <- ecs %>%
  mutate(across(
    .cols = c(depv3_1, depv3_2, depv3_3, depv3_4, depv3_5),  # Столбцы для обработки
    .fns = ~ case_when(
      . %in% c("1  (абсолютно не согласен)") ~ "1",  # Условие
      TRUE ~ .                                       # Иначе оставить как есть
    )
  ))

ecs <- ecs %>%
  mutate(across(
    .cols = c(depv3_1, depv3_2, depv3_3, depv3_4, depv3_5),  # Столбцы для обработки
    .fns = ~ case_when(
      . %in% c("5 (абсолютно согласен)") ~ "5",  # Условие
      TRUE ~ .                                       # Иначе оставить как есть
    )
  ))

contr <- contr %>%
  mutate(across(
    .cols = c(depv3_1, depv3_2, depv3_3, depv3_4, depv3_5),  # Столбцы для обработки
    .fns = ~ case_when(
      . %in% c("1  (абсолютно не согласен)") ~ "1",  # Условие
      TRUE ~ .                                       # Иначе оставить как есть
    )
  ))

contr <- contr %>%
  mutate(across(
    .cols = c(depv3_1, depv3_2, depv3_3, depv3_4, depv3_5),  # Столбцы для обработки
    .fns = ~ case_when(
      . %in% c("5 (абсолютно согласен)") ~ "5",  # Условие
      TRUE ~ .                                       # Иначе оставить как есть
    )
  ))

#я когда переписывала значения, сделал все текстом, чтобы разницы в типах данных не было, теперь возвращаю назад цифры
ecs <- ecs %>%
  mutate(across(
    .cols = starts_with("depv"), #это значит что возвращаем цифры во всех колонках что начинаются с этого
    .fns = as.numeric
  ))

contr <- contr %>%
  mutate(across(
    .cols = starts_with("depv"), #это значит что возвращаем цифры во всех колонках что начинаются с этого
    .fns = as.numeric
  ))

#считаем 3 зп - нам тут нужно среднее а не сумма
contr <- contr %>%
  mutate(depv3 = (depv3_1 + depv3_2 + depv3_3 + depv3_4 + depv3_5) / 5)
#можно еще типо я умная
ecs <- ecs %>%
  mutate(depv3 = rowMeans(select(., depv3_1, depv3_2, depv3_3, depv3_4, depv3_5), na.rm = TRUE))

mean(ecs$depv3)
mean(contr$depv3)
mean(ecs$depv1)
mean(contr$depv1)
mean(ecs$depv2)
mean(contr$depv2)

#создаем датафрейм для анализа
depv3_3 <- bind_rows(
  data.frame(НП = "Mсмерть", ЗП = ecs$depv3), 
  data.frame(НП = "Mстоматолог", ЗП = contr$depv3))

depv2_2 <- bind_rows(
  data.frame(НП = "Mсмерть", ЗП = ecs$depv2), 
  data.frame(НП = "Mстоматолог", ЗП = contr$depv2))

depv1_1 <- bind_rows(
  data.frame(НП = "Mсмерть", ЗП = ecs$depv1), 
  data.frame(НП = "Mстоматолог", ЗП = contr$depv1))

#анализ
wilcox.test(depv1_1$ЗП ~ depv1_1$НП, alternative = "less", conf.level = 0.95)
levels(as.factor(depv1$НП))

wilcox.test(depv2_2$ЗП ~ depv2_2$НП, alternative = "less", conf.level = 0.95)

wilcox.test(depv3_3$ЗП ~ depv3_3$НП, alternative = "less", conf.level = 0.95)

#визуализация анализа основного
depv1_1 %>%
  ggplot(aes(x = `Напоминание о смерти`, y = Доверие, fill = `Напоминание о смерти`)) +
  geom_boxplot() +
  theme_minimal()

depv2_2 %>%
  ggplot(aes(x = `Напоминание о смерти`, y = Симпатия, fill = `Напоминание о смерти`)) +
  geom_boxplot() +
  theme_minimal()

depv3_3 %>%
  ggplot(aes(x = `Напоминание о смерти`, y = `Социльная дистанция`, fill = `Напоминание о смерти`)) +
  geom_boxplot() +
  theme_minimal()


depv1_1 <- depv1_1 %>%
  rename("Напоминание о смерти" = НП)

depv2_2 <- depv2_2 %>%
  rename("Симпатия" = ЗП)
