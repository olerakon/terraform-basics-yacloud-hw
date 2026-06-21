<img width="937" height="248" alt="image" src="https://github.com/user-attachments/assets/b00cd2be-8e36-4bfd-b15d-a1cd87556fae" /># Домашнее задание к занятию «Основы Terraform. Yandex Cloud» - `Гилельс К.М.`

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.

### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.12.0

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.

----

### Решение

В файле `providers.tf` заменил `~>1.12.0` на `>=1.12.0`.
Создал сервисный аккаунт и ключ. Поместил согласно лекции и переменной вне проекта `service_account_key_file = file("~/.authorized_key.json")`.
Сгенерировал новый ключ и добавил его в переменную `vms_ssh_public_root_key`, заменив ей шаблонную `vms_ssh_root_key`
Инициализировал и валидировал проект.
Первая же ошибка с переменной vms_ssh_root_key - заменил ее упоминание на vms_ssh_public_root_key:
```tf
    ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
```
Больше ошибок обнаружено не было 

![1](/1.png)

Выполнил `terraform apply`.

Обнаружена ошибка 

![1.1](/1.1.png)

Значения standart-v4 в Yandex Cloud не работает с core_fraction=5 Для работы с core_fraction=5 используем значение standart-v1. Так же минимальное число ядер 2.

Выполнил `terraform apply`. Инфраструктура поднялась. Подключился к машине по ssh:


![1.2](/1.2.png)

![1.3](/1.3.png)

![1.4](/1.4.png)

Параметр `preemptible = true` создаёт прерываемую виртуальную машину.
Параметр `core_fraction = 5` задаёт минимальную гарантированную долю производительности vCPU в 5%.
Оба параметра позволяют существенно экономить облачные ресурсы в процессе обучения. 

----

### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

----

### Решение

Обновленный main.tf
```tf
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
  }

  metadata = {
    serial-port-enable = var.vm_web_serial_port
    ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
  }

}
```

Обновленный variables.tf
```tf
###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vms_ssh_public_root_key" {
  type        = string
  description = "Public SSH key for VM access"
}

###TASK 2

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Family image"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM Web name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Platform ID"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Number of CPU"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description = "RAM size in gb"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Core fraction %"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Preemptible"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "Enables NAT"
}

variable "vm_web_serial_port" {
  type        = number
  default     = 1
  description = "Enable or disable serial port"
}
```

Проверка terraform validate and terraform plan

![2](/2.png)

----

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

----

### Решение

Создал файл vms_platform.tf, так же внес изменения в main.tf:
Ключевые особенности vms_platform.tf
```tf
### NETWORK

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develop-db"
  description = "VPC network & subnet name"
}
### Скопированные переименованные параметры для прошлой ВМ + изменения по ресурсам.....
```
Ключевые особенности main.tf
```tf
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

### Подсеть DB
resource "yandex_vpc_subnet" "develop-db" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}
### WEB VM ......
### WEV VM ......

### DB VM

resource "yandex_compute_instance" "platform-db" {
  name        = var.vm_db_name
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone
  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-db.id
    nat       = var.vm_db_nat
  }
  metadata = {
    serial-port-enable = var.vm_db_serial_port
    ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
  }
}
```
В результате были развернуты 2 ВМ.

![3](/3.png)

----

### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

----

### Решение

Создал outputs.tf с одним output "vm_info"
```tf
output "vm_info" {
  description = "VM`s info"
  value = <<EOT

=========================================
  WEB:
=========================================
  Name:          ${yandex_compute_instance.platform.name}
  FQDN:          ${yandex_compute_instance.platform.fqdn}
  External IP:   ${yandex_compute_instance.platform.network_interface.0.nat_ip_address}
  Internal IP:   ${yandex_compute_instance.platform.network_interface.0.ip_address}
  CPU Cores:     ${yandex_compute_instance.platform.resources.0.cores}
  Core Fraction: ${yandex_compute_instance.platform.resources.0.core_fraction}%
  RAM GB:        ${yandex_compute_instance.platform.resources.0.memory}
  Disk Size GB:  ${yandex_compute_instance.platform.boot_disk.0.initialize_params.0.size}

=========================================
  DB:
=========================================
  Name:          ${yandex_compute_instance.platform-db.name}
  FQDN:          ${yandex_compute_instance.platform-db.fqdn}
  External IP:   ${yandex_compute_instance.platform-db.network_interface.0.nat_ip_address}
  Internal IP:   ${yandex_compute_instance.platform-db.network_interface.0.ip_address}
  CPU Cores:     ${yandex_compute_instance.platform-db.resources.0.cores}
  Core Fraction: ${yandex_compute_instance.platform-db.resources.0.core_fraction}%
  RAM GB:        ${yandex_compute_instance.platform-db.resources.0.memory}
  Disk Size GB:  ${yandex_compute_instance.platform-db.boot_disk.0.initialize_params.0.size}
EOT
}
```
При первом выводе обнаружил что не задан параметр fqdn для обеих машин.

![4.1](/4.1.png)

Добавил переменные и параметры.

Столкнулся с неприятной проблемой, которой нет в документации и ТП поддержка не смогла ответить на вопрос когда будет доступно. (Скриншот общения с тех поддержкой не стал выкладывать в публичный репозиторий)

![4.2](/4.2.png)

Временно отключил внешний ip для web и db, 
```
variable "vm_<web/db>_nat" {
  type        = bool
  default     = false #true
  description = "Enables NAT"
}
```

![4.3](/4.3.png)

----

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

----

### Решение

Создал переменные и обьединил их в locals.tf
```tf
locals {
  vm_web_local_name = "${var.vm_web_env}-${var.vm_web_role}-${var.vm_web_user}"
  vm_db_local_name  = "${var.vm_db_env}-${var.vm_db_role}-${var.vm_db_user}"
}
```
Заменил переменные в main.tf и применил изменения

![5](/5.png)

----

### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.

----

### Решение

Добавил в variables.tf новый блок  
```tf
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    nat           = bool
    preemptible   = bool
  }))
  description = "resources"
}

variable "metadata" {
  type        = map(string)
  description = "metadata"
}
```
Так же раскрыл его в personal.auto.tfvars
```tfvars
vms_resources = {
  web = {
    cores         = 2
    memory        = 1
    core_fraction = 5
    nat           = false
    preemptible   = true
  }
  db = {
    cores         = 2
    memory        = 2
    core_fraction = 20
    nat           = false
    preemptible   = true
  }
}

metadata = {
  serial-port-enable = "1"
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA---------------------RgYlBndW4 root@git-km"
}
```
Закоментировал все неиспользуемые переменные. (финальные файлы во вложении)

![6](/6.png)

------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

------

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.
------

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

**Важно. Удалите все созданные ресурсы**.




* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
