{
  lib,
  pkgs,
  ...
}: {
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        eval "$(mise activate zsh)"
        export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
      '';
    };

    nushell = {
      enable = true;
      extraConfig = ''
        # Common ls aliases and sort them by type and then name
        # Inspired by https://github.com/nushell/nushell/issues/7190
        def lla [...args] { ls -la ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def la  [...args] { ls -a  ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def ll  [...args] { ls -l  ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def l   [...args] { ls     ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }

        # Completions
        # mainly pieced together from https://www.nushell.sh/cookbook/external_completers.html

        # carapce completions https://www.nushell.sh/cookbook/external_completers.html#carapace-completer
        # + fix https://www.nushell.sh/cookbook/external_completers.html#err-unknown-shorthand-flag-using-carapace
        # enable the package and integration bellow
        let carapace_completer = {|spans: list<string>|
          carapace $spans.0 nushell ...$spans
          | from json
          | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
        }
        # some completions are only available through a bridge
        # eg. tailscale
        # https://carapace-sh.github.io/carapace-bin/setup.html#nushell
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

        # fish completions https://www.nushell.sh/cookbook/external_completers.html#fish-completer
        let fish_completer = {|spans|
          ${lib.getExe pkgs.fish} --command $'complete "--do-complete=($spans | str join " ")"'
          | $"value(char tab)description(char newline)" + $in
          | from tsv --flexible --no-infer
        }

        # zoxide completions https://www.nushell.sh/cookbook/external_completers.html#zoxide-completer
        let zoxide_completer = {|spans|
            $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
        }

        # multiple completions
        # the default will be carapace, but you can also switch to fish
        # https://www.nushell.sh/cookbook/external_completers.html#alias-completions
        let multiple_completers = {|spans|
          ## alias fixer start https://www.nushell.sh/cookbook/external_completers.html#alias-completions
          let expanded_alias = scope aliases
          | where name == $spans.0
          | get -i 0.expansion

          let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
          } else {
            $spans
          }
          ## alias fixer end

          match $spans.0 {
            __zoxide_z | __zoxide_zi => $zoxide_completer
            _ => $carapace_completer
          } | do $in $spans
        }

        $env.config = {
          show_banner: false,
          completions: {
            case_sensitive: false # case-sensitive completions
            quick: true           # set to false to prevent auto-selecting completions
            partial: true         # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
              # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100
              completer: $multiple_completers
            }
          }
        }
        $env.PATH = ($env.PATH |
          split row (char esep) |
          prepend /home/keinsell/.apps |
          append /usr/bin/env
        )
      '';
    };

    carapace.enable = true;
    atuin.enable = true;
    mise.enable = true;
    # Type `z <pat>` to cd to some directory
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-index.enableZshIntegration = true;
    mise.enableZshIntegration = true;

    # https://nixos.asia/en/direnv
    direnv = {
      enable = true;
      silent = true;
      nix-direnv = {
        enable = true;
      };
      config.global = {
        # Make direnv messages less verbose
        hide_env_diff = true;
        disable_stdin = true;
        load_dotenv = true;
        strict_env = true;
      };
    };

    # https://ohmyposh.dev/docs/themes
    oh-my-posh = {
      enable = true;
      useTheme = "uew";
    };
    zellij = {
      enable = true;
      enableZshIntegration = false;
      enableBashIntegration = false;
      settings = {
        simplified_ui = true;
        theme = "catppuccin-mocha";
        on_force_close = "quit";
        default_layout = "compact";
        ui = {
          pane_frames = {
            rounded_corners = true;
            hide_session_name = true;
          };
        };
      };
    };
    thefuck.enable = true;
    broot.enable = true;
    eza.enable = true;
  };
}
