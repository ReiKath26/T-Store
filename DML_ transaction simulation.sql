USE Tstore;

-- Purchase Transaction

-- Staff purchase from vendor, transaction is recorded to Purchase_transaction log
INSERT INTO Purchase_transaction
VALUES('PU016', 'ST007', 'VE002', '2020/11/16 17:46:38')

--The purchase detail recorded to pu_transaction_detail log
INSERT INTO pu_transaction_detail
VALUES('PU016', 'CL001', 50),
('PU016', 'CL003', 50),
('PU016', 'CL005', 50)

--Stock updated as the purchase suceeded
UPDATE Cloth 
SET Stock =
(
	SELECT SUM(cl.stock + pu.quantity) FROM Cloth cl JOIN pu_transaction_detail pu
	ON cl.ID = pu.clothID
	WHERE cl.ID = pu.clothID
)

--Sales transaction

--Customer buy from Tstore served by staff, transaction is recorded to sales transaction log
INSERT INTO sales_transaction
VALUES('SA016', 'ST003', 'CU008', '2020/11/16 18:24:50')

-- The sales detail recorded into sales transaction detail log
INSERT INTO sa_transaction_detail
VALUES('SA016', 'CL007', 5),
('SA016', 'CL009', 3)

--Stock updated as the sales suceeded
UPDATE Cloth
SET Stock =
(
	SELECT SUM(cl.stock - sa.quantity) FROM Cloth cl JOIN sa_transaction_detail sa
	ON cl.ID = sa.clothID
	WHERE cl.ID = sa.clothID
)
