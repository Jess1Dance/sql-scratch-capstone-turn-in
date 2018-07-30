SELECT *
FROM survey
LIMIT 10;

--1--

SELECT question,
COUNT(DISTINCT user_id)
FROM survey
GROUP BY question;

--4--
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

--5--

SELECT DISTINCT q.user_id,
CASE
WHEN
h.user_id IS NOT NULL
THEN 'true'
ELSE 'false'
END AS 'is_home_try_on',
h.number_of_pairs,
CASE
WHEN
p.user_id IS NOT NULL
THEN 'true'
ELSE 'false'
END AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
ON q.user_id = h.user_id
LEFT JOIN purchase p
ON p.user_id = q.user_id
LIMIT 10;


--6.1--
WITH browse AS (
SELECT DISTINCT q.user_id,
CASE
    WHEN
      h.user_id IS NOT NULL
    THEN 'true'
    ELSE 'false'
  END AS 'is_home_try_on',
 h.number_of_pairs,
  CASE
    WHEN
      p.user_id IS NOT NULL
    THEN 'true'
    ELSE 'false'
  END AS 'is_purchase'
  FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT COUNT(user_id) AS 'num_of_user_id',
number_of_pairs,
SUM(
  CASE WHEN
  IS_HOME_TRY_ON = 'true'
THEN 1
ELSE 0
END) AS is_home_try_on_true,
SUM(
  CASE WHEN
  IS_HOME_TRY_ON = 'false'
THEN 1
ELSE 0
END) AS is_home_try_on_false,
SUM(
  CASE WHEN
 is_purchase = 'true'
THEN 1
ELSE 0
END) AS is_purchase_true,
SUM(
  CASE WHEN
 is_purchase = 'false'
THEN 1
ELSE 0
END) AS is_purchase_false
from browse
GROUP BY number_of_pairs;

--6.2--

-- Quiz Funnel --
WITH browse AS (
SELECT DISTINCT q.user_id,
CASE
    WHEN
      h.user_id IS NOT NULL
    THEN 'true'
    ELSE 'false'
  END AS 'is_home_try_on',
 h.number_of_pairs,
 q.style,
  CASE
    WHEN
      p.user_id IS NOT NULL
    THEN 'true'
    ELSE 'false'
  END AS 'is_purchase'
  FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT style AS 'Style_types',
count(style) AS 'Style',
SUM(
CASE WHEN
is_purchase = 'true'
THEN 1
ELSE 0
END) AS 'Purchased',
1.0 * COUNT(style) / SUM(CASE WHEN
is_purchase = 'true'
THEN 1
ELSE 0
END) AS 'sale_rate'
FROM browse
GROUP BY style;

--6.3--
WITH browse AS (
SELECT DISTINCT q.user_id,
CASE
    WHEN
      h.user_id IS NOT NULL
    THEN 'true'
    ELSE 'false'
  END AS 'is_home_try_on',
 h.number_of_pairs,
  CASE
    WHEN
      p.user_id IS NOT NULL
    THEN 'true'
    ELSE 'false'
  END AS 'is_purchase'
  FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT
count(user_id) AS 'quiz_participants',
SUM(CASE
    WHEN is_home_try_on = 'true' THEN 1
    ELSE 0
    END) AS 'Home_try_on',
SUM(CASE WHEN is_purchase = 'true' THEN 1
    ELSE 0
   END) AS 'Purchases'
FROM browse
LIMIT 10;

--6.4--
WITH browse AS
(SELECT DISTINCT q.user_id,
  CASE
  WHEN
  h.user_id IS NOT NULL
  THEN 'true'
  ELSE 'false'
  END AS 'is_home_try_on',
  h.number_of_pairs,
  CASE
  WHEN
  p.user_id IS NOT NULL
  THEN 'true'
  ELSE 'false'
  END AS 'is_purchase'
  FROM quiz q
  LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
  LEFT JOIN purchase p
  ON p.user_id = q.user_id)
  SELECT count(user_id) AS 'quiz_participants',
  SUM(CASE
    WHEN is_home_try_on = 'true'
    THEN 1
    ELSE 0     END) AS 'Home_try_on',
    1.0 * COUNT(user_id) /
    SUM(CASE
      WHEN is_home_try_on = 'true'
      THEN 1
      ELSE 0
      END) AS 'quiz/home_try_on_rate'
    FROM browse
    LIMIT 10;

--6.5--

WITH browse AS (
SELECT DISTINCT q.user_id,
CASE
    WHEN
      h.user_id IS NOT NULL
    THEN 'true'
    ELSE 'false'
  END AS 'is_home_try_on',
 h.number_of_pairs,
  CASE
    WHEN
      p.user_id IS NOT NULL
    THEN 'true'
    ELSE 'false'
  END AS 'is_purchase'
  FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT
SUM(CASE
    WHEN is_home_try_on = 'true' THEN 1
    ELSE 0
    END) AS 'Home_try_on',
SUM(CASE
    WHEN is_purchase = 'true' THEN 1
    ELSE 0
    END) AS 'Purchased',
 1.0 * SUM(CASE
    WHEN is_home_try_on = 'true' THEN 1
    ELSE 0
    END) / SUM(CASE
    WHEN is_purchase  = 'true' THEN 1
    ELSE 0
    END) AS 'home_try_on/purchase_rate'
FROM browse
LIMIT 10;

--6.6--

WITH browse AS
(SELECT DISTINCT q.user_id,
 CASE
 WHEN
 h.user_id IS NOT NULL
 THEN 'true'
 ELSE 'false'
 END AS 'is_home_try_on',
 h.number_of_pairs,
 p.product_id,
 p.price,
 CASE
 WHEN
 p.user_id IS NOT NULL
 THEN 'true'
 ELSE 'false'
 END AS 'is_purchase'
 FROM quiz q
 LEFT JOIN home_try_on h
 ON q.user_id = h.user_id
 LEFT JOIN purchase p
 ON p.user_id = q.user_id)
 SELECT product_id,
 price,
 SUM( CASE
     WHEN is_purchase = 'true'
     THEN 1 ELSE 0 END) AS 'num_of_purchases'
FROM browse
GROUP BY product_id
ORDER BY price desc;

--6.7--

WITH browse AS
(SELECT DISTINCT q.user_id,
 CASE
 WHEN
 h.user_id IS NOT NULL
 THEN 'true'
 ELSE 'false'
 END AS 'is_home_try_on',
 h.number_of_pairs,
 p.product_id,
 p.price,
 CASE
 WHEN
 p.user_id IS NOT NULL
 THEN 'true'
 ELSE 'false'
 END AS 'is_purchase'
 FROM quiz q
 LEFT JOIN home_try_on h
 ON q.user_id = h.user_id
 LEFT JOIN purchase p
 ON p.user_id = q.user_id)
 SELECT SUM(
 CASE WHEN is_purchase = 'true'
 THEN 1
 ELSE 0 END) AS 'is_purchase',
 price,
 product_id
FROM browse
GROUP BY product_id
ORDER BY is_purchase DESC;
