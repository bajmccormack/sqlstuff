-- This came about after @PamelaMooney tweeted: #SQLHelp Is anyone aware of a character length on the STUFF function?
-- I still don't have a definitive answer but I can get it working up to 50 million characters. If you are stuffing beyond that, good luck to you.

DECLARE @var NVARCHAR(MAX) = N''
DECLARE @counter int = 0
WHILE @counter < 100000
BEGIN
SET @var += '500 characters pqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuv500 characters pqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuv500 characters pqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuv500 characters pqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuv500 characters pqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuv'

SET @counter +=1
END
SELECT STUFF(@var, 5, 1, ' Still works! ')
SELECT LEN(@var)

/*	While limit value for @counter:
	10 - ok
	100 - ok
	1000 - ok
	10000 - ok
	100000 - ok - Works out as 50,000,000 characters. It took 4 hours, 28 minutes and 18 seconds of my laptop.
*/