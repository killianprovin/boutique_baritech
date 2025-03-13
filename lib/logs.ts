import prisma from "@/lib/prisma";
import { Prisma } from "@prisma/client";

export async function createLog(
    action: string,
    entity: string,
    entityId: string | null,
    oldData: object | null,
    newData: object | null,
    userId: string | null = null
  ): Promise<void> {
    try {
      await prisma.log.create({
        data: {
            action,
            entity,
            entityId,
            oldData : oldData ? (oldData as Prisma.InputJsonValue) : Prisma.JsonNull,
            newData : newData ? (newData as Prisma.InputJsonValue) : Prisma.JsonNull,
            userId,
        },
      });
    } catch (error) {
      console.error("Erreur lors de la création du log:", error);
    }
}