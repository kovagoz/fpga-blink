# Blinking LEDs with FPGA

With this logic the LEDs blink at 1, 2, 4 and 5 Hz.

![blinking LEDs](https://res.cloudinary.com/kovagoz/image/upload/s--Syx2dD5w--/c_scale,w_320/v1620164375/github/blink.gif)

To achive the desired frequencies I used counters.
Detailed description in the code.

## Deployment

Do it the usual way:

```sh
make && make install
```

## Simulate

To start the simulation, run this:

```sh
make test
```

It takes some minutes to get the result due to the low period times of blinking LEDs.

When the simulation is done, you can load the result to [GTKWave](http://gtkwave.sourceforge.net) to view the waveforms.
It will look like this:

![GTKWave screenshot](https://res.cloudinary.com/kovagoz/image/upload/s--05jL7_M9--/c_scale,w_640/v1620565875/github/Screenshot_2021-05-08_at_22.41.25.png)
