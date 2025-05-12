IF OBJECT_ID('dbo.staging_payment') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[staging_payment];
END

IF OBJECT_ID('dbo.staging_rider') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[staging_rider];
END

IF OBJECT_ID('dbo.staging_station') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[staging_station];
END

IF OBJECT_ID('dbo.staging_trip') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[staging_trip];
END

-- Drop an external file format  
DROP EXTERNAL FILE FORMAT SynapseDelimitedTextFormat  

