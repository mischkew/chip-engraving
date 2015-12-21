# Chip Engraving

Engraving RFID-chips with continuous numbers. These chips serve as door-opener at the Hasso-Plattner-Institute Potsdam.
The provided script compiles a shape-description into a set of SVG files.

<img src="http://i.imgur.com/GE75imP.jpg" width="300">
<img src="http://i.imgur.com/8ISBv4Z.png" width="300">


## Installation & Usage

You will need `npm` installed.

Just clone the repo...
```bash
git clone https://github.com/mischkew/chip-engraving
```

...and start the script.

```bash
FROM=1 TO=100 npm start
```

The `FROM` and `TO` parameter determine the range of the continuous numbering. This will generate svg files in a `./tags` subdirectory.
Adapt the size of your chip in `index.coffee`. 

**Happy Engraving**

<img src="http://i.imgur.com/7HudSNR.jpg" width="600">

## License 

MIT

## Credits

Thanks to [@adius](http://github.com/adius) for providing the shape and svg generator.
