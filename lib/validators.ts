export function validateCategoryInput(name: string, state: number | undefined) {
    if (typeof name !== "string" || !name.trim()) {
        return { valid: false, message: "Le nom est requis et doit être une chaîne de caractères valide." };
    }
    if (name.length < 3 || name.length > 50) {
        return { valid: false, message: "Le nom doit contenir entre 3 et 50 caractères." };
    }
    if (state !== undefined && (typeof state !== "number" || ![0, 1, 2].includes(state))) {
        return { valid: false, message: "Le state doit être un nombre (0, 1 ou 2)." };
    }
    return { valid: true };
}
  