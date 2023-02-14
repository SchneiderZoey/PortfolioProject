/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject2].[dbo].[dbo.NashvilleHousing]

  --cleaning Data in SQL Queries

  --*/

  select *
  from PortfolioProject2.dbo.NashvilleHousing


  --Standardize Date Format

    select SaleDateConverted, CONVERT(Date,Saledate)
  from PortfolioProject2.dbo.NashvilleHousing

  Update NashvilleHousing
  set SaleDate = Convert(date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted date;

Update NashvilleHousing
SET SaleDateConverted = Convert(date,SaleDate)


--Populate Property Adress Data

  select *
  from PortfolioProject2.dbo.NashvilleHousing
  order by ParcelID




  --where PropertyAddress is null




select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
from PortfolioProject2.dbo.NashvilleHousing a
Join PortfolioProject2.dbo.NashvilleHousing b
On a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.propertyAddress,b.PropertyAddress)
from PortfolioProject2.dbo.NashvilleHousing a
Join PortfolioProject2.dbo.NashvilleHousing b
On a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]


--Breaking out Address Into Individual Colums (address, City, State)

  select PropertyAddress
  from PortfolioProject2.dbo.NashvilleHousing
  --where PropertyAddress is null
  --order by ParcelID

  SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(propertyAddress)) as Address

  from PortfolioProject2.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


Alter Table NashvilleHousing
Add PropertySplitcity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(propertyAddress))




Select *
from PortfolioProject2.dbo.NashvilleHousing


Select OwnerAddress
from PortfolioProject2.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from PortfolioProject2.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OwnersplitAddress Nvarchar(255);

UPDATE Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE Nashvillehousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE Nashvillehousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


Select *
from PortfolioProject2.dbo.NashvilleHousing




--Change Y and N to yes and no

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject2.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
When SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END 
FROM PortfolioProject2.dbo.NashvilleHousing


UPDATE PortfolioProject2.dbo.NashvilleHousing
SET SoldAsVacant= CASE When SoldAsVacant = 'Y' THEN 'YES'
When SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END 



-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY
UniqueID
) row_num
FROM PortfolioProject2.dbo.NashvilleHousing

)
select *
FROM RowNumCTE
WHERE row_num >1


select *
From PortfolioProject2.dbo.NashvilleHousing


--Delete Unused Colums

SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing


ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN Saledate
