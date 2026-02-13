#!/bin/bash

# --- Primary Variable ---
SRC_DIR="/usr/share/plasma/look-and-feel"
LIGHT_SRC="org.kde.klassykitelightbottompanel.desktop"
DARK_SRC="org.kde.klassykitedarkbottompanel.desktop"

# --- Error Message ---
error_message() {
    echo -e "\e[31m\e[7m ERROR \e[27m $1\e[0m"
}

# --- Note Message ---
note_message() {
    echo -e "\e[33m\e[7m \e[3mi\e[23m NOTE \e[0m\e[27m $1"
}

# --- Centered Text ---
center() {
    local cols="$(tput cols)"
    printf "%$(((cols - ${#1}) / 2 ))s%s\n" "" "$1"
}

# --- 0. Show Name ---
center "┌──────────────────────────────────┐"
center "│         Partskite-Klassy         │"
center "└──────────────────────────────────┘"

echo -e "\nCreate (read: duplicate) new customizable Klassy-Breeze global theme from installed Kite Global Theme. \n\nUse this script wisely, as it may violate the true philosophy of Kite Klassy Global Theme, as stated in:\n"

echo -e " │ The default Kite theme is designed to be pragmatic for long-term every-day \n │ use, not for instant likes on social media or "ricing" sites. Kite is the \n │ result of Paul A McAuley evolving the Breeze theme to be arguably more \n │ polished and usable, with influences from the original Breeze design, the \n │ “Blue Ocean” refresh, and the original KDE 1. A kite floats in the breeze! \n\n Source: https://github.com/paulmcauley/klassy/blob/plasma6.5/README.md \n"

read -ep $'By pressing \e[7m[Enter]\e[27m, I have read and understood the consequences of my decision to run this script to create customizable partsklassy, which may violate the true philosophy as stated above.'

# --- 1. Is Kite Global Theme Exist/Installed ---
if [[ ! -d "$SRC_DIR/$LIGHT_SRC" ]] || [[ ! -d "$SRC_DIR/$DARK_SRC" ]]; then
    error_message "Kite Global Theme might not exist in $SRC_DIR. Make sure Klassy installed with latest version."
    center "Let’s check it in https://github.com/paulmcauley/klassy"
    exit 1
fi

while true; do
    # --- 2. Theme Name Selection ---
    echo
    echo "Select a new global theme name"
    echo "[1] Kite [Light/Dark] with Breeze (Klassy) --- [Default]"
    echo "[2] Partskite [Light/Dark]"
    echo "[3] Partsklassy [Light/Dark]"
    echo
    read -ep "Enter 1/2/3 (Default 1) --> " choice_name

    case ${choice_name:-1} in
        1) BASE_NAME="Kite" ; SUFFIX="with Breeze (Klassy)" ; break ;;
        2) BASE_NAME="Partskite" ; SUFFIX="" ; break ;;
        3) BASE_NAME="Partsklassy" ; SUFFIX="" ; break ;;
        *) echo -e "\e[33mPlease select correctly.\e[0m" ;;
    esac
done

while true; do
    # --- 3. Save Location Selection ---
    echo -e "\nSelect save location"
    echo "[1] User-only (~/.local/share/plasma/look-and-feel)"
    echo "[2] System-wide (/usr/share/plasma/look-and-feel) --- [sudo will prompted]"
    echo "[3] Custom (Just testing or create-share purpose)"
    note_message "Saving in User-only is recommended for easy deletion when you regretted.\nSystem-wide is default save location for Kite Klassy after Klassy installation.\n"

    read -ep "Enter 1/2/3 --> " choice_path

    case $choice_path in
        1) TARGET_BASE="$HOME/.local/share/plasma/look-and-feel" ; break ;;
        2) TARGET_BASE="/usr/share/plasma/look-and-feel" ; break ;;
        3) read -ep $'\e[7m CUSTOM MODE \e[27m Enter custom path: ' TARGET_BASE ; break ;;
        *) echo -e "\e[33mPlease select correctly.\e[0m" ;;
    esac
done

# Remove trailing "/" from path
TARGET_BASE="${TARGET_BASE%/}"

while true; do
    # --- 4. Overview & Confirmation ---
    NAME_L="$BASE_NAME Light $SUFFIX"
    NAME_D="$BASE_NAME Dark $SUFFIX"
    ID_L="org.kde.${BASE_NAME,,}light.desktop"
    ID_D="org.kde.${BASE_NAME,,}dark.desktop"

    echo "──────────────────────────"
    echo "    SETTINGS OVERVIEW     "
    echo "──────────────────────────"
    echo "Copied Kite Light Folder : $TARGET_BASE/$ID_L"
    echo "Copied Kite Dark Folder  : $TARGET_BASE/$ID_D"
    echo "New Light Global Theme   : $NAME_L"
    echo "New Dark Global Theme    : $NAME_D"
    echo "Save Location            : $TARGET_BASE"
    echo "──────────────────────────"
    echo -e "\nContinue? \n    [y] Yes \n    [n] No & Exit \n    [c] Cancel & Restart\n"
    read -ep "Enter your selection --> " confirm

    case $confirm in
        [yY]) break ;;
        [nN]) exit 0 ;;
        [cC]) clear ; exec "$0" ;;
        *) echo -e "\e[33mPlease select correctly.\e[0m" ;;
    esac
done

# --- 5. Execution ---
process_theme() {
    local TYPE=$1
    local SRC_FOLDER=$2
    local TARGET_ID=$3
    local THEME_NAME=$4
    local COLOR_SCHEME=$5
    local ICON_THEME=$6

    local FINAL_DEST="$TARGET_BASE/$TARGET_ID"

    # Is sudo needed?
    local SUDO_CMD=""
    if [[ ! -w "$TARGET_BASE" ]]; then
        SUDO_CMD="sudo"
        echo -e "\e[33mNeed superuser or root to write changes in $TARGET_BASE\e[0m"
    fi

    echo "Processing $TYPE global theme to $FINAL_DEST..."

    # Create directory
    $SUDO_CMD mkdir -p "$FINAL_DEST" || error_message "Failed to create folder."

    # Copy folder contents inside (except "layouts")
    $SUDO_CMD cp -r "$SRC_DIR/$SRC_FOLDER/." "$FINAL_DEST/"
    $SUDO_CMD rm -rf "$FINAL_DEST/contents/layouts"

    # Update metadata.json
    cat <<EOF | $SUDO_CMD tee "$FINAL_DEST/metadata.json" > /dev/null
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
        "Description": "$(echo $TYPE | sed 's/./\U&/') theme with savable configurations",
        "Id": "$TARGET_ID",
        "License": "LGPL 2.1",
        "Name": "$THEME_NAME",
        "Website": "https://github.com/paulmcauley/klassy"
    },
    "X-Plasma-APIVersion": "2"
}
EOF

    # Update file defaults
    cat <<EOF | $SUDO_CMD tee "$FINAL_DEST/contents/defaults" > /dev/null
[kcminputrc][Mouse]
cursorTheme=breeze_cursors

[kdeglobals][General]
ColorScheme=$COLOR_SCHEME

[kdeglobals][Icons]
Theme=$ICON_THEME

[kdeglobals][KDE]
widgetStyle=Klassy

[kwinrc][org.kde.kdecoration2]
library=org.kde.klassy
theme=Klassy

[plasmarc][Theme]
name=default

[KSplash]
Theme=org.kde.Breeze
EOF
}

# Proceed field filling for Light dan Dark
process_theme "light" "$LIGHT_SRC" "$ID_L" "$NAME_L" "BreezeLight" "klassy"
process_theme "dark" "$DARK_SRC" "$ID_D" "$NAME_D" "BreezeDark" "klassy-dark"

echo -e "\n\e[32m\e[7m COMPLETED \e[27m Partsklassy global theme now available.\e[0m"
echo "You should apply this configureable kite global theme from Global Theme Settings rather than Quick Settings."
