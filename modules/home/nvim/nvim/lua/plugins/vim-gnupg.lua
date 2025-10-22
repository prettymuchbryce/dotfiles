return {
  'jamessan/vim-gnupg',
  init = function()
    -- prefer symmetric (AES-256) mode
    vim.g.GPGPreferSymmetric = 1
    -- if you like, you can turn off ASCII armor (.asc) and always use binary (.gpg)
    -- vim.g.GPGAutoArmor = 0
  end,
  config = function()
    -- optional: set your default GPG executable / args
    -- vim.g.GPGExecutable = 'gpg'
    -- vim.g.GPGEncryptArgs = { '--symkey-cache-mode', '2' }
    -- vim.g.GPGDecryptArgs = {}
  end,
}
