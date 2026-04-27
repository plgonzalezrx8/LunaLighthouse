# Frequently Asked Questions

## Modules

### How Do I Install a "Module"?

Modules are the external services LunaLighthouse can connect to, such as Lidarr, Radarr, Sonarr, NZBGet, SABnzbd, and Tautulli. These services must be installed and maintained separately on a home computer or server. LunaLighthouse provides the mobile/client interface; it does not install or operate those services for you.

### Why Are Some Services Not Supported?

LunaLighthouse intentionally focuses on deeper support for a smaller set of modules instead of shallow support for every possible media-management tool. New modules are evaluated against maintenance cost, API quality, platform policy risk, and whether maintainers can support a complete implementation.

### Will Torrent Clients Be Supported?

Torrent-client support remains outside the current relaunch scope. App-store policy risk and platform-review constraints make this area sensitive, so any future work needs a separate product and compliance review before implementation.

## Development

### Who Maintains LunaLighthouse?

LunaLighthouse is maintained by the LunaLighthouse maintainers and community contributors. Contributions are welcome through reviewed GitHub pull requests.

### What is LunaLighthouse Developed In?

LunaLighthouse is developed with [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/), allowing one codebase to target multiple platforms.

### How is LunaLighthouse Free?

LunaLighthouse is open-source software. The relaunch plan keeps the core application free to use while preserving the option to document project-owned funding or paid infrastructure decisions separately if maintainers approve them.

### Are There Ads or Paid Features?

There are no ads in the current relaunch baseline. Any future paid feature or recurring-cost recovery model should be documented publicly before release and should not compromise the open-source core experience.

## Bugs & Feedback

### I Found a Bug. How Do I Report It?

Please report reproducible bugs through GitHub Issues and include exported logs when relevant. Logs can be exported from the application settings.

* [GitHub Issues](https://www.lunalighthouse.app/github)
* [GitHub Discussions](https://github.com/plgonzalezrx8/LunaLighthouse/discussions)
* [Email](mailto:hello@lunalighthouse.app)

### How Can I Request a New Feature?

Feature requests should go through GitHub Discussions or GitHub Issues so the maintainers can triage them in public and link them to implementation work.

* [GitHub Discussions](https://github.com/plgonzalezrx8/LunaLighthouse/discussions)
* [Email](mailto:hello@lunalighthouse.app)

{% hint style="info" %}
Maintainers may not be able to respond to every request directly, but public requests help keep roadmap decisions visible.
{% endhint %}

## Support

### Why Don't The Settings Explain Much?

The settings section is intentionally concise to keep the application focused. Detailed setup guidance belongs in the documentation where it can be updated without app-store review delays.

### "X" Won't Connect, Help!

Initial setup can be simple or painful depending on network layout, reverse proxies, service API keys, and local firewall rules. Use the support channels above and include the affected module, app platform, service version, and exported logs when possible.

A few quick tips on common problems:

* `localhost` and `0.0.0.0` mean "this computer". They should not be used as the host when LunaLighthouse runs on a different device. Use the local IP address of the computer/server running the service instead.
* Ensure the API key matches the correct service.
* For -arr services, ensure the binding address in advanced general settings is not limited to `127.0.0.1` or `localhost`; use `0.0.0.0`, `*`, or the host machine's local IP address where appropriate.
* For download clients, ensure the host is reachable from the device running LunaLighthouse.
* Add `http://` or `https://` before the IP address or domain. LunaLighthouse does not assume the protocol.
* Avoid `3xx` redirecting webpages for module endpoints. Redirects are not supported for all POST and PUT requests.
* _(Windows Only)_: Some services must be run as administrator to bind correctly to the network interface.

### How Can I Access My Services Remotely?

Remote access is outside the core LunaLighthouse application scope, but common approaches include:

* **Reverse proxy**: exposes services through a domain and HTTPS. Common options include [NGINX Proxy Manager](https://nginxproxymanager.com/), [Traefik](https://traefik.io/), [NGINX](https://nginx.org/), and [Apache](https://www.apache.org/).
* **VPN tunnelling**: connects back to the home network using tools such as [WireGuard](https://www.wireguard.com/) or [OpenVPN](https://openvpn.net/).
* **Direct port forwarding**: not recommended because it increases exposure and is easy to configure insecurely.

### Where Can I Send Complaints or Critical Feedback?

Use GitHub Discussions or [email the maintainers](mailto:hello@lunalighthouse.app). Please keep feedback specific, actionable, and respectful toward maintainers and community members.
