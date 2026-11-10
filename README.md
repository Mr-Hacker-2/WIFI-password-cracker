# Wi-Fi Password Security — Science Fair Demo

An offline educational project about password strength. This repository uses **fictional sample data only**.

## Safety and scope

- Does not scan nearby Wi-Fi networks.
- Does not reveal, collect, store, or export saved Wi-Fi passwords.
- Does not attempt to guess or crack credentials.
- Does not connect to any network.
- All sample strings are invented and prefixed with `DEMO-ONLY-`.

Only use the project as an offline classroom demonstration.

## Files

| File | Purpose |
|---|---|
| `scan.bat` | Opens the local demonstration dataset in Notepad. It performs no network scan. |
| `WiFi_Passwords.txt` | Fictional sample dataset for comparing password characteristics. |

## How to run

1. Download both files into the same folder.
2. Double-click `scan.bat`.
3. Review the fictional samples in `WiFi_Passwords.txt`.
4. Compare length, repeated characters, predictable sequences, and multi-word phrases.
5. Record observations for your science fair display.

## Suggested experiment

**Question:** How do password length and predictability affect estimated password strength?

**Independent variables:** Sample length and pattern type.

**Dependent variable:** The strength category reported by an offline password-strength estimator.

**Controls:** Use the same estimator and settings for every fictional sample. Do not submit real passwords or test any sample against a Wi-Fi network.

**Important:** The ratings in the text file are illustrative starting labels, not measured results. Record the estimator's actual output separately and explain the method you used.

## Responsible use

Never collect or share real passwords. Never test a network unless you own it and have explicit permission. This project is designed to teach defensive password practices, not credential recovery.
