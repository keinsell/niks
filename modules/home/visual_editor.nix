# https://github.com/nix-community/home-manager/blob/master/modules/programs/zed-editor.nix
{lib, pkgs, ...}: {
  programs.zed-editor = {
    enable = true;

    # https://github.com/zed-industries/extensions/tree/main/extensions
    extensions = [
      "just"
      "toml"
      "nix"
      "kdl"
      "ansible"
      "cargo-appraiser"
      "cargo-tom"
      "cairo"
      "catppuccin-blur"
      "cue"
      "docker-compose"
      "earthfile"
      "env"
      "flatbuffers"
      "gleam"
      "graphql"
      "graphviz"
      "ini"
      "jsonnet"
      "log"
      "make"
      "superhtml"
      "typst"
    ];

    userSettings = {
      vim_mode = false;
      base_keymap = "VSCode";
      soft_wrap = "editor_width";
      tab_size = 2;
      theme = {
          dark = "Catppuccin Mocha";
          light = "macOS Classic Light";
      };

      load_direnv = "shell_hook";

      languages.Nix = {
        language_servers = ["nixd" "!nil"]; # Force use of nixd over nil
        formatter = (lib.getExe pkgs.alejandra);
      };

      lsp = let
        useDirenv = {binary.path_lookup = true;};
      in {
        haskell = useDirenv;
        rust_analyzer = useDirenv;
        nixd = {
            binary.path = (lib.getExe pkgs.nixd);
            binary.path_lookup = true;
        };
        nil.formatting.command =  (lib.getExe pkgs.alejandra);
      };

      buffer_font_family = "Scientifica";
      ui_font_size = 16;
      ui_font_family = "Scientifica";
      buffer_font_size = 14;

      outline_panel = {
        dock = "left";
      };
      project_panel = {
        dock = "left";
      };
    };
  };
}
