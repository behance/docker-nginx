brotli
====

This is a simple [dgoss] test to validate that the brotli module is running.

To test:

1. cd `tests/brotli`
1. Run `make dgoss`

Behind the scenes, it builds the `brotli`-enabled docker image, then builds
a test image.

Finally, it runs `dgoss` and passes in `Accept-Encoding: gzip, deflate, br`
as part of the request.

Here's a sample curl request when `SERVER_ENABLE_NGX_BROTLI=true`:

```shell
$ curl http://localhost:8080/ -v -H "Accept-Encoding: gzip, deflate, br"
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8083 (#0)
> GET / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.64.1
> Accept: */*
> Accept-Encoding: gzip, deflate, br
>
< HTTP/1.1 200 OK
< Server: nginx
< Date: Wed, 17 Aug 2022 21:41:21 GMT
< Content-Type: text/html
< Last-Modified: Wed, 17 Aug 2022 17:59:04 GMT
< Transfer-Encoding: chunked
< Connection: keep-alive
< ETag: W/"62fd2c68-279"
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< Content-Encoding: br
<
Warning: Binary output can mess up your terminal. Use "--output -" to tell
Warning: curl to output it to your terminal anyway, or consider "--output
Warning: <FILE>" to save to a file.
* Failed writing body (0 != 299)
* Failed writing data
* Closing connection 0
```

The script assumes that you have `dgoss` installed. 

[dgoss]: https://github.com/aelsabbahy/goss/blob/master/extras/dgoss/README.md
