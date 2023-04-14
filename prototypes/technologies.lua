local tech =
{
    type = 'technology',
    name = Names.prototypes.tech,
    icon_size = 128,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.TechIcon, Names.prototypes.radar),
    prerequisites = { 'electric-engine', 'advanced-electronics-2' },
    effects =
    {
        {
            type = 'unlock-recipe',
            recipe = Names.prototypes.radar
        }
    },
    unit =
    {
        count = 50,
        ingredients =
        {
            { 'automation-science-pack', 1 },
            { 'logistic-science-pack', 1 },
            { 'chemical-science-pack', 1 },
            { 'military-science-pack', 1 },
        },
        time = 30
    },
    order = 'i-h'
}

data:extend({ tech })
