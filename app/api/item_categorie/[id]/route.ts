import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";
import { createLog } from "@/lib/logs";
import { validateCategoryInput } from "@/lib/validators";

export async function GET(req: Request, { params }: { params: { id: string } }) {
  try {
    const { id } = await params;
    if (!id) return NextResponse.json({ message: "ID requis." }, { status: 400 });

    const category = await prisma.itemCategorie.findFirst({
      where: {
        id,
        state: { in: [0, 1, 2] },
      },
    });

    if (!category) return NextResponse.json({ message: "Catégorie non trouvée." }, { status: 404 });

    return NextResponse.json(category, { status: 200 });
  } catch (error) {
    return NextResponse.json({ message: "Erreur serveur", error }, { status: 500 });
  }
}

export async function PUT(req: Request, { params }: { params: { id: string } }) {
  try {
    const { id } = await params;
    if (!id) return NextResponse.json({ message: "ID requis." }, { status: 400 });

    const body = await req.json();
    const { name, state } = body;

    const validation = validateCategoryInput(name, state);
    if (!validation.valid) {
      return NextResponse.json({ message: validation.message }, { status: 400 });
    }

    // Vérification que la catégorie existe
    const category = await prisma.itemCategorie.findUnique({ where: { id } });
    if (!category) return NextResponse.json({ message: "Catégorie non trouvée." }, { status: 404 });

    // Vérification que le nom n'est pas déjà utilisé
    const existingCategory = await prisma.itemCategorie.findFirst({
      where: { name, NOT: { id } },
    });
    if (existingCategory) return NextResponse.json({ message: "La catégorie existe déjà." }, { status: 400 });

    // Mise à jour de la catégorie
    const updatedCategory = await prisma.itemCategorie.update({
      where: { id },
      data: { name, state },
    });

    // Log de mise à jour
    await createLog(
      "UPDATE",
      "ItemCategorie",
      id,
      category,
      updatedCategory,
      null
    );

    return NextResponse.json(updatedCategory, { status: 200 });
  } catch (error) {
    return NextResponse.json({ message: "Erreur serveur", error }, { status: 500 });
  }
}


export async function DELETE(req: Request, { params }: { params: { id: string } }) {
  try {
    const { id } = await params;
    if (!id) return NextResponse.json({ message: "ID requis." }, { status: 400 });

    // Vérifier si la catégorie existe
    const category = await prisma.itemCategorie.findUnique({ where: { id } });
    if (!category) return NextResponse.json({ message: "Catégorie non trouvée." }, { status: 404 });

    if (category.state === 3) return NextResponse.json({ message: "Catégorie déjà archivée." }, { status: 400 });

    // Mettre `state = 3` au lieu de supprimer définitivement
    const updatedCategory = await prisma.itemCategorie.update({
      where: { id },
      data: { state: 3 },
    });

    // Log d'archivage
    await createLog(
      "ARCHIVE",
      "ItemCategorie",
      id,
      category,
      updatedCategory,
      null
    );

    return NextResponse.json({ message: "Catégorie archivée avec succès.", updatedCategory }, { status: 200 });
  } catch (error) {
    return NextResponse.json({ message: "Erreur serveur", error }, { status: 500 });
  }
}
