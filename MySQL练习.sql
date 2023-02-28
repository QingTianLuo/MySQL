USE sql_store;

SELECT *
FROM customers
-- WHERE customer_id = 1
-- ORDER BY first_name
;

SELECT first_name, last_name, points, points+10
FROM customers;

SELECT 
	last_name,
    first_name,
    points,
    (points + 10) * 100 AS discount_factor
FROM customers;

SELECT 
	last_name,
    points + 10 AS "discount factor"
FROM customers;

SELECT state
FROM customers;
-- 修改表格，打开customer，修改第一个MA为VA，然后右下角确定alter
-- DISTINCT相当于去重
SELECT DISTINCT state
FROM customers;

-- exercise
SELECT 
	name,
    unit_price,
    unit_price * 1.1 AS new_price
FROM products;

SELECT *
FROM customers
WHERE points > 3000;

SELECT *
FROM customers
WHERE state != "VA";
-- !=与<>一个意思

SELECT *
FROM customers
WHERE birth_date > "1990-01-01"
;
-- exercise
SELECT *
FROM orders
WHERE order_date >= "2019-01-01";

SELECT *
FROM customers
WHERE birth_date > "1990-01-01" AND points > 1000;

SELECT * 
FROM customers
WHERE birth_date > "1990-01-01" OR points > 1000 AND state = "VA";
-- ADN优先于OR,或者用括号改变运算优先级

SELECT *
FROM customers
WHERE birth_date > "1990-01-01" OR 
	(points > 1000 AND state = "VA");

SELECT *
FROM customers
WHERE NOT (birth_date > "1990-01-01" OR points > 1000);

-- exercise
SELECT *
FROM order_items
WHERE order_id = 6 AND (quantity * unit_price > 30);

SELECT *
FROM customers
WHERE state = "VA" OR state = "GA" OR state = "FL";
-- 用IN改写
SELECT *
FROM customers
WHERE state IN ("VA", "GA", "FL");

SELECT *
FROM customers
WHERE state NOT IN ("VA", "GA", "FL");

-- exercise
SELECT *
FROM products
WHERE quantity_in_stock IN (49,38,72);

SELECT *
FROM customers
WHERE points >= 1000 AND points <= 3000;
-- BETWEEN改写
SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000;

-- exercise
SELECT *
FROM customers
WHERE birth_date BETWEEN "1990-01-01" AND "2000-01-01";

SELECT *
FROM customers
WHERE last_name LIKE "b%";
-- 大小写不要紧，%表示0到无数个字符,_表示一个字符
-- 上面b开头，下面只要含有b就行
SELECT *
FROM customers
WHERE last_name LIKE "%b%";
-- exercise
SELECT *
FROM customers
WHERE address LIKE "%TRAIL%" OR address LIKE "%AVENUE%";

SELECT *
FROM customers
WHERE phone LIKE "%9";

SELECT *
FROM customers
WHERE phone NOT LIKE "%9";

SELECT *
FROM customers
WHERE last_name LIKE "%field%";
-- 正则表达式REGEXP改写上文
SELECT *
FROM customers
WHERE last_name REGEXP "field";
-- ^f表示f开头，f$表示f结尾, f|g表示字符中含有f或者g
SELECT *
FROM customers
WHERE last_name REGEXP "^field|mac|rose";
-- e前面有gim中一个字母
SELECT *
FROM customers
WHERE last_name REGEXP "[gim]e";

SELECT *
FROM customers
WHERE last_name REGEXP "[a-h]e";
-- exercise
SELECT *
FROM customers
WHERE first_name REGEXP "ELKA|AMBUR";
SELECT *
FROM customers
WHERE last_name REGEXP "EY$|ON$";
SELECT *
FROM customers
WHERE last_name REGEXP "^MY|SE";
SELECT *
FROM customers
WHERE last_name REGEXP "B[RU]";

SELECT *
FROM customers
WHERE phone IS NULL;
SELECT *
FROM customers
WHERE phone IS NOT NULL;
-- exercise
SELECT *
FROM orders
WHERE shipper_id IS NULL;
-- 升序
SELECT *
FROM customers
ORDER BY first_name;
-- 降序
SELECT *
FROM customers
ORDER BY first_name DESC;
-- 多种方式的排序
SELECT *
FROM customers
ORDER BY state,first_name DESC;
-- mysql有一个好处，可以用没有选中的列来排序
SELECT first_name, last_name
FROM customers
ORDER BY birth_date;
SELECT first_name,last_name, 10 AS points
FROM customers
ORDER BY points, first_name;
-- exercise
SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY quantity*unit_price DESC;
-- 简写上述
SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;

SELECT *
FROM customers
LIMIT 3;
-- 跳过前6条数据，再选3条,这个交偏移量
SELECT *
FROM customers
LIMIT 6, 3;
-- exercise
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

USE sql_store;
SELECT *
FROM orders
INNER JOIN customers
	ON orders.customer_id = customers.customer_id;
-- INNER可以不用写，列重名需要指定表
SELECT order_id,orders.customer_id
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id;
-- 代码简化
SELECT order_id, o.customer_id
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;
-- exercise
SELECT order_id, oi.product_id, p.name, quantity, oi.unit_price
FROM order_items oi
JOIN products p 
	ON oi.product_id = p.product_id;
-- 跨库连接
SELECT *
FROM order_items oi
JOIN sql_inventory.products p 
	ON oi.product_id = p.product_id;
-- 自连接
USE sql_hr;
SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
JOIN employees m 
	ON e.reports_to = m.employee_id;
-- 多表连接
USE sql_store;
SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_statuses os ON o.status = os.order_status_id;
-- exercise
USE sql_invoicing;
SELECT 
	p.date,
	p.invoice_id,
    p.amount,
    c.name AS client_name,
    pm.name AS payment_name
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
JOIN clients c 
	ON p.client_id = c.client_id;
-- 复合连接，多个主键唯一识别一行数据
USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;

SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;
-- 用隐式连接改写,尽量不用,WHERE那句不写容易造成交叉连接
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;
-- 外连接,用于显示不满足JOIN条件的记录
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
-- OUTER可以省略,有LEFT与RIGHT,左表显示与右表显示
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT OUTER JOIN orders o 
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
-- exercise
SELECT 
	p.product_id,
    p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id;
-- 多表外连接
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON sh.shipper_id = o.shipper_id
ORDER BY c.customer_id;
-- exercise
SELECT 
	o.order_date,
    o.order_id,
    c.first_name,
    sh.name AS shipper,
    os.name AS status
FROM orders o
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
LEFT JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY  os.name;
USE sql_hr;
SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;
-- USING,列名一致才能用
USE sql_store;
SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper 
FROM orders o
JOIN customers c
	-- ON o.customer_id = c.customer_id
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);
-- 复合主键案例
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	USING (order_id, product_id);
-- exercise
USE sql_invoicing;
SELECT 
	p.date,
    c.name AS client,
    p.amount,
    pm.name
FROM payments p
LEFT JOIN clients c
	USING (client_id)
LEFT JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;
-- NATURAL 自然连接，系统自己找连接方式，结果未知，仅做了解。
USE sql_store;
SELECT 
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;
-- 交叉连接，相当于两个集合中的元素(每一行是一个元素)两两组合有多少种，叫笛卡尔积
SELECT 
	c.first_name AS customer,
	p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;
-- 做个隐式的
SELECT 
	c.first_name AS customer,
	p.name AS product
FROM customers c ,products p
ORDER BY c.first_name;
-- exercise
SELECT *
FROM shippers sh
CROSS JOIN products p;
SELECT *
FROM shippers sh, products p;
-- UNION 联合，其实就是行合并
SELECT 
	order_id,
    order_date,
    "Active" AS status
FROM orders
WHERE order_date >= "2019-01-01"
UNION 
SELECT 
	order_id,
    order_date,
    "Archived" AS status
FROM orders
WHERE order_date < "2019-01-01";
-- 不同表格试一下
SELECT name AS full_name
FROM shippers
UNION 
SELECT first_name
FROM customers;
-- exercise
SELECT 
	customer_id,
    first_name,
    points,
    "Bronze" AS type
FROM customers
WHERE points < 2000
UNION 
SELECT
	customer_id,
    first_name,
    points,
    "Sliver" AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT 
	customer_id,
    first_name,
    points,
    "Gold" AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;
-- 增加某一行,DEFAULT是默认参数,主键自动填充
USE sql_store;
INSERT INTO customers
VALUES(
	DEFAULT,
    "John",
    "Smith",
    "1990-01-01",
    DEFAULT,
    "address",
    "city",
    "CA",
    DEFAULT);
-- 指定列名，其余地方自动用默认值填充
INSERT INTO customers(
	first_name,
    last_name,
    birth_date,
    address,
    city,
    state)
VALUES (
	"John",
    "Smith",
    "1990-01-01",
    "address",
    "city",
    "CA");
-- 插入多行

INSERT INTO shippers(name)
VALUES ("shipper1"),
	("shipper2"),
    ("shipper3");
-- exercise
INSERT INTO products (
	name,
    quantity_in_stock,
    unit_price)
VALUES ("Smith",20,0),
	("Smith",21,1),
    ("Smith",22,2);
-- 插入分层行,相当于更新多张表
-- 有信息的一号顾客下了一单,这一单里面有两种产品
INSERT INTO orders (customer_id,order_date, status)
VALUES (1, "2019-01-02",1);
INSERT INTO order_items
VALUES (LAST_INSERT_ID(),1, 1, 2.95),
	(LAST_INSERT_ID(),2, 1, 3.95);
-- 创建表的副本,但是注意副本没有主键与递增了
CREATE TABLE orders_Archived AS 
SELECT * FROM orders;
-- 将上面的副本中数据删除,但保留副本这张表的结构
-- 右击，选择截断truncate即可
-- 现在将满足条件的数据复制到副本中
INSERT INTO orders_Archived
SELECT *
FROM orders
WHERE order_date < "2019-01-01" ;
-- exercise
USE sql_invoicing;
-- 创建副本
CREATE TABLE invoices_Archived1 AS
SELECT *
FROM invoices;
-- 清空副本之后填补数据
INSERT INTO invoices_Archived1
SELECT *
FROM invoices 
WHERE payment_date IS NOT NULL;
-- 直接用筛选好的数据建立副本
CREATE TABLE invoices_Archived AS
SELECT 
	i.invoice_id,
    i.number,
    c.name AS client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM invoices i
LEFT JOIN clients c
	ON i.client_id = c.client_id
WHERE payment_date IS NOT NULL;
-- 一张表可以先创副本再选数据，涉及JOIN的先把数据选好，直接创建副本
-- 下面更新某一行中的数据
UPDATE invoices
SET payment_total = 10, payment_date="2019-03-01"
WHERE invoice_id = 1;

UPDATE invoices
SET payment_total = DEFAULT, payment_date = DEFAULT
WHERE invoice_id = 1;

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE invoice_id = 3;

UPDATE invoices
SET 
	payment_total = DEFAULT,
	payment_date = DEFAULT
WHERE invoice_id = 3;
-- 更新多行数据
-- sql工作台只能更新一条数据，其他程序或者客户端可以更新多条
-- 所以要重新设置一下
-- Edit-Preference-SQL Edit-拉到最下面取消勾选安全更新按钮
-- 然后退出重开工作台
USE sql_invoicing;
UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id = 3;

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id  IN (3, 4);
-- exercise
USE sql_store;
UPDATE customers
SET points = points + 10
WHERE birth_date < "1990-01-01";
-- UPDATE子句
-- 会先运行加括号的部分
USE sql_invoicing;
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id = 
	(SELECT client_id
    FROM clients
    WHERE name = "Myworks");
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id IN 
	(SELECT client_id
	FROM clients
    WHERE state IN ("CA", "NY"));
-- 更新前先查出来看下是什么
-- exercise
USE sql_store;
UPDATE orders
SET comments = "Gold customers"
WHERE customer_id IN 
	(SELECT customer_id
    FROM customers
    WHERE points > 3000);
-- 删除数据(这一块报错，好像不能删)
DELETE FROM orders
WHERE customer_id IN 
	(SELECT customer_id
    FROM customers
    WHERE first_name = "Babara");

DELETE FROM orders
WHERE customer_id = 1;
-- 恢复数据库
-- file-open_sql_script,然后打开create-databases.sql文件运行一下就好。
-- 不要恢复，不然后面答案对不上。
USE sql_invoicing;
SELECT 
	MAX(invoice_date) AS date,
	MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS  average,
    SUM(invoice_total) AS total,
    SUM(invoice_total * 1.1) AS total_mutiply,
    COUNT(invoice_total) AS number_of_invoices,
    COUNT(payment_date) AS count_of_payments,
    COUNT(*) AS total_records,
    COUNT(client_id) AS total_records_one,
    COUNT(DISTINCT client_id) AS total_records_two
FROM invoices
WHERE invoice_date > "2019-07-01";
-- 函数只运行非空值,空值不做运算
-- exercise
SELECT
	"First half of 2019" AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total) - SUM(payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date < "2019-07-01"
UNION
SELECT 
	"Second half of 2019" AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total) - SUM(payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date >= "2019-07-01"
UNION 
SELECT 
	"Total" AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total) - SUM(payment_total) AS what_we_expect
FROM invoices;
SELECT 
	client_id,
	SUM(invoice_total) AS total_sales
FROM invoices
WHERE invoice_date >= "2019-07-01"
GROUP BY client_id
ORDER BY total_sales DESC;

SELECT
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients USING (client_id)
GROUP BY state, city;
-- exercise
SELECT 
	date,
    pm.name AS payment_method,
    SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY date, payment_method
ORDER BY date;
-- WHERE分组前筛选数据,HAVING分组后筛选数据
-- HAVING后的列必须是SELECT中的，WHERE中的可以不是
SELECT 
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id
HAVING total_sales > 500;
SELECT 
	client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5;
-- exercise,这个案例有意思
-- 一般来讲,SELECT选中的都要拿来分组排序
USE sql_store;
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING(order_id)
WHERE state = "VA"
GROUP BY 
	c.customer_id,
    c.first_name,
    c.last_name
HAVING total_sales > 100;
-- WITH ROLLUP只计算SUM等聚合函数的总和
-- 只能在sql中用,sql_sever与oracle中不能用
USE sql_invoicing;
SELECT 
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP;
SELECT
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c USING(client_id)
GROUP BY state, city WITH ROLLUP;
-- exercise
-- WITH ROLLUP前面那个位置不要使用别名
SELECT 
	pm.name AS payment_method,
    SUM(p.amount) AS total
FROM payments p
JOIN payment_methods pm 
	ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;
-- 学会写子查询,先运行括号里面的代码
USE sql_store;
SELECT *
FROM products
WHERE unit_price > 
	(SELECT unit_price
    FROM products
    WHERE name LIKE "%Lettuce%" );
-- exercise
USE sql_hr;
SELECT *
FROM employees
WHERE salary > 
	(SELECT 
		AVG(salary)
	FROM employees);
USE sql_store;
SELECT *
FROM products
WHERE product_id  NOT IN 
	(SELECT DISTINCT product_id
    FROM order_items);
-- exercise
USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id NOT IN
	(SELECT DISTINCT client_id
    FROM invoices);
-- 用JOIN改写
SELECT * 
FROM clients
LEFT JOIN invoices USING(client_id)
WHERE invoice_id IS NULL;
-- exercise
USE sql_store;
SELECT  
	DISTINCT c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
JOIN orders o USING(customer_id)
JOIN order_items oi USING(order_id)
WHERE product_id = 3;
-- 直接从产品开始写,上面是知道了产品id
USE sql_store;
SELECT  
	DISTINCT c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
JOIN orders o USING(customer_id)
JOIN order_items oi USING(order_id)
JOIN products p USING(product_id)
WHERE P.name LIKE "%Lettuce%";
-- 子查询改写上述的
SELECT 
	DISTINCT c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
WHERE c.customer_id IN (
	SELECT DISTINCT o.customer_id
    FROM orders o
    WHERE o.order_id IN (
		SELECT oi.order_id
        FROM order_items oi
        WHERE oi.product_id = 3)
	);
USE sql_invoicing;
SELECT *
FROM invoices
WHERE invoice_total > (
	SELECT MAX(invoice_total)
    FROM invoices
    WHERE client_id = 3);
-- ALL 改写
SELECT *
FROM invoices
WHERE invoice_total > ALL(
	SELECT invoice_total
    FROM invoices
    WHERE client_id = 3);

SELECT 
	client_id
FROM invoices
GROUP BY client_id
HAVING count(*) >= 2;
-- 改写上述
SELECT *
FROM clients
WHERE client_id IN(
	SELECT client_id
    FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2
);
-- 第三种写法
SELECT *
FROM clients
WHERE client_id =  ANY(
	SELECT client_id
    FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2);
USE sql_hr;
-- 相关子查询,有点for循坏的意思
SELECT *
FROM employees e
WHERE salary > (
	SELECT AVG(salary)
    FROM employees em
    WHERE em.office_id = e.office_id);
-- exercise
USE sql_invoicing;
SELECT *
FROM invoices i
WHERE i.invoice_total > (
	SELECT AVG(inv.invoice_total)
    FROM invoices inv
    WHERE inv.client_id = i.client_id);

SELECT  *
FROM clients
WHERE client_id IN(
	SELECT DISTINCT client_id
    FROM invoices);
-- 用JOIN改写
SELECT 
	DISTINCT c.client_id,
    c.name,
    c.address,
    c.city,
    c.state,
    c.phone
FROM clients c
JOIN invoices i USING(client_id);
-- 用IN来写
SELECT *
FROM clients c
WHERE c.client_id IN (
	SELECT DISTINCT i.client_id
    FROM invoices i);
-- 用EXISTS来写,IN是执行括号，返回列表
-- EXISTS是看满足条件返回TRUE值，逐行看满足条件不
SELECT *
FROM clients c
WHERE EXISTS (
	SELECT i.client_id 
    FROM invoices i
    WHERE i.client_id = c.client_id);
-- exercise
USE sql_store;
SELECT *
FROM products p
WHERE NOT EXISTS (
	SELECT oi.product_id
    FROM order_items oi
    WHERE oi.product_id =p.product_id);
USE sql_invoicing;
SELECT 
	invoice_id,
    invoice_total,
    (SELECT AVG(i.invoice_total) FROM invoices i) AS invoice_average,
    invoice_total - (SELECT invoice_average) AS difference
    -- 上面这里加SELECT变成一列了,不加是个数
	-- 或者把第三行AS前的语句放这里是一样的
FROM invoices;
-- exercise
SELECT 
	client_id,
    name,
    (SELECT SUM(invoice_total)
    FROM invoices
    WHERE client_id = c.client_id) AS total_sales,
    (SELECT AVG(invoice_total) FROM invoices) AS average,
    (SELECT total_sales - average) AS difference
FROM clients c;
-- 上面搞出来的表可以作为一张独立的表来用
SELECT *
FROM (
	SELECT 
		client_id,
		name,
		(SELECT SUM(invoice_total)
		FROM invoices
		WHERE client_id = c.client_id) AS total_sales,
		(SELECT AVG(invoice_total) FROM invoices) AS average,
		(SELECT total_sales - average) AS difference
	FROM clients c) AS sales_summary
WHERE total_sales IS NOT NULL;

SELECT ROUND(5.32,1);-- 保留几位小数
SELECT TRUNCATE(5.7365, 2); -- 截断，不四舍五入
SELECT CEILING(5.3);
SELECT FLOOR(5.3);
SELECT ABS(-3);
SELECT RAND();-- 0-1之间的随机数
-- 网上搜索mysql numeric functions看更多的
SELECT LENGTH("sky");
SELECT UPPER("sky");
SELECT LOWER("SKY");
SELECT LTRIM("  sky"); -- 移除左侧空白
SELECT RTRIM("sky  "); -- 移除右侧空白
SELECT TRIM("  sky  ");
SELECT LEFT("Kindergarten", 4); -- 左侧四个数字
SELECT RIGHT("Kindergarten", 6); -- 右侧六个数字
SELECT SUBSTRING("Kindergarten", 3, 5); -- 起止点，长度
SELECT LOCATE("N","Kindergarten"); -- 找字符的起始位置,不区分大小写
SELECT LOCATE("q", "kindergarten"); -- 没有的话会变成0，不会报错，注意
SELECT LOCATE("garten", "kindergarten"); 
SELECT REPLACE("kindergarten", "garten", "garden");
SELECT CONCAT("first", "last");
USE sql_store;
SELECT CONCAT(first_name, " ", last_name) AS full_name
FROM customers;
-- mysql string functions
SELECT NOW(), CURDATE(), CURTIME(), DAYNAME(NOW()), MONTHNAME(NOW());
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), MINUTE(NOW()), SECOND(NOW());
-- EXTRACT是标准的sql语言，放到别的DBMS里面都可以的
SELECT EXTRACT(DAY FROM NOW()), EXTRACT(YEAR FROM NOW());
SELECT *
FROM orders
WHERE order_date >= (SELECT CONCAT(YEAR(NOW()),"-","01","-","01"));
-- 改写简单一点
SELECT *
FROM orders
WHERE YEAR(order_date) = YEAR(NOW());
SELECT DATE_FORMAT(NOW(), "%m %d %y"), DATE_FORMAT(NOW(),"%M %D %Y"); 
-- 小写的y表示两位数年份，大写的Y表示四位数年份
-- 小写的m表示数字月份，大写的M表示文字月份
-- mysql date format string看详细解析
SELECT TIME_FORMAT(NOW(),"%H:%i %p");
SELECT DATE_ADD(NOW(),INTERVAL 1 DAY);-- 增加一天
SELECT DATE_ADD(NOW(),INTERVAL 1 YEAR);-- 增加一年
SELECT DATE_ADD(NOW(),INTERVAL -1 DAY);-- 减少一天
SELECT DATE_SUB(NOW(),INTERVAL 1 DAY); -- 减少一天
SELECT DATEDIFF("2019-01-05 09:00", "2019-01-01 17:00"); -- 日期差值,只返回天数，这个函数
SELECT TIME_TO_SEC("09:00");-- 当天0点的到该点的秒数
SELECT TIME_TO_SEC("09:00") - TIME_TO_SEC("09:02"); -- 得到负数是因为顺序原因
-- IFNULL 满足条件就填充，不满足就原始值
SELECT
	order_id,
    IFNULL(shipper_id, "Not assigned") AS shipper
FROM orders;
-- COALESCE (1,2,3),如果1是空，就显示2,2是空就显示3,返回第一个空值
SELECT
	order_id,
    COALESCE(shipper_id, comments, "Not assigned") AS shipper
FROM orders;
-- exercise
SELECT
	CONCAT(first_name," ",last_name) AS customer,
    IFNULL(phone, "Unknown") AS phone
FROM customers;
SELECT 
	order_id,
    order_date,
    IF(
		YEAR(order_date) = YEAR(NOW()),
        "Active",
        "Archive") AS category
FROM orders;
-- exercise
SELECT 
	p.product_id,
    p.name,
    COUNT(*) AS orders,
    IF(COUNT(*) > 1, "Many times", "Once") AS frequency
FROM products p 
LEFT JOIN order_items oi USING(product_id)
GROUP BY p.product_id, p.name;
-- CASE用于多个条件判断，if是单个条件判断
SELECT
	order_id,
    CASE
		WHEN YEAR(order_date) = YEAR(NOW()) THEN "Active"
        WHEN YEAR(order_date) = YEAR(NOW()) -1 THEN "Last Year"
        WHEN YEAR(order_date) < YEAR(NOW()) -1 THEN "Archived"
        ELSE "Future"
	END AS category
FROM orders;
-- exercise
SELECT 
	CONCAT(first_name," ", last_name) AS customer,
    points,
    CASE
		WHEN points > 3000 THEN "Gold"
        WHEN points BETWEEN 2000 AND 3000 THEN "Silver"
        WHEN points < 2000 THEN "Bronze"
        ELSE "Others"
	END AS category
FROM customers
ORDER BY points DESC;
-- WHEN >3000 >=2000 ELSE 也行，逐级判断的
-- 创建视图,子查询出来的表，弄进视图下次想用就不用再写代码了
-- 相当于一个虚拟表，不储存数据的，table里面数据变量，视图数据会相应的改变
-- 拿来当table用的，功能差不多
USE sql_invoicing;
CREATE VIEW sales_by_client AS
SELECT
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name;
-- 用VIEW
SELECT *
FROM sales_by_client
JOIN clients USING(client_id)
WHERE total_sales > 500
ORDER BY total_sales DESC;
-- exercise
CREATE VIEW clients_balance AS
SELECT 
	c.client_id,
    c.name,
    SUM(invoice_total - payment_total) AS balance
FROM clients c
LEFT JOIN invoices i USING(client_id)
GROUP BY c.client_id, c.name;
-- 更新或者删除视图，需求有问题需要改一下
-- 方法1 删除，重建
DROP VIEW sales_by_client;
-- 方法2 REPLACE
CREATE OR REPLACE VIEW clients_balance AS
SELECT 
	c.client_id,
    c.name,
    SUM(invoice_total - payment_total) AS balance
FROM clients c
LEFT JOIN invoices i USING(client_id)
GROUP BY c.client_id, c.name;
-- 方法2代码找不到怎么办
-- VIEW保存为sql文件,文件放到源码控制,文件放入Git存储库并与他人分享存储库
-- 这样他人可以在他人电脑上自建这个数据库
-- 将这个文件保存在叫"视图"的文件夹里,取名sales_by_client,
-- 文件夹名字view,文件名字是sales_by_client
-- 然后文件夹放到源码控制中。
-- 如果团队不使用源码控制，回到视图界面，点扳手，以编辑模式打开视图就能看见源码
-- 代码会有点花哨，自己按照写代码的改好，右下角确认一下就好
-- 最好还是从源码里面修改，最好的办法，编辑模式比较花哨
 
-- 可更新视图就是视图中不包含下面的关键词
-- DISTINCT，MAX()类函数，GROUP BY，HAVING，UNION
-- 这样就可以在 INSRET UPDATE DELETE语句中使用这类视图
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0;
-- 上面这个视图是可更新视图,就是可以修改数据
DELETE FROM invoices_with_balance
WHERE invoice_id = 1;
UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;
-- 插入新发票有点复杂,只有视图表中有所有基础表要用到的列才能插入
-- 如果视图表中没有invoice_date,就不能插入任何行了,因为表(invoices)不允许插入的日期列为空值
-- 其实就是视图是从表来的，所以要按照表的规矩来插入
-- 为什么不更新表，而更新视图，是因为处于安全考虑,没有某张表的权限

-- 注意更新视图的时候原始table中的数据也会变
UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 2;
-- 上面更新以后有一行数据没有了,现在不想让这一行消失,用WITH CHECK OPTION 
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0
WITH CHECK OPTION;
UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 3;
-- 这个的意思是你要修改的那一行在视图里面会消失就会报错，不管是VIEW还是table都不会修改
UPDATE invoices
SET payment_total = 1
WHERE invoice_id = 3;
-- 更新了table中的数据，VIEW中的数据会相应发生改变
-- VIEW优点
-- 优点1，简化查询
-- 优点2，view一头连接table，一头连接查询代码，table变了以后改view就好，查询不用改
-- 优点3，table中有些数据不让看，做view时删选出去就好了
-- 有一个疑点，改VIEW也会改变table，就像直接删invoice_id = 1 ,原始table中的这一行也没有了

-- stored procedure,存储过程，一个包含一堆sql代码的数据库对象
-- 优点1，sql代码与应用代码如java要分开才不乱，上sql代码存在stored_procedure
-- 应用程序通过调用这些过程来获取数据
-- 优点2，DBMS--database manager system可以对存储过程中的代码优化
-- 所以存储过程中的sql代码执行得很快
-- 优点3 存储过程加强安全性，取消对table的直接访问，使插入，更新，删除全部由存储过程来实现
-- 指定执行存储过程的某一人，限制用户的访问，防止其删除数据
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT * FROM clients;
END$$
DELIMITER ;
-- BEGIN与END之间是存储的主体，每个语句后都要加分号，一个也要，
-- DELIMITER是改变分隔符的，不设置，到分号那里就算结束
-- 后面再写DELIMITER 是为了将分号作为语句结束的分隔符改回来
-- 这样$$ $$围起来的会被视为一个完整的语句
-- 其实与Python中写的函数差不多，后期直接调用，就像下面这样
CALL get_clients();
-- exercise
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance ()
BEGIN 
	SELECT * FROM invoices_with_balance;
END$$
DELIMITER ;
;
-- 每次改变分隔符比较麻烦,直接工作台右击存储过程来建比较方便
-- 反引号不用管,那是sql怕你写自带关键词,打个引号好识别
-- name:get_payments, body:SELECT * FROM payments
-- 整完之后右下角确认即可
-- 删除存储过程
DROP PROCEDURE IF EXISTS get_clients;
-- 最好是建个文件夹store_procedure，然后把下面代码存在里面，就像view那里
-- 创建存储过程的正确架构是下面这样的
DROP PROCEDURE IF EXISTS get_clients;
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT * FROM clients;
END$$
DELIMITER ;
;
-- 带参数的存储过程,其实就是Python写函数
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(state CHAR(2)
)
BEGIN
	SELECT * FROM clients c
    WHERE c.state = state;
END$$
DELIMITER ;
;
-- 调用
CALL get_clients_by_state("CA");
-- exercise
DROP PROCEDURE IF EXISTS get_invoices_by_client;
DELIMITER $$
CREATE PROCEDURE get_invoices_by_client
	(client_id INT)
BEGIN 
	SELECT * FROM invoices i
    WHERE i.client_id = client_id;
END$$
DELIMITER ;
;
-- 调用
CALL get_invoices_by_client(1);
-- 整个默认参数的存储过程
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(state CHAR(2)
)
BEGIN
	IF state IS NULL THEN
		SET state = "CA";
	END IF;
	SELECT * FROM clients c
    WHERE c.state = state;
END$$
DELIMITER ;
;
CALL get_clients_by_state(NULL);
-- 空值选全部顾客
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(state CHAR(2)
)
BEGIN
	IF state IS NULL THEN
		SELECT * FROM clients;
	ELSE
		SELECT * FROM clients c
		WHERE c.state = state;
	END IF;
END$$
DELIMITER ;
;
-- 调用
CALL get_clients_by_state(NULL);
-- 用IFNULL来简化
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(state CHAR(2)
)
BEGIN
	SELECT * FROM clients c
	WHERE c.state = IFNULL(state, c.state);
END$$
DELIMITER ;
;
-- 调用
CALL get_clients_by_state(NULL);
-- exercise
DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments
	(client_id INT,
	payment_method_id TINYINT)
BEGIN 
	SELECT *
    FROM payments p
    WHERE 
		p.client_id = IFNULL(client_id, p.client_id) AND
        p.payment_method = IFNULL(payment_method_id, p.payment_method);
END$$
DELIMITER ;
;
-- 调用
CALL get_payments(NULL,NULL);
CALL get_payments(5,NULL);
CALL get_payments(NULL,1);
-- 参数验证，其实就是出入参数不符合要求，后面给出错误提示，和Python函数输错误参数的提示一样
-- 直接在面板那里建一个存储过程就好
USE sql_invoicing;
-- CREATE PROCEDURE `make_payment` (
--	invoice_id INT,
--    payment_amount DECIMAL(9,2),
--    payment_date DATE)
-- BEGIN
--	UPDATE invoices i
--	SET
--		i.payment_total = payment_amount,
--       i.payment_date = payment_date
--	WHERE i.invoice_id = invoice_id;
-- END
-- 在面板更新,2,100,2019-01-01
-- table中的数据更新了
-- 有一个问题是,现在想要第二个参数输入负数的时候提示错误,现在修改存储程序
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `make_payment`(
--	invoice_id INT,
--    payment_amount DECIMAL(9,2),
--    payment_date DATE)
-- BEGIN
--	IF payment_amount <= 0 THEN
--		SIGNAL SQLSTATE "22003"
--			SET MESSAGE_TEXT = "Invalid payment amount";
--	END IF;
    
--	UPDATE invoices i
--	SET
--		i.payment_total = payment_amount,
--       i.payment_date = payment_date
--	WHERE i.invoice_id = invoice_id;
-- END
-- 第二个参数输入-100，就会得到报错Invalid payment amount
call sql_invoicing.make_payment(2, -100, '2019-01-01');
-- 输出参数,同样在面板那里操作
-- CREATE PROCEDURE `get_unpaid_invoices_for_client` (
--	client_id INT)
-- BEGIN
--	SELECT COUNT(*), SUM(invoice_total)
--    FROM invoices i
--    WHERE i.client_id = client_id AND 
--		payment_total = 0;
-- END
-- 调用
call sql_invoicing.get_unpaid_invoices_for_client(5);
-- 输出参数，其实就像Python先赋值为i=0,然后求和，最后return后i=100这种
 -- CREATE PROCEDURE `get_unpaid_invoices_for_client` (
--	client_id INT,
--	OUT invoices_count INT,
--	OUT invoices_total DECIMAL(9,2))
-- BEGIN
--	SELECT COUNT(*), SUM(invoice_total)
--	INTO invoices_count, invoices_total
--    FROM invoices i
--    WHERE i.client_id = client_id AND 
--		payment_total = 0;
-- END
-- 面板那里调用会出现下面的代码
set @invoices_count = 0;
set @invoices_total = 0;
call sql_invoicing.get_unpaid_invoices_for_client(5, @invoices_count, @invoices_total);
select @invoices_count, @invoices_total;
-- 变量,有点局部变量与全局变量的意思
-- User or session Variables 客户会话中保存,客户从sql掉线就被清空，全局变量
SET @invoices_count = 0;
-- Local variables,不会在客户端会话过程中保存,存储过程完结,变量就被清空，局部变量
-- 面板建一个新的存储过程
-- CREATE PROCEDURE `get_risk_factor` ()
-- BEGIN
--	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
--   DECLARE invoices_total DECIMAL(9,2);
--    DECLARE invoices_count INT;
--   
--    SELECT COUNT(*), SUM(invoice_total)
--    INTO invoices_count,invoices_total
--    FROM invoices;
--   
--    SET risk_factor = invoices_total / invoices_count * 5;
--    
--    SELECT risk_factor;
-- END
-- 上面就是声明使用本地变量，执行完就被抹去了，就像局部变量一样
-- 下面是自己写函数就像求和，求均值这种内置的函数一样
-- 函数与存储过程的区别，函数只能返回单一的值，存储过程能返回多行多列的值
-- 面板那里写函数
-- rerurns后面那个是函数返回的值的类型,下面那一行是函数的属性
-- 每个sql都至少要有一个属性
 -- 1、DETERMINISTIC(确定性),给同样的值返回一样的值
 -- 2、READS SQL DATA(读取sql数据)
 -- 3、MODIFIES SQL DATA(修改sql中的数据),相当于函数中有插入,更新或者删除函数
-- CREATE FUNCTION `get_risk_factor_for_client` (
--	client_id INT)
-- RETURNS INTEGER
-- READS SQL DATA
-- BEGIN
--	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
--	DECLARE invoices_total DECIMAL(9,2);
--    DECLARE invoices_count INT;
--    
--    SELECT COUNT(*), SUM(invoice_total)
--    INTO invoices_count,invoices_total
--    FROM invoices i
--    WHERE i.client_id = client_id;
--    
--    SET risk_factor = invoices_total / invoices_count * 5;
--	RETURN IFNULL(risk_factor, 0);
-- END
-- 调用
SELECT 
	client_id,
    name,
    get_risk_factor_for_client(client_id) AS risk_factor
FROM clients ;
-- 删除函数
DROP FUNCTION IF EXISTS get_risk_factor_for_client;
-- 触发器，以payments与invoices为例
-- 一个客户有多张发票，每张发票有不同的支付方式（现金或者卡）
-- 当我更新了payment里面的支付金额时，invoices里面的数据也要自动更新
DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_insert;
CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN 
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END $$
DELIMITER ;
;
-- 调用
INSERT INTO payments
VALUES (DEFAULT, 5, 3, "2019-01-01", 10, 1);
-- 上面代码运行完之后，invoices里面客户5的发票3的支付总额增加了10
-- exercise
DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_delete;
CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
	FOR EACH ROW
BEGIN 
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
END $$
DELIMITER ;
;
-- 调用,删除上面插入的那一行
DELETE 
FROM payments
WHERE payment_id = 10;
-- 查看触发器或者只查看某些触发器
-- 触发器这里发现一个问题，invoices里面的payment_total本来是由payments表里面的数据加总的
-- 但是刚刚发现，这两个数据并不一定依照这个关系，这是为什么？
SHOW TRIGGERS;
SHOW TRIGGERS LIKE "payments%";
-- 删除触发器
DROP TRIGGER IF EXISTS payments_after_insert;-- 这个句子最好放在CREATE之前，就像前面的存储与函数一样
-- 用触发器进行审计,其实就是新建一个表，然后在触发器里面加点代码，让每次删减更新了什么记在表里面
-- 先建立一张表
USE sql_invoicing;
CREATE TABLE payments_audit
	(
    client_id      INT           NOT NULL,
    date           DATE          NOT NULL,
    amount         DECIMAL(9,2)  NOT NULL,
    action_type    VARCHAR(50)   NOT NULL,
    action_date    DATETIME      NOT NULL)
-- 重建插入的触发器并加上审计代码
DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_insert;
CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN 
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, "Insert", NOW());
END $$
DELIMITER ;
;
-- 重建删除的触发器并加上审计代码
DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_delete;
CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
	FOR EACH ROW
BEGIN 
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    
	INSERT INTO payments_audit
    VALUES (OLD.client_id, OLD.date, OLD.amount, "Delete", NOW());
END $$
DELIMITER ;
;
-- 开始插入
INSERT INTO payments
VALUES (DEFAULT, 5, 3, "2019-01-01", 10, 1);
-- 删除刚刚插入的 id是11
DELETE FROM payments
WHERE payment_id = 11;
-- 现在审计表中有两条记录了
-- 事件,是根据计划执行的任务，其实就是定时，每一天10点执行一次，有点自动化的意思
-- 事件需要调度器来执行,调度器是一个后台程序,每时每刻都在寻找需要执行的事件
-- 自动化数据库的维护任务
-- 调出调度器
SHOW VARIABLES;-- 看系统中的变量
SHOW VARIABLES LIKE "event%"; -- 找事件管理器的变量,ON意味着打开的，OFF意味着关闭的
-- 打开关闭调度器的方法,关闭是为了节省系统资源
SET GLOBAL event_scheduler = OFF;
SET GLOBAL event_scheduler = ON;
-- 创建一个事件,删除超过一年的审计记录
DELIMITER $$
CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE
-- AT "2019-06-01",这种是执行一次的
	EVERY 1 YEAR STARTS "2019-01-01" ENDS "2029-01-01"
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$
DELIMITER ;
;
-- 看下系统中的事件
SHOW EVENTS;
SHOW EVENTS LIKE "yearly%";
-- 删除事件
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;
-- ALTER EVENTS,用来修改事件,而不用删除再重建,其实就是CREATE改为ALTER就行了
DELIMITER $$
ALTER EVENT yearly_delete_stale_audit_rows
ON SCHEDULE
-- AT "2019-06-01",这种是执行一次的
	EVERY 1 YEAR STARTS "2019-01-01" ENDS "2029-01-01"
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$
DELIMITER ;
;
-- 用ALTER EVENT来暂时启用或者禁用一个事件
ALTER EVENT yearly_delete_state_audit_rows DISABLE;
ALTER EVENT yearly_delete_state_audit_rows ENABLE;
-- 事务，是代表单个工作单元的一组sql语句
-- 所有的语句都要执行成功，否则事务会运行失效
-- 列如，我的卡转钱给别人，我的钱减少与别人的钱增多，两个操作都要完成
-- 两个操作一起就是一个工作单元，这个事务才算完成
-- 就像order与order_item，在一个里面插入数据，断电了，就会得到不一致的数据
-- 这时候就用事务，两个里面有一个搞不成，全部都白干
-- 事务的性质ACID
-- Atomicity 每个事务不管包含多少语句，都是一个工作单元
-- 要么所有语句都成功执行并且事务被提交
-- 要么事务被退回,所有更改被撤销
-- Consistency 使用事务，数据库始终保持一致,就像orders与order_items
-- Isolation,事务相互隔离,不相互干扰,多个事务更新相同的数据一个一个的来
-- Durablity,一旦事务被提交,事务产生的更改是永久的,就算停电或系统崩溃,也不会丢失更改内容
-- 创建一个事务来存储一笔带有项目的订单
-- 先恢复一下数据库，就是把给的sql数据文件重新运行一遍
USE sql_store;
START TRANSACTION;
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, "2019-01-01", 1);
INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1);
COMMIT;
-- 执行上述代码,两张表都增加了数据,保证了数据的一致性
-- 某些情况下进行一些错误检查,并手动退回事务,这种情况情况下使用ROLLBACK,而不是commit
-- 使用ROLLBACK会退回事务并撤销所有更改
START TRANSACTION;
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, "2019-01-01", 1);
INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1);
ROLLBACK;
-- MySQL会装好写在事务里面的每一条语句,如果语句没有错误就会提交
-- 所以当有INSERT UPDATE DELETE语句时,MySQL会先装在事务里面,然后自动提交
-- 这些由一个叫做autocommit的系统变量来控制
SHOW VARIABLES LIKE "autocommit";
-- 所以每当执行一句语句 ,MySQL将该语句放进事务中,如果语句没有引发错误就提交
-- 并发与锁定
-- 并发就是多个人,都在打开sql对同一个数据库中的数据进行修改
-- 所以这里需要,在最开始的local instance重现开一个界面,模仿两个人在修改数据,最左上角那个回主页的点一下就看到界面了
-- 锁定的意思就是,一个人执行事务修改数据整好了,下一个人才有机会修改数据
-- 两位用户同时更新给定顾客的积分 
-- 第一个LOCAL instance下的代码
-- 现在第一个顾客有2273的积分,下面的代码一句句运行,commit那里不运行
-- 然后复制这段代码到第二个local instance下面,也是不运行commit
-- 这个时候文件名那里一直转圈圈就是那一行被前一个用户锁定了
-- 后面先回第一个local执行commit,再到第二个local执行commit
-- 现在第一个客户变成2293了
USE sql_store;
START TRANSACTION;
UPDATE customers
SET points = points + 10
WHERE customer_id = 1;
COMMIT;
-- 并发带来的常见问题及使用事务隔离级别的解决方式
-- 1、Lost Updates 两个事务更新相同数据没有上锁，较晚提交的事务覆盖较早提交的事务
-- John NY 10
-- 事务A John VA 10
-- 事务B John NY 20
-- 事务A更新了但是没有提交，等B提交后最终结果和B的一致，A的被覆盖了
-- Dirty Reads，事务读取了尚未被提交的数据
-- 事务A把积分从10改为20，还没来得及提交，事务B就读取了数据（10）
-- 相当于拿没有更新的数据来做分析
-- 用隔离级别READ COMMITTED 
-- Non-repeating Reads 事务中添加更多隔离时候
-- 就是读取同一个数据得到不同结果
-- 我先读取了10分，还没搞完，这个时候别人更新数据为0，我后面再读就是0了，对不上
-- 用隔离级别REPEATABLE READ，这样我还是得到10，不管别人更新的
-- Phantom Reads
-- 这就是我给积分大于10的人发短信，但同时他人新增一位顾客积分为12，但没有被查询返回
-- 这个时候我发短信的人里面就漏掉了这个人
-- 相当于我饭都做好了，多来了一个人
-- 用隔离级别SERIALIZABLE，就是等人家更新好，我再搞，这样就不会漏掉了
-- 事务隔离级别与并发问题
--                         Lost Updates      Dirty Reads      Non-repeating Reads     Phantom Reads
--     READ UNCOMMITTED
--     READ COMMITTED                              1
-- 默认REPEATABLE READ          1                  1                      1
--     SERIALIZABLE             1                  1                      1                    1
-- 设置事务隔离级别
-- 查看隔离级别
SHOW VARIABLES LIKE "transaction_isolation";
-- 为下一个事务设置隔离级别
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- 当前会话或者以后所有的事务设置隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- 所有会话中的所有新事务设置全局隔离级别
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- 读未提交隔离级别-READ UNCOMMITTED
-- 打开两个Local instance
-- 第一个输入
USE sql_store;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT points
FROM customers
WHERE customer_id = 1;
-- 第二个输入
USE sql_store;
START TRANSACTION;
UPDATE customers
SET points = 20
WHERE customer_id = 1;
COMMIT;
-- 首先执行第一个的前两句，然后执行第二个的前三句，最后执行第一个的最后一句
-- 发现读取了没有提交的20积分
-- 需要注意的是不设置的话,每一个语句都会被放到默认的事务中去执行
-- 接下来把第二个语句中的commi换成ROLLBACK,意思是人家撤回更新,你读取了错的数据,锅是你来背

-- 读已提交隔离级别 READ COMMITTED,和上面一样的操作,只不过换一下隔离级别的语句
-- 因为上面更新已经撤回,所以这边顾客初始还是2293
-- 打开两个Local instance
-- 第一个输入
USE sql_store;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT points
FROM customers
WHERE customer_id = 1;
-- 第二个输入
USE sql_store;
START TRANSACTION;
UPDATE customers
SET points = 20
WHERE customer_id = 1;
COMMIT;
-- 先执行一遍,读到的还是2293,然后回去commi一下就能读到20了
-- 但是会存在另外一个问题,我做一件事先读了数据,还没做完人家中途更新并提交了
-- 我最后需要再读一下数据,前后读出来不一致
-- 需要再执行一遍 READ COMMITTTED，因为 这是管下一个事务的，不执行的话两个事务其中之一就是按默认的来
--  先读第一个select得到20，然后去第二个更新提交，再来执行第二个select就得到了30，前后读取数据不一致
-- 最后记得commit 方便下一节内容，不提交的话意味着这个事务还没完
-- 第一个输入
USE sql_store;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT points FROM customers WHERE customer_id = 1;
SELECT points FROM customers WHERE customer_id = 1;
COMMIT;
-- 第二个输入
USE sql_store;
START TRANSACTION;
UPDATE customers
SET points = 30
WHERE customer_id = 1;
COMMIT;

-- 可重读读取隔离级别REPEATABLE READ 
-- 第一个输入
USE sql_store;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT points FROM customers WHERE customer_id = 1;
SELECT points FROM customers WHERE customer_id = 1;
COMMIT;

-- 第二个输入
USE sql_store;
START TRANSACTION;
UPDATE customers
SET points = 40
WHERE customer_id = 1;
COMMIT;
-- 先执行第一个到第一个SELECT,得到30
-- 然后执行第二个到提交，最后再回去执行第二个select，得到的还是30，相当于把第一个事务框起来了，不管别的
-- 这里注意一下，第二个事务是默认的隔离特点
-- 注意这时候表中的数据已经被别人更新为40了，但是我当前的事务是被隔离起来的，表中还是显示30
-- 当时当我做完事提交之后，这个表就显示40了，就相当于你更新不管我的事
-- 我拿到这个数据是什么样我就做什么事，你中途更新是你的事
-- 上面解决的这种问题也叫幻读，如果我给满足要求的顾客发优惠券，这时候中途更新了一个满足要求的顾客
-- 但是我没有读到他的消息，过后人家要来找我麻烦，解决这种问题需要下面的隔离级别
-- SERIALIZABLE 序列化隔离级别
-- 先执行第一个select 发现只有一个顾客
-- 然后执行序列，开始事务，不要去执行select 再去执行第二个输入（不执行commit），这个时候再回来执行第一个里面的select
-- 会显示转圈圈，因为第一个是序列级别，要等其他的所有事务提交之后才会去执行,回去提交之后第一个查询才能执行
-- 第一个输入
USE sql_store;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM customers WHERE state = "VA";
COMMIT;
-- 第二个输入
USE sql_store;
START TRANSACTION;
UPDATE customers
SET state = "VA"
WHERE customer_id = 3;
COMMIT;
-- 死锁——不同事务均掌握了别的事务所需要的锁,一直在等对方,永远无法释放的锁
-- 第一个输入
USE sql_store;
START TRANSACTION;
UPDATE customers SET state = "VA" WHERE customer_id = 1;
UPDATE orders SET status = 1 WHERE order_id = 1;
COMMIT;
-- 第二个输入
USE sql_store;
START TRANSACTION;
UPDATE orders SET status = 1 WHERE order_id = 1;
UPDATE customers SET state = "VA" WHERE customer_id = 1;
COMMIT;
-- 不管是哪个UPDATE语句，一旦执行，那么这条记录就被锁定了,这与使用什么隔离级别没有关系 
-- 两个一起执行，只能执行前三句，第四句被对方锁定了
-- 死锁不是什么大问题，如果经常发生就要管一下
-- 死锁无解，但是可以好好写代码最小化死锁
-- 死锁无法消除,只能减小可能性

-- MYSQL DATA TYPES
-- String types
-- numeric types
-- date and time types
-- Bolb type(二进制)
-- spatial types 
-- 英语一个字节，欧洲的语言两个字节。中文三个字节
-- 枚举，其实就像excel中，某一列只能输入设定的几种答案之一，不让别人乱填
-- sql_store中设计模式打开products,添加一列size ENUM("small","medium","large") 输完之后按一下tab,再按一次，然后确定
-- 直接点products最右边表格，在表格里面把第一个改为small，右下角确定即可
-- 枚举尽量不要用，后期改起来很麻烦
-- JSON 数据类型，其实就是一个表格里面多个键值对
-- 一样的表一样的操作添加一个JSON列
UPDATE products
SET properties = '
{
	"dimensions": [1,2,3],
    "weight": 10,
    "manufacturer": {"name": "sony"}
    }
'
WHERE product_id = 1;
-- 另外一种创建JSON的对象的函数
UPDATE products
SET properties = JSON_OBJECT(
	"weight", 10,
    "dimensions", JSON_ARRAY(1, 2, 3),
    "manufacturer", JSON_OBJECT("name","sony")
    )
WHERE product_id = 2;
-- 提取产品id与对应的重量
SELECT product_id, JSON_EXTRACT(properties, "$.weight") AS weight
FROM products
WHERE product_id = 1;
-- 另外一种调用方式
SELECT product_id, properties -> "$.weight"
FROM products
WHERE product_id = 1;
-- 注意[]里面索引是从0开始
SELECT product_id, properties -> "$.dimensions[0]"
FROM products
WHERE product_id = 1;
SELECT product_id, properties -> "$.manufacturer.name"
FROM products
WHERE product_id = 1;
-- 把上面"sony"的字符去掉
SELECT product_id, properties ->> "$.manufacturer.name"
FROM products
WHERE product_id = 1;
SELECT product_id, properties ->> "$.manufacturer.name"
FROM products
WHERE properties ->> "$.manufacturer.name" = "sony";
-- 设置属性,就算没有也可以设置
UPDATE products
SET properties = JSON_SET(
	properties,
    "$.weight", 20,
    "$.age", 10
)
WHERE product_id = 1;
-- 清除不要的属性
-- 注意这下面用的单引号
UPDATE products
SET properties = JSON_REMOVE(
	properties,
    '$.age')
WHERE product_id = 1;
-- DATA MODELLING
	-- Understand the requirements
	-- Build a Conceptual Model 其实就是画个思维导图
	-- Student                             Course
	--	name                               title
	--	email           enrolls            price
    --  registered							instructor
    --										tags
	-- Build a Logical Model  这一步就是把思维导图里面的关系表述清楚，列的类型补上去
    -- 觉得思维导图不行的就该,优化,加细节
    	-- Student                      enrolls                   Course
	--	firstName(string)             date(dateTime)               title(string)
    --  lastName(string)              price(float)
	--	email(string)                                              price(float)
    --  dateRegistered(dateTime)							       instructor(string)
    --										                       tags(string)
	-- Build a Physical Model（前面两步都是在draw.io中画思维导图，这个是在sql中直接做表了）
    -- 工作台（最初那个界面，生成local instance那里），点击file——new model
    -- EER(diagrams) 增强实体关系的缩写,相当于sql中画图的地方
    -- 下面给了一个默认的新建数据库(mydb)，改下名字就好
    -- 右击编辑模式Edit schema改名为school
    -- 然后点击 Add diagram,这里面可以添加表和视图
    -- 单击倒数第三个图标拖到界面，然后双击改名字,左边面板放大一下，然后添加列属性,主键取消了 非空勾选
-- 实体模型搞好以后，就开始模型的正向工程，就是把实体模型变成数据库
-- 顶部找到DATABASE——forward engineer,其他的都默认就好了,搞好了去打开的local instance面板里面刷新一下就好
-- 数据库同步模型
-- 数据库搞好了,现在想增加表或者改变表,我自己用可以直接在面板设计模式里面改
-- 但是实际情况是大家用,有好几台服务器
-- 不同环境中的数据库要有一致性
-- 回到实体模型(就是那个图),做出更改,然后将该模型与数据库同步
-- 点击DATABASE——synchronize MODLE（同步模型）
-- 没有数据的时候使用正向工程---用一个模型生成一个数据库
-- 现在是有一个数据库，想将数据库与模型同步，所以选择同步模型
-- 这里可以选择连接到本地计算机上的数据库，也可以选择其他数据库
-- 最好把代码录入Git这样的源代码控制资源库中，这样就知道对数据库做了什么更改，然后可以将相同的变动复制到其他数据库
-- 模型反向工程
-- 想改一个没有模型的数据库怎么办，就像sql_store
-- 首先关闭上一个模型,如果上一个模型还打开,会把这个数据库添加到上一个模型里面
-- 顶部database--reverse engineer,后面一直点默认,最后就会自动生成模型了

-- 创建和删除数据库
-- 前面学的是在mysql中用视图方式来创建数据库，想成为数据库管理员，要能看懂脚本，现在不用视图方式
-- 直接写代码来创建数据库
CREATE DATABASE IF NOT EXISTS sql_store2;
DROP DATABASE IF EXISTS sql_store2;
-- 创建表
CREATE DATABASE IF NOT EXISTS sql_store2;
USE sql_store2;
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    email  VARCHAR(50) NOT NULL UNIQUE
);
-- 修改表
 ALTER TABLE customers
	ADD last_name  VARCHAR(50) NOT NULL AFTER first_name,
    ADD city       VARCHAR(50) NOT NULL,
    MODIFY COLUMN first_name VARCHAR(55) DEFAULT "",
    DROP points;
-- 创建关系
CREATE DATABASE IF NOT EXISTS sql_store2;
USE sql_store2;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    email  VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE orders(
	order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    FOREIGN KEY fk_orders_customers (customer_id)
		REFERENCES customers (customer_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION);
-- 因为现在customers表有别的关系，所以不能删掉
-- 想删掉的话就要先删掉关系表，orders，所以要将DROP语句提前	

-- 更改主键或者外键约束,其实就是删除和创建表之间的关系
-- 上面创建表的时候已经创建了关系，现在是先创建两张表然后创建关系
-- 其实就是使用ALTER 
ALTER TABLE orders
	ADD PRIMARY KEY (order_id),
    DROP PRIMARY KEY,
    DROP FOREIGN KEY fk_orders_customers,
    ADD FOREIGN KEY fk_orders_customers (customer_id)
		REFERENCES customers (customer_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION;
-- 字符集与排序规则
-- mysql的默认字符集就是UTF-8
-- 字符集就是你输入的是汉字，计算机自动转成内置的数字，就像UTF-8
-- 排序规则collation就是一堆规则，决定了某类语言的字符如何排序
-- utf-8的排序规则就是ci（case insensitive）不区分大小写
-- 改变字符集可以改变数据库大小
-- CHAR(10)表示10个字符,而utf-8给每个字符留3个字节，所以这个单元格占了30个字节
-- 这一章主要是讲怎么优化字节，就是减少磁盘内存
SHOW CHARSET;
-- 用鼠标来改字符集
-- 右击数据库，选择Schema Inspector 就能看到默认的字符集与排序规则以及所占内存
-- 点鼠标改变不了数据库的字符集，但是可以改变表或者列的字符集，改变数据库的字符集必须要用sql语言
-- 设计模式打开一张表，点中列就改列，右上角两个三角符号改变表的字符集
-- 现在使用sql语言改变数据库的字符集
-- 可以在创建数据库时或之后设置字符集和排序规则
CREATE DATABASE db_name
	CHARACTER SET Latin1;
-- 更改现有数据库的字符集
ALTER DATABASE db_name
	CHARACTER SET Latin1;
-- 表级别更改字符集
-- 创建表的时候改
-- CREATE TABLE table1
--	(
-- )
-- CHARACTER SET Latin1
-- 表级别更改字符集
-- 现在有表去改
ALTER TABLE table1
CHARACTER SET Latin1;
-- 特定列设置字符集,建数据库的时候直接设置
-- first_name VARCHAR(50) CHARACTER SET Latin1 NOT NULL,

-- 存储引擎(决定了数据如何被存储以及哪些功能可供我们使用)
SHOW ENGINES;
-- 最常用的是老款的MyISAM与新版的InnoDB
-- 改变表级别的存储引擎,在一个数据库里面可以使用多个存储引擎
-- 编辑模式打开表,左边有的,选一下就可以改了
-- 用sql语句来改
ALTER TABLE customers
ENGINE = InnoDB;
-- 改一张表的存储引擎要花很大功夫，因为MySQL会重建这张表
-- 在这期间无法访问这张表，不要在产出阶段更改存储引擎，除非需要定期维护

-- 如何使用索引来获得高性能
-- 大型数据库与高流量网站中可以显著提高查询性能
-- 每个开发人员以及数据库管理员都必须学习与理解
-- 开始这一章前先执行一个脚本，为顾客表增加1000条新纪录(load_1000_customers)
-- 索引其实是用来快速查询的一种数据结构,就像电话薄是按名字来排序的,我不用一个个找,直接找那个人开头字母
-- 不然我就要从头一个个找了
-- 索引很小,可以放进内存,因为从内存读数据比从磁盘读数据快很多,所以索引查询速度快
-- 使用索引的代价  1、增加数据库的大小，它们永远存储在表的旁边
-- 2、添加或者更新记录的时候，mysql要更新对应的索引，这会影响正常操作的性能
-- 所以要为性能关键的查询保留索引，要基于查询创建索引，而不是基于表
-- 索引内部通常被存储为二叉树，这节课用表来体现
-- 创建索引
SELECT customer_id FROM customers;
-- 看查询原理
EXPLAIN SELECT customer_id FROM customers WHERE state = "CA";
CREATE INDEX idx_state ON customers (state);
EXPLAIN SELECT customer_id FROM customers WHERE state = "CA";
-- exercise
EXPLAIN SELECT customer_id FROM customers WHERE points > 1000;
CREATE INDEX idx_points ON customers (points);
EXPLAIN SELECT customer_id FROM customers WHERE points > 1000;
-- 查看一张表中的索引
SHOW INDEXES IN customers;
ANALYZE TABLE customers;-- 生成这张表的具体统计信息,再执行上面那一行代码,会获得更多明细
SHOW INDEXES IN customers;
SHOW INDEXES IN orders;
-- 导航面板那里也能看到index
-- 前缀索引,就是给字符串建索引,相当于选前几个字母来作为索引,所以这里要找最合适的前缀
-- 这里选5最合适,就是拿名字的前五个字符来排序
CREATE INDEX idx_lastname ON customers (last_name(5));
SELECT 
	COUNT(DISTINCT LEFT(last_name, 1)),
    COUNT(DISTINCT LEFT(last_name, 5)),
    COUNT(DISTINCT LEFT(last_name, 10))
FROM customers;
-- 全文索引,就是相当于goole搜索引擎
-- 这一步相当于我建了一个博客网站,人家来搜想要的,输一个词,我会跳出来相应的文章
-- 首先运行CREATE blog的代码
-- 假设用户在博客中搜索 "React Redux"
-- 首先
USE sql_blog;
SELECT *
FROM posts
WHERE title LIKE '%React Redux%' OR
	body LIKE "%React Redux%";
-- 这种在文章特别多的时候运行很慢，并且返回的文章所搜索的词顺序不能变的
-- 所以我们用全文索引来做--包括整个字符串列，而不是存储前缀，会忽视任何停止词，如in，on这种
-- 本质上，它们存储了一套单词列表，对于每个单词，它们又存储了一列这些单词会出现的行或记录
-- 全文索引会计算相关得分,mysql基于若干因素,为包含了搜索短句的每一行计算相关性得分(0-1之间)
CREATE FULLTEXT INDEX idx_title_body ON posts (title, body);
SELECT *, MATCH(title, body) AGAINST('react redux')
FROM posts
WHERE MATCH(title, body) AGAINST('react redux');-- 返回所有标题或者正文中包含一个或两个关键字的文章
-- 全文搜索有两种模式,一种是自然语言(默认),
-- 一种是布尔模式 可以包括或排除某些单词,就像用谷歌一样
CREATE FULLTEXT INDEX idx_title_body ON posts (title, body);
SELECT *, MATCH(title, body) AGAINST('react redux')
FROM posts
WHERE MATCH(title, body) AGAINST('react -redux' IN BOOLEAN MODE);-- 找包含react但是没有redux的行
CREATE FULLTEXT INDEX idx_title_body ON posts (title, body);
SELECT *, MATCH(title, body) AGAINST('react redux')
FROM posts
WHERE MATCH(title, body) AGAINST('react -redux + form' IN BOOLEAN MODE);-- 结果中每一行,标题或者正文必须含有form
CREATE FULLTEXT INDEX idx_title_body ON posts (title, body);
SELECT *, MATCH(title, body) AGAINST('react redux')
FROM posts
WHERE MATCH(title, body) AGAINST('"handling a form"' IN BOOLEAN MODE);-- 搜索确切的短句

-- 复合索引，其实就是每个列搞一个索引太烦了，几列搞一个索引,最多可以搞16列,搞多少自己定
-- 先按顾客所在state索引，再按points索引这种
-- 注意主键（一级索引）是自动嵌入二级索引的（后面自己建的索引）
-- 不管一张表里面有多少索引,mysql会选择一个来执行
USE sql_store;
SHOW INDEXES IN customers;
EXPLAIN SELECT customer_id FROM customers
WHERE state = "CA" AND points > 1000;
-- 创建符合索引
USE sql_store;
CREATE INDEX idx_state_points ON customers (state, points);
EXPLAIN SELECT customer_id FROM customers
WHERE state = "CA" AND points > 1000;
-- 删除费事的索引
SHOW INDEXES IN customers;
DROP INDEX idx_state ON customers;
DROP INDEX idx_points ON customers;

-- 复合索引中的列顺序(其实就是搞复合索引时,哪一列排在前面,哪一列排在后面)
-- 最常用的放在前面
-- 基数(就像男女来分类,基数为2,洲来分类,有几个洲基数就是几)更高的放在前面
-- 结合自己实际情况,并不一定要按照上面这个来
SELECT customer_id
FROM customers
WHERE state = "CA" AND last_name LIKE "A%";
-- 看基数
SELECT 
	COUNT(DISTINCT state),
    COUNT(DISTINCT last_name)
FROM customers;

CREATE INDEX Idx_lastname_state ON customers(last_name, state);
EXPLAIN SELECT customer_id
FROM customers
WHERE state = "CA" AND last_name LIKE "A%";
-- 调换索引顺序
CREATE INDEX Idx_state_lastname ON customers(state, last_name);
EXPLAIN SELECT customer_id
FROM customers
WHERE state = "CA" AND last_name LIKE "A%";

EXPLAIN SELECT customer_id
FROM customers
WHERE state = "NY" AND last_name LIKE "A%";
-- 指定索引
EXPLAIN SELECT customer_id
FROM customers
USE INDEX (idx_lastname_state)
WHERE state = "CA" AND last_name LIKE "A%";
-- 看哪个索引性能更好
EXPLAIN SELECT customer_id
FROM customers
USE INDEX (idx_lastname_state)
WHERE state LIKE "A%" AND last_name LIKE "A%";

EXPLAIN SELECT customer_id
FROM customers
USE INDEX (idx_state_lastname)
WHERE state LIKE "A%" AND last_name LIKE "A%";
-- 删除没必要的索引
DROP INDEX idx_lastname_state ON customers;
-- 有需要也可以为单列设置索引.就像下面的一样
EXPLAIN SELECT customer_id
FROM customers
WHERE last_name LIKE "A%";

-- 当索引无效时,要改写查询来适应索引
EXPLAIN SELECT customer_id FROM customers
WHERE state = "CA" OR points > 1000;
-- 看起来是全表扫描,但是并不是,这里type的值是index,这是全索引扫描
-- 它比表扫描快,因为不涉及从磁盘读取每个记录,但是还是扫了1010条记录
-- 优化这个查询,利用索引
-- 这里是为了方便points查询所以才创建了一个新索引
-- 这里UNION会自动去重
CREATE INDEX idx_points ON customers (points);
EXPLAIN 
	SELECT customer_id FROM customers
    WHERE state = "CA"
    UNION 
    SELECT customer_id FROM customers
    WHERE points > 1000;
-- 上面代码出的结果中，id=1表示第一个SELECT，以此类推，这回两个加起来才扫描了600多条记录
EXPLAIN SELECT customer_id FROM customers
WHERE points + 10 > 2000;-- 还是做了索引扫描(索引中的每条记录),一千多条
-- 这是因为在上面的表达式中用到了列,这样mysql就无法以最优方式利用索引了
-- 所以要单独将列放在一边
EXPLAIN SELECT customer_id FROM customers
WHERE points > 2000;-- 这样才扫描三条记录

-- 使用索引排序,就是排序的时候优选考虑索引,这样能节约资源
SHOW INDEXES IN customers;
DROP INDEX idx_state_lastname ON customers;
DROP INDEX idx_points ON customers;
CREATE INDEX idx_lastname ON customers (last_name);
-- 当在列上添加索引时,mysql会获取该列中的所有值,并对其排序,并将其存储在索引中,
-- 所以那个复合索引中,是先按照state再按照points排序了
EXPLAIN SELECT customer_id FROM customers ORDER BY state;
-- 上面是做了一个索引扫描type=index,在Extra中看到使用了索引

-- 用别的不在索引的列进行排序会发生什么
EXPLAIN SELECT customer_id FROM customers ORDER BY first_name;
-- 现在变成全表扫描了,type=all 在Extra中看使用了外部排序(很耗费的一种操作)
-- 通常来说,除非真的必要,否则不要给数据排序
-- 然后可以看看你是否能设计一个索引,来避免sql做排序操作

-- 查看服务器变量
SHOW STATUS LIKE "last_query_cost";-- 查看上一次查询花了多少成本
-- 下面用索引中的列排序看一下成本,很明显成本下降很多,可以看出外部排序(不用索引列)操作非常昂贵
EXPLAIN SELECT customer_id FROM customers ORDER BY state;
SHOW STATUS LIKE "last_query_cost";
-- 基本规则是,ORDER BY 子句中的列的顺序,应该与索引中的列的顺序相同
EXPLAIN SELECT customer_id FROM customers ORDER BY state, points;
-- 如果在中间加了一列first_name就会变成全表扫描
EXPLAIN SELECT customer_id FROM customers ORDER BY state, first_name, points;
-- 另一种情况是以不同方向排序
EXPLAIN SELECT customer_id FROM customers ORDER BY state, points;
EXPLAIN SELECT customer_id FROM customers ORDER BY state, points DESC;-- 这个成本高很多,有外部排序
EXPLAIN SELECT customer_id FROM customers ORDER BY state DESC, points DESC;-- 都降序排列成本就降下来了
-- (a, b)排序规则
-- a
-- a, b
-- a DESC, b DESC
-- 直接用points(b)来排，成本也是增高了，使用外部排序了，浪费资源的索引
EXPLAIN SELECT customer_id FROM customers ORDER BY points;-- 这个成本高很多,有外部排序
-- 这种排序也行的，先选出来了
EXPLAIN SELECT customer_id FROM customers WHERE state = "CA" ORDER BY points;
SHOW STATUS LIKE "last_query_cost";

-- 覆盖索引--一个包含所有满足查询需要的数据的索引
-- 上面select都只选了customer_id，现在解释为什么
EXPLAIN SELECT customer_id FROM customers ORDER BY state;-- 这是按照索引来的
EXPLAIN SELECT * FROM customers ORDER BY state;-- 这就扫描全表了
-- 放在洲和积分列上的索引包含了关于每个顾客的三条信息（因为主键会自动放到二级索引里面去）--id, state, points
EXPLAIN SELECT customer_id, state FROM customers ORDER BY state;-- 这是按照索引来的,mysql可以在不读取表的情况下就执行查询

-- 索引维护
-- 要注意重复索引和多余索引,
-- (A,B,C), (A,B,C)即是以前有索引,再建一个相同的也不会报错
-- (a,b)上有一个索引，然后在a上创建另一个索引（A）就叫多余索引，因为原来的索引也可以包含列A的查询
-- 然而如果在b列和a列上创建了索引，或者只有与b列，这就不算多余
-- （a,b）存在的情况下，（b,a）或者b是合理的

-- 保护数据库
-- 前面都是在自己电脑上运行数据库，不用考虑数据安全与访问权限的问题，
-- 现实生活中，通常在服务器的某个地方有一个数据库，不重视安全，别人就会访问和滥用我的数据
-- 这一章学保障数据库安全的用户账户和权限问题
-- 目前为止，都在使用根用户连接到数据库服务器，就是安装sql时创建的用户
-- 当需要在工作环境中使用mysql时，需要创建其他用户账户，并赋予其相应权限
-- Application———访问—————DATABASE SERVER
-- 现在要为application创建一个用户账户，授予其阅读与数据写入数据库的权限
-- 这个账户不能改变数据库的结构，不能创建表与删除表
-- 有人以数据库管理员身份加入公司，要为他建立一个账户，便于他管理一个或多个数据库或整个mysql服务器
-- 创建一个新的用户账户
CREATE USER John;  -- 啥都不限制
CREATE USER John@127.0.01;  -- 限制用户连接的位置,电脑的ip地址,只能从这台计算机上的mysql与数据库相连
-- 上面这个限制在云环境中有用
-- WEB server----------database server
-- 通常有一个网络服务器和一个数据库服务器,
-- 在数据库服务器上,当为应用程序创建新用户账户时,需要确保那个用户账户只能从网络服务器连接
-- 接下来指定网络服务器的ip地址
CREATE USER John@Localhost;-- 指定主机名,代表当前安装mysql的这台计算机
CREATE USER John@codewitmosh.com;-- 指定域名,现在这个用户可以从该域中的任何计算机连接,但是无法从该域的子网域连接
CREATE USER John@"%.codewitmosh.com";-- 现在可以从这个域的任何计算机或任何子网域连接了
-- 为了讲课方便,不设限制,现在为用户设置密码
CREATE USER John IDENTIFIED BY "1234";

-- 看看mysql服务器的用户列表host是主机,没有就可以从任何计算机来连接
-- 还有三个用户账户,供mysql自行使用,还有根用户(安装mysql创建的用户账户)
-- 这些账户的主机都是localhost,所以以根用户身份登录,必须使用这台计算机
-- 不能远程连接并以根用户身份登录
SELECT * FROM mysql.user;
-- 在导航面板administrator————users and privileges也能看到

-- 删除用户(人员离职时要删除他的用户账户)
CREATE USER bob@codewithmosh.com IDENTIFIED BY "1234";
CREATE USER bob@codewithmosh.com;

-- 改密码
SET PASSWORD FOR john = "1234";-- 为别人改密码
SET PASSWORD = "1234";-- 帮当前登录的用户改密码，不管是根用户还是其他人
-- 另一种方法在导航面板administrator————users and privileges也能看到，直接点击哪个人，右边改好点确认就好

-- 授予权限
-- 一种授予应用程序application
CREATE USER moon_app IDENTIFIED BY "1234";
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE
ON sql_store.* -- sql_store下面所有表,也可以指定表sql_store.customers
TO moon_app;
-- 这样的话在最开始界面,重新创建一个链接moon_app_connection,输入账户密码即可，只能访问sql_store数据库

-- 第二种是拿给数据库管理员的 -- 所有数据库的所有表,-- 所有权限
CREATE USER John IDENTIFIED BY "1234";
GRANT ALL 
ON *.* 
TO John;

-- 查看权限
SHOW GRANTS FOR John;
SHOW GRANTS;-- 当前用户的权限，根用户拥有最高级别的权限

-- 导航面板里面看，administrator————users and privileges，再看里面的administrative roles 和schema privileges
-- 想改直接点中改就好了

-- 撤销权限
GRANT CREATE VIEW
ON sql_store.*
TO moon_app;

REVOKE CREATE VIEW
ON sql_store.*
FROM moon_app;

-- 终于学完了,除了考研数学,第二个在b站上学完的课程