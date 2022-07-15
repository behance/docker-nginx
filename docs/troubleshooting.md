# Troubleshooting

* [io_setup() failed](#iosetup-failed)

## io_setup failed

**Symptom**

During start up, you see:

```shell
cont-init.d] done.
[services.d] starting services
2022/07/15 14:48:57 [emerg] 1015#1015: io_setup() failed (38: Function not implemented)
2022/07/15 14:48:57 [emerg] 1017#1017: io_setup() failed (38: Function not implemented)
2022/07/15 14:48:57 [emerg] 1019#1019: io_setup() failed (38: Function not implemented)
2022/07/15 14:48:57 [emerg] 1020#1020: io_setup() failed (38: Function not implemented)
[services.d] done.
```

**Resolution**

You might be running docker with emulation i.e. `docker run --platform linux/amd64`.

If so, you need to run it natively on an ARM64 computer. See [StackOverflow](https://stackoverflow.com/questions/68704538/error-io-setup-failed-38-function-not-implemented-in-nginx-for-arm-m1)