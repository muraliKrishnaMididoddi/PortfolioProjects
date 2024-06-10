/*
Cleaning data in SQL Queries
*/
Select *
From portfolioProjects.dbo.NashvilleHousing

--Standardize sale Date Format

Select SaleDateConverted,Convert(Date,SaleDate) as newsaledate
From portfolioProjects.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate= Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted= Convert(Date,SaleDate)


--Populate Property Adress Data

Select *
From portfolioProjects.dbo.NashvilleHousing
--Where PropertyAddress is null
order by  ParcelID



Select a.parcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolioProjects.dbo.NashvilleHousing a
JOIN portfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b. [UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
From portfolioProjects.dbo.NashvilleHousing a
JOIN portfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b. [UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns(Adress,City,State)


Select PropertyAddress
From portfolioProjects.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by  ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City

From portfolioProjects.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



Select *
From portfolioProjects.dbo.NashvilleHousing



Select OwnerAddress
From portfolioProjects.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)

From portfolioProjects.dbo.NashvilleHousing





ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)



--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From portfolioProjects.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant='Y' THEN 'Yes'
	when SoldAsVacant='N' THEN 'No'
	Else SoldAsVacant
	END
From portfolioProjects.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant=CASE When SoldAsVacant='Y' THEN 'Yes'
	when SoldAsVacant='N' THEN 'No'
	Else SoldAsVacant
	END

---------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					)row_num

From portfolioProjects.dbo.NashvilleHousing
--order by ParcelID 
)
Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress

Select *
From portfolioProjects.dbo.NashvilleHousing


-------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
From portfolioProjects.dbo.NashvilleHousing

ALTER TABLE portfolioProjects.dbo.NashvilleHousing
DROP Column OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE portfolioProjects.dbo.NashvilleHousing
DROP Column SaleDate
















