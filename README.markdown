
**README**

 *Дана інструкція є коротким описом тільки як запустити проект, вона не є заміною офіційної документаї мови програмування Ruby та фреймворку RubyOnRails, та не має настанов з адміністрування та конфігурації веб серверу, чи серверу баз даних*

Для заапуску проекта потрібно мати Linux server зі слідуючими необхідними пакетами та службами:

* RVM - https://rvm.io/rvm/install

* Ruby

* Nginx with Passenger https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/install_passenger_main.html
при конфігурації nginx root деректорію потріюно вказати за таким принципом побудови каталогів, наприклад  ми будемо робити деплой в /home/publicwhip-kyiv/ то наш запис буде мати вигляд `root /home/publicwhip-kyiv/current/public/;`

* PostgresSQL


після того як маємо встановлений сервер, клонуємо репозиторій на локальний компютер який має встановлений Ruby

`git clone git@github.com:OPORA/publicwhip-kyiv.git`

Редагуємо файли тасків завантаження даних

`lib/tasks/load_mp.rake`

 6 та 19 стрічка `JSON.load(open("http://#{Settings.name_site}mp.oporaua.org/"))`
`http://#{Settings.name_site}mp.oporaua.org/` - вказуємо свій працюючий uri з датасетом депутатів
датасет депутатів повинен мати ідентичну структуру з ось таким JSON [https://kyivmp.oporaua.org/]

та `lib/tasks/load_division.rake`

4 стрічка  `JSON.load(open("http://#{Settings.name_site}voted.oporaua.org/votes_events"))`
вказуємор свій uri `http://#{Settings.name_site}voted.oporaua.org/votes_events`
датасет повинен мати ідентичну структуру з ось таким JSON [https://kyivvoted.oporaua.org/votes_events/]

і 8 стрічка відповідно `JSON.load(open("http://#{Settings.name_site}voted.oporaua.org/votes_events/#{date}.json"))`

зміна #{date} є індитифікатором дати сесії формат uri може бути інший головне щоб можна було отримати данні
датасет повинен мати ідентичну структуру з ось таким JSON [https://kyivvoted.oporaua.org/votes_events/2015-12-01.json]

Змінюємо налаштування пошти під свої потреби, зміні `Settings.email, Settings.email_password` можна вказати в файлі  ./shared/config/settings.yml під час деплою

для цього правимо:
 
 `config/environments/production.rb`
 
```
config.action_mailer.smtp_settings = {
      address: 'mail.oporaua.org',
      port: 2525,
      domain: 'oporaua.org',
      authentication: :plain,
      user_name: Settings.email,
      password: Settings.email_password,
      enable_starttls_auto: true
  }
  ```
 
 та 
 
  `config/initializers/devise.rb`
  `config.mailer_sender = 'postmaster@oporaua.org'`



Для deploy проекту використовуємо gem mina, в `config/deploy.rb`

і відповідно до наших параметрів правимо файл конфігурації

 ```
 set :domain, 'ruby.oporaua.org'  # вказуєм домене імя чи IP адрес серверу
 set :deploy_to, "/home/publicwhip-kyiv/" # де саме буде знаходитись проект
 set :repository, "git@github.com:OPORA/publicwhip-kyiv.git" #Ваш gitрепозиторій
 set :branch, 'policy' #Ветка
 set :user, 'root'          # Username in the server to SSH to.
 set :port, '1122'           # SSH port number.
 ```

 УВАГА! Всі зміни відправляємо в свій git репозиторій!

 після цього, якщо в нас вірно встановлено Ruby та Gem Bundler, виконуєм команду

`bundle install`

`mina setup`

пісдя того як виконали `mina setup` на сервері потрібно відредагувати файли конфігурації
`./shared/config/database.yml`, `./shared/config/secrets.yml` та `./shared/config/settings.yml`

* `./shared/config/database.yml`

```
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: 5

production:
  <<: *default
  database: #імя бази даних створеної на сервері
  host: localhost
  username: #імя користувача
  password: #пароль

```
* `./shared/config/secrets.yml`

```
production:
  secret_key_base: # виконуємо команду  rake secret в результаты отримуєм хеш який записуємо сюда

```

* `./shared/config/settings.yml`

```
  name_site: "kyiv" #Назва сайта
  name_rada: "Київської Міськради" #назва ради
  gtag: # код google аналытики FAQ: UA-70897601-12
  directory_name: 'publicwhip-kyiv' № директорія сайта
  email:
  email_password:

```
після редагування, ми можемо запустити команду деполою `mina deploy`

після успішоно деплою виконуємо завнтаження або оновлення:

 * депутатів `mina rake[load_mp:all]`

 * фотографій депутатів `mina rake[load_mp::image]`

 * голосувань `mina rake[load_division:votes]`


після завантаження нових данних потрібно виконати оновлення статичтичних даних командами:

* `mina rake[division_cashe:all]`

* `mina rake[deputi_cashe:all]`


