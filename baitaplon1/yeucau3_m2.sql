--****LOSTUPDATE*****
--**Mức cô lập ban đầu
ALTER SESSION SET ISOLATION_LEVEL=READ COMMITTED;

--**Mô tả trường hợp
--B2 Kiểm tra dữ liệu kênh
SELECT * FROM CHANNEL WHERE CHANNELID='ch002';
--B4 Máy 2 cập nhật dữ liệu tên kênh là 'Sa Mac Va Rung Ram'
UPDATE CHANNEL SET CNAME='Sa Mac Va Rung Ram' WHERE CHANNELID='ch002';
--B6 Commit lại (Sau máy 1)
COMMIT;
--B8 Kiểm tra lại dữ tại máy 2 => Tên kênh 'Sa Mac Va Rung Ram'
SELECT * FROM CHANNEL WHERE CHANNELID ='ch002';

--**Xử lý
--Thay đổi mức cô lập để xử lý
ALTER SESSION SET ISOLATION_LEVEL=SERIALIZABLE;

--**Các bước kiểm tra lại
--B2 Máy 2 cập nhật dữ liệu tên kênh là 'Quy Bi Chi Chu'
UPDATE CHANNEL SET CNAME='Quy Bi Chi Chu' WHERE CHANNELID='ch002';
--B4 Commit lại (Sau máy 1)
COMMIT;
--B6 Kiểm tra lại dữ liệu
SELECT * FROM CHANNEL WHERE CHANNELID ='ch002';
-- => Việc sửa đổi không được cho phép (có hiển thị lỗi trước đó)


----------------------------------------------------------------------------------------------------


--****NON-REPEATABLE****
--**Mức cô lập ban đầu
ALTER SESSION SET ISOLATION_LEVEL=READ COMMITTED;

--**Mô tả trường hợp
--B2 Kiểm tra thông tin kênh tại máy 2
SELECT * FROM CHANNEL WHERE CHANNELID ='ch002';
--B5 Kiểm tra thông tin kênh tại máy 2 lần 2
SELECT * FROM CHANNEL WHERE CHANNELID ='ch002';
--=> Dữ liệu đã bị thay đổi (NON-REPEATABLE)

--**Xử lý
--Thay đổi mức cô lập để xử lý
ALTER SESSION SET ISOLATION_LEVEL=SERIALIZABLE;

--**Các bước kiểm tra lại
--B2 Kiểm tra dữ liệu tại máy 2
SELECT * FROM CHANNEL WHERE CHANNELID ='ch002';
--B5 Kiểm tra lại dữ liệu lần 2
SELECT * FROM CHANNEL WHERE CHANNELID ='ch002';
-- => Dữ liệu không bị thay đổi (đã xử lý thành công)
--B6 Commit lại để đồng bộ
COMMIT;
--B7 Kiểm tra lại dữ liệu lần 3
SELECT * FROM CHANNEL WHERE CHANNELID='ch002';
-- => Lúc này dữ liệu mới bị thay đổi



----------------------------------------------------------------------------------------------------



--****PHANTOM****
--**Mức cô lập ban đầu
ALTER SESSION SET ISOLATION_LEVEL=READ COMMITTED;

--**Mô tả trường hợp
--B1 Đếm số dòng hiện có trong bảng TAG
SELECT COUNT(*) FROM TAG;
--B4 Kiểm tra lại số dòng trong bảng TAG lần 2
SELECT COUNT(*) FROM TAG;
-- => Số dòng dữ liệu thay đổi tại lần kiểm tra 2 
-- => Đây là trường hợp Phantom (số dòng dữ liệu thay đổi so với ban đầu)

--**Xử lý
--Thay đổi mức cô lập để xử lý
ALTER SESSION SET ISOLATION_LEVEL=SERIALIZABLE;

--**Các bước kiểm tra lại
--B1 Đếm số dòng hiện có trong bảng TAG
SELECT COUNT(*) FROM TAG;
--B4 Kiểm tra lại số dòng trong bảng TAG lần 2
SELECT COUNT(*) FROM TAG;
-- => Số dòng dữ liệu không thay đổi
--B5 Commit lại
COMMIT;	
--B6 Kiểm tra lại số dòng trong bảng TAG lần 3
SELECT COUNT(*) FROM TAG;
-- => Số dòng dữ liệu lúc này mới thay đổi



----------------------------------------------------------------------------------------------------





--****DEADLOCK****
--**Mức cô lập ban đầu
ALTER SESSION SET ISOLATION_LEVEL=READ COMMITTED;

--**Mô tả trường hợp
--B1 Cập nhật 1 hàng thông tin trong bảng TAG (TAGID = 't050')
UPDATE TAG SET TAGNAME = 'TAG 400' WHERE TAGID='t050';
--B3 Cập nhật 1 hàng thông tin trong bảng TAG (TAGID = 't051')
UPDATE TAG SET TAGNAME = 'TAG 900' WHERE TAGID='t051';
-- => Chờ việc update tại B2 được commit
--B5 Commit lại (chỉ B1 được commit, B3 đã bị rollback do deadlock)
COMMIT;
-- => B1 được commit nên B4 được thực hiện
--B6 Kiểm tra lại thông tin TAG
SELECT * FROM TAG WHERE TAGID IN ('t050','t051');
-- => Deadlock làm B3 không thể thực hiện

--**Xử lý
--Thay đổi mức cô lập để xử lý	
ALTER SESSION SET ISOLATION_LEVEL=SERIALIZABLE;

--**Các bước kiểm tra lại
--B1 Cập nhật 1 hàng thông tin trong bảng TAG (TAGID = 't050')
UPDATE TAG SET TAGNAME = 'TAG 1400' WHERE TAGID='t050';
--B3 Cập nhật 1 hàng thông tin trong bảng TAG (TAGID = 't051')
UPDATE TAG SET TAGNAME = 'TAG 2900' WHERE TAGID='t051';
-- => Chờ việc update tại B2 được commit
--B5 Commit lại
COMMIT;
--B6 Kiểm tra lại thông tin TAG
SELECT * FROM TAG WHERE TAGID IN ('t050','t051');
