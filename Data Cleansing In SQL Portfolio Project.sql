/*

		
		
		Data Cleansing Portfolio Project!


*/

SELECT *
FROM PorfolioProject..NashvilleHousing
-- --------------------------------------------------------------------------------------------------------------------------------------

-- Standardize Data Format:

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PorfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)



-- -------------------------------------------------------------------------------------------------------------------------------------

-- Populate Porperty Address Data:

SELECT *
FROM PorfolioProject..NashvilleHousing
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PorfolioProject..NashvilleHousing a
JOIN PorfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PorfolioProject..NashvilleHousing a
JOIN PorfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL




-- --------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into individual columns: (Address, City, State)

SELECT PropertyAddress
FROM PorfolioProject..NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address


FROM PorfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)



ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM PorfolioProject..NashvilleHousing






SELECT OwnerAddress
FROM PorfolioProject..NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM PorfolioProject..NashvilleHousing



ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)



ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)


SELECT *
FROM PorfolioProject..NashvilleHousing


-- --------------------------------------------------------------------------------------------------------------------------------------

-- Change "Y" and "N" values to "Yes" and "No" in "Sold as Vacant" field:

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) as 'Count'
FROM PorfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PorfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PorfolioProject..NashvilleHousing




-- -------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates:

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER
	(
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID
	)	row_num
	
FROM PorfolioProject..NashvilleHousing

)

SELECT *
FROM RowNumCTE
WHERE row_num > 1






-- -------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



SELECT *
FROM PorfolioProject.dbo.NashvilleHousing

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate






/*


		End!



*/