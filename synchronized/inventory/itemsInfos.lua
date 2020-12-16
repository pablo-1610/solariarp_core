ITEM_ACTIONS = {
    [ITEM_LIST.BREAD] = {
        display = "Pain",
        weight = 0.25,
        category = ITEMS_CAT.FOOD,
        args = {target = "hunger"},
        use = ITEMS_CAT_USE[category]
    },

    [ITEM_LIST.WATER] = {
        display = "Bouteille d'eau",
        weight = 0.35,
        category = ITEMS_CAT.FOOD,
        args = {target = "thirst"},
        use = ITEMS_CAT_USE[category]
    }
}

