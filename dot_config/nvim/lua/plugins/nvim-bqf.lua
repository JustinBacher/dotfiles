return {
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        {
            'junegunn/fzf',
            init = function()
                vim.fn['fzf#install']()
            end,
        },
    },
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
}