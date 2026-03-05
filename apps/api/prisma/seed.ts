import { PrismaClient, UserRole } from '@prisma/client';

import { hashPassword } from '../src/lib/password.js';

const prisma = new PrismaClient();

const DEV_COMPANY_ID = '11111111-1111-1111-1111-111111111111';
const DEV_OWNER_ID = '22222222-2222-2222-2222-222222222222';
const DEV_MANAGER_ID = '77777777-7777-7777-7777-777777777777';
const DEV_STAFF_ID = '88888888-8888-8888-8888-888888888888';
const FOOD_CATEGORY_ID = '33333333-3333-3333-3333-333333333333';
const CLEANING_CATEGORY_ID = '44444444-4444-4444-4444-444444444444';
const WATER_PRODUCT_ID = '55555555-5555-5555-5555-555555555555';
const SOAP_PRODUCT_ID = '66666666-6666-6666-6666-666666666666';

async function main() {
  await prisma.company.upsert({
    where: { id: DEV_COMPANY_ID },
    update: {
      name: 'Оптовый склад Дербент',
      city: 'Дербент',
      phone: '+7 900 000-00-00',
    },
    create: {
      id: DEV_COMPANY_ID,
      name: 'Оптовый склад Дербент',
      city: 'Дербент',
      phone: '+7 900 000-00-00',
    },
  });

  await prisma.user.upsert({
    where: { id: DEV_OWNER_ID },
    update: {
      companyId: DEV_COMPANY_ID,
      name: 'Мурад И.',
      role: UserRole.OWNER,
      passwordHash: hashPassword('demo-owner-123'),
      isActive: true,
    },
    create: {
      id: DEV_OWNER_ID,
      companyId: DEV_COMPANY_ID,
      name: 'Мурад И.',
      role: UserRole.OWNER,
      passwordHash: hashPassword('demo-owner-123'),
      isActive: true,
      phone: '+7 900 000-00-00',
      email: 'owner@nexussklad.local',
    },
  });

  await prisma.user.upsert({
    where: { id: DEV_MANAGER_ID },
    update: {
      companyId: DEV_COMPANY_ID,
      name: 'Менеджер смены',
      role: UserRole.MANAGER,
      passwordHash: hashPassword('demo-manager-123'),
      isActive: true,
    },
    create: {
      id: DEV_MANAGER_ID,
      companyId: DEV_COMPANY_ID,
      name: 'Менеджер смены',
      role: UserRole.MANAGER,
      passwordHash: hashPassword('demo-manager-123'),
      isActive: true,
      phone: '+7 900 000-00-01',
      email: 'manager@nexussklad.local',
    },
  });

  await prisma.user.upsert({
    where: { id: DEV_STAFF_ID },
    update: {
      companyId: DEV_COMPANY_ID,
      name: 'Кладовщик 1',
      role: UserRole.STAFF,
      passwordHash: hashPassword('demo-staff-123'),
      isActive: true,
    },
    create: {
      id: DEV_STAFF_ID,
      companyId: DEV_COMPANY_ID,
      name: 'Кладовщик 1',
      role: UserRole.STAFF,
      passwordHash: hashPassword('demo-staff-123'),
      isActive: true,
      phone: '+7 900 000-00-02',
      email: 'staff@nexussklad.local',
    },
  });

  await prisma.category.upsert({
    where: { id: FOOD_CATEGORY_ID },
    update: {
      companyId: DEV_COMPANY_ID,
      name: 'Напитки',
      parentId: null,
    },
    create: {
      id: FOOD_CATEGORY_ID,
      companyId: DEV_COMPANY_ID,
      name: 'Напитки',
      parentId: null,
    },
  });

  await prisma.category.upsert({
    where: { id: CLEANING_CATEGORY_ID },
    update: {
      companyId: DEV_COMPANY_ID,
      name: 'Бытовая химия',
      parentId: null,
    },
    create: {
      id: CLEANING_CATEGORY_ID,
      companyId: DEV_COMPANY_ID,
      name: 'Бытовая химия',
      parentId: null,
    },
  });

  await prisma.product.upsert({
    where: { id: WATER_PRODUCT_ID },
    update: {
      companyId: DEV_COMPANY_ID,
      categoryId: FOOD_CATEGORY_ID,
      name: 'Вода 0.5 л',
      sku: 'WATER-05',
      barcode: '460100000001',
      unit: 'шт',
      minStock: 24,
      currentStock: 96,
    },
    create: {
      id: WATER_PRODUCT_ID,
      companyId: DEV_COMPANY_ID,
      categoryId: FOOD_CATEGORY_ID,
      name: 'Вода 0.5 л',
      sku: 'WATER-05',
      barcode: '460100000001',
      unit: 'шт',
      minStock: 24,
      currentStock: 96,
    },
  });

  await prisma.product.upsert({
    where: { id: SOAP_PRODUCT_ID },
    update: {
      companyId: DEV_COMPANY_ID,
      categoryId: CLEANING_CATEGORY_ID,
      name: 'Жидкое мыло 5 л',
      sku: 'SOAP-5L',
      barcode: '460100000002',
      unit: 'канистра',
      minStock: 8,
      currentStock: 14,
    },
    create: {
      id: SOAP_PRODUCT_ID,
      companyId: DEV_COMPANY_ID,
      categoryId: CLEANING_CATEGORY_ID,
      name: 'Жидкое мыло 5 л',
      sku: 'SOAP-5L',
      barcode: '460100000002',
      unit: 'канистра',
      minStock: 8,
      currentStock: 14,
    },
  });

  console.log(JSON.stringify({ defaultCompanyId: DEV_COMPANY_ID }, null, 2));
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
