CREATE TABLE "URL" (
	"ID" TEXT,
	"URL" TEXT NOT NULL,
	"NAME" TEXT NOT NULL DEFAULT '',
	"ITEM_ID" TEXT,
	"OFFICIAL" INTEGER DEFAULT 0,
	"CREATED_AT" TEXT,
	UNIQUE(URL),
	FOREIGN KEY("ITEM_ID") REFERENCES "ITEM"("ID"),
	PRIMARY KEY("ID")
);

INSERT INTO URL (
ID,URL, NAME, ITEM_ID,OFFICIAL,CREATED_AT
) 
select 
lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) AS ID,
URL,
'' AS NAME,
id as ITEM_ID,
1 AS OFFICIAL,
datetime('now')||':000' AS CREATED_AT
from item where url is not null and url<>'';

ALTER TABLE ITEM DROP COLUMN URL;