return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('octo').setup {
      use_local_fs = true,
      picker = 'telescope',
      mappings_disable_default = true,
      suppress_missing_scope = {
        projects_v2 = true,
      },
      mappings = {
        issue = {
          close_issue = { lhs = '<F11>', desc = 'close issue' },
          reopen_issue = { lhs = '<F11>', desc = 'reopen issue' },
          list_issues = { lhs = '<F11>', desc = 'list open issues on same repo' },
          reload = { lhs = '<F11>', desc = 'reload issue' },
          open_in_browser = { lhs = '<F11>', desc = 'open issue in browser' },
          copy_url = { lhs = '<F11>', desc = 'copy url to system clipboard' },
          add_assignee = { lhs = '<F11>', desc = 'add assignee' },
          remove_assignee = { lhs = '<F11>', desc = 'remove assignee' },
          create_label = { lhs = '<F11>', desc = 'create label' },
          add_label = { lhs = '<F11>', desc = 'add label' },
          remove_label = { lhs = '<F11>', desc = 'remove label' },
          goto_issue = { lhs = '<F11>', desc = 'navigate to a local repo issue' },
          add_comment = { lhs = '<F11>', desc = 'add comment' },
          delete_comment = { lhs = '<F11>', desc = 'delete comment' },
          next_comment = { lhs = '<F11>', desc = 'go to next comment' },
          prev_comment = { lhs = '<F11>', desc = 'go to previous comment' },
          react_hooray = { lhs = '<F11>', desc = 'add/remove 🎉 reaction' },
          react_heart = { lhs = '<F11>', desc = 'add/remove ❤️ reaction' },
          react_eyes = { lhs = '<F11>', desc = 'add/remove 👀 reaction' },
          react_thumbs_up = { lhs = '<F11>', desc = 'add/remove 👍 reaction' },
          react_thumbs_down = { lhs = '<F11>', desc = 'add/remove 👎 reaction' },
          react_rocket = { lhs = '<F11>', desc = 'add/remove 🚀 reaction' },
          react_laugh = { lhs = '<F11>', desc = 'add/remove 😄 reaction' },
          react_confused = { lhs = '<F11>', desc = 'add/remove 😕 reaction' },
        },
        pull_request = {
          checkout_pr = { lhs = '<F11>', desc = 'checkout PR' },
          merge_pr = { lhs = '<F11>', desc = 'merge commit PR' },
          squash_and_merge_pr = { lhs = '<F11>', desc = 'squash and merge PR' },
          rebase_and_merge_pr = { lhs = '<F11>', desc = 'rebase and merge PR' },
          list_commits = { lhs = '<F11>', desc = 'list PR commits' },
          list_changed_files = { lhs = '<F11>', desc = 'list PR changed files' },
          show_pr_diff = { lhs = '<F11>', desc = 'show PR diff' },
          add_reviewer = { lhs = '<F11>', desc = 'add reviewer' },
          remove_reviewer = { lhs = '<F11>', desc = 'remove reviewer request' },
          close_issue = { lhs = '<F11>', desc = 'close PR' },
          reopen_issue = { lhs = '<F11>', desc = 'reopen PR' },
          list_issues = { lhs = '<F11>', desc = 'list open issues on same repo' },
          reload = { lhs = '<F11>', desc = 'reload PR' },
          open_in_browser = { lhs = '<F11>', desc = 'open PR in browser' },
          copy_url = { lhs = '<F11>', desc = 'copy url to system clipboard' },
          goto_file = { lhs = '<F11>', desc = 'go to file' },
          add_assignee = { lhs = '<F11>', desc = 'add assignee' },
          remove_assignee = { lhs = '<F11>', desc = 'remove assignee' },
          create_label = { lhs = '<F11>', desc = 'create label' },
          add_label = { lhs = '<F11>', desc = 'add label' },
          remove_label = { lhs = '<F11>', desc = 'remove label' },
          goto_issue = { lhs = '<F11>', desc = 'navigate to a local repo issue' },
          add_comment = { lhs = '<F11>', desc = 'add comment' },
          delete_comment = { lhs = '<F11>', desc = 'delete comment' },
          next_comment = { lhs = '<F11>', desc = 'go to next comment' },
          prev_comment = { lhs = '<F11>', desc = 'go to previous comment' },
          react_hooray = { lhs = '<F11>', desc = 'add/remove 🎉 reaction' },
          react_heart = { lhs = '<F11>', desc = 'add/remove ❤️ reaction' },
          react_eyes = { lhs = '<F11>', desc = 'add/remove 👀 reaction' },
          react_thumbs_up = { lhs = '<F11>', desc = 'add/remove 👍 reaction' },
          react_thumbs_down = { lhs = '<F11>', desc = 'add/remove 👎 reaction' },
          react_rocket = { lhs = '<F11>', desc = 'add/remove 🚀 reaction' },
          react_laugh = { lhs = '<F11>', desc = 'add/remove 😄 reaction' },
          react_confused = { lhs = '<F11>', desc = 'add/remove 😕 reaction' },
          review_start = { lhs = '<F11>', desc = 'start a review for the current PR' },
          review_resume = { lhs = '<F11>', desc = 'resume a pending review for the current PR' },
        },
        review_thread = {
          goto_issue = { lhs = '<F11>', desc = 'navigate to a local repo issue' },
          add_comment = { lhs = '<F11>', desc = 'add comment' },
          add_suggestion = { lhs = '<F11>', desc = 'add suggestion' },
          delete_comment = { lhs = '<F11>', desc = 'delete comment' },
          next_comment = { lhs = '<F11>', desc = 'go to next comment' },
          prev_comment = { lhs = '<F11>', desc = 'go to previous comment' },
          select_next_entry = { lhs = '<F11>', desc = 'move to previous changed file' },
          select_prev_entry = { lhs = '<F11>', desc = 'move to next changed file' },
          select_first_entry = { lhs = '<F11>', desc = 'move to first changed file' },
          select_last_entry = { lhs = '<F11>', desc = 'move to last changed file' },
          close_review_tab = { lhs = '<F11>', desc = 'close review tab' },
          react_hooray = { lhs = '<F11>', desc = 'add/remove 🎉 reaction' },
          react_heart = { lhs = '<F11>', desc = 'add/remove ❤️ reaction' },
          react_eyes = { lhs = '<F11>', desc = 'add/remove 👀 reaction' },
          react_thumbs_up = { lhs = '<F11>', desc = 'add/remove 👍 reaction' },
          react_thumbs_down = { lhs = '<F11>', desc = 'add/remove 👎 reaction' },
          react_rocket = { lhs = '<F11>', desc = 'add/remove 🚀 reaction' },
          react_laugh = { lhs = '<F11>', desc = 'add/remove 😄 reaction' },
          react_confused = { lhs = '<F11>', desc = 'add/remove 😕 reaction' },
        },
        submit_win = {
          approve_review = { lhs = '<C-a>', desc = 'approve review' },
          comment_review = { lhs = '<C-m>', desc = 'comment review' },
          request_changes = { lhs = '<C-r>', desc = 'request changes review' },
          close_review_tab = { lhs = '<C-c>', desc = 'close review tab' },
        },
        review_diff = {
          submit_review = { lhs = '<F11>', desc = 'submit review' },
          discard_review = { lhs = '<F11>', desc = 'discard review' },
          add_review_comment = { lhs = '<F11>', desc = 'add a new review comment' },
          add_review_suggestion = { lhs = '<F11>', desc = 'add a new review suggestion' },
          focus_files = { lhs = '<F11>', desc = 'move focus to changed file panel' },
          toggle_files = { lhs = '<F11>', desc = 'hide/show changed files panel' },
          next_thread = { lhs = '<F11>', desc = 'move to next thread' },
          prev_thread = { lhs = '<F11>', desc = 'move to previous thread' },
          select_next_entry = { lhs = '<F11>', desc = 'move to previous changed file' },
          select_prev_entry = { lhs = '<F11>', desc = 'move to next changed file' },
          select_first_entry = { lhs = '<F11>', desc = 'move to first changed file' },
          select_last_entry = { lhs = '<F11>', desc = 'move to last changed file' },
          close_review_tab = { lhs = '<F11>', desc = 'close review tab' },
          toggle_viewed = { lhs = '<F11>', desc = 'toggle viewer viewed state' },
          goto_file = { lhs = '<F11>', desc = 'go to file' },
        },
        file_panel = {
          submit_review = { lhs = '<F11>', desc = 'submit review' },
          focus_files = { lhs = '<F11>', desc = 'move focus to changed file panel' },
          toggle_files = { lhs = '<F11>', desc = 'hide/show changed files panel' },
          select_next_entry = { lhs = '<F11>', desc = 'move to previous changed file' },
          select_prev_entry = { lhs = '<F11>', desc = 'move to next changed file' },
          select_first_entry = { lhs = '<F11>', desc = 'move to first changed file' },
          select_last_entry = { lhs = '<F11>', desc = 'move to last changed file' },
          close_review_tab = { lhs = '<F11>', desc = 'close review tab' },
          toggle_viewed = { lhs = '<F11>', desc = 'toggle viewer viewed state' },
          next_entry = { lhs = 'k', desc = 'move to next changed file' },
          prev_entry = { lhs = 'l', desc = 'move to previous changed file' },
          select_entry = { lhs = '<cr>', desc = 'show selected changed file diffs' },
          refresh_files = { lhs = 'R', desc = 'refresh changed files panel' },
        },
      },
    }
    local mappings = {
      { '<leader>o', group = 'Octo' },
      { '<leader>oe', group = 'React' },
      { '<leader>oec', '<cmd>Octo react confused<cr>', desc = 'Add/Remove 😕 Reaction' },
      { '<leader>oed', '<cmd>Octo react thumbs_down<cr>', desc = 'Add/Remove 👎 Reaction' },
      { '<leader>oee', '<cmd>Octo react eyes<cr>', desc = 'Add/Remove 👀 Reaction' },
      { '<leader>oeh', '<cmd>Octo react heart<cr>', desc = 'Add/Remove ❤️ Reaction' },
      { '<leader>oel', '<cmd>Octo react laugh<cr>', desc = 'Add/Remove 😄 Reaction' },
      { '<leader>oer', '<cmd>Octo react rocket<cr>', desc = 'Add/Remove 🚀 Reaction' },
      { '<leader>oeu', '<cmd>Octo react thumbs_up<cr>', desc = 'Add/Remove 👍 Reaction' },
      { '<leader>oey', '<cmd>Octo react hooray<cr>', desc = 'Add/Remove 🎉 Reaction' },
      { '<leader>oi', group = 'Issue' },
      { '<leader>oia', group = 'Assignee' },
      { '<leader>oiaa', '<cmd>Octo issue assignee add<cr>', desc = 'Add Assignee' },
      { '<leader>oiad', '<cmd>Octo issue assignee remove<cr>', desc = 'Remove Assignee' },
      { '<leader>oib', '<cmd>Octo issue browser<cr>', desc = 'Open in Browser' },
      { '<leader>oic', group = 'Comment' },
      { '<leader>oica', '<cmd>Octo comment add<cr>', desc = 'Add Comment' },
      { '<leader>oicd', '<cmd>Octo comment delete<cr>', desc = 'Delete Comment' },
      { '<leader>oicn', '<cmd>Octo comment next<cr>', desc = 'Next Comment' },
      { '<leader>oicp', '<cmd>Octo comment prev<cr>', desc = 'Previous Comment' },
      { '<leader>oif', '<cmd>Octo issue reload<cr>', desc = 'Reload Issue' },
      { '<leader>oig', '<cmd>Octo issue goto<cr>', desc = 'Goto Issue' },
      { '<leader>oii', '<cmd>Octo issue list<cr>', desc = 'List Issues' },
      { '<leader>oil', group = 'Label' },
      { '<leader>oila', '<cmd>Octo label add<cr>', desc = 'Add Label' },
      { '<leader>oilc', '<cmd>Octo label create<cr>', desc = 'Create Label' },
      { '<leader>oild', '<cmd>Octo label remove<cr>', desc = 'Remove Label' },
      { '<leader>oio', '<cmd>Octo issue reopen<cr>', desc = 'Reopen Issue' },
      { '<leader>oiq', '<cmd>Octo issue close<cr>', desc = 'Close Issue' },
      { '<leader>oir', group = 'React' },
      { '<leader>oirc', '<cmd>Octo react confused<cr>', desc = 'add/remove 😕 reaction' },
      { '<leader>oird', '<cmd>Octo react thumbs_down<cr>', desc = 'add/remove 👎 reaction' },
      { '<leader>oire', '<cmd>Octo react eyes<cr>', desc = 'add/remove 👀 reaction' },
      { '<leader>oirh', '<cmd>Octo react heart<cr>', desc = 'add/remove ❤️ reaction' },
      { '<leader>oirl', '<cmd>Octo react laugh<cr>', desc = 'add/remove 😄 reaction' },
      { '<leader>oirr', '<cmd>Octo react rocket<cr>', desc = 'add/remove 🚀 reaction' },
      { '<leader>oiru', '<cmd>Octo react thumbs_up<cr>', desc = 'add/remove 👍 reaction' },
      { '<leader>oiry', '<cmd>Octo react hooray<cr>', desc = 'add/remove 🎉 reaction' },
      { '<leader>oiy', '<cmd>Octo issue url<cr>', desc = 'Copy URL' },
      { '<leader>op', group = 'Pull Request' },
      { '<leader>opa', group = 'Assignee' },
      { '<leader>opaa', '<cmd>Octo pr assignee add<cr>', desc = 'Add Assignee' },
      { '<leader>opad', '<cmd>Octo pr assignee remove<cr>', desc = 'Remove Assignee' },
      { '<leader>opb', group = 'Label' },
      { '<leader>opba', '<cmd>Octo label add<cr>', desc = 'Add Label' },
      { '<leader>opbc', '<cmd>Octo label create<cr>', desc = 'Create Label' },
      { '<leader>opbd', '<cmd>Octo label remove<cr>', desc = 'Remove Label' },
      { '<leader>opc', group = 'Comment' },
      { '<leader>opca', '<cmd>Octo comment add<cr>', desc = 'Add Comment' },
      { '<leader>opcd', '<cmd>Octo comment delete<cr>', desc = 'Delete Comment' },
      { '<leader>opcn', '<cmd>Octo comment next<cr>', desc = 'Next Comment' },
      { '<leader>opcp', '<cmd>Octo comment prev<cr>', desc = 'Previous Comment' },
      { '<leader>opd', '<cmd>Octo pr diff<cr>', desc = 'Show PR Diff' },
      { '<leader>ope', '<cmd>Octo pr rebase_merge<cr>', desc = 'Rebase and Merge PR' },
      { '<leader>opf', '<cmd>Octo pr reload<cr>', desc = 'Reload PR' },
      { '<leader>opg', '<cmd>Octo pr goto<cr>', desc = 'Goto File' },
      { '<leader>oph', '<cmd>Octo pr files<cr>', desc = 'List PR Changed Files' },
      { '<leader>opi', group = 'Issue' },
      { '<leader>opic', '<cmd>Octo pr close<cr>', desc = 'Close PR' },
      { '<leader>opil', '<cmd>Octo issue list<cr>', desc = 'List Issues' },
      { '<leader>opio', '<cmd>Octo pr reopen<cr>', desc = 'Reopen PR' },
      { '<leader>opl', '<cmd>Octo pr list<cr>', desc = 'List PRs' },
      { '<leader>opm', '<cmd>Octo pr merge<cr>', desc = 'Merge Commit PR' },
      { '<leader>opo', '<cmd>Octo pr checkout<cr>', desc = 'Checkout PR' },
      { '<leader>opr', '<cmd>Octo pr browser<cr>', desc = 'Open in Browser' },
      { '<leader>ops', '<cmd>Octo pr squash_merge<cr>', desc = 'Squash and Merge PR' },
      { '<leader>opt', '<cmd>Octo pr commits<cr>', desc = 'List PR Commits' },
      { '<leader>opw', group = 'Reviewer' },
      { '<leader>opwa', '<cmd>Octo pr reviewer add<cr>', desc = 'Add Reviewer' },
      { '<leader>opwd', '<cmd>Octo pr reviewer remove<cr>', desc = 'Remove Reviewer' },
      { '<leader>opy', '<cmd>Octo pr url<cr>', desc = 'Copy URL' },
      { '<leader>or', group = 'Review' },
      { '<leader>orc', group = 'Comment' },
      { '<leader>orca', '<cmd>Octo comment add<cr>', desc = 'Add Comment' },
      { '<leader>orcc', '<cmd>Octo review comments<cr>', desc = 'List comments' },
      { '<leader>orcd', '<cmd>Octo comment delete<cr>', desc = 'Delete Comment' },
      { '<leader>ord', '<cmd>Octo review discard<cr>', desc = 'Discard Review' },
      { '<leader>orr', '<cmd>Octo review resume<cr>', desc = 'Resume Review' },
      { '<leader>ors', '<cmd>Octo review start<cr>', desc = 'Start Review' },
      { '<leader>oru', '<cmd>Octo review submit<cr>', desc = 'Submit Review' },
    }
    require('which-key').add(mappings) -- , { prefix = '<leader>' })
  end,
}
