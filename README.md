# latinobarometro

Stata command to download a Latinobarometro survey wave, optionally harmonize variable names across waves using Latinobarometro’s official time-series crosswalk, and construct country-population-scaled weights for pooled analysis.

## Requirements

- Stata 14 or later.
- Internet access for the first download of each survey wave and the
  crosswalk.
- `wbopendata` only when using `addpopulation`:

  ```stata
  ssc install wbopendata
  ```

The command downloads survey data directly from Latinobarometro and does not redistribute it. Users remain responsible for following Latinobarometro’s data terms and for citing the survey wave used.



## Installation

### From GitHub

After replacing `<USERNAME>` and `<REPOSITORY>` with this repository's values:

```stata
net install latinobarometro, ///
    from("https://raw.githubusercontent.com/jlopezton/latinobarometro-stata/main/")
```

To update an existing installation:

```stata
net install latinobarometro, ///
    from("https://raw.githubusercontent.com/jlopezton/latinobarometro-stata/main/") replace
```

### From SSC

Once the package is accepted by SSC:

```stata
ssc install latinobarometro
```

## Usage

```stata
latinobarometro, year(2020)
latinobarometro, year(2020) rename
latinobarometro, year(2020) rename addpopulation
latinobarometro, year(2020) rename cache("/path/to/lb_cache")
```

Run `help latinobarometro` after installation for the full documentation,
available years, options, and caveats.

## Caching and data

Downloaded files are cached locally. Use `cache()` to select another location
and `force` to refresh downloaded inputs. Do not commit downloaded `.dta`,
`.zip`, or crosswalk cache files to this repository.

`wt_lac` is a population-scaled survey weight for pooled point estimates. It
must be used with an appropriate `svyset` declaration that reflects the actual
national sampling design when design variables are available; it is not a
frequency weight.

## Development checks

`test_latinobarometro.do` is the pre-submission test script. Run it in Stata
with the repository folder on the ado path, preferably also in Stata 14.

## Citation

Please cite the relevant Latinobarometro wave. For example:

Latinobarómetro Study 2023. Latinobarómetro Corporation: 2023 Wave – Aggregated Version. Madrid: JD Systems Institute.

## License

General MIT License
The survey data themselves are not included and are governed by
Latinobarometro’s terms, not by the code license.


## Thanks to

This package was originally developed as an internal repository pulling command by Germán Reyes (World Bank-Cornell). Although I've been using beta versions of the program for years now, I finally came to 'formalize' the program recently using a mix of old code and the help of Claude.
