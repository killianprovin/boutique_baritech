import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function GET() {
    try {
        const stats = await prisma.statsItemCategorieCustomer.findMany();
        return NextResponse.json(stats, { status: 200 });
    } catch (error) {
        return NextResponse.json({ message: "Erreur serveur" }, { status: 500 });
    }
}