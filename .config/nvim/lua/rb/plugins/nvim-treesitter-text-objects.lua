return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local swap = require("nvim-treesitter-textobjects.swap")
    local move = require("nvim-treesitter-textobjects.move")
    local repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    local map = vim.keymap.set

    local function sel(query, group)
      return function()
        select.select_textobject(query, group or "textobjects")
      end
    end

    -- Assignment
    map({ "x", "o" }, "a=", sel("@assignment.outer"), { desc = "Outer assignment" })
    map({ "x", "o" }, "i=", sel("@assignment.inner"), { desc = "Inner assignment" })
    map({ "x", "o" }, "l=", sel("@assignment.lhs"), { desc = "Assignment LHS" })
    map({ "x", "o" }, "r=", sel("@assignment.rhs"), { desc = "Assignment RHS" })

    -- Property
    map({ "x", "o" }, "a:", sel("@property.outer"), { desc = "Outer property" })
    map({ "x", "o" }, "i:", sel("@property.inner"), { desc = "Inner property" })
    map({ "x", "o" }, "l:", sel("@property.lhs"), { desc = "Property LHS" })
    map({ "x", "o" }, "r:", sel("@property.rhs"), { desc = "Property RHS" })

    -- Parameter
    map({ "x", "o" }, "aa", sel("@parameter.outer"), { desc = "Outer parameter" })
    map({ "x", "o" }, "ia", sel("@parameter.inner"), { desc = "Inner parameter" })

    -- Conditional
    map({ "x", "o" }, "ai", sel("@conditional.outer"), { desc = "Outer conditional" })
    map({ "x", "o" }, "ii", sel("@conditional.inner"), { desc = "Inner conditional" })

    -- Loop
    map({ "x", "o" }, "al", sel("@loop.outer"), { desc = "Outer loop" })
    map({ "x", "o" }, "il", sel("@loop.inner"), { desc = "Inner loop" })

    -- Call
    map({ "x", "o" }, "af", sel("@call.outer"), { desc = "Outer call" })
    map({ "x", "o" }, "if", sel("@call.inner"), { desc = "Inner call" })

    -- Function
    map({ "x", "o" }, "am", sel("@function.outer"), { desc = "Outer function" })
    map({ "x", "o" }, "im", sel("@function.inner"), { desc = "Inner function" })

    -- Class
    map({ "x", "o" }, "ac", sel("@class.outer"), { desc = "Outer class" })
    map({ "x", "o" }, "ic", sel("@class.inner"), { desc = "Inner class" })

    -- Swap
    map("n", "<leader>na", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap parameter with next" })
    map("n", "<leader>n:", function()
      swap.swap_next("@property.outer")
    end, { desc = "Swap property with next" })
    map("n", "<leader>nm", function()
      swap.swap_next("@function.outer")
    end, { desc = "Swap function with next" })
    map("n", "<leader>pa", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap parameter with prev" })
    map("n", "<leader>p:", function()
      swap.swap_previous("@property.outer")
    end, { desc = "Swap property with prev" })
    map("n", "<leader>pm", function()
      swap.swap_previous("@function.outer")
    end, { desc = "Swap function with prev" })

    -- Move helpers
    local function gns(q, g)
      return function()
        move.goto_next_start(q, g or "textobjects")
      end
    end
    local function gne(q, g)
      return function()
        move.goto_next_end(q, g or "textobjects")
      end
    end
    local function gps(q, g)
      return function()
        move.goto_previous_start(q, g or "textobjects")
      end
    end
    local function gpe(q, g)
      return function()
        move.goto_previous_end(q, g or "textobjects")
      end
    end

    -- Move: next start
    map({ "n", "x", "o" }, "]f", gns("@call.outer"), { desc = "Next call start" })
    map({ "n", "x", "o" }, "]m", gns("@function.outer"), { desc = "Next function start" })
    map({ "n", "x", "o" }, "]c", gns("@class.outer"), { desc = "Next class start" })
    map({ "n", "x", "o" }, "]i", gns("@conditional.outer"), { desc = "Next conditional start" })
    map({ "n", "x", "o" }, "]l", gns("@loop.outer"), { desc = "Next loop start" })
    map({ "n", "x", "o" }, "]s", gns("@local.scope", "locals"), { desc = "Next scope" })
    map({ "n", "x", "o" }, "]z", gns("@fold", "folds"), { desc = "Next fold" })

    -- Move: next end
    map({ "n", "x", "o" }, "]F", gne("@call.outer"), { desc = "Next call end" })
    map({ "n", "x", "o" }, "]M", gne("@function.outer"), { desc = "Next function end" })
    map({ "n", "x", "o" }, "]C", gne("@class.outer"), { desc = "Next class end" })
    map({ "n", "x", "o" }, "]I", gne("@conditional.outer"), { desc = "Next conditional end" })
    map({ "n", "x", "o" }, "]L", gne("@loop.outer"), { desc = "Next loop end" })

    -- Move: prev start
    map({ "n", "x", "o" }, "[f", gps("@call.outer"), { desc = "Prev call start" })
    map({ "n", "x", "o" }, "[m", gps("@function.outer"), { desc = "Prev function start" })
    map({ "n", "x", "o" }, "[c", gps("@class.outer"), { desc = "Prev class start" })
    map({ "n", "x", "o" }, "[i", gps("@conditional.outer"), { desc = "Prev conditional start" })
    map({ "n", "x", "o" }, "[l", gps("@loop.outer"), { desc = "Prev loop start" })

    -- Move: prev end
    map({ "n", "x", "o" }, "[F", gpe("@call.outer"), { desc = "Prev call end" })
    map({ "n", "x", "o" }, "[M", gpe("@function.outer"), { desc = "Prev function end" })
    map({ "n", "x", "o" }, "[C", gpe("@class.outer"), { desc = "Prev class end" })
    map({ "n", "x", "o" }, "[I", gpe("@conditional.outer"), { desc = "Prev conditional end" })
    map({ "n", "x", "o" }, "[L", gpe("@loop.outer"), { desc = "Prev loop end" })

    -- Repeatable
    map({ "n", "x", "o" }, ";", repeat_move.repeat_last_move)
    map({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite)
    map({ "n", "x", "o" }, "f", repeat_move.builtin_f_expr, { expr = true })
    map({ "n", "x", "o" }, "F", repeat_move.builtin_F_expr, { expr = true })
    map({ "n", "x", "o" }, "t", repeat_move.builtin_t_expr, { expr = true })
    map({ "n", "x", "o" }, "T", repeat_move.builtin_T_expr, { expr = true })
  end,
}
