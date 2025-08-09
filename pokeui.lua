--Config UI
local restart_toggles_left = { 
                 {ref_value = "pokeballs", label = "poke_settings_pokeballs"},
                 {ref_value = "pokemon_altart", label = "poke_settings_pokemon_altart"},
                 {ref_value = "pokemon_aprilfools", label = "poke_settings_pokemon_aprilfools"},
                 {ref_value = "poke_enable_animations", label = "poke_settings_enable_animations"}
                }
                
local restart_toggles_right = { 
  {ref_value = "pokemon_splash", label = "poke_settings_pokemon_splash"}, 
  {ref_value = "pokemon_discovery", label = "poke_settings_pokemon_discovery", tooltip = {set = 'Other', key = 'discovery_tooltip'}},
  {ref_value = "pokemon_legacy", label = "poke_settings_pokemon_legacy"}
}

local no_restart_toggles = {{ref_value = "pokemon_only", label = "poke_settings_pokemon_only"}, {ref_value = "shiny_playing_cards", label = "poke_settings_shiny_playing_cards"},
                          {ref_value = "gen_oneb", label = "poke_settings_pokemon_gen_one"}, }
 
local energy_toggles = {
  {ref_value = "unlimited_energy", label = "poke_settings_unlimited_energy", tooltip = {set = 'Other', key = 'unlimited_energy_tooltip'}}, 
  {ref_value = "precise_energy", label = "poke_settings_pokemon_precise_energy", tooltip = {set = 'Other', key = 'precise_energy_tooltip'}},
}

local joker_pool_toggles = {
  {ref_value = "pokemon_only", label = "poke_settings_pokemon_only", tooltip = {set = 'Other', key = 'pokemononly_tooltip'}},
  {ref_value = "gen_oneb", label = "poke_settings_pokemon_gen_one", tooltip = {set = 'Other', key = 'gen1_tooltip'}},
  {ref_value = "gen_two", label = "poke_settings_pokemon_gen_two", tooltip = {set = 'Other', key = 'gen2_tooltip'}},
  {ref_value = "gen_three", label = "poke_settings_pokemon_gen_three", tooltip = {set = 'Other', key = 'gen3_tooltip'}},
  {ref_value = "gen_four", label = "poke_settings_pokemon_gen_four", tooltip = {set = 'Other', key = 'gen4_tooltip'}},
  {ref_value = "gen_five", label = "poke_settings_pokemon_gen_five", tooltip = {set = 'Other', key = 'gen5_tooltip'}},
  {ref_value = "gen_six", label = "poke_settings_pokemon_gen_six", tooltip = {set = 'Other', key = 'gen6_tooltip'}},
  {ref_value = "gen_seven", label = "poke_settings_pokemon_gen_seven", tooltip = {set = 'Other', key = 'gen7_tooltip'}},
  {ref_value = "gen_eight", label = "poke_settings_pokemon_gen_eight", tooltip = {set = 'Other', key = 'gen8_tooltip'}},
  {ref_value = "gen_nine", label = "poke_settings_pokemon_gen_nine", tooltip = {set = 'Other', key = 'gen9_tooltip'}},
  {ref_value = "hazards_on", label = "poke_settings_pokemon_hazards_on", tooltip = {set = 'Other', key = 'hazards_on_tooltip'}},
}

local misc_no_restart_toggles = {
  {ref_value = "shiny_playing_cards", label = "poke_settings_shiny_playing_cards", tooltip = {set = 'Other', key = 'shinyplayingcard_tooltip'}},
  {ref_value = "detailed_tooltips", label = "poke_settings_pokemon_detailed_tooltips", tooltip = {set = 'Other', key = 'detailed_tooltips_tooltip'}}
}

local content_toggles = {
  {ref_value = "pokemon_legacy", label = "poke_settings_pokemon_legacy", tooltip = {set = 'Other', key = 'legacycontent_tooltip'}},
  {ref_value = "pokemon_aprilfools", label = "poke_settings_pokemon_aprilfools", tooltip = {set = 'Other', key = 'jokecontent_tooltip'}},
}

local visual_toggles = {
  {ref_value = "pokemon_splash", label = "poke_settings_pokemon_splash", tooltip = {set = 'Other', key = 'splashcard_tooltip'}},
  {ref_value = "pokemon_title", label = "poke_settings_pokemon_title", tooltip = {set = 'Other', key = 'title_tooltip'}},
  {ref_value = "pokemon_altart", label = "poke_settings_pokemon_altart", tooltip = {set = 'Other', key = 'altart_tooltip'}},
  {ref_value = "poke_enable_animations", label = "poke_settings_enable_animations", tooltip = {set = 'Other', key = 'animation_tooltip'}}
}

local misc_restart_toggles = {
  {ref_value = "pokeballs", label = "poke_settings_pokeballs", tooltip = {set = 'Other', key = 'allowpokeballs_tooltip'}},
  {ref_value = "pokemon_discovery", label = "poke_settings_pokemon_discovery", tooltip = {set = 'Other', key = 'discovery_tooltip'}},
}

-- Character set for Base64 encoding.
local b64_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

--- Encodes the pokemon config table into a compact string.
-- @param config_table table The pokermon_config.allowed_pokemon table.
-- @param all_pokemon_keys table A sorted list of all possible pokemon joker keys.
-- @return string The compressed configuration string.
function encode_pokemon_config(config_table, all_pokemon_keys)
    local bit_string = ''
    for _, key in ipairs(all_pokemon_keys) do
        if config_table[key] then
            bit_string = bit_string .. '1'
        else
            bit_string = bit_string .. '0'
        end
    end

    local encoded = ''
    for i = 1, #bit_string, 6 do
        local chunk = bit_string:sub(i, i + 5)
        -- Pad the last chunk with zeros if it's less than 6 bits
        while #chunk < 6 do
            chunk = chunk .. '0'
        end
        local value = tonumber(chunk, 2)
        encoded = encoded .. b64_chars:sub(value + 1, value + 1)
    end
    return encoded
end

function decode_pokemon_config(encoded_string, all_pokemon_keys)
    local b64_map = {}
    for i = 1, #b64_chars do
        b64_map[b64_chars:sub(i, i)] = i - 1
    end

    local bit_string = ''
    for i = 1, #encoded_string do
        local char = encoded_string:sub(i, i)
        local value = b64_map[char]
        if value then
            local binary = string.format("%06s", dec_to_bin(value)):gsub(' ', '0')
            bit_string = bit_string .. binary
        end
    end

    local decoded_table = {}
    for i = 1, #all_pokemon_keys do
        local key = all_pokemon_keys[i]
        local bit = bit_string:sub(i, i)
        if bit == '1' then
            decoded_table[key] = true
        else
            decoded_table[key] = false
        end
    end
    return decoded_table
end

-- Helper function to convert decimal to binary string
function dec_to_bin(n)
    local bin = ''
    if n == 0 then return '0' end
    while n > 0 do
        bin = (n % 2) .. bin
        n = math.floor(n / 2)
    end
    return bin
end

local create_menu_toggles = function (parent, toggles)
  for k, v in ipairs(toggles) do
    parent.nodes[#parent.nodes + 1] = create_toggle({
          label = localize(v.label),
          ref_table = pokermon_config,
          ref_value = v.ref_value,
          callback = function(_set_toggle)
            NFS.write(mod_dir.."/config.lua", STR_PACK(pokermon_config))
          end,
    })
    if v.tooltip then
      parent.nodes[#parent.nodes].config.detailed_tooltip = v.tooltip
    end
  end
end

-- somewhere in your mod init, before any centers get registered:
local jokerProtos = {}

-- grab the metatable so we can wrap the __call metamethod
local mt = getmetatable(SMODS.Joker)

-- backup the original __call
local orig_call = mt.__call

-- override it to capture each new proto
mt.__call = function(self, tbl)
  local proto = orig_call(self, tbl)   -- actually register the prototype
  table.insert(jokerProtos, proto)     -- stash it for later
  return proto
end


--- Creates a UI definition for a grid of cards.
-- @param card_ids table An array of card ID strings (e.g., {'j_joker', 'c_ace'}).
-- @param width number The total width available for the grid.
-- @param height number The total height available for the grid.
-- @return table A UI definition that can be used within a UIBox's `nodes`.
local function create_card_grid_definition(card_ids, width, height, page, cards_per_page)
    print ("in!")
    local ret = {}

    if not card_ids or #card_ids == 0 then
        return ret
    end

    -- Slice the card_ids table to get only the cards for the current page
    local page_card_ids = {}
    local start_index = (page - 1) * cards_per_page + 1
    local end_index = math.min(start_index + cards_per_page - 1, #card_ids)

    if start_index > #card_ids then return {} end

    for i = start_index, end_index do
        table.insert(page_card_ids, card_ids[i])
    end

    -- 1. Calculate how many rows are needed for a balanced grid
    local card_rows = {}
    local n_rows = math.max(1, 1 + math.floor(#page_card_ids / 10) - math.floor(math.log(6, #page_card_ids)))
    local max_width = 1 -- Track the row with the most cards

    print ("done 1")
    -- 2. Distribute card IDs into the calculated rows
    for k, v in ipairs(page_card_ids) do
        local _row = math.ceil(n_rows * (k / #page_card_ids))
        card_rows[_row] = card_rows[_row] or {}
        table.insert(card_rows[_row], v)
        if #card_rows[_row] > max_width then max_width = #card_rows[_row] end
    end
    print ("done 2")
    -- 3. Calculate the size of each card to fit them all in the view
    local card_size = math.max(0.3, 0.8 - 0.01 * (max_width * n_rows))
    print ("done 3")
    -- 4. Create the UI nodes for each row
    for _, card_row in ipairs(card_rows) do
        -- This is the main container for one row of cards
        local row_container = {
            n = G.UIT.R, -- Horizontal container for the cards in this row
            config = {
                align = 'cm',
                padding = 0.1
            },
            nodes = {}
        }

        -- Create each card and its toggle, then add them to the row container
        for _, card_id in ipairs(card_row) do
            -- G.P_CENTERS[card_id] retrieves the card's definition (artwork, etc.)
            local card = Card(0, 0, G.CARD_W * card_size, G.CARD_H * card_size, nil, G.P_CENTERS[card_id],
                { bypass_discovery_center = true, bypass_discovery_ui = true })
            
            -- Create a vertical container for a single card and its toggle
            local card_and_toggle_node = {
              n = G.UIT.C, 
              config = { align = 'cm', padding = 0.1, scale = card_size },
              nodes = {
                {
                  n = G.UIT.R,
                  config = { padding = 0, align = 'cm' },
                  nodes = {
                      -- Node for the card object
                      { n = G.UIT.O, config = { object = card } },
                  }
                },
                {
                  n = G.UIT.R,
                  config = { padding = 0, align = 'cm' },
                  nodes = {
                    create_toggle({
                        label = 'Enabled',
                        ref_table = pokermon_config.allowed_pokemon,
                        ref_value = card_id,
                        -- invert_toggle = true, -- So checked means 'not banned' (false)
                        w = G.CARD_W * card_size, -- Match the card's width
                        h = G.CARD_H * card_size * 0.2, -- Set a proportional height
                        scale = 0.8, -- Adjust scale of the toggle
                        callback = function()
                            NFS.write(mod_dir.."/config.lua", STR_PACK(pokermon_config))
                        end
                    })
                  }
                }
              }
            }
            -- Add the card+toggle group to the current row
            table.insert(row_container.nodes, card_and_toggle_node)
        end
        print ("done 4")
        -- 5. Add the completed row container to the final result
        table.insert(ret, row_container)
        print ("done 5")
    end

    return ret
end


local pokedex_page_state = {
    current_page = 1,
    current_gen = "1"
}


function create_banned_pokemon_page()
    local card_ids = {}
    -- Initialize the banned list if it doesn't exist
    pokermon_config.allowed_pokemon = pokermon_config.allowed_pokemon or {}

    -- Populate card_ids with the keys from the banned_pokemon table
    for _, proto in ipairs(jokerProtos) do
      -- Add card in key:value format of <gen>:<card_id>
      local card_id = proto.key
      if pokermon_config.allowed_pokemon[card_id] == nil then
        pokermon_config.allowed_pokemon[card_id] = true
      end
      -- Check if gen is specified
      if proto.gen then
        if card_ids[tostring(proto.gen)] == nil then
          card_ids[tostring(proto.gen)] = {}
        end
        table.insert(card_ids[tostring(proto.gen)], card_id)
      else
        if not card_ids["misc"] then
          card_ids["misc"] = {}
        end
        table.insert(card_ids["misc"], card_id)
      end
    end
    local generations = {}
    for gen, _ in pairs(card_ids) do
        table.insert(generations, gen)
    end
    table.sort(generations)
    -- Ensure the current_gen is valid, otherwise set a default
    if not card_ids[pokedex_page_state.current_gen] then
        pokedex_page_state.current_gen = "1"
    end
    
    -- Get the list of cards for the currently selected generation
    local current_gen_card_ids = card_ids[pokedex_page_state.current_gen] or {}
    -- Print the current generation and its card IDs for debugging
    -- print("Current Generation: " .. pokedex_page_state.current_gen)
    -- print("Cards in current generation: " .. #current_gen_card_ids)
    -- for _, card_id in ipairs(current_gen_card_ids) do
    --     print("Card ID: " .. card_id)
    -- end
    -- Create the tab buttons
    local tabs_container = {
        n = G.UIT.R, -- Horizontal container for tabs
        config = { align = 'cm', padding = 0.1 },
        nodes = {}
    }

    local gen_map = {
      ["1"] = "one", ["2"] = "two", ["3"] = "three", ["4"] = "four",
      ["5"] = "five", ["6"] = "six", ["7"] = "seven", ["8"] = "eight",
      ["9"] = "nine", ["10"] = "ten", ["misc"] = "misc"
    }

    for _, gen_name in ipairs(generations) do
      local is_active_tab = (tostring(gen_name) == tostring(pokedex_page_state.current_gen))
      local colour = G.C.UI.Button_unselected
      if is_active_tab then
        colour = HEX("FF7ABF") -- Highlight active tab
        print ("Active tab: " .. gen_name)
      end
      local button_func_name = "pokermon_select_gen_tab_" .. (gen_map[tostring(gen_name)] or "misc")
      print (button_func_name)
      table.insert(tabs_container.nodes, {
      n = G.UIT.C,
      config = { align = 'cm', padding = 0.1 },
      nodes = {
        UIBox_button({
        minw = 1,
        scale = 0.75,
        button = button_func_name,
        label = gen_name == "misc" and {"MISC"} or {"Gen " .. gen_name},
        colour = colour, -- Highlight active tab
        one_press = true
        })
      }
      })
    end

    -- Pagination logic based on the selected generation's cards
    local cards_per_page = 12 -- Or any number you prefer
    local total_pages = math.ceil(#current_gen_card_ids / cards_per_page)
    total_pages = math.max(1, total_pages) -- Ensure total_pages is at least 1

    -- Reset page if it's out of bounds (e.g., filters changed the total number of cards)
    if pokedex_page_state.current_page > total_pages then
        pokedex_page_state.current_page = 1
    end

    local card_grid_nodes = create_card_grid_definition(current_gen_card_ids, 10, 4, pokedex_page_state.current_page, cards_per_page)

    -- return {}
    local cards_per_page = 12 -- Or any number you prefer
    local total_pages = math.ceil(#current_gen_card_ids / cards_per_page)

    -- Reset page if it's out of bounds (e.g., filters changed the total number of cards)
    if pokedex_page_state.current_page > total_pages then
        pokedex_page_state.current_page = 1
    end

    local page_buttons = {
      n = G.UIT.R,
      config = { align = 'cm', padding = 0 },
      nodes = {}
    }

    -- Previous Page Button
    if pokedex_page_state.current_page > 1 then
      table.insert(page_buttons.nodes, {
        n = G.UIT.C,
        config = { align = 'cm', padding = 0.1, scale = 1 },
        nodes = {
          UIBox_button({
            minw = 1,
            button = "pokermon_cycle_page_back",
            label = {"< Previous"},
            colour = HEX("FF7ABF")
          }),
        }
      })
    else
      -- Placeholder to keep alignment
      table.insert(page_buttons.nodes, { n = G.UIT.C, config = { minw = 1.2 }})
    end

    -- Page Indicator
    table.insert(page_buttons.nodes, {
      n = G.UIT.C,
      config = { align = 'cm', padding = 0.1, scale = 1 },
      nodes = {
        {
          n = G.UIT.T,
          config = {
            text = "Page " .. pokedex_page_state.current_page .. " / " .. total_pages,
            scale = 0.5,
            w = 3,
            align = 'cm'
          }
        }
      }
    })

    -- Next Page Button
    if pokedex_page_state.current_page < total_pages then
      table.insert(page_buttons.nodes, {
        n = G.UIT.C,
        config = { align = 'cm', padding = 0.1, scale = 1 },
        nodes = {
          UIBox_button({
            minw = 1,
            button = "pokermon_cycle_page_front",
            label = {"Next >"},
            colour = HEX("FF7ABF")
          }),
        }
      })
    else
      -- Placeholder to keep alignment
      table.insert(page_buttons.nodes, { n = G.UIT.C, config = { minw = 1.2 }})
    end


    -- Spacer
    table.insert(page_buttons.nodes, { n = G.UIT.C, config = { minw = 1 }}) -- Spacer

    -- Save Button in order to save the current state of allowed_pokemon
    table.insert(page_buttons.nodes, {
      n = G.UIT.C,
      config = { align = 'cm', scale = 1 },
      nodes = {
        UIBox_button({
          minw = 1.5,
          minh = 1,
          button = "pokermon_copy_banned_pokemon",
          label = {"Copy"},
          colour = HEX("4FE000"),
          one_press = true,
        })
      }
    })
    -- Paste Button in order to paste the current state of allowed_pokemon
    table.insert(page_buttons.nodes, {
      n = G.UIT.C,
      config = { align = 'cm', padding = 0.1, scale = 1 },
      nodes = {
        UIBox_button({
          minw = 1.5,
          minh = 1,
          button = "pokermon_paste_banned_pokemon",
          label = {"Paste"},
          colour = HEX("4FE000"),
          one_press = true,
        })
      }
    })

    -- Reset Button
    -- This resets all jokers to allowed_pokemon
    table.insert(page_buttons.nodes, {
      n = G.UIT.C,
      config = { align = 'cm', padding = 0.1, scale = 1 },
      nodes = {
        UIBox_button({
          minw = 1.5,
          button = "pokermon_reset_banned_pokemon",
          label = {"Reset"},
          colour = HEX("c135ff"),
        })
      }
    })

    -- Create the card grid definition using the card_ids
    local ret = 
      {
          n = G.UIT.C,
          config = { 
            minw = 10.8, 
            minh = 4.8, 
            colour = HEX("38b8f8"), 
            alpha = 0.8,
            outline = 1,
            outline_colour = HEX("FFFFFF"),
            r = 0.4,
          },
          nodes = {
            tabs_container,
            {
                n = G.UIT.R,
                config = { minw = 10.8, minh = 4.2 },
                nodes = card_grid_nodes -- Use the generated nodes here
            },
              page_buttons
          }
      }

      local t = create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',contents = {ret}})
      return t
end


pokemonconfig = function()
  local restart_left_settings = {n = G.UIT.C, config = {align = "tl", padding = 0.05, scale = 0.75, colour = G.C.CLEAR,}, nodes = {}}
  create_menu_toggles(restart_left_settings, restart_toggles_left)

  local restart_right_settings = {n = G.UIT.C, config = {align = "tl", padding = 0.05, scale = 0.75, colour = G.C.CLEAR,}, nodes = {}}
  create_menu_toggles(restart_right_settings, restart_toggles_right)

  local no_restart_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR,}, nodes = {}}
  create_menu_toggles(no_restart_settings, no_restart_toggles)
  
  print("Creating config nodes for Pokermon")
  
  local config_nodes =   
  {
    {
      n = G.UIT.R,
      config = {
        padding = 0.25,
        align = "cm"
      },
      nodes = {
        {
          n = G.UIT.T,
          config = {
            text = localize("poke_settings_header_norequired"),
            shadow = true,
            scale = 0.75 * 0.8,
            colour = HEX("ED533A")
          }
        }
      },
    },
    UIBox_button({
      minw = 3.85,
      colour = HEX("ED533A"),
      button = "pokermon_joker_pool",
      label = {"Joker Pool Options"}
    }),
    UIBox_button({
      minw = 3.85,
      colour = HEX("38b8f8"),
      button = "pokermon_specific_joker_pool",
      label = {"Specific Joker Pool Options"}
    }),
    UIBox_button({
      minw = 3.85,
      colour = HEX("FF7ABF"),
      button = "pokermon_energy",
      label = {"Energy Options"}
    }),
    UIBox_button({
      minw = 3.85,
      colour = HEX("9AA4B7"),
      button = "pokermon_misc_no_restart",
      label = {"Misc Options"}
    }),
    {
      n = G.UIT.R,
      config = {
        padding = 0.25,
        align = "cm"
      },
      nodes = {
        {
          n = G.UIT.T,
          config = {
            text = localize("poke_settings_header_required"),
            shadow = true,
            scale = 0.75 * 0.8,
            colour = HEX("ED533A")
          }
        }
      },
    },
    UIBox_button({
      minw = 3.85,
      colour = HEX("38b8f8"),
      button = "pokermon_content",
      label = {"Content Options"}
    }),
    UIBox_button({
      minw = 3.85,
      colour = HEX("c135ff"),
      button = "pokermon_visual",
      label = {"Visual Options"}
    }),
    UIBox_button({
      minw = 3.85,
      colour = HEX("9AA4B7"),
      button = "pokermon_misc_restart",
      label = {"Misc Options"}
    }),
  }
  return config_nodes
end


SMODS.current_mod.config_tab = function()
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = pokemonconfig()
    }
end

SMODS.current_mod.extra_tabs = function()
  local scale = 0.75
  return {
    label = localize("poke_credits_actualcredits"),
    tab_definition_function = function()
      return {
        n = G.UIT.ROOT,
        config = {
          align = "cm",
          padding = 0.05,
          colour = G.C.CLEAR,
        },
        nodes = {
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_thanks"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_lead"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "InertSteak",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_graphics"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "GayCoonie, Joey J. Jester, Larantula, The Kuro, Lemmanade",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            },
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_graphics"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "Yamper, MyDude, Numbuh 214, SMG9000, Sonfive, PrincessRoxie",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            },
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_graphics"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "Catzzadilla, bt, KatRoman",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            },
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_quality_assurance_main"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "Lemmanade, drspectred",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_sound"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "Dread",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_developer"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "SDM0, Jevonnissocoolman, Ishtech, Fem, MathIsFun_, Kek",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_designer"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "Xilande, Lemmanade, PrincessRoxie, Catzzadilla",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_localization"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "Rafael, PainKiller, FlamingRok, Mr. Onyx",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_localization"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "PIPIKAI, PanbimboGD, HuyCorn, IlPastaio",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_community_manager"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "Astra, Kaethela",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("poke_credits_special_thanks"),
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.UI.TEXT_LIGHT
                }
              },
              {
                n = G.UIT.T,
                config = {
                  text = "Marie|Tsunami, CBMX, ...and you!",
                  shadow = true,
                  scale = scale * 0.8,
                  colour = G.C.BLUE
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = 0.2,
              align = "cm",
            },
            nodes = {
              UIBox_button({
                minw = 3.85,
                button = "pokermon_github",
                label = {"Github"}
              }),
              UIBox_button({
                minw = 3.85,
                colour = HEX("9656ce"),
                button = "pokermon_discord",
                label = {"Discord"}
              })
            },
          },
        },
      }
    end
  }
end
function G.FUNCS.pokermon_github(e)
	love.system.openURL("https://github.com/InertSteak/Pokermon")
end
function G.FUNCS.pokermon_discord(e)
  love.system.openURL("https://discord.gg/AptX86Qsyz")
end
function G.FUNCS.pokermon_energy(e)
  local ttip = {set = 'Other', key = 'precise_energy_tooltip'}
  local energy_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
  create_menu_toggles(energy_settings, energy_toggles)
  
  local t = create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
      contents = {energy_settings}
  })
  G.FUNCS.overlay_menu{definition = t}
end
function G.FUNCS.pokermon_copy_banned_pokemon(e)
  -- Copy the current state of allowed_pokemon to the clipboard
  -- Encode allowed_pokemon as a string
  -- Steps: Sort pokermon_config.allowed_pokemon, then pack it using encode_pokemon_config

  -- local allowed_pokemon_str = encode_pokemon_config(pokermon_config.allowed_pokemon)
  local allowed_pokemon_str = STR_PACK(pokermon_config.allowed_pokemon)
  if G.F_LOCAL_CLIPBOARD then
		G.CLIPBOARD = allowed_pokemon_str
	else
		love.system.setClipboardText(allowed_pokemon_str)
	end
end

function G.FUNCS.pokermon_paste_banned_pokemon(e)
  -- Paste the allowed_pokemon from the clipboard
  local allowed_pokemon_str = G.F_LOCAL_CLIPBOARD and G.CLIPBOARD or love.system.getClipboardText()
  if allowed_pokemon_str then
    -- Decode the string back into a table
    local decoded_allowed_pokemon = STR_UNPACK(allowed_pokemon_str)
    pokermon_config.allowed_pokemon = decoded_allowed_pokemon
    NFS.write(mod_dir.."/config.lua", STR_PACK(pokermon_config))
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
  else
    print("No data in clipboard to paste")
  end
end

function G.FUNCS.pokermon_specific_joker_pool(e)
  local specific_joker_pool_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
  create_menu_toggles(specific_joker_pool_settings, joker_pool_toggles)
  

  G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end


function G.FUNCS.pokermon_select_gen_tab_one(e)
  print("Switching to Gen 1")
    -- Update the current generation
    pokedex_page_state.current_gen = "1"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_two(e)
  print("Switching to Gen 2")
    -- Update the current generation
    pokedex_page_state.current_gen = "2"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_three(e)
  print("Switching to Gen 3")
    -- Update the current generation
    pokedex_page_state.current_gen = "3"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_four(e)
    print("Switching to Gen 4")
    -- Update the current generation
    pokedex_page_state.current_gen = "4"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_five(e)
    print("Switching to Gen 5")
    -- Update the current generation
    pokedex_page_state.current_gen = "5"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_six(e)
    print("Switching to Gen 6")
    -- Update the current generation
    pokedex_page_state.current_gen = "6"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_seven(e)
    print("Switching to Gen 7")
    -- Update the current generation
    pokedex_page_state.current_gen = "7"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_eight(e)
    print("Switching to Gen 8")
    -- Update the current generation
    pokedex_page_state.current_gen = "8"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_nine(e)
    print("Switching to Gen 9")
    -- Update the current generation
    pokedex_page_state.current_gen = "9"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_ten(e)
    print("Switching to Gen 10")
    -- Update the current generation
    pokedex_page_state.current_gen = "10"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_select_gen_tab_misc(e)
    print("Switching to Misc")
    -- Update the current generation
    pokedex_page_state.current_gen = "misc"
    -- Reset to the first page when changing tabs
    pokedex_page_state.current_page = 1
    -- Refresh the UI
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end
function G.FUNCS.pokermon_reset_banned_pokemon(e)
    -- Reset the allowed_pokemon to an empty table
    for card_id in pairs(pokermon_config.allowed_pokemon) do
        pokermon_config.allowed_pokemon[card_id] = true -- Set all to true (not banned)
    end
    -- Write the updated config to the file
    NFS.write(mod_dir.."/config.lua", STR_PACK(pokermon_config))
    -- Refresh the UI to reflect the changes
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}
end

function G.FUNCS.pokermon_cycle_page_front(e)
    pokedex_page_state.current_page = pokedex_page_state.current_page + 1
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}    -- This re-runs the function that builds the config tab, thus refreshing the UI
end
function  G.FUNCS.pokermon_cycle_page_back(e)
    pokedex_page_state.current_page = pokedex_page_state.current_page - 1
    G.FUNCS.overlay_menu{definition = create_banned_pokemon_page()}    -- This re-runs the function that builds the config tab, thus refreshing the UI
end

function G.FUNCS.pokermon_joker_pool(e)
  local joker_pool_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
  create_menu_toggles(joker_pool_settings, joker_pool_toggles)
  
  local t = create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
      contents = {joker_pool_settings}
  })
  G.FUNCS.overlay_menu{definition = t}
end
function G.FUNCS.pokermon_misc_no_restart(e)
  local misc_no_restart_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
  create_menu_toggles(misc_no_restart_settings, misc_no_restart_toggles)
  
  local t = create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
      contents = {misc_no_restart_settings}
  })
  G.FUNCS.overlay_menu{definition = t}
end
function G.FUNCS.pokermon_content(e)
  local content_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
  create_menu_toggles(content_settings, content_toggles)
  
  local t = create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
      contents = {content_settings}
  })
  G.FUNCS.overlay_menu{definition = t}
end
function G.FUNCS.pokermon_visual(e)
  local visual_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
  create_menu_toggles(visual_settings, visual_toggles)
  
  local t = create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
      contents = {visual_settings}
  })
  G.FUNCS.overlay_menu{definition = t}
end
function G.FUNCS.pokermon_misc_restart(e)
  local misc_restart_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
  create_menu_toggles(misc_restart_settings, misc_restart_toggles)
  
  local t = create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
      contents = {misc_restart_settings}
  })
  G.FUNCS.overlay_menu{definition = t}
end

--Reserve Area for Pocket packs (adapted from betmma)
local G_UIDEF_use_and_sell_buttons_ref=G.UIDEF.use_and_sell_buttons
    function G.UIDEF.use_and_sell_buttons(card)
        if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
            if (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.label:find("Pocket")) or (G.GAME.poke_save_all and not SMODS.OPENED_BOOSTER.label:find("Wish")) or (card.ability.name == 'megastone') then
                return {
                    n=G.UIT.ROOT, config = {padding = -0.1,  colour = G.C.CLEAR}, nodes={
                      {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, minh = 0.7*card.T.h, maxw = 0.7*card.T.w - 0.15, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_use_consumeable'}, nodes={
                        {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                      }},
                      {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.1*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'Can Reserve', func = 'can_reserve_card'}, nodes={
                        {n=G.UIT.T, config={text = localize('b_save'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
                      }},
                      {n=G.UIT.R, config = {align = "bm", w=7.7*card.T.w}},
                      {n=G.UIT.R, config = {align = "bm", w=7.7*card.T.w}},
                      {n=G.UIT.R, config = {align = "bm", w=7.7*card.T.w}},
                      {n=G.UIT.R, config = {align = "bm", w=7.7*card.T.w}},
                      -- I can't explain it
                  }}
            end
        end
        return G_UIDEF_use_and_sell_buttons_ref(card)
    end
    G.FUNCS.can_reserve_card = function(e)
        if #G.consumeables.cards < G.consumeables.config.card_limit then 
            e.config.colour = G.ARGS.LOC_COLOURS.pink
            e.config.button = 'reserve_card' 
        else
          e.config.colour = G.C.UI.BACKGROUND_INACTIVE
          e.config.button = nil
        end
    end
    G.FUNCS.reserve_card = function(e) -- only works for consumeables
        local c1 = e.config.ref_table
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
              c1.area:remove_card(c1)
              c1:add_to_deck()
              if c1.children.price then c1.children.price:remove() end
              c1.children.price = nil
              if c1.children.buy_button then c1.children.buy_button:remove() end
              c1.children.buy_button = nil
              remove_nils(c1.children)
              G.consumeables:emplace(c1)
              G.GAME.pack_choices = G.GAME.pack_choices - 1
              if G.GAME.pack_choices <= 0 then
                G.FUNCS.end_consumeable(nil, delay_fac)
              end
              return true
            end
        }))
    end
    G.FUNCS.reserve_card_to_joker_slot = function(e) -- only works for consumeables
        local c1 = e.config.ref_table
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
              c1.area:remove_card(c1)
              c1:add_to_deck()
              if c1.children.price then c1.children.price:remove() end
              c1.children.price = nil
              if c1.children.buy_button then c1.children.buy_button:remove() end
              c1.children.buy_button = nil
              remove_nils(c1.children)
              G.jokers:emplace(c1)
              G.GAME.pack_choices = G.GAME.pack_choices - 1
              if G.GAME.pack_choices <= 0 then
                G.FUNCS.end_consumeable(nil, delay_fac)
              end
              return true
            end
        }))
    end

G.FUNCS.your_collection_pokemon_page = function(args)
  if not args or not args.cycle_config then return end
  for j = 1, #G.your_collection do
    for i = #G.your_collection[j].cards,1, -1 do
      local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
      c:remove()
      c = nil
    end
  end
  local row_start = 1 + (12 * (args.cycle_config.current_option - 1))
  for i = 1, 3 do
    for j = row_start, row_start + 3 do
      local akeys = args.cycle_config.keys
      local key = (type(akeys[j]) == "table" and akeys[j].key) or akeys[j]
      if not akeys[j] then break end
      local card = Card(G.your_collection[i].T.x + G.your_collection[i].T.w/2, G.your_collection[i].T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[key])
        if type(akeys[j]) == "table" then
          card.ability.extra.form = akeys[j].form
          G.P_CENTERS[key]:set_sprites(card)
        end
        G.your_collection[i]:emplace(card)
    end
    row_start = row_start + 4
  end
  INIT_COLLECTION_CARD_ALERTS()
end

poke_joker_page = 1

create_UIBox_pokedex_jokers = function(keys, previous_menu)
  local deck_tables = {}
  G.your_collection = {}
  if #keys > 4 and #keys < 13 then
    local rows = math.ceil(#keys/4)
    local marker = 1
    for i = 1, rows do
      G.your_collection[i] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      4*G.CARD_W,
      0.95*G.CARD_H, 
      {card_limit = 4, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[i]}}
    }}
  )
      local lastcard = math.min(marker + 3, #keys)
      for j = marker, lastcard do
        local key = (type(keys[j]) == "table" and keys[j].key) or keys[j]
        local card = Card(G.your_collection[i].T.x + G.your_collection[i].T.w/2, G.your_collection[i].T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[key])
        if type(keys[j]) == "table" then
          card.ability.extra.form = keys[j].form
          G.P_CENTERS[key]:set_sprites(card)
        end
        G.your_collection[i]:emplace(card)
      end
      marker = marker + 4
    end
  elseif #keys > 12 then
    local rows = 3
    local marker = 1
    for i = 1, rows do
      G.your_collection[i] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      4*G.CARD_W,
      0.95*G.CARD_H, 
      {card_limit = 4, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[i]}}
    }}
  )
      local lastcard = math.min(marker + 3, #keys)
      for j = marker, lastcard do
        local key = (type(keys[j]) == "table" and keys[j].key) or keys[j]
        local card = Card(G.your_collection[i].T.x + G.your_collection[i].T.w/2, G.your_collection[i].T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[key])
        if type(keys[j]) == "table" then
          card.ability.extra.form = keys[j].form
          G.P_CENTERS[key]:set_sprites(card)
        end
        G.your_collection[i]:emplace(card)
      end
      marker = marker + 4
    end
  else
    G.your_collection[1] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      math.min(4, #keys)*G.CARD_W,
      0.95*G.CARD_H, 
      {card_limit = #keys, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[1]}}
    }}
    )
    
    for i = 1, #keys do
      local key = (type(keys[i]) == "table" and keys[i].key) or keys[i]
      local card = Card(G.your_collection[1].T.x + G.your_collection[1].T.w/2, G.your_collection[1].T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[key])
      if type(keys[i]) == "table" then
        card.ability.extra.form = keys[i].form
        G.P_CENTERS[key]:set_sprites(card)
      end
      G.your_collection[1]:emplace(card)
    end
  end
  local t = nil
  if #keys <= 12 then
    t =  create_UIBox_generic_options({ back_func = previous_menu or 'exit_overlay_menu', contents = {
          {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
      }})
  else
    local joker_options = {}
    for i = 1, math.ceil(#keys/(4*#G.your_collection)) do
      table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#keys/(4*#G.your_collection))))
    end
    t =  create_UIBox_generic_options({ back_func = previous_menu or 'exit_overlay_menu', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = joker_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_pokemon_page', current_option = 1, keys = keys, colour = G.C.RED, no_pips = true, focus_args = {          snap_to = true, nav = 'wide'}})
        }}
    }})
  end
  return t
end

G.FUNCS.pokedexui = function(e)
  if G.STAGE == G.STAGES.RUN then
    if G.jokers and G.jokers.highlighted and G.jokers.highlighted[1] then
      local selected = G.jokers.highlighted[1]
      if selected.config.center.stage then
        G.FUNCS.overlay_menu{
          definition = create_UIBox_pokedex_jokers(get_family_keys(selected.config.center.name, selected.config.center.poke_custom_prefix, selected)),
        }
      end
    end
  end
end

G.FUNCS.pokedex_back = function()
  G.FUNCS.your_collection_jokers()
  G.FUNCS.SMODS_card_collection_page({cycle_config = {current_option = poke_joker_page}})
  local page = G.OVERLAY_MENU:get_UIE_by_ID('cycle_shoulders').children[1].children[1]
  page.config.ref_table.current_option = poke_joker_page
  page.config.ref_table.current_option_val = page.config.ref_table.options[poke_joker_page]
end

-- Functionality for Pokedex View
SMODS.Keybind({
    key = "openPokedex",
    key_pressed = "p",
    action = function(controller)
        G.FUNCS.pokedexui()
    end
})

local controller_queue_R_cursor_press_ref = Controller.queue_R_cursor_press
function Controller:queue_R_cursor_press(x, y)
    controller_queue_R_cursor_press_ref(self, x, y)
    local clicked = self.hovering.target or self.focused.target
    if clicked and type(clicked) == 'table' and clicked.config and type(clicked.config) == 'table' and clicked.config.center and clicked.facing ~= 'back' then
      if clicked.config.center.stage or clicked.config.center.poke_multi_item then
        local menu = G.SETTINGS.paused and 'pokedex_back' or nil
        if menu and G.OVERLAY_MENU:get_UIE_by_ID('cycle_shoulders') then poke_joker_page = G.OVERLAY_MENU:get_UIE_by_ID('cycle_shoulders').children[1].children[1].config.ref_table.current_option end
        if menu and clicked.config.center.poke_multi_item then menu = 'your_collection_consumables' end
        G.FUNCS.overlay_menu{
          definition = create_UIBox_pokedex_jokers(get_family_keys(clicked.config.center.name, clicked.config.center.poke_custom_prefix, clicked), menu),
        }
      end
    end
end

-- double click trigger
function G.FUNCS.check_double_click_trigger()
  -- 检查触发器是否被设置
  if G.double_clicked_card then
    local target_card = G.double_clicked_card

    -- 执行查看图鉴的逻辑
    if target_card and target_card.config.center and (target_card.config.center.stage or target_card.config.center.poke_multi_item) then
      local menu = G.SETTINGS.paused and 'pokedex_back' or nil
      if menu and G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('cycle_shoulders') then poke_joker_page = G.OVERLAY_MENU:get_UIE_by_ID('cycle_shoulders').children[1].children[1].config.ref_table.current_option end
      if menu and target_card.config.center.poke_multi_item then menu = 'your_collection_consumables' end

      G.FUNCS.overlay_menu{
        definition = create_UIBox_pokedex_jokers(get_family_keys(target_card.config.center.name, target_card.config.center.poke_custom_prefix, target_card), menu),
      }
    end

    -- 重要：执行后立即重置触发器，避免重复执行
    G.double_clicked_card = nil
  end
end

local poke_capture_focused_input = Controller.capture_focused_input
function Controller:capture_focused_input(button, input_type, dt)
  if self.focused then
    local clicked = self.focused.target
    if input_type == 'press' and button == 'rightstick' then
      if clicked and type(clicked) == 'table' and clicked.config and type(clicked.config) == 'table' and clicked.config.center and clicked.facing ~= 'back' then
        if clicked.config.center.stage or clicked.config.center.poke_multi_item then
          local menu = G.SETTINGS.paused and 'pokedex_back' or nil
          if menu and G.OVERLAY_MENU:get_UIE_by_ID('cycle_shoulders') then poke_joker_page = G.OVERLAY_MENU:get_UIE_by_ID('cycle_shoulders').children[1].children[1].config.ref_table.current_option end
          if menu and clicked.config.center.poke_multi_item then menu = 'your_collection_consumables' end
          G.SETTINGS.paused = true
          G.FUNCS.overlay_menu{
            definition = create_UIBox_pokedex_jokers(get_family_keys(clicked.config.center.name, clicked.config.center.poke_custom_prefix, clicked), menu),
          }
          self:update_focus()
        end
      end
    end
  end
  
  return poke_capture_focused_input(self, button, input_type, dt)
end