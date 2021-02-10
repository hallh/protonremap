# ProtonBridge IMAP Proxy

This is a simple tool to work around some current issues with syncing emails using the ProtonMail Bridge. You can use this to build a Docker image, that when run, will rewrite unsupported IMAP queries to allow your email client to sync with your inbox. This tool was put together specifically for *BlueMail for Linux (v. 1.1.63-3.1.82-21)* and *ProtonMail Bridge (v. 1.5.7)*, but may work with other clients, YMMV.

### Who should use it?

Ideally, no one should. This is a terrible hack, which I should be ashamed of releasing, but it was the only way to make BlueMail sync with ProtonMail. A better solution would probably be to just use another email client, but for me personally, BlueMail is the only client for Linux that doesn't suck completely. Hence this hack.

### Why is this abomination needed and how does it work?

It's very simple. The ProtonMail Bridge has incomplete support for IMAPv4, and the following two issues are what's breaking it for BlueMail:

1. [No support boolean operators in search commands](https://github.com/ProtonMail/proton-bridge/issues/113).
2. [Error when fetching the body of a non-multipart message](https://github.com/ProtonMail/proton-bridge/issues/137).

To work around these two, this tool will set up a couple of proxies that rewrites the specific IMAP commands to something that the bridge supports.

Unfortunately, it means that you'll need to disable SSL/TLS when connecting your email client to the proxy. Given the fact that the bridge is most likely running on your local system, this may or may not be an acceptable trade-off for you.

It would of course be possible to implement this to provide an SSL-enabled proxy that handles the rewriting directly, but this mix-and-match of existing tools put in a Docker container is the working solution I could come up with in an evening's time. I'll be happy to receive PRs with improvements if anyone has the same problem and an evening to spare.

### How to use it?

To build the image and run the container, do this:

```sh
$ git clone https://github.com/hallh/protonremap
$ cd protonremap
$ ./build.sh
```

To run it, do this:

```sh
$ docker run --net=host --restart always -d -m 32m protonremap:0.0.1
```

To connect your email client:

1. Configure ProtonMail Bridge to use port `1143` for IMAP.
2. Configure your email client to connect to `127.0.0.1:3143` **without SSL/TLS, nor STARTTLS**.

### Final remarks

This tool can work for macOS users too, but requires a change in the `stunnel.conf` file. You'll need to replace `127.0.0.1:1143` with `host.docker.internal:1143`, and then add `-p 3143` to the `docker run ...` command.

Enjoy.
