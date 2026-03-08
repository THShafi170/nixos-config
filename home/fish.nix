{
  lib,
  ...
}:

{
  # Enable Fish shell
  programs.fish = {
    enable = true;
    # Aliases
    shellAliases = {
      free = "free -m";
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#X1-Yoga-2nd";
      nix-upgrade = "sudo nix flake update --flake /etc/nixos#X1-Yoga-2nd && sudo nixos-rebuild switch --flake /etc/nixos#X1-Yoga-2nd";
      nix-clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage && sudo nixos-rebuild boot --flake /etc/nixos#X1-Yoga-2nd";
    };
    # Custom Fish functions
    functions = {
      # System greeting
      fish_greeting = {
        body = "fastfetch";
      };
      # Git pull helper
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

  # Starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = {
      add_newline = true;

      # Prompt format
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$nix_shell"
        "$fill"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$character"
      ];

      # Right prompt format
      right_format = lib.concatStrings [
        "$package"
        "$python"
        "$rust"
        "$golang"
        "$nodejs"
        "$lua"
        "$docker_context"
        "$terraform"
      ];

      # -----------------------------------------------------------------------
      # Core Integration: Nix Shell
      # -----------------------------------------------------------------------
      nix_shell = {
        disabled = false;
        heuristic = true;
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "❄️  ";
        style = "bold blue";
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
      };

      # Character
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      fill = {
        symbol = " ";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
        read_only = " 🔒";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        conflicted = "🏳";
        up_to_date = "";
        untracked = " ";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        stashed = " ";
        modified = " ";
        staged = "[++(\${count})](green)";
        renamed = "襁 ";
        deleted = " ";
      };

      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "bold yellow";
      };

      username = {
        show_always = false;
        style_user = "bold yellow";
        style_root = "bold red";
        format = "[$user]($style) ";
      };

      hostname = {
        ssh_only = true;
        format = "[$hostname]($style) ";
        style = "bold green";
      };

      # Language stacks
      package = {
        symbol = "📦 ";
        format = "[$symbol$version]($style) ";
        style = "dimmed white";
      };

      python = {
        symbol = "🐍 ";
        format = "[$symbol$version(\\($virtualenv\\))]($style) ";
        style = "bold yellow";
      };

      rust = {
        symbol = "🦀 ";
        format = "[$symbol$version]($style) ";
        style = "bold red";
      };

      golang = {
        symbol = "🐹 ";
        format = "[$symbol$version]($style) ";
        style = "bold cyan";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol$version]($style) ";
        style = "bold green";
      };

      lua = {
        symbol = "🌙 ";
        format = "[$symbol$version]($style) ";
        style = "bold blue";
      };

      docker_context = {
        symbol = "🐳 ";
        format = "[$symbol$context]($style) ";
        style = "blue bold";
      };
    };
  };
}
