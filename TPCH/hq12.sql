-- Copyright (c) 2020, Oracle and/or its affiliates.
-- Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

SELECT /*+ set_var(use_secondary_engine=forced) */   
    l_shipmode,
    SUM(CASE
        WHEN
            o_orderpriority = '1-URGENT'
                OR o_orderpriority = '2-HIGH'
        THEN
            1
        ELSE 0
    END) AS high_line_count,
    SUM(CASE
        WHEN
            o_orderpriority <> '1-URGENT'
                AND o_orderpriority <> '2-HIGH'
        THEN
            1
        ELSE 0
    END) AS low_line_count
FROM
    ORDERS,
    LINEITEM
WHERE
    o_orderkey = l_orderkey
        AND l_shipmode IN ('MAIL' , 'SHIP')
        AND l_commitdate < l_receiptdate
        AND l_shipdate < l_commitdate
        AND l_receiptdate >= DATE '1994-01-01'
        AND l_receiptdate < DATE '1994-01-01' + INTERVAL '1' YEAR
GROUP BY l_shipmode
ORDER BY l_shipmode;