return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local mappings = {
      o = {
        name = 'Octo',
        i = {
          name = 'Issue',
          q = { '<cmd>Octo issue close<cr>', 'Close Issue' },
          o = { '<cmd>Octo issue reopen<cr>', 'Reopen Issue' },
          i = { '<cmd>Octo issue list<cr>', 'List Issues' },
          f = { '<cmd>Octo issue reload<cr>', 'Reload Issue' },
          b = { '<cmd>Octo issue browser<cr>', 'Open in Browser' },
          y = { '<cmd>Octo issue url<cr>', 'Copy URL' },
          a = {
            name = 'Assignee',
            a = { '<cmd>Octo issue assignee add<cr>', 'Add Assignee' },
            d = { '<cmd>Octo issue assignee remove<cr>', 'Remove Assignee' },
          },
          l = {
            name = 'Label',
            c = { '<cmd>Octo label create<cr>', 'Create Label' },
            a = { '<cmd>Octo label add<cr>', 'Add Label' },
            d = { '<cmd>Octo label remove<cr>', 'Remove Label' },
          },
          g = { '<cmd>Octo issue goto<cr>', 'Goto Issue' },
          c = {
            name = 'Comment',
            a = { '<cmd>Octo comment add<cr>', 'Add Comment' },
            d = { '<cmd>Octo comment delete<cr>', 'Delete Comment' },
            p = { '<cmd>Octo comment prev<cr>', 'Previous Comment' },
            n = { '<cmd>Octo comment next<cr>', 'Next Comment' },
          },
          r = {
            name = 'React',
            y = { '<cmd>Octo react hooray<cr>', 'add/remove 🎉 reaction' },
            h = { '<cmd>Octo react heart<cr>', 'add/remove ❤️ reaction' },
            e = { '<cmd>Octo react eyes<cr>', 'add/remove 👀 reaction' },
            u = { '<cmd>Octo react thumbs_up<cr>', 'add/remove 👍 reaction' },
            d = { '<cmd>Octo react thumbs_down<cr>', 'add/remove 👎 reaction' },
            r = { '<cmd>Octo react rocket<cr>', 'add/remove 🚀 reaction' },
            l = { '<cmd>Octo react laugh<cr>', 'add/remove 😄 reaction' },
            c = { '<cmd>Octo react confused<cr>', 'add/remove 😕 reaction' },
          },
        },
        p = {
          name = 'Pull Request',
          o = { '<cmd>Octo pr checkout<cr>', 'Checkout PR' },
          m = { '<cmd>Octo pr merge<cr>', 'Merge Commit PR' },
          s = { '<cmd>Octo pr squash_merge<cr>', 'Squash and Merge PR' },
          e = { '<cmd>Octo pr rebase_merge<cr>', 'Rebase and Merge PR' },
          t = { '<cmd>Octo pr commits<cr>', 'List PR Commits' },
          h = { '<cmd>Octo pr files<cr>', 'List PR Changed Files' },
          d = { '<cmd>Octo pr diff<cr>', 'Show PR Diff' },
          l = { '<cmd>Octo pr list<cr>', 'List PRs' },
          w = {
            name = 'Reviewer',
            a = { '<cmd>Octo pr reviewer add<cr>', 'Add Reviewer' },
            d = { '<cmd>Octo pr reviewer remove<cr>', 'Remove Reviewer' },
          },
          i = {
            name = 'Issue',
            c = { '<cmd>Octo pr close<cr>', 'Close PR' },
            o = { '<cmd>Octo pr reopen<cr>', 'Reopen PR' },
            l = { '<cmd>Octo issue list<cr>', 'List Issues' },
          },
          f = { '<cmd>Octo pr reload<cr>', 'Reload PR' },
          r = { '<cmd>Octo pr browser<cr>', 'Open in Browser' },
          y = { '<cmd>Octo pr url<cr>', 'Copy URL' },
          g = { '<cmd>Octo pr goto<cr>', 'Goto File' },
          a = {
            name = 'Assignee',
            a = { '<cmd>Octo pr assignee add<cr>', 'Add Assignee' },
            d = { '<cmd>Octo pr assignee remove<cr>', 'Remove Assignee' },
          },
          b = {
            name = 'Label',
            c = { '<cmd>Octo label create<cr>', 'Create Label' },
            a = { '<cmd>Octo label add<cr>', 'Add Label' },
            d = { '<cmd>Octo label remove<cr>', 'Remove Label' },
          },
          c = {
            name = 'Comment',
            a = { '<cmd>Octo comment add<cr>', 'Add Comment' },
            d = { '<cmd>Octo comment delete<cr>', 'Delete Comment' },
            p = { '<cmd>Octo comment prev<cr>', 'Previous Comment' },
            n = { '<cmd>Octo comment next<cr>', 'Next Comment' },
          },
        },
        e = {
          name = 'React',
          y = { '<cmd>Octo react hooray<cr>', 'Add/Remove 🎉 Reaction' },
          h = { '<cmd>Octo react heart<cr>', 'Add/Remove ❤️ Reaction' },
          e = { '<cmd>Octo react eyes<cr>', 'Add/Remove 👀 Reaction' },
          u = { '<cmd>Octo react thumbs_up<cr>', 'Add/Remove 👍 Reaction' },
          d = { '<cmd>Octo react thumbs_down<cr>', 'Add/Remove 👎 Reaction' },
          r = { '<cmd>Octo react rocket<cr>', 'Add/Remove 🚀 Reaction' },
          l = { '<cmd>Octo react laugh<cr>', 'Add/Remove 😄 Reaction' },
          c = { '<cmd>Octo react confused<cr>', 'Add/Remove 😕 Reaction' },
        },
        r = {
          name = 'Review',
          s = { '<cmd>Octo review start<cr>', 'Start Review' },
          r = { '<cmd>Octo review resume<cr>', 'Resume Review' },
          u = { '<cmd>Octo review submit<cr>', 'Submit Review' },
          d = { '<cmd>Octo review discard<cr>', 'Discard Review' },
          c = {
            name = 'Comment',
            a = { '<cmd>Octo comment add<cr>', 'Add Comment' },
            d = { '<cmd>Octo comment delete<cr>', 'Delete Comment' },
            c = { '<cmd>Octo review comments<cr>', 'List comments' },
          },
        },
      },
    }
    require('octo').setup {
      mappings_disable_default = true,
      suppress_missing_scope = {
        projects_v2 = true,
      },
      mappings = {
        issue = {
          close_issue = { desc = 'close issue' },
          reopen_issue = { desc = 'reopen issue' },
          list_issues = { desc = 'list open issues on same repo' },
          reload = { desc = 'reload issue' },
          open_in_browser = { desc = 'open issue in browser' },
          copy_url = { desc = 'copy url to system clipboard' },
          add_assignee = { desc = 'add assignee' },
          remove_assignee = { desc = 'remove assignee' },
          create_label = { desc = 'create label' },
          add_label = { desc = 'add label' },
          remove_label = { desc = 'remove label' },
          goto_issue = { desc = 'navigate to a local repo issue' },
          add_comment = { desc = 'add comment' },
          delete_comment = { desc = 'delete comment' },
          next_comment = { desc = 'go to next comment' },
          prev_comment = { desc = 'go to previous comment' },
          react_hooray = { desc = 'add/remove 🎉 reaction' },
          react_heart = { desc = 'add/remove ❤️ reaction' },
          react_eyes = { desc = 'add/remove 👀 reaction' },
          react_thumbs_up = { desc = 'add/remove 👍 reaction' },
          react_thumbs_down = { desc = 'add/remove 👎 reaction' },
          react_rocket = { desc = 'add/remove 🚀 reaction' },
          react_laugh = { desc = 'add/remove 😄 reaction' },
          react_confused = { desc = 'add/remove 😕 reaction' },
        },
        pull_request = {
          checkout_pr = { desc = 'checkout PR' },
          merge_pr = { desc = 'merge commit PR' },
          squash_and_merge_pr = { desc = 'squash and merge PR' },
          rebase_and_merge_pr = { desc = 'rebase and merge PR' },
          list_commits = { desc = 'list PR commits' },
          list_changed_files = { desc = 'list PR changed files' },
          show_pr_diff = { desc = 'show PR diff' },
          add_reviewer = { desc = 'add reviewer' },
          remove_reviewer = { desc = 'remove reviewer request' },
          close_issue = { desc = 'close PR' },
          reopen_issue = { desc = 'reopen PR' },
          list_issues = { desc = 'list open issues on same repo' },
          reload = { desc = 'reload PR' },
          open_in_browser = { desc = 'open PR in browser' },
          copy_url = { desc = 'copy url to system clipboard' },
          goto_file = { desc = 'go to file' },
          add_assignee = { desc = 'add assignee' },
          remove_assignee = { desc = 'remove assignee' },
          create_label = { desc = 'create label' },
          add_label = { desc = 'add label' },
          remove_label = { desc = 'remove label' },
          goto_issue = { desc = 'navigate to a local repo issue' },
          add_comment = { desc = 'add comment' },
          delete_comment = { desc = 'delete comment' },
          next_comment = { desc = 'go to next comment' },
          prev_comment = { desc = 'go to previous comment' },
          react_hooray = { desc = 'add/remove 🎉 reaction' },
          react_heart = { desc = 'add/remove ❤️ reaction' },
          react_eyes = { desc = 'add/remove 👀 reaction' },
          react_thumbs_up = { desc = 'add/remove 👍 reaction' },
          react_thumbs_down = { desc = 'add/remove 👎 reaction' },
          react_rocket = { desc = 'add/remove 🚀 reaction' },
          react_laugh = { desc = 'add/remove 😄 reaction' },
          react_confused = { desc = 'add/remove 😕 reaction' },
          review_start = { desc = 'start a review for the current PR' },
          review_resume = { desc = 'resume a pending review for the current PR' },
        },
        review_thread = {
          goto_issue = { desc = 'navigate to a local repo issue' },
          add_comment = { desc = 'add comment' },
          add_suggestion = { desc = 'add suggestion' },
          delete_comment = { desc = 'delete comment' },
          next_comment = { desc = 'go to next comment' },
          prev_comment = { desc = 'go to previous comment' },
          select_next_entry = { desc = 'move to previous changed file' },
          select_prev_entry = { desc = 'move to next changed file' },
          select_first_entry = { desc = 'move to first changed file' },
          select_last_entry = { desc = 'move to last changed file' },
          close_review_tab = { desc = 'close review tab' },
          react_hooray = { desc = 'add/remove 🎉 reaction' },
          react_heart = { desc = 'add/remove ❤️ reaction' },
          react_eyes = { desc = 'add/remove 👀 reaction' },
          react_thumbs_up = { desc = 'add/remove 👍 reaction' },
          react_thumbs_down = { desc = 'add/remove 👎 reaction' },
          react_rocket = { desc = 'add/remove 🚀 reaction' },
          react_laugh = { desc = 'add/remove 😄 reaction' },
          react_confused = { desc = 'add/remove 😕 reaction' },
        },
        submit_win = {
          approve_review = { desc = 'approve review' },
          comment_review = { desc = 'comment review' },
          request_changes = { desc = 'request changes review' },
          close_review_tab = { desc = 'close review tab' },
        },
        review_diff = {
          submit_review = { desc = 'submit review' },
          discard_review = { desc = 'discard review' },
          add_review_comment = { desc = 'add a new review comment' },
          add_review_suggestion = { desc = 'add a new review suggestion' },
          focus_files = { desc = 'move focus to changed file panel' },
          toggle_files = { desc = 'hide/show changed files panel' },
          next_thread = { desc = 'move to next thread' },
          prev_thread = { desc = 'move to previous thread' },
          select_next_entry = { desc = 'move to previous changed file' },
          select_prev_entry = { desc = 'move to next changed file' },
          select_first_entry = { desc = 'move to first changed file' },
          select_last_entry = { desc = 'move to last changed file' },
          close_review_tab = { desc = 'close review tab' },
          toggle_viewed = { desc = 'toggle viewer viewed state' },
          goto_file = { desc = 'go to file' },
        },
        file_panel = {
          submit_review = { desc = 'submit review' },
          focus_files = { desc = 'move focus to changed file panel' },
          toggle_files = { desc = 'hide/show changed files panel' },
          select_next_entry = { desc = 'move to previous changed file' },
          select_prev_entry = { desc = 'move to next changed file' },
          select_first_entry = { desc = 'move to first changed file' },
          select_last_entry = { desc = 'move to last changed file' },
          close_review_tab = { desc = 'close review tab' },
          toggle_viewed = { desc = 'toggle viewer viewed state' },
          next_entry = { lhs = 'k', desc = 'move to next changed file' },
          prev_entry = { lhs = 'l', desc = 'move to previous changed file' },
          select_entry = { lhs = '<cr>', desc = 'show selected changed file diffs' },
          refresh_files = { lhs = 'R', desc = 'refresh changed files panel' },
        },
      },
    }
    require('which-key').register(mappings, { prefix = '<leader>' })
  end,
}
