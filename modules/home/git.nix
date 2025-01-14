{pkgs, ...}: {
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  # https://nixos.asia/en/git
  programs = {
    git = {
      enable = true;
      userName = "keinsell";
      userEmail = "keinsell@protonmail.com";
      ignores = ["*~" "*.swp" "node_modules" ".direnv" ".cache" ".DS_Store"];

      aliases = {
        ci = "commit";
      };

      iniContent = {
        # Performance optimalization with
        # usage of fsmonitor which do not seem
        # to be enabled by default.
        # https://github.blog/engineering/infrastructure/improve-git-monorepo-performance-with-a-file-system-monitor/
        core.untrackedCache = true;
        core.fsmonitor = "${pkgs.rs-git-fsmonitor}/bin/rs-git-fsmonitor";
        branch.sort = "-committerdate";
        rerere.enabled = true;
        push.autoSetupRemote = true;
        pull.rebase = true;
        fetch.fsckObjects = true;
        index.threads = true;
        push = {
          # Make `git push` push relevant annotated tags when pushing branches out.
          followTags = true;
        };
      };

      signing = {
        signByDefault = true;
        # Signing key was generated at 01/01/2025 and replaced older one which was used
        # Key itself is available on keyboase and can be imported to local machine using
        # keybase pgp pull-private "73D2E5DFD6CC2BD08C6822E45B8600D62E632A5A"
        key = "73D2E5DFD6CC2BD08C6822E45B8600D62E632A5A";
        # TODO: Implement secret management mechanism which would allow for key persistance
        # in repository, nix-sops and usage of age should be considerable option for this
        # purpose.
      };

      difftastic = {
        enable = true;
        display = "inline";
      };

      extraConfig = {
        init.defaultBranch = "trunk";
        credential = {
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        };

        # init.defaultBranch = "master";
        # pull.rebase = "false";

        filter.lfs.clean = "${pkgs.git-lfs}/bin/git-lfs clean -- %f";
        filter.lfs.smudge = "${pkgs.git-lfs}/bin/git-lfs smudge -- %f";
        filter.lfs.process = "${pkgs.git-lfs}/bin/git-lfs filter-process";
        filter.lfs.required = true;
      };
    };

    lazygit = {
      enable = true;
      settings = {
        update.method = "never";
        gui = {
          nerdFontsVersion = 3;
          lightTheme = false;
          filterMode = "fuzzy";
        };
        git = {
          paging = {
            colorArg = "always";
            useConfig = false;
            externalDiffCommand = "difft --color=always";
          };
        };
      };
    };
  };
}
