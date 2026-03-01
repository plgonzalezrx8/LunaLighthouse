# Web

Lunarr can be hosted as a web application for usage within any modern browser!

{% hint style="info" %}
If you want a stable experience, stick with stable releases. Want to test new builds of Lunarr? Read about the [build channels](https://docs.lunarr.app/getting-started/build-channels) to make the right choice!
{% endhint %}

## Hosted Builds

_Channel(s): `Stable`, `Beta`, `Edge`_

All web releases of Lunarr are available on hosted instances by the Lunarr team! All communication and data stored is client-side, but there are some limitations of the platform which can be [viewed here](https://docs.lunarr.app/getting-started/platform-restrictions).

{% tabs %}
{% tab title="Stable" %}
Access the stable release [here](https://web.lunarr.app/)!
{% endtab %}

{% tab title="Beta" %}
Access the beta release [here](https://beta.web.lunarr.app/)!
{% endtab %}

{% tab title="Edge" %}
Access the edge release [here](https://edge.web.lunarr.app/)!
{% endtab %}
{% endtabs %}

## Docker

_Channel(s): `Stable`, `Beta`, `Edge`_

All web releases of Lunarr are also available in officially hosted Docker images! There is currently only one value that needs to be configured which is the port mapping. Lunarr functions as a frontend application with all data being stored client-side.

{% tabs %}
{% tab title="Stable" %}
```
docker run -p 80:80 ghcr.io/pedrogonzalez/lunarr:stable
```
{% endtab %}

{% tab title="Beta" %}
```
docker run -p 80:80 ghcr.io/pedrogonzalez/lunarr:beta
```
{% endtab %}

{% tab title="Edge" %}
```
docker run -p 80:80 ghcr.io/pedrogonzalez/lunarr:edge
```
{% endtab %}
{% endtabs %}

## Build Bucket

_Channel(s): `Stable`, `Beta`, `Edge`_\
_Format(s): `.zip`_

All web releases are available in the [Build Bucket](https://builds.lunarr.app/#latest/)!

## GitHub Releases

_Channel(s): `Stable`_\
_Format(s): `.zip`_

All stable releases are available on GitHub via the [Releases](https://github.com/pedrogonzalez/Lunarr/releases) page!
