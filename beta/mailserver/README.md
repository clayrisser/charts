# mailserver

> fullstack but simple mailserver

## Relay Settings

When configuring a relay, it is recommended to use the `relay` transport
even though the `smtp` transport would technically work. This ensures
there is a clean separation between transports sending emails to their
final destination with the `smtp` transport and emails being relayed with
the `relay` transport. The separation allows more fine grained control.

### transport

This config is a hash for the postfix `transport_maps` parameter. The
configuration will be set in the `/etc/postfix/transport` file.

This is used to route to the next hop or relay based on the recipient
or more specifically based on the `rcpt to` set on the envelope.

If a transport is not found in the `transport_maps`, the
`sender_dependent_default_transport_maps` or `default_transport`
will be used. In other words, this `transport` config is evaluated
before the following `sender_map` config is evaluated. This means
that if a match all wildcard `*` is set, `sender_map` will never
be evaluated.

To ensure that `transport_maps` is configured correctly, the domain
of this mailserver is automatically routed to the `local` transport.
In other words, `<CURRENT_DOMAIN> local` does not need to be added
to this config because it will automatically be applied.

Below is an example of a **transport** config that routes emails being sent
to gmail accounts through a sendinblue relay. Note that the square brackets
in the config prevent an unnecessary dns lookup.

```
gmail.com    relay:[smtp-relay.sendinblue.com]:587
```

As stated earlier, assuming my email server domain is _example.com_, the `transport`
config will be translated to the following postfix `transport_maps` parameter.
This enures local email is immediately sent to the correct location without being
unnecessarily routed through a relay.

```
example.com    local
gmail.com      relay:[smtp-relay.sendinblue.com]:587
```

You can find additional documentation for this option at the
links below.

- http://www.postfix.org/postconf.5.html#transport_maps
- http://www.postfix.org/transport.5.html

### sender map

This config is a hash for the postfix `sender_dependent_default_transport_maps`
parameter. The configuration will be set in the `/etc/postfix/sender_map` file.

This is used to route to the next hop or relay based on the sender or more
specifically based on the `email from` set on the envelope.

It is important to note that the `sender_dependent_default_transport_maps`
overrides the `default_transport`. In other words, this `sender_map` will not
be evaluated unless the previous `transport` config is unable to find a transport.

If a transport is not found when `sender_dependent_default_transport_maps` is evaluated,
then the `default_transport` will be used. `default_transport` is set to the `smtp`
transport by default.

Below is an example of a **sender map** config that routes emails being sent from the
postmaster account to sendinblue, assuming my email server domain is _example.com_.

```
postmaster@example.com    relay:[smtp-relay.sendinblue.com]:587
```

You can find additional documentation for this option at the
links below.

- http://www.postfix.org/postconf.5.html#sender_dependent_default_transport_maps
- http://www.postfix.org/transport.5.html

### default transport

This config will set the postfix `default_transport` parameter. It configures the
transport that is used if no transport is found in `transport_maps` or
`sender_dependent_default_transport_maps`. By default it is set to `smtp`, which tries
to directly deliver the email. This will not work if the outgoing mail port `25` is blocked.

Below is an example setting the **default transport** to relay emails to sendinblue.

```
relay:[smtp-relay.sendinblue.com]:587
```

You can find additional documentation for this option at the
links below.

- http://www.postfix.org/postconf.5.html#default_transport
- http://www.postfix.org/transport.5.html

### fallback relay

The fallback relay config will set the postfix `smtp_fallback_relay` parameter. If
an smtp destination cannot be reached or the primary relay host is offline, postfix
will use this fallback relay host.

Below is a example using sendinblue as the **fallback relay**.

```
[smtp-relay.sendinblue.com]:587
```

You can find additional documentation for this option at the
links below.

- http://www.postfix.org/postconf.5.html#fallback_relay
- http://www.postfix.org/transport.5.html

### sasl passwd

This config is a hash for the postfix `smtp_sasl_password_maps`
parameter. The configuration will be set in the `/etc/postfix/sasl_passwd` file.

This is used to used to authenticate any relay configured in the previous transport,
sender map, or fallback relay config.

Below is an example of a **sasl passwd** config that authenticates the sendinblue
relay.

```
[smtp-relay.sendinblue.com]:587    <SENDINBLUE_SMTP_USERNAME>:<SENDINBLUE_SMTP_PASSWORD>
```

You can find additional documentation for this option at the
links below.

- http://www.postfix.org/postconf.5.html#smtp_sasl_password_maps
- http://www.postfix.org/transport.5.html

## Resources

You can find additional resources at the links below.

- http://www.postfix.org/postconf.5.html
- http://www.postfix.org/transport.5.html
- https://docker-mailserver.github.io/docker-mailserver/edge
- https://github.com/docker-mailserver/docker-mailserver-helm
- https://kruyt.org/running-a-mailserver-in-kubernetes
- https://serverfault.com/questions/426060/outbound-email-loadbalance-with-multiple-ips
- https://shami.blog/2016/04/randomize-source-ip-addresses-with-postfix
- https://www.linode.com/docs/guides/postfix-smtp-debian7
- https://www.linuxbabe.com/mail-server/postfix-transport-map-relay-map-flexible-email-delivery
- https://www.reddit.com/r/sysadmin/comments/3vi9v2/how_to_have_postfix_vary_the_smtp_relay_depending
- https://www.tauceti.blog/posts/run-postfix-in-kubernetes
- https://www.thesysadmin.rocks/2020/01/13/postfix-sender_dependent_default_transport_maps-per-domain-outgoing-ip
