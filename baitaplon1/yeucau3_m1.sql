--****LOST UPDATE*****
--**M?c cô l?p ban ??u
ALTER SESSION SET ISOLATION_LEVEL=READ COMMITTED;

--**Mô t? tr??ng h?p
--B1 Ki?m tra thông tin kenh trên máy 2
SELECT * FROM BTL1M2.CHANNEL@DBL_M2 WHERE CHANNELID='ch002';
--B3 C?p nh?t thông tin tên kênh
UPDATE BTL1M2.CHANNEL@DBL_M2 SET CNAME = 'Thoi Su 24h' WHERE CHANNELID='ch002';
--B5 Commit l?i (tr??c M2)
COMMIT;
--B7 Ki?m tra l?i thông tin v? tên kênh
SELECT * FROM BTL1M2.CHANNEL@DBL_M2 WHERE CHANNELID='ch002';
-- => CNAME = 'Sa Mac Va Rung Ram' (d? li?u 'Thoi Su 24h' b? m?t)

--**X? lý
--Thay ??i m?c cô l?p ?? x? lý
ALTER SESSION SET ISOLATION_LEVEL=SERIALIZABLE;

--**Các b??c ki?m tra l?i
--B1 C?p nh?t thông tin tên kênh 'Nguoi Thong Thai'
UPDATE BTL1M2.CHANNEL@DBL_M2 SET CNAME = 'Nguoi Thong Thai' WHERE CHANNELID='ch002';
--B3 Commit l?i (tr??c M2)
COMMIT;
--B5 Ki?m tra l?i thông tin kênh
SELECT * FROM BTL1M2.CHANNEL@DBL_M2 WHERE CHANNELID='ch002';
-- => CNAME = 'Nguoi Thong Thai', d? li?u không còn m?t ?i



----------------------------------------------------------------------------------------------------


--****NON-REPEATABLE****	
--**M?c cô l?p ban ??u
ALTER SESSION SET ISOLATION_LEVEL=READ COMMITTED;

--**Mô t? tr??ng h?p
--B1 Ki?m tra thông tin kênh t?i máy 2
SELECT * FROM BTL1M2.CHANNEL@DBL_M2 WHERE CHANNELID='ch002';
--B3 C?p nh?t thông tin kênh t?i máy 2
UPDATE BTL1M2.CHANNEL@DBL_M2 SET CNAME = 'Dem Khong Ngu' WHERE CHANNELID='ch002';
--B4 Commit l?i
COMMIT;

--**X? lý
--Thay ??i m?c cô l?p ?? x? lý
ALTER SESSION SET ISOLATION_LEVEL=SERIALIZABLE;	

--**Các b??c ki?m tra l?i
--B1 Ki?m tra thông tin kênh t?i máy 2
SELECT * FROM BTL1M2.CHANNEL@DBL_M2 WHERE CHANNELID='ch002';
--B3 C?p nh?t thông tin kênh
UPDATE BTL1M2.CHANNEL@DBL_M2 SET CNAME = 'Hoai huong Nho' WHERE CHANNELID='ch002';
--B4 Commit l?i
COMMIT;


----------------------------------------------------------------------------------------------------



--****PHANTOM****
--**M?c cô l?p ban ??u
ALTER SESSION SET ISOLATION_LEVEL=READ COMMITTED;

--**Mô t? tr??ng h?p
--B2 Chèn 1 dòng d? li?u vào b?ng TAG trên máy 2
INSERT INTO BTL1M2.TAG@DBL_M2 values('t050','Tag duoc them',20);
--B3 Commit l?i
COMMIT;

--**X? lý
--Thay ??i m?c cô l?p ?? x? lý
ALTER SESSION SET ISOLATION_LEVEL=SERIALIZABLE;

--**Các b??c ki?m tra l?i
--B2 Chèn 1 dòng d? li?u vào b?ng TAG trên máy 2
INSERT INTO BTL1M2.TAG@DBL_M2 values('t051','Tag duoc them 2',20);
--B3 Commit l?i
COMMIT;



----------------------------------------------------------------------------------------------------



--****DEADLOCK****
--**M?c cô l?p ban ??u
ALTER SESSION SET ISOLATION_LEVEL=READ COMMITTED;

--**Mô t? tr??ng h?p
--B2 C?p nh?t 1 hàng thông tin trong b?ng TAG (TAGID = 't051')
UPDATE BTL1M2.TAG@DBL_M2 SET TAGNAME = 'TAG 100' WHERE TAGID='t051';
--B4 C?p nh?t 1 hàng thông tin trong b?ng TAG (TAGID = 't050')
UPDATE BTL1M2.TAG@DBL_M2 SET TAGNAME = 'TAG 200' WHERE TAGID='t050';	
-- =>B4 ch? vi?c update t?i B1 ???c commit
-- =>Xu?t hi?n deadlock t? lúc ch?y l?nh b??c này.
-- =>Rollback vi?c c?p nh?t thông tin ? B3
--B7 Commit l?i
COMMIT;

--**X? lý
--Thay ??i m?c cô l?p ?? x? lý
ALTER SESSION SET ISOLATION_LEVEL=SERIALIZABLE;

--**Các b??c ki?m tra l?i
--B2 C?p nh?t balance c?a 'kh04'
UPDATE BTL1M2.TAG@DBL_M2 SET TAGNAME = 'TAG 500' WHERE TAGID='t051';
--B4 C?p nh?t balance c?a 'kh03'
UPDATE BTL1M2.TAG@DBL_M2 SET TAGNAME = 'TAG 700' WHERE TAGID='t050';	
--B7 Commit l?i
COMMIT;