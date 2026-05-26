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
  
   Для проверки правильности настройки псевдонимов путей созданы текстовые файлы статического контента:
   
   <img width="1130" height="95" alt="echo" src="https://github.com/user-attachments/assets/8895d6da-d9a3-456b-932d-33eb638345d9" />
  
   Далее выполнен запрос ```/static-files/test.txt```. В файле ``` app1.conf ``` содержится директива ```alias```, которая преобразует внешний путь ```/static-files/``` во внутренний ```/usr/share/nginx/html/static/```. Аналогично выполнена проверка для ```app2``` с путем ```/shared/```. Результаты представлены на скриншоте ниже:
   
   <img width="905" height="240" alt="nginx_alias" src="https://github.com/user-attachments/assets/a65ed2a7-99f3-49d9-8953-a3c2e73edc4b" />


*  настроены виртуальные хосты для обслуживания нескольких доменных имен на одном сервере:
  
   Выполним запрос к обоим доменным именам и убедимся, что они корректно работают на одном сервере:
   
   <img width="687" height="74" alt="local" src="https://github.com/user-attachments/assets/aac12a6c-fd38-479a-92be-4570687b90a9" />



## Часть 2
