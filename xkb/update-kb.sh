# backup xkd settings
sudo cp /usr/share/X11/xkb/rules/evdev.xml /usr/share/X11/xkb/rules/evdev.xml.bak
sudo cp /usr/share/X11/xkb/symbols/ru /usr/share/X11/xkb/symbols/ru.bak
sudo cp /usr/share/X11/xkb/symbols/us /usr/share/X11/xkb/symbols/us.bak
sudo cp /etc/default/keyboard /etc/default/keyboard.bak

# update xkb
sudo cp xkb/rules/evdev.xml /usr/share/X11/xkb/rules/evdev.xml
sudo cp xkb/symbols/ru /usr/share/X11/xkb/symbols/ru
sudo cp xkb/symbols/us /usr/share/X11/xkb/symbols/us
sudo cp xkb/keyboard /etc/default/keyboard # kb layout on login screen
