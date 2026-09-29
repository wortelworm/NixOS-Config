{
  lib,
  pkgs,
  ...
}: {
  # Wortelworm's Redirection Engine:
  #   just because duckduckgo's bangs are outdated (!nixos, !mcw),
  #   and I don't feel like paying for kagi.
  #   Its pretty nice :)
  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://localhost" = {
        extraConfig = ''
          handle_path /redirector/* {
            file_server {
              root ${./redirect.html}
            }
            header Cache-Control public,max-age=86400
          }

          respond * 404
        '';
      };

      # TODO: figure out why http://127.0.0.1 is still not responding with 404...
      "http://*" = {
        extraConfig = "respond * 404";
      };
    };
  };
}
