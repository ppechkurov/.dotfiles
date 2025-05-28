{ config, ... }:
let secrets = config.age.secrets;
in {
  age.secrets.gatus-environment.file = ./gatus-environment.age;

  services.gatus = {
    environmentFile = secrets.gatus-environment.path;
    settings = {
      alerting = {
        mattermost = {
          webhook-url = "\${MATTERMOST_WEBHOOK_URL}";
          default-alert.enabled = true;
          default-alert.send-on-resolved = true;
        };
      };

      endpoints = [{
        name = "matter";
        url =
          "https://matter-pp.duckdns.org/api/v4/system/ping?get_server_status=true";
        interval = "5s";
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
          "[BODY].database_status == OK"
          "[BODY].filestore_status == OK"
        ];

        alerts = [{
          type = "mattermost";
          description = "Mattermost chat is unhealthy.";
        }];
      }];
    };
  };
}
