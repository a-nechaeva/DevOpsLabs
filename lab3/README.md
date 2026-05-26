# Лабораторная работа 3

## Часть 1
Настроен nginx для двух Flask-приложений, соответствующий следующим требованиям:
*  работает с https сертификатом:
  <img width="543" height="158" alt="app1_https" src="https://github.com/user-attachments/assets/638ee8e9-2021-4e6a-99c8-af07c254a77f" />
  <img width="540" height="144" alt="app2_https" src="https://github.com/user-attachments/assets/2a7a5825-87f1-48d0-8be6-a2d2b7a7b103" />

*  настроено принудительное перенаправление HTTP-запросов на HTTPS:
   <img width="701" height="154" alt="app1_redir" src="https://github.com/user-attachments/assets/318a55e5-434a-4713-88a8-f1d57d01c09f" />
   <img width="675" height="153" alt="app2_redir" src="https://github.com/user-attachments/assets/e7f71b73-091c-4b90-aac4-f2585d16aefa" />


*  использован alias для создания псевдонимов путей к файлам на сервере:
*  настроены виртуальные хосты для обслуживания нескольких доманных имен на одном сервере:


## Часть 2
