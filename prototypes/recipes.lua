local radar = 
{
    type = 'recipe',
    name = Names.prototypes.radar,
    enabled = false,
    energy_required = 10,
    ingredients =
    {
        { 'processing-unit', 1 },
        { 'electric-engine-unit', 2 },
        { 'radar', 1 },
    },
    result = Names.prototypes.radar
}

data:extend({ radar } )
