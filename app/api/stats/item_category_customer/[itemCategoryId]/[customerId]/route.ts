import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function GET(
    req: Request,
    { params }: { params: { customerId: string; itemCategoryId: string } }
) {
    try {
        const { customerId, itemCategoryId } = await params;
        if (!customerId || !itemCategoryId) {
            return NextResponse.json({ message: "IDs requis." }, { status: 400 });
        }

        const itemCategory = await prisma.itemCategory.findUnique({ where: { id: itemCategoryId } });
        if (!itemCategory) return NextResponse.json({ message: "Catégorie non trouvée." }, { status: 404 });

        const customer = await prisma.customer.findUnique({ where: { id: customerId }});
        if (!customer) return NextResponse.json({ message: "Client non trouvé." }, { status: 404 });
  
        const stats = await prisma.statsItemCategoryCustomer.findUnique({
            where: { customerId_itemCategoryId: { customerId, itemCategoryId } },
        });

        if (!stats) return NextResponse.json({ message: "Statistiques non trouvées." }, { status: 404 });
  
        return NextResponse.json(stats, { status: 200 });
    } catch (error) {
        return NextResponse.json({ message: "Erreur serveur" }, { status: 500 });
    }
}