{
  lib,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;

    settings = {
      theme = "catppuccin_mocha";
      editor = {
        auto-save = true;
        auto-completion = true;
        color-modes = true;
        line-number = "relative";
        completion-trigger-len = 0;
        mouse = false;
        true-color = true;
        cursorline = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        soft-wrap.enable = true;
        lsp = {
          auto-signature-help = true;
          display-inlay-hints = true;
          display-messages = true;
          enable = true;
          snippets = true;
        };
      };
    };

    languages = {
      language-server = {
        nil = {
          command = lib.getExe pkgs.nil;
        };
        nixd = {
          command = lib.getExe pkgs.nixd;
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = ["nil" "nixd"];
          formatter.command = lib.getExe pkgs.alejandra;
        }
      ];
    };

    extraPackages = with pkgs; [
      marksman
      markdown-oxide
      nil
      nixd
      biome
    ];
  };
}
