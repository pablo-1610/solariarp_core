ITEM_ACTIONS = {
    [ITEM_LIST.BREAD] = {
        weight = 0.6,
        category = ITEMS_CAT.FOOD,
        args = {target = "hunger"},
        use = function()
            Fox.trace("USED")
        end
    }
}

