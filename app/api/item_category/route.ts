import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";
import { createLog } from "@/lib/logs";
import { validateCategoryInput } from "@/lib/validators";

export async function GET() {
  try {
    const categories = await prisma.itemCategory.findMany({
      where: {
        state: { in: [0, 1, 2] },
      },
    });

    return NextResponse.json(categories, { status: 200 });
  } catch (error) {
    return NextResponse.json({ message: "Erreur serveur", error }, { status: 500 });
  }
}

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { name, state } = body;

    const validation = validateCategoryInput(name, state);
    if (!validation.valid) {
      return NextResponse.json({ message: validation.message }, { status: 400 });
    }

    // Vérification de l'unicité de la catégorie
    const existingCategory = await prisma.itemCategory.findUnique({ where: { name } });
    if (existingCategory) {
      return NextResponse.json({ message: "La catégorie existe déjà." }, { status: 400 });
    }

    // Création de la nouvelle catégorie
    const newCategory = await prisma.itemCategory.create({
      data: { name, state: state ?? 0 }
    });

    await prisma.statsItemCategory.create({
      data: {
        itemCategoryId: newCategory.id,
        totalSpend: 0,
        purchaseCount: 0,
        lastPurchaseAt: null,
      },
    });

    // Log de création
    await createLog(
      "CREATE",
      "ItemCategory",
      newCategory.id,
      null,
      newCategory,
      null
    );

    return NextResponse.json(newCategory, { status: 201 });
  } catch (error) {
    return NextResponse.json({ message: "Erreur serveur", error }, { status: 500 });
  }
}
