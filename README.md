
This is a OpenWRT package. To compile, please download OpenWRT
buildroot and copy this directory to 'packages'. Then, select icee (M)
on menuconfig.

To compile as single package, then:

  $ make package/icee/compile

Please, compile on 32bits, as the OpenWRT does not work well on 64bits.
