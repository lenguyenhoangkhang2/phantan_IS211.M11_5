--CAC CAU LENH DUOC TRUY VAN THONG QUA TAI KHOAN GUEST

--IN RA TEN CHU KENH, TEN KENH CO LUOT LIKE VIDEO CAO NHAT

--TRUY VAN TAP TRUNG
--TAI MAY 2
EXPLAIN PLAN FOR 
SELECT U.USERNAME, C.CNAME, COUNT(*) LIKES FROM BTL1M2.USERACCOUNT U 
    JOIN BTL1M2.CHANNEL C ON U.USERID=C.OWNERID 
    JOIN BTL1M2.VIDEO V ON V.CHANNELID=C.CHANNELID
    JOIN BTL1M2.LIKEVIDEO LV ON LV.VIDEOID=V.VIDEOID
GROUP BY U.USERNAME, C.CNAME
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROWS ONLY;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

--TAI MAY 1
EXPLAIN PLAN FOR 
SELECT U.USERNAME, C.CNAME, COUNT(*) LIKES FROM BTL1M1.USERACCOUNT@DBL_M1 U 
    JOIN BTL1M1.CHANNEL@DBL_M1 C ON U.USERID=C.OWNERID 
    JOIN BTL1M1.VIDEO@DBL_M1 V ON V.CHANNELID=C.CHANNELID
    JOIN BTL1M1.LIKEVIDEO@DBL_M1 LV ON LV.VIDEOID=V.VIDEOID
GROUP BY U.USERNAME, C.CNAME
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROWS ONLY;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

--TOI UU HOA TAP TRUNG
--TAI MAY 2
EXPLAIN PLAN FOR 
SELECT U.USERNAME, C.CNAME, LIKES
FROM BTL1M2.USERACCOUNT U 
    JOIN BTL1M2.CHANNEL C
    ON U.USERID=C.OWNERID 
    JOIN (
        SELECT CHANNELID, COUNT(*) LIKES
        FROM BTL1M2.LIKEVIDEO LV 
            JOIN BTL1M2.VIDEO V ON V.VIDEOID=LV.VIDEOID
        GROUP BY CHANNELID
        ORDER BY LIKES DESC
        FETCH FIRST 1 ROWS ONLY
    ) T 
    ON C.CHANNELID=T.CHANNELID;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

--TAI MAY 1
EXPLAIN PLAN FOR 
SELECT U.USERNAME, C.CNAME, LIKES
FROM BTL1M1.USERACCOUNT@DBL_M1 U 
    JOIN BTL1M1.CHANNEL@DBL_M1 C
    ON U.USERID=C.OWNERID 
    JOIN (
        SELECT CHANNELID, COUNT(*) LIKES
        FROM BTL1M1.LIKEVIDEO@DBL_M1 LV 
            JOIN BTL1M1.VIDEO@DBL_M1 V ON V.VIDEOID=LV.VIDEOID
        GROUP BY CHANNELID
        ORDER BY LIKES DESC
        FETCH FIRST 1 ROWS ONLY
    ) T 
    ON C.CHANNELID=T.CHANNELID;


--KET HOP DE TAO RA CAU TRUY VAN TOI UU
SELECT * FROM (
    SELECT U.USERNAME, C.CNAME, LIKES
    FROM BTL1M2.USERACCOUNT U 
    JOIN BTL1M2.CHANNEL C
    ON U.USERID=C.OWNERID 
    JOIN (
        SELECT CHANNELID, COUNT(*) LIKES
        FROM BTL1M2.LIKEVIDEO LV 
            JOIN BTL1M2.VIDEO V ON V.VIDEOID=LV.VIDEOID
        GROUP BY CHANNELID
        ORDER BY LIKES DESC
        FETCH FIRST 1 ROWS ONLY
    ) T 
    ON C.CHANNELID=T.CHANNELID
    
    UNION
    
    SELECT U.USERNAME, C.CNAME, LIKES
    FROM BTL1M1.USERACCOUNT@DBL_M1 U 
    JOIN BTL1M1.CHANNEL@DBL_M1 C
    ON U.USERID=C.OWNERID 
    JOIN (
        SELECT CHANNELID, COUNT(*) LIKES
        FROM BTL1M1.LIKEVIDEO@DBL_M1 LV 
            JOIN BTL1M1.VIDEO@DBL_M1 V ON V.VIDEOID=LV.VIDEOID
        GROUP BY CHANNELID
        ORDER BY LIKES DESC
        FETCH FIRST 1 ROWS ONLY
    ) T 
    ON C.CHANNELID=T.CHANNELID
) 
ORDER BY LIKES DESC
FETCH FIRST 1 ROWS ONLY;