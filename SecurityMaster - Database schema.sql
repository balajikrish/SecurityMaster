--SecurityMaster table
CREATE TABLE SecurityMaster (
  MasterSecID int NOT NULL PRIMARY KEY,
  Ticker varchar(10),
  Name varchar(600),
  Currency varchar(5),
  AssetType varchar(10),
  CreatedDate datetime,
  LastUpdateDate datetime,
  CONSTRAINT secmaster_superkey UNIQUE (MasterSecID, AssetType)
);

Drop table Future
--Future
CREATE TABLE Future (
  MasterSecID int NOT NULL,
  AssetType varchar(10) Default 'Future' CHECK (AssetType = 'Future'),
  ContractSize int,
  ExpirationDate datetime,
  PRIMARY KEY (MasterSecID, AssetType),
  FOREIGN KEY (MasterSecID, AssetType) REFERENCES SecurityMaster(MasterSecID, AssetType)
);


--Option
CREATE TABLE Options (
  MasterSecID int NOT NULL,
  AssetType varchar(10) Default 'Options' CHECK (AssetType = 'Options'),
  ContractSize int,
  ExpirationDate datetime,
  StrikePrice numeric(28,12),
  OptionType varchar(4),
  Underlier int,
  PRIMARY KEY (MasterSecID, AssetType),
  FOREIGN KEY (MasterSecID, AssetType) REFERENCES SecurityMaster(MasterSecID, AssetType),
  FOREIGN KEY (Underlier) REFERENCES SecurityMaster(MasterSecID)
);


--DailyPrice
CREATE TABLE DailyPrice(
	MasterSecID int NOT NULL,
	PriceDate datetime NOT NULL,
	ClosePrice numeric(24,12),
	PRIMARY KEY (MasterSecID, PriceDate),
	FOREIGN KEY (MasterSecID) REFERENCES SecurityMaster(MasterSecID)
)

--DailyPosition
CREATE TABLE DailyPosition(
	MasterSecID int NOT NULL,
	PositionDate datetime NOT NULL,
	Quantity int,
	PRIMARY KEY (MasterSecID, PositionDate),
	FOREIGN KEY ( MasterSecID ) REFERENCES SecurityMaster (MasterSecID)
)


CREATE VIEW Equity AS 
	SELECT [MasterSecID]
		  ,[Ticker]
		  ,[Name]
		  ,[Currency]
		  ,[AssetType]
		  ,[CreatedDate]
		  ,[LastUpdateDate]
	  FROM [dbo].[SecurityMaster]

CREATE VIEW Future AS 
	SELECT [MasterSecID]
		  ,[Ticker]
		  ,[Name]
		  ,[Currency]
		  ,[AssetType]
		  ,[ExpirationDate]
		  ,[ContractSize]
		  ,[CreatedDate]
		  ,[LastUpdateDate]
	  FROM [dbo].[SecurityMaster] secmas
	  INNER JOIN [dbo].[Future] fut ON secmas.MasterSecID = fut.MasterSecID 

CREATE VIEW Future AS 
	SELECT [MasterSecID]
		  ,[Ticker]
		  ,[Name]
		  ,[Currency]
		  ,underlier.[Ticker] as [Underlier]
		  ,[AssetType]
		  ,[ExpirationDate]
		  ,[ContractSize]
		  ,[StrikePrice]
		  ,[OptionType]
		  ,[CreatedDate]
		  ,[LastUpdateDate]
	  FROM [dbo].[SecurityMaster] secmas
	  INNER JOIN [dbo].[Options] opt ON secmas.MasterSecID = opt.MasterSecID 
	  LEFT OUTER JOIN [dbo].[SecurityMaster] undelier ON underlier.MasterSecID = opt.Underlier  
--DimSecurityMaster
CREATE TABLE DimSecurityMaster(
	ID int NOT NULL, -- surrogate key
	EffectiveStartDate Datetime Not NULL,
	EffectiveEndDate datetime NOT NULL,
	KnowledgeStartDate datetime NOT NULL,
	KnowledgeEndDate datetime NOT NULL,
	MasterSecID int, --natural key
	Ticker varchar(10),
	Name varchar(600),
	Currency varchar(5),
	AssetType varchar(10),
	ExpirationDate datetime,
	ContractSize int,
	StrikePrice numeric(28,12),
	OptionType varchar(4),
	Underlier varchar(10),
	LastModifiedDate datetime,
	LastModifiedBy varchar(60),
	CreatedDate datetime,
	CreatedBy varchar(60),
	Primary key ( ID, EffectiveStartDate, EffectiveEndDate, KnowledgeStartDate, KnowledgeEndDate)
);