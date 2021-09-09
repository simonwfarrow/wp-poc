export PGPASSWORD='clearing'; psql -h localhost -p 5432 -U clearing -c "CREATE TABLE payment (id char(36) NOT NULL UNIQUE PRIMARY KEY, merchant_id char(36) NOT NULL, total_value integer NOT NULL, currency char(3) NOT NULL, scheme char(16) NOT NULL, paid_at timestamp with time zone NOT NULL, status varchar(16) NOT NULL)"
export PGPASSWORD='clearing'; psql -h localhost -p 5432 -U clearing -c "INSERT INTO payment (id,merchant_id,total_value,currency,scheme,paid_at,status) VALUES('1c471ea8-07e9-4278-b0ac-d964b9a3cbbd', '27d2aadb-c444-4788-9195-5a42715a1d13', '50000', 'GBP', 'VISA', current_timestamp, 'NEW')"
export PGPASSWORD='clearing'; psql -h localhost -p 5432 -U clearing -c "INSERT INTO payment (id,merchant_id,total_value,currency,scheme,paid_at,status) VALUES('69702a64-772f-453f-9a1d-99e1ad913af8', '861edc23-ae0e-4a1d-84c8-c6aa98fb284e', '60000', 'GBP', 'VISA', current_timestamp, 'NEW')"
export PGPASSWORD='clearing'; psql -h localhost -p 5432 -U clearing -c "SELECT * FROM payment"

export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "CREATE TABLE merchant (id char(36) NOT NULL UNIQUE PRIMARY KEY, tariff varchar(16) NOT NULL)"
export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "CREATE TABLE blended_merchant (id char(36) NOT NULL UNIQUE, charge_percent float NOT NULL, fixed_charge_amount integer NOT NULL, fixed_charge_currency char(3) NOT NULL, CONSTRAINT fk_merchant FOREIGN KEY(id) REFERENCES merchant(id))"
export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "CREATE TABLE passthrough_merchant (id char(36) NOT NULL UNIQUE, charge_percent float NOT NULL, CONSTRAINT fk_merchant FOREIGN KEY(id) REFERENCES merchant(id))"

export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "INSERT INTO merchant (id, tariff) VALUES('27d2aadb-c444-4788-9195-5a42715a1d13', 'blended')"
export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "INSERT INTO merchant (id, tariff) VALUES('861edc23-ae0e-4a1d-84c8-c6aa98fb284e', 'passthrough')"
export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "INSERT INTO blended_merchant (id, charge_percent, fixed_charge_amount, fixed_charge_currency) VALUES('27d2aadb-c444-4788-9195-5a42715a1d13', 1, 2, 'GBP')"
export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "INSERT INTO passthrough_merchant (id, charge_percent) VALUES('861edc23-ae0e-4a1d-84c8-c6aa98fb284e', 1)"

export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "SELECT * FROM merchant"
export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "SELECT * FROM blended_merchant"
export PGPASSWORD='pricing'; psql -h localhost -p 5432 -U pricing -c "SELECT * FROM passthrough_merchant"