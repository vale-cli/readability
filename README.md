# Readability

[Vale](https://vale.sh) rules for the common readability scores: Automated
Readability Index, Coleman–Liau, Flesch–Kincaid, Flesch reading ease,
Gunning fog, LIX, and SMOG. Each is graded a paragraph at a time, so the
alert lands on the paragraph that reads hard rather than on line one of the
file.

## Install

Requires Vale 3.23.0 or later.

```ini
StylesPath = styles
Packages = Readability

[*.md]
BasedOnStyles = Readability
```

```console
$ vale sync
```

Every score is on by default. Keep the score you care about and turn off
the rest, or raise a limit. `Polysyllables` is a suggestion, so it shows
with `MinAlertLevel = suggestion` or when a rule setting turns it up:

```ini
[*.md]
BasedOnStyles = Readability
Readability.SMOG = NO
Readability.LIX = NO
Readability.FleschKincaid[condition] = "> 10"
Readability.Polysyllables = warning
```

| Rule | Flags a paragraph whose |
| ---- | ---------------------- |
| `AutomatedReadability` | Automated Readability Index is above 8 |
| `ColemanLiau` | Coleman–Liau grade is above 9 |
| `FleschKincaid` | Flesch–Kincaid grade is above 8 |
| `FleschReadingEase` | Flesch reading-ease score is below 70 |
| `GunningFog` | Gunning fog index is above 10 |
| `LIX` | LIX score is above 35 |
| `SMOG` | SMOG grade is above 10 |
| `Polysyllables` | words have three or more syllables, one alert per word, as a suggestion. The words behind the SMOG and Gunning fog scores; turn it on while bringing a score down |

To grade the whole document instead, set the scope: `Readability.LIX[scope]
= text` measures the file's prose as one block, and the alert lands on line
one.

## Development

`./test.sh` runs each rule's cases with `vale test --coverage`.
