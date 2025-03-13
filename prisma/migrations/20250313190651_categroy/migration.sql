/*
  Warnings:

  - You are about to drop the `CustomerCategorie` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `CustomerCategoriePivot` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ItemCategorie` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ItemCategoriePivot` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `StatsItemCategorie` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `StatsItemCategorieCustomer` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `CustomerCategoriePivot` DROP FOREIGN KEY `CustomerCategoriePivot_categorieId_fkey`;

-- DropForeignKey
ALTER TABLE `CustomerCategoriePivot` DROP FOREIGN KEY `CustomerCategoriePivot_customerId_fkey`;

-- DropForeignKey
ALTER TABLE `ItemCategoriePivot` DROP FOREIGN KEY `ItemCategoriePivot_categorieId_fkey`;

-- DropForeignKey
ALTER TABLE `ItemCategoriePivot` DROP FOREIGN KEY `ItemCategoriePivot_itemId_fkey`;

-- DropForeignKey
ALTER TABLE `StatsItemCategorie` DROP FOREIGN KEY `StatsItemCategorie_itemCategorieId_fkey`;

-- DropForeignKey
ALTER TABLE `StatsItemCategorieCustomer` DROP FOREIGN KEY `StatsItemCategorieCustomer_customerId_fkey`;

-- DropForeignKey
ALTER TABLE `StatsItemCategorieCustomer` DROP FOREIGN KEY `StatsItemCategorieCustomer_itemCategorieId_fkey`;

-- DropTable
DROP TABLE `CustomerCategorie`;

-- DropTable
DROP TABLE `CustomerCategoriePivot`;

-- DropTable
DROP TABLE `ItemCategorie`;

-- DropTable
DROP TABLE `ItemCategoriePivot`;

-- DropTable
DROP TABLE `StatsItemCategorie`;

-- DropTable
DROP TABLE `StatsItemCategorieCustomer`;

-- CreateTable
CREATE TABLE `ItemCategory` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `state` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `ItemCategory_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ItemCategoryPivot` (
    `itemId` VARCHAR(191) NOT NULL,
    `categoryId` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`itemId`, `categoryId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CustomerCategory` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `overdraft` INTEGER NOT NULL,
    `bonus` BOOLEAN NOT NULL DEFAULT false,
    `state` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `CustomerCategory_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CustomerCategoryPivot` (
    `customerId` VARCHAR(191) NOT NULL,
    `categoryId` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`customerId`, `categoryId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StatsItemCategory` (
    `id` VARCHAR(191) NOT NULL,
    `itemCategoryId` VARCHAR(191) NOT NULL,
    `totalSpend` INTEGER NOT NULL DEFAULT 0,
    `purchaseCount` INTEGER NOT NULL DEFAULT 0,
    `lastPurchaseAt` DATETIME(3) NULL,

    UNIQUE INDEX `StatsItemCategory_itemCategoryId_key`(`itemCategoryId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StatsItemCategoryCustomer` (
    `id` VARCHAR(191) NOT NULL,
    `customerId` VARCHAR(191) NOT NULL,
    `itemCategoryId` VARCHAR(191) NOT NULL,
    `totalSpend` INTEGER NOT NULL DEFAULT 0,
    `purchaseCount` INTEGER NOT NULL DEFAULT 0,
    `lastPurchaseAt` DATETIME(3) NULL,

    UNIQUE INDEX `StatsItemCategoryCustomer_customerId_itemCategoryId_key`(`customerId`, `itemCategoryId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `ItemCategoryPivot` ADD CONSTRAINT `ItemCategoryPivot_itemId_fkey` FOREIGN KEY (`itemId`) REFERENCES `Item`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ItemCategoryPivot` ADD CONSTRAINT `ItemCategoryPivot_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `ItemCategory`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CustomerCategoryPivot` ADD CONSTRAINT `CustomerCategoryPivot_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CustomerCategoryPivot` ADD CONSTRAINT `CustomerCategoryPivot_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `CustomerCategory`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItemCategory` ADD CONSTRAINT `StatsItemCategory_itemCategoryId_fkey` FOREIGN KEY (`itemCategoryId`) REFERENCES `ItemCategory`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItemCategoryCustomer` ADD CONSTRAINT `StatsItemCategoryCustomer_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItemCategoryCustomer` ADD CONSTRAINT `StatsItemCategoryCustomer_itemCategoryId_fkey` FOREIGN KEY (`itemCategoryId`) REFERENCES `ItemCategory`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
