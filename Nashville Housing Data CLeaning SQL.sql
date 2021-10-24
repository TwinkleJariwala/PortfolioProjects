

--Cleaning data in SQL Queries


--Standardize data

Alter table NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted=CONVERT(Date,SaleDate)

select SaleDateConverted, CONVERT(date,SaleDate) from PortfolioProject1.dbo.NashvilleHousing


--Populate Property Address Data

select * from PortfolioProject1.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into indivdual columns 

select PropertyAddress from PortfolioProject1.dbo.NashvilleHousing


select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from PortfolioProject1.dbo.NashvilleHousing

Alter Table NashvilleHousing
Drop Column PropertySplitCity

Alter table NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress=substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity=substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select * from PortfolioProject1.dbo.NashvilleHousing

select OwnerAddress 
from PortfolioProject1.dbo.NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject1.dbo.NashvilleHousing

Alter table NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter table NashvilleHousing 
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter table NashvilleHousing 
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)

Select Distinct(SoldAsVacant) ,Count(SoldAsVacant)
from PortfolioProject1.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, Case when SoldAsVacant='Y' Then 'Yes'
		when SoldAsVacant='N' Then 'No'
		Else SoldAsVacant
		End
from PortfolioProject1.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant=Case when SoldAsVacant='Y' Then 'Yes'
		when SoldAsVacant='N' Then 'No'
		Else SoldAsVacant
		End

---Remove Duplicates


WITH RowNUMCTE AS(
Select *, 
ROW_NUMBER() Over (
	Partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY 
	UniqueID) Row_Num
from PortfolioProject1.dbo.NashvilleHousing
--ORDER BY ParcelID
)
Select * from RowNUMCTE
where Row_Num>1
Order BY PropertyAddress


--Delete Unused Columns


select *
from PortfolioProject1.dbo.NashvilleHousing


Alter Table PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN SaleDate

