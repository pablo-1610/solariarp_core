ITEM_ACTIONS = {
    [ITEM_LIST.BREAD] = function()
        return {
            weight = 0.05,
            category = ITEMS_CAT.FOOD,
            args = {target = "hunger"},
            use = ITEMS_CAT_USE[category](args)
        }
    end
}