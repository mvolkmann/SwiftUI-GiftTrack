// TODO: How can you replace these 3 functions with one?
func name(_ gift: GiftEntity?) -> String {
    gift?.name ?? "unknown"
}

func name(_ occasion: OccasionEntity?) -> String {
    occasion?.name ?? "unknown"
}

func name(_ person: PersonEntity?) -> String {
    person?.name ?? "unknown"
}
