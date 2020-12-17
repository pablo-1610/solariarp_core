ITEM_ACTIONS = {
    [ITEM_LIST.BREAD] = {
        display = "Pain",
        description = "Quoi de mieux qu'un vieux bout de pain bien sec ?",
        weight = 0.25,
        category = ITEMS_CAT.FOOD,
        args = {target = "hunger"},
        use = ITEMS_CAT_USE[category]
    },

    [ITEM_LIST.WATER] = {
        display = "Bouteille d'eau",
        description = "Envie de boire quelque chose ? Comme l'a dit JCVD, dans 20/30 ans y'en aura pu'!",
        weight = 0.35,
        category = ITEMS_CAT.FOOD,
        args = {target = "thirst"},
        use = ITEMS_CAT_USE[category]
    }

}



