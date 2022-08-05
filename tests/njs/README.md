njs
====

This is a simple dgoss test to validate that the njs module is running.

To test:

1. cd `tests/njs`
1. Run `make dgoss`

Behind the scenes, it builds the `njs`-enabled docker image, then builds
a test image and copies over some test files

Finally, it runs `dgoss` and checks the `njs` enabled endpoint.

The script assumes that you have `dgoss` installed. 
