--- @module Resources
Resources = { }

Resources.__name__ = '__ScanningRadar__'
Resources.graphics_dir = Resources.__name__ .. '/graphics/'

Resources.graphics_item_types =
{
    ItemIcon = 'icon-item',
    TechIcon = 'icon-tech',
    Sprite = 'sprite',
    HDSprite = 'sprite-hr',
}

function Resources.get_graphics_item(item_type, item_id)
    return Resources.graphics_dir .. item_type .. '_' .. item_id .. '.png'
end

return Resources
