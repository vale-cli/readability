# Readability

[Vale](https://vale.sh) rules for the common readability scores: Automated
Readability Index, Coleman–Liau, Flesch–Kincaid, Flesch reading ease,
Gunning fog, LIX, and SMOG, with a rule that names the polysyllables behind
them.

## Install

Requires Vale 2.13.0 or later.

```ini
StylesPath = styles
Packages = Readability

[*.md]
BasedOnStyles = Readability
```

```console
$ vale sync
```

Every score is on by default and grades the whole document, with the alert
on line one. Keep the score you care about and turn off the rest, or raise a
limit:

```ini
[*.md]
BasedOnStyles = Readability
Readability.SMOG = NO
Readability.LIX = NO
Readability.FleschKincaid[condition] = "> 10"
```

| Rule | Flags a document whose |
| ---- | --------------------- |
| `AutomatedReadability` | Automated Readability Index is above 8 |
| `ColemanLiau` | Coleman–Liau grade is above 9 |
| `FleschKincaid` | Flesch–Kincaid grade is above 8 |
| `FleschReadingEase` | Flesch reading-ease score is below 70 |
| `GunningFog` | Gunning fog index is above 10 |
| `LIX` | LIX score is above 35 |
| `SMOG` | SMOG grade is above 10 |

`Polysyllables` reports each word of three or more syllables, the words
behind the SMOG and Gunning fog scores. It is a suggestion, so it shows with
`MinAlertLevel = suggestion`, or when a setting turns it up while you bring
a score down:

```ini
Readability.Polysyllables = warning
```

## Grading by paragraph

On Vale 3.22.0 or later, a score can be scoped so that the alert lands on
the paragraph that reads hard rather than on line one:

```ini
[*.md]
BasedOnStyles = Readability
Readability.FleschKincaid[scope] = paragraph
Readability.SMOG[scope] = paragraph
```

## Development

`./test.sh` runs the cases in `tests/` with `vale test --coverage`, then
checks `fixtures/page.md` against the golden file in `testdata/` and
requires its rewrite in `fixtures/clean/` to pass clean. `./test.sh -u`
rewrites the golden file.
