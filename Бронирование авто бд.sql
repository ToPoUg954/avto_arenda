Create Table Role 
(
    id int identity(1,1) primary key,
    name varchar(50),
    description varchar(500) -- описание роли
);

-- роль определяется через role_id)
Create Table Client 
(
    id int identity(1,1) primary key,
    role_id int references role(id), -- связь с ролью (role.id)
    last_name varchar(100), -- фамилия
    first_name varchar(100), -- имя
    middle_name varchar(100), -- отчество
    phone varchar(20),
    birth_date date -- дата рождения
);

-- пункты проката
Create Table Rental_point 
(
    id int identity(1,1) primary key,
    city varchar(100), -- город
    address varchar(255), -- адрес
    capacity int, -- вместимость парка/пункта
    manager_id int references client(id) 
    -- закреплённый менеджер (связь с client.id, у этого клиента роль 'менеджер')
);

-- таблица автомобилей
Create Table Car 
(
    vin varchar(17) primary key, -- vin — уникальный номер машины (первичный ключ)
    brand varchar(100), -- марка
    year int,  -- год выпуска
    mileage int,  -- пробег
    rental_point_id int references rental_point(id)
    -- в каком пункте проката сейчас стоит машина (связь с rental_point.id)
);

-- справочник статусов договора: черновик, активен, закрыт, отменён
Create Table contract_status 
(
    id int identity(1,1) primary key,
    name varchar(50)
);

-- таблица договоров аренды
Create Table rental_contract 
(
    id int identity(1,1) primary key,
    car_vin varchar(17) references car(vin), -- какая машина (связь с car.vin)
    pickup_point_id int references rental_point(id), -- пункт выдачи (связь с rental_point.id)
    return_point_id int references rental_point(id), -- пункт возврата (связь с rental_point.id)
    start_date date,
    end_date date,
    status_id int references contract_status(id) -- статус договора (связь с contract_status.id)
);

-- таблица бронирований: кто забронировал и по какому договору
Create Table booking 
(
    id int identity(1,1) primary key,
    client_id int references client(id),    -- кто бронирует (связь с client.id)
    contract_id int references rental_contract(id) -- по какому договору (связь с rental_contract.id)
);


-- 1) роли
insert into Role (name, description) values
('клиент',   'обычный клиент'),
('менеджер', 'менеджер пункта проката'),
('админ',    'администратор');

-- 2) клиенты (1-й иванов, 2-й — ты, 3-й сидоров-менеджер)
insert into Client (role_id, last_name, first_name, middle_name, phone, birth_date) values
(1, 'Софронова', 'Валентина', 'Николаевна',  '+7-900-111-22-33', '2008-08-9'),
(1, 'Токарева', 'Полина', 'Игоревна',  '+7-905-800-52-79', '2008-06-17'),
(2, 'Моисеенков', 'Арсений', 'Александрович', '+7-900-777-88-99', '2007-11-26');

-- 3) пункты проката (менеджер — сидоров, id=3)
insert into Rental_point (city, address, capacity, manager_id) values
('Москва', 'ул. Ленина, 13', 50, 3),
('Москва', 'ул. Кружская, 36', 30, 3),
('Тула', 'ул. Солнечная, 5', 20, 3);

-- 4) машины
insert into Car (vin, brand, year, mileage, rental_point_id) values
('xw8zzz61zkg000001', 'lada vesta', 2021, 45000,  1),
('xw8zzz61zkg000002', 'kia rio', 2020, 78000,  1),
('xw8zzz61zkg000003', 'toyota camry', 2022, 22000,  2),
('xw8zzz61zkg000004', 'hyundai solaris', 2019, 110000, 3);

-- 5) статусы договоров
insert into contract_status (name) values
('черновик'),
('активен'),
('закрыт'),
('отменён');

-- 6) договоры аренды
insert into rental_contract (car_vin, pickup_point_id, return_point_id, start_date, end_date, status_id) values
('xw8zzz61zkg000001', 1, 1, '2026-11-01', '2026-11-05', 3),  -- закрыт
('xw8zzz61zkg000002', 1, 2, '2026-11-10', '2026-11-15', 2),  -- активен
('xw8zzz61zkg000003', 2, 2, '2026-11-20', '2026-11-25', 1),  -- черновик
('xw8zzz61zkg000004', 3, 3, '2026-11-18', '2026-11-22', 2);  -- активен

-- 7) бронирования
insert into booking (client_id, contract_id) values
(2, 2),  -- ты забронировала договор №2
(1, 1),  -- Валя — договор №1
(1, 3),  -- Валя — договор №3
(1, 4);  -- Валя — договор №4
