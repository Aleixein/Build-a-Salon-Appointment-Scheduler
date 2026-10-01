These are the commands and schema to create the database

customers
customer_id 		    phone				        name
serial primary key	varchar(40) unique	varchar(60)
CREATE TABLE customers(customer_id SERIAL PRIMARY KEY, phone VARCHAR(40) UNIQUE, name VARCHAR(60));

appointments
appointment_id		  customer_id		service_id	time
serial primary key	INT				    INT			    varchar(40) 
CREATE TABLE appointments(appointment_id SERIAL PRIMARY KEY, customer_id INT REFERENCES customers(customer_id), service_id INT REFERENCES services(service_id), time VARCHAR(40));

services
service_id			    name
1					          Haircut
2					          Color
3					          Perm
4					          Style
5					          Trim
serial primary key  varchar(30)
CREATE TABLE services(service_id SERIAL PRIMARY KEY, name VARCHAR(30));
INSERT INTO services(name) VALUES('Haircut'), ('Color'), ('Perm'), ('Style'), ('Trim');
