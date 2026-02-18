> [!NOTE]
> You don't need to use `partskite-klassy-maker` script for KDE Plasma version 6.6 or latest

# partskite-klassy-maker

Shell script to create (read: duplicate) a new customizable Klassy-Breeze global theme from installed Kite global theme, which savable &amp; remember with your configurations when light/dark theme changes.

<p align="center">
<picture>
  <source srcset="https://github.com/user-attachments/assets/e0277024-9617-4acc-884c-282198eafd5a" media="(prefers-color-scheme: light)">
  <source srcset="https://github.com/user-attachments/assets/fe4e6a4d-f668-4c01-ac99-f0f957b9bc1c" media="(prefers-color-scheme: dark)">
  <img src="https://github.com/user-attachments/assets/e0277024-9617-4acc-884c-282198eafd5a" />
</picture>
</p>


## Before You Begin

Use this script wisely (for personal customizing use, not recommended for ricing/_unix-porning_ activities), as it may violate the true philosophy of Kite Global Theme, as stated in:

> The default _Kite_ theme is designed to be pragmatic for long-term every-day use, _not for instant likes on social media or “ricing sites”_. Kite is the result of Paul A McAuley evolving the Breeze theme to be arguably more polished and usable, with influences from the original Breeze design, the “Blue Ocean” refresh, and the original KDE 1. A kite floats in the breeze! 

Source: https://github.com/paulmcauley/klassy/blob/plasma6.5/README.md 


## How to Use

Simply run this command below without bothering to clone or download this script.

- For `curl`
  ```shell
  bash <(curl -sL https://raw.githubusercontent.com/yoelwep13578/partskite-klassy-maker/refs/heads/main/partskite-klassy.sh)
  ```
  
- for `wget`
  ```shell
  bash <(wget -qO- https://raw.githubusercontent.com/yoelwep13578/partskite-klassy-maker/refs/heads/main/partskite-klassy.sh)
  ```


## How it Started

I really like the Klassy theme, especially how it can be customized in Window Decoration and its integration with Application Style, as well as how the Klassy developers [improved the “icon language” for better human-computer interaction](https://github.com/paulmcauley/klassy/discussions/263).

I usually use the Light and Dark themes that switch between light and dark (where I need the Light theme to be closer to white rather than staying dark), and I also like the color scheme that can match the wallpaper I use. Unfortunately, I need some of the Breeze theme “components,” especially for Plasma Style, so that the Plasma theme colors and color scheme can be as dynamic as Breeze in general. This is what's a little confusing when trying to use this combination in KDE's built-in Light/Dark Automatic feature.

<p align="center">
  <picture>
    <source width="70%" srcset="https://github.com/user-attachments/assets/7aa9f4e4-075a-4833-a9a6-57710ad2a9ff" media="(prefers-color-scheme: light)">
    <source width="70%" srcset="https://github.com/user-attachments/assets/2eb90718-84a1-4a55-b2ce-6a5b1ac0ce61" media="(prefers-color-scheme: dark)">
    <img width="70%" src="https://github.com/user-attachments/assets/7aa9f4e4-075a-4833-a9a6-57710ad2a9ff">
  </picture>
</p>

So, I created this Partskite/Partsklassy script to create a copy of the Kite global theme, replacing the Klassy plasma style with Breeze and making it remember the settings (not reset) when the light and dark changes. The created partsklassy theme also works well with KDE built-in Light/Dark theme changer feature.

> _Why is it called Partsklassy/Partskite?_ Well, this name is inspired by how people refer to Stratocaster/Telecaster guitars made from parts as Partscasters. So this global theme was created (read: duplicated) with some klassy/kite parts --> hence Partsklassy/Partskite.
>
> <img src="https://github.com/user-attachments/assets/7384d695-4a6c-4e86-91d0-7cab4cde55a4" />

I made this just for fun. Maybe this is just a temporary solution.


## How it Works

Klassy [8 Feb 2026] has a global Kite theme with 4 types stored in `/usr/share/plasma/look-and-feel`, including:

- Kite Light Left Panel
- Kite Dark Left Panel
- Kite Light Bottom Panel (`org.kde.klassykitelightbottompanel.desktop`)
- Kite Dark Bottom Panel (`org.kde.klassykitedarkbottompanel.desktop`)

The folder to be copied (read: duplicated) are the Kite Light Bottom Panel and Kite Dark Bottom Panel. This is roughly the structure of the files to be copied.

```
contents
    ...
    plasmoidsetupscripts
        ...
    defaults
metadata.json
```

The `metadata.json` file will be edited like this:

```
{
    "KPackageStructure": "Plasma/LookAndFeel",
    "KPlugin": {
        "Authors": [
            {
                "Email": "kde@paulmcauley.com",
                "Name": "Paul A McAuley"
            }
        ],
        "Category": "",
        "Description": "[Light / Dark] theme with savable configurations",
        "Id": "[FOLDER NAME]",
        "License": "LGPL 2.1",
        "Name": "[GLOBAL THEME NAME]",
        "Website": "https://github.com/paulmcauley/klassy"
    },
    "X-Plasma-APIVersion": "2"
}
```

The `defaults` file will be edited like this:

```
[kcminputrc][Mouse]
cursorTheme=breeze_cursors

[kdeglobals][General]
ColorScheme=[BreezeLight / BreezeDark]

[kdeglobals][Icons]
Theme=[klassy / klassy-dark]

[kdeglobals][KDE]
widgetStyle=Klassy

[kwinrc][org.kde.kdecoration2]
library=org.kde.klassy
theme=Klassy

[plasmarc][Theme]
name=default

[KSplash]
Theme=org.kde.Breeze
```

You will be asked to fill in:
- Global theme name with these options <br>
  Filling `[GLOBAL THEME NAME]`

- Save location, with options:
  - User-only `~/.local/share/plasma/look-and-feel` (good for easy deletion)
  - System-wide `/usr/share/plasma/look-and-feel` (like default Klassy global themes placed)
  - Custom (for testing or create-share purpose)


Once completed and confirmed, the two previous folders will be copied with the new contents and names that have been adjusted according to the information you provided.


## Credit

- paulmcauley (Paul A McAuley), klassy, GitHub
