import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function GET(
    req: Request,
    { params }: { params: { customerId: string; itemCategorieId: string } }
) {
    try {
        const { itemCategorieId } = await params;
        if (!itemCategorieId) {
            return NextResponse.json({ message: "ID requis." }, { status: 400 });
        }

        const itemCategorie = await prisma.itemCategorie.findUnique({ where: { id: itemCategorieId } });
        if (!itemCategorie) return NextResponse.json({ message: "Catégorie non trouvée." }, { status: 404 });
  
        const stats = await prisma.statsItemCategorieCustomer.findMany({
            where: { itemCategorieId },
        });

        if (!stats) return NextResponse.json({ message: "Statistiques non trouvées." }, { status: 404 });
  
        return NextResponse.json(stats, { status: 200 });
    } catch (error) {
        return NextResponse.json({ message: "Erreur serveur" }, { status: 500 });
    }
}