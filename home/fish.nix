{
  ...
}:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      # NixOS management
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#X1-Yoga-2nd";
      nix-upgrade = "sudo nix flake update --flake /etc/nixos#X1-Yoga-2nd && sudo nixos-rebuild switch --flake /etc/nixos#X1-Yoga-2nd";
      nix-clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage && sudo nixos-rebuild boot --flake /etc/nixos#X1-Yoga-2nd";

      # System
      free = "free -m";
      jctl = "journalctl -p 3 -xb";
      psmem = "ps auxf | sort -nr -k 4";
      psmem10 = "ps auxf | sort -nr -k 4 | head -10";

      # eza replaces ls
      ls = "eza -al --color=always --group-directories-first --icons=always";
      la = "eza -a --color=always --group-directories-first --icons=always";
      ll = "eza -l --color=always --group-directories-first --icons=always";
      lt = "eza -aT --color=always --group-directories-first --icons=always";
      "l." = "eza -a | grep -e '^\\.'";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

      # Common tools
      grep = "grep --color=auto";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";
      wget = "wget -c";
      tarnow = "tar -acf ";
      untar = "tar -zxvf ";
      tb = "nc termbin.com 9999";
    };

    interactiveShellInit = ''
      # Rustup-managed binaries first on PATH
      # CARGO_HOME is set via environment.sessionVariables in system-devenv.nix
      fish_add_path "$CARGO_HOME/bin"

      # Better man pages with bat
      set -x MANROFFOPT -c
      set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

      # Bang-bang (!! and !$) key bindings
      if [ "$fish_key_bindings" = fish_vi_key_bindings ]
          bind -Minsert ! __history_previous_command
          bind -Minsert '$' __history_previous_command_arguments
      else
          bind ! __history_previous_command
          bind '$' __history_previous_command_arguments
      end
    '';

    functions = {
      fish_greeting = {
        body = "fastfetch";
      };

      # !! support — recall last command
      __history_previous_command = {
        body = ''
          switch (commandline -t)
              case "!"
                  commandline -t $history[1]
                  commandline -f repaint
              case "*"
                  commandline -i !
          end
        '';
      };

      # !$ support — recall last argument
      __history_previous_command_arguments = {
        body = ''
          switch (commandline -t)
              case "!"
                  commandline -t ""
                  commandline -f history-token-search-backward
              case "*"
                  commandline -i '$'
          end
        '';
      };

      # History with timestamps
      history = {
        body = "builtin history --show-time='%F %T '";
      };

      # Quick file backup
      backup = {
        argumentNames = [ "filename" ];
        body = "cp $filename $filename.bak";
      };

      # Smart directory copy
      copy = {
        body = ''
          set count (count $argv)
          if test "$count" = 2; and test -d "$argv[1]"
              set from (string replace -r '/+$' "" "$argv[1]")
              set to "$argv[2]"
              command cp -r "$from" "$to"
          else
              command cp $argv
          end
        '';
      };

      git-pull-all = {
        body = ''
          for gitdir in (find . -name ".git" -type d)
            set repo (dirname "$gitdir")
            echo "Pulling $repo..."
            cd "$repo"

            if not git pull
              echo "Normal pull failed, trying force pull..."
              git fetch origin
              git reset --hard origin/(git rev-parse --abbrev-ref HEAD)
            end

            cd -
          end
        '';
      };
    };
  };

  # Starship shell integration (config is shared system-wide via /etc/starship.toml)
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };
}
