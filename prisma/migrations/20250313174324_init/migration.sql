/*
  Warnings:

  - The primary key for the `Deposit` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `userId` on the `Deposit` table. All the data in the column will be lost.
  - The primary key for the `Item` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `categorieId` on the `Item` table. All the data in the column will be lost.
  - The primary key for the `ItemCategorie` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Price` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Purchase` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `userId` on the `Purchase` table. All the data in the column will be lost.
  - You are about to alter the column `status` on the `Purchase` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Int`.
  - The primary key for the `StatsItem` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `balance` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `categorieId` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `firstname` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `lastname` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `nickname` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `StatsItemUser` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `StatsUser` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `UserCategorie` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[username]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `username` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `Deposit` DROP FOREIGN KEY `Deposit_userId_fkey`;

-- DropForeignKey
ALTER TABLE `Item` DROP FOREIGN KEY `Item_categorieId_fkey`;

-- DropForeignKey
ALTER TABLE `Price` DROP FOREIGN KEY `Price_itemId_fkey`;

-- DropForeignKey
ALTER TABLE `Purchase` DROP FOREIGN KEY `Purchase_itemId_fkey`;

-- DropForeignKey
ALTER TABLE `Purchase` DROP FOREIGN KEY `Purchase_priceId_fkey`;

-- DropForeignKey
ALTER TABLE `Purchase` DROP FOREIGN KEY `Purchase_userId_fkey`;

-- DropForeignKey
ALTER TABLE `StatsItem` DROP FOREIGN KEY `StatsItem_itemId_fkey`;

-- DropForeignKey
ALTER TABLE `StatsItemUser` DROP FOREIGN KEY `StatsItemUser_itemId_fkey`;

-- DropForeignKey
ALTER TABLE `StatsItemUser` DROP FOREIGN KEY `StatsItemUser_userId_fkey`;

-- DropForeignKey
ALTER TABLE `StatsUser` DROP FOREIGN KEY `StatsUser_userId_fkey`;

-- DropForeignKey
ALTER TABLE `User` DROP FOREIGN KEY `User_categorieId_fkey`;

-- DropIndex
DROP INDEX `Deposit_userId_fkey` ON `Deposit`;

-- DropIndex
DROP INDEX `Item_categorieId_fkey` ON `Item`;

-- DropIndex
DROP INDEX `Price_itemId_fkey` ON `Price`;

-- DropIndex
DROP INDEX `Purchase_itemId_fkey` ON `Purchase`;

-- DropIndex
DROP INDEX `Purchase_priceId_fkey` ON `Purchase`;

-- DropIndex
DROP INDEX `Purchase_userId_fkey` ON `Purchase`;

-- DropIndex
DROP INDEX `User_categorieId_fkey` ON `User`;

-- DropIndex
DROP INDEX `User_nickname_key` ON `User`;

-- AlterTable
ALTER TABLE `Deposit` DROP PRIMARY KEY,
    DROP COLUMN `userId`,
    ADD COLUMN `customerId` VARCHAR(191) NULL,
    ADD COLUMN `status` INTEGER NOT NULL DEFAULT 0,
    MODIFY `id` VARCHAR(191) NOT NULL,
    ADD PRIMARY KEY (`id`);

-- AlterTable
ALTER TABLE `Item` DROP PRIMARY KEY,
    DROP COLUMN `categorieId`,
    ADD COLUMN `state` INTEGER NOT NULL DEFAULT 0,
    MODIFY `id` VARCHAR(191) NOT NULL,
    ADD PRIMARY KEY (`id`);

-- AlterTable
ALTER TABLE `ItemCategorie` DROP PRIMARY KEY,
    ADD COLUMN `state` INTEGER NOT NULL DEFAULT 0,
    MODIFY `id` VARCHAR(191) NOT NULL,
    ADD PRIMARY KEY (`id`);

-- AlterTable
ALTER TABLE `Price` DROP PRIMARY KEY,
    MODIFY `id` VARCHAR(191) NOT NULL,
    MODIFY `itemId` VARCHAR(191) NOT NULL,
    ADD PRIMARY KEY (`id`);

-- AlterTable
ALTER TABLE `Purchase` DROP PRIMARY KEY,
    DROP COLUMN `userId`,
    ADD COLUMN `customerId` VARCHAR(191) NULL,
    MODIFY `id` VARCHAR(191) NOT NULL,
    MODIFY `status` INTEGER NOT NULL DEFAULT 0,
    MODIFY `itemId` VARCHAR(191) NULL,
    MODIFY `priceId` VARCHAR(191) NULL,
    ADD PRIMARY KEY (`id`);

-- AlterTable
ALTER TABLE `StatsItem` DROP PRIMARY KEY,
    ADD COLUMN `totalSpend` INTEGER NOT NULL DEFAULT 0,
    MODIFY `id` VARCHAR(191) NOT NULL,
    MODIFY `itemId` VARCHAR(191) NOT NULL,
    ADD PRIMARY KEY (`id`);

-- AlterTable
ALTER TABLE `User` DROP PRIMARY KEY,
    DROP COLUMN `balance`,
    DROP COLUMN `categorieId`,
    DROP COLUMN `firstname`,
    DROP COLUMN `lastname`,
    DROP COLUMN `nickname`,
    ADD COLUMN `promo` INTEGER NULL,
    ADD COLUMN `status` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `username` VARCHAR(191) NOT NULL,
    MODIFY `id` VARCHAR(191) NOT NULL,
    ADD PRIMARY KEY (`id`);

-- DropTable
DROP TABLE `StatsItemUser`;

-- DropTable
DROP TABLE `StatsUser`;

-- DropTable
DROP TABLE `UserCategorie`;

-- CreateTable
CREATE TABLE `ItemCategoriePivot` (
    `itemId` VARCHAR(191) NOT NULL,
    `categorieId` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`itemId`, `categorieId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CustomerCategorie` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `overdraft` INTEGER NOT NULL,
    `bonus` BOOLEAN NOT NULL DEFAULT false,
    `state` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `CustomerCategorie_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Customer` (
    `id` VARCHAR(191) NOT NULL,
    `firstname` VARCHAR(191) NOT NULL,
    `lastname` VARCHAR(191) NOT NULL,
    `nickname` VARCHAR(191) NOT NULL,
    `balance` INTEGER NOT NULL DEFAULT 0,
    `state` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Customer_nickname_key`(`nickname`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CustomerCategoriePivot` (
    `customerId` VARCHAR(191) NOT NULL,
    `categorieId` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`customerId`, `categorieId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StatsItemCategorie` (
    `id` VARCHAR(191) NOT NULL,
    `itemCategorieId` VARCHAR(191) NOT NULL,
    `totalSpend` INTEGER NOT NULL DEFAULT 0,
    `purchaseCount` INTEGER NOT NULL DEFAULT 0,
    `lastPurchaseAt` DATETIME(3) NULL,

    UNIQUE INDEX `StatsItemCategorie_itemCategorieId_key`(`itemCategorieId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StatsCustomer` (
    `id` VARCHAR(191) NOT NULL,
    `customerId` VARCHAR(191) NOT NULL,
    `totalDeposit` INTEGER NOT NULL DEFAULT 0,
    `totalSpend` INTEGER NOT NULL DEFAULT 0,
    `depositCount` INTEGER NOT NULL DEFAULT 0,
    `purchaseCount` INTEGER NOT NULL DEFAULT 0,
    `lastDepositAt` DATETIME(3) NULL,
    `lastPurchaseAt` DATETIME(3) NULL,

    UNIQUE INDEX `StatsCustomer_customerId_key`(`customerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StatsItemCustomer` (
    `id` VARCHAR(191) NOT NULL,
    `customerId` VARCHAR(191) NOT NULL,
    `itemId` VARCHAR(191) NOT NULL,
    `totalSpend` INTEGER NOT NULL DEFAULT 0,
    `purchaseCount` INTEGER NOT NULL DEFAULT 0,
    `lastPurchaseAt` DATETIME(3) NULL,

    UNIQUE INDEX `StatsItemCustomer_customerId_itemId_key`(`customerId`, `itemId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StatsItemCategorieCustomer` (
    `id` VARCHAR(191) NOT NULL,
    `customerId` VARCHAR(191) NOT NULL,
    `itemCategorieId` VARCHAR(191) NOT NULL,
    `totalSpend` INTEGER NOT NULL DEFAULT 0,
    `purchaseCount` INTEGER NOT NULL DEFAULT 0,
    `lastPurchaseAt` DATETIME(3) NULL,

    UNIQUE INDEX `StatsItemCategorieCustomer_customerId_itemCategorieId_key`(`customerId`, `itemCategorieId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Log` (
    `id` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NULL,
    `action` VARCHAR(191) NOT NULL,
    `entity` VARCHAR(191) NOT NULL,
    `entityId` VARCHAR(191) NULL,
    `oldData` JSON NULL,
    `newData` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE UNIQUE INDEX `User_username_key` ON `User`(`username`);

-- AddForeignKey
ALTER TABLE `ItemCategoriePivot` ADD CONSTRAINT `ItemCategoriePivot_itemId_fkey` FOREIGN KEY (`itemId`) REFERENCES `Item`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ItemCategoriePivot` ADD CONSTRAINT `ItemCategoriePivot_categorieId_fkey` FOREIGN KEY (`categorieId`) REFERENCES `ItemCategorie`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Price` ADD CONSTRAINT `Price_itemId_fkey` FOREIGN KEY (`itemId`) REFERENCES `Item`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CustomerCategoriePivot` ADD CONSTRAINT `CustomerCategoriePivot_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CustomerCategoriePivot` ADD CONSTRAINT `CustomerCategoriePivot_categorieId_fkey` FOREIGN KEY (`categorieId`) REFERENCES `CustomerCategorie`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Deposit` ADD CONSTRAINT `Deposit_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Purchase` ADD CONSTRAINT `Purchase_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Purchase` ADD CONSTRAINT `Purchase_itemId_fkey` FOREIGN KEY (`itemId`) REFERENCES `Item`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Purchase` ADD CONSTRAINT `Purchase_priceId_fkey` FOREIGN KEY (`priceId`) REFERENCES `Price`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItem` ADD CONSTRAINT `StatsItem_itemId_fkey` FOREIGN KEY (`itemId`) REFERENCES `Item`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItemCategorie` ADD CONSTRAINT `StatsItemCategorie_itemCategorieId_fkey` FOREIGN KEY (`itemCategorieId`) REFERENCES `ItemCategorie`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsCustomer` ADD CONSTRAINT `StatsCustomer_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItemCustomer` ADD CONSTRAINT `StatsItemCustomer_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItemCustomer` ADD CONSTRAINT `StatsItemCustomer_itemId_fkey` FOREIGN KEY (`itemId`) REFERENCES `Item`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItemCategorieCustomer` ADD CONSTRAINT `StatsItemCategorieCustomer_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StatsItemCategorieCustomer` ADD CONSTRAINT `StatsItemCategorieCustomer_itemCategorieId_fkey` FOREIGN KEY (`itemCategorieId`) REFERENCES `ItemCategorie`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Log` ADD CONSTRAINT `Log_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
