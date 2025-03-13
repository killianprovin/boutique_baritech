import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function GET(
    req: Request,
    { params }: { params: { customerId: string; itemCategorieId: string } }
) {
    try {
        const { customerId, itemCategorieId } = await params;
        if (!customerId || !itemCategorieId) {
            return NextResponse.json({ message: "IDs requis." }, { status: 400 });
        }

        const itemCategorie = await prisma.itemCategorie.findUnique({ where: { id: itemCategorieId } });
        if (!itemCategorie) return NextResponse.json({ message: "Catégorie non trouvée." }, { status: 404 });

        const customer = await prisma.customer.findUnique({ where: { id: customerId }});
        if (!customer) return NextResponse.json({ message: "Client non trouvé." }, { status: 404 });
  
        const stats = await prisma.statsItemCategorieCustomer.findUnique({
            where: { customerId_itemCategorieId: { customerId, itemCategorieId } },
        });

        if (!stats) return NextResponse.json({ message: "Statistiques non trouvées." }, { status: 404 });
  
        return NextResponse.json(stats, { status: 200 });
    } catch (error) {
        return NextResponse.json({ message: "Erreur serveur" }, { status: 500 });
    }
}