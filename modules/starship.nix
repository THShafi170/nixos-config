{
  lib,
  pkgs,
  ...
}:

let
  tomlFormat = pkgs.formats.toml { };

  starshipSettings = {
    add_newline = true;

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

    nix_shell = {
      disabled = false;
      heuristic = true;
      format = "[$symbol$state( \\\\($name\\\\))]($style) ";
      symbol = "❄️  ";
      style = "bold blue";
      impure_msg = "[impure](bold red)";
      pure_msg = "[pure](bold green)";
    };

    character = {
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
      vimcmd_symbol = "[❮](bold green)";
    };

    fill.symbol = " ";

    directory = {
      truncation_length = 3;
      truncate_to_repo = true;
      style = "bold cyan";
      read_only = " 🔒";
      format = "[$path]($style)[$read_only]($read_only_style) ";
    };

    git_branch = {
      symbol = " ";
      format = "[$symbol$branch]($style) ";
      style = "bold purple";
    };

    git_status = {
      format = "([$all_status$ahead_behind]($style) )";
      style = "bold red";
      conflicted = "🏳";
      up_to_date = "";
      untracked = " ";
      ahead = "⇡\${count}";
      diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      behind = "⇣\${count}";
      stashed = " ";
      modified = " ";
      staged = "[++(\${count})](green)";
      renamed = "襁 ";
      deleted = " ";
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

    package = {
      symbol = "📦 ";
      format = "[$symbol$version]($style) ";
      style = "dimmed white";
    };

    python = {
      symbol = "🐍 ";
      format = "[$symbol$version(\\\\($virtualenv\\\\))]($style) ";
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
      symbol = " ";
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
in
{
  # Generate /etc/starship.toml — single source of truth for all shells/users
  environment.etc."starship.toml".source = tomlFormat.generate "starship.toml" starshipSettings;

  # Point all users to the shared config
  environment.sessionVariables.STARSHIP_CONFIG = "/etc/starship.toml";

  # Install starship system-wide
  environment.systemPackages = [ pkgs.starship ];
}
