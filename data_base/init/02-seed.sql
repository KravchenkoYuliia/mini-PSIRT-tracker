INSERT INTO products (name, version)
VALUES
    ('Company gateway', '2.3.1'),
    ('Company Portal', '1.9.0');

INSERT INTO vulnerabilities (cve_id, title, cvss, severity, status, product_id, fixed_in_vesion)
VALUES
    ('CVE-2026-0001', 'Auth bypass in admin API',   9.8, 'CRITICAL', 'CONFIRMED', 1, NULL),
    ('CVE-2026-0002', 'Stored XSS in comments',     6.1, 'MEDIUM',   'TRIAGE',    2, NULL),
    ('CVE-2026-0003', 'Stack trace in error page',  3.7, 'LOW',      'FIXED',     2, '1.8.1'),
    ('CVE-2026-0004', 'Weak password policy',       NULL, 'NONE',    'NEW',       1, NULL);