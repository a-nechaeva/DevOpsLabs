# Лабораторная работа 3

## Часть 1

   В качестве двух веб-сервисов взяты простейшие Flask-приложения (см. app1.py и app2.py). Для каждого из них созданы соответствующие ```Dockerfile``` и вспомогательные ```requirements.txt```.

   Далее для обеспечения шифрования трафика создан скрипт ```create-ssl.sh``` и сгенерированы самоподписанные сертификаты:
   
   <img width="1920" height="419" alt="chmod" src="https://github.com/user-attachments/assets/8345ec3e-0985-412e-adcb-fcabe9d34e9b" />

   <img width="228" height="145" alt="ssl" src="https://github.com/user-attachments/assets/6d3ba6bb-11ed-477c-9c29-f272b556856a" />

   Настроен основной конфиг ```nginx.conf``` для загрузки конфигураций виртуальных хостов из ```sites-enabled/```. Конфигурация для app1.local (```app1.conf```) содержит два блока ```server```. Первый блок слушает порт 80 и выполняет принудительное перенаправление всех HTTP-запросов на HTTPS с кодом ответа 301. Второй блок прослушивает порт 443 с SSL шифрованием. Внутри блока определен ```proxy_pass``` на приложение ```http://app1:5000``` и директива ```alias``` пути ```/static-files/```, которая позволяет получать статические файлы из ```/usr/share/nginx/html/static```. Конфигурация для app2.local (```app2.conf```) реализована аналогично. Отличие есть только в настройке алиаса пути ```/shared/```, в котором включена директива ```autoindex on```, позволяющая автоматически генерировать список файлов директории.

   Для проверки правильности работы ```alias``` созданы следующие файлы:
   
   <img width="1130" height="95" alt="echo" src="https://github.com/user-attachments/assets/8895d6da-d9a3-456b-932d-33eb638345d9" />

Проверено, что настроенный nginx соответствуюет требованиям тз:
*  работает с https сертификатом:
   <img width="543" height="158" alt="app1_https" src="https://github.com/user-attachments/assets/638ee8e9-2021-4e6a-99c8-af07c254a77f" />
   <img width="540" height="144" alt="app2_https" src="https://github.com/user-attachments/assets/2a7a5825-87f1-48d0-8be6-a2d2b7a7b103" />

*  настроено принудительное перенаправление HTTP-запросов на HTTPS:
   <img width="701" height="154" alt="app1_redir" src="https://github.com/user-attachments/assets/318a55e5-434a-4713-88a8-f1d57d01c09f" />
   <img width="675" height="153" alt="app2_redir" src="https://github.com/user-attachments/assets/e7f71b73-091c-4b90-aac4-f2585d16aefa" />


*  использован alias для создания псевдонимов путей к файлам на сервере:
   
   Далее поверки корректной работы выполнен запрос ```/static-files/test.txt```. В файле ``` app1.conf ``` содержится директива ```alias```, которая преобразует внешний путь ```/static-files/``` во внутренний ```/usr/share/nginx/html/static/```. Аналогично выполнена проверка для ```app2``` с путем ```/shared/```. Результаты представлены на скриншоте ниже:
   
   <img width="905" height="240" alt="nginx_alias" src="https://github.com/user-attachments/assets/a65ed2a7-99f3-49d9-8953-a3c2e73edc4b" />


*  настроены виртуальные хосты для обслуживания нескольких доменных имен на одном сервере:
  
   Выполним запрос к обоим доменным именам и убедимся, что они корректно работают на одном сервере:
   
   <img width="687" height="74" alt="local" src="https://github.com/user-attachments/assets/aac12a6c-fd38-479a-92be-4570687b90a9" />



## Часть 2

   Проверены три уязвимости настроенного в первой части работы nginx:

   *  Path Traversal (обход путей). Проверено, можно ли выйти за пределы ```/usr/share/nginx/html/```:
      <img width="1037" height="242" alt="p2_pt_part1" src="https://github.com/user-attachments/assets/4df359e3-208f-4df4-8cb5-84632a8a3abd" />

      Видим, что наш nginx защищен от обхода путей.

   *  Directory Listing (получение списка файлов). Проверено, можно ли увидеть содержимое директорий:
      <img width="895" height="288" alt="p2_dl" src="https://github.com/user-attachments/assets/172c4556-c1da-4bcd-bd52-563548a0b62f" />

      Для ```/shared/``` мы видим список файлов и это ожидаемо, так как включена директива ```autoindex```. В случае ```/static-files/``` не должно быть прямого доступа к содержимомму директории, в данном случае это потенциальная уязвимость.

   *  Сканирование скрытых путей (FFUF). Создан список путей и запущено сканирование:
       <img width="1036" height="433" alt="ffuf" src="https://github.com/user-attachments/assets/657a010d-2fa8-409f-be52-20f8b1868f48" />
       Видим, что проверены все пять путей из списка и ни один путь не вернул 200/301/302/403, значит, соответствующих ресурсов нет на сервере.



