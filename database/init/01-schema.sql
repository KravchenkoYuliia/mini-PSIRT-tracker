CREATE TABLE products (
    id			bigserial PRIMARY KEY,
	name		varchar(100) NOT NULL,
	version		varchar(50) NOT NULL,
	UNIQUE		( name, version )
);

CREATE TABLE vulnerabilities (
	id					bigserial PRIMARY KEY,
	cve_id				varchar(20) NOT NULL UNIQUE,
	title				varchar(255) NOT NULL,
	cvss				numeric(3, 1) CHECK (cvss BETWEEN 0.0 AND 10.0),
	severity			varchar(10) NOT NULL DEFAULT 'NONE'
						CHECK (severity IN ('NONE','LOW','MEDIUM','HIGH','CRITICAL')),
	status				varchar(20) NOT NULL DEFAULT 'NEW',
	product_id			bigint NOT NULL REFERENCES products(id),
	fixed_in_version	varchar(50)

);