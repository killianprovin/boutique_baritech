import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function GET(
    req: Request,
    { params }: { params: { customerId: string; itemCategoryId: string } }
) {
    try {
        const { customerId } = await params;
        if (!customerId) {
            return NextResponse.json({ message: "ID requis." }, { status: 400 });
        }

        const customer = await prisma.customer.findUnique({ where: { id: customerId }});
        if (!customer) return NextResponse.json({ message: "Client non trouvé." }, { status: 404 });
  
        const stats = await prisma.statsItemCategoryCustomer.findMany({
            where: { customerId },
        });

        if (!stats) return NextResponse.json({ message: "Statistiques non trouvées." }, { status: 404 });
  
        return NextResponse.json(stats, { status: 200 });
    } catch (error) {
        return NextResponse.json({ message: "Erreur serveur" }, { status: 500 });
    }
}