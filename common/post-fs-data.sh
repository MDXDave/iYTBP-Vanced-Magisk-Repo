#!/system/bin/sh

MODDIR=${0%/*}

# Detach/Attach Apps from playstore by hinxnz modified for the Youtube Vanced project

PLAY_DB_DIR=/data/data/com.android.vending/databases
DETACHENABLED=/data/youtube-vanced-detach-enabled
DETACHDISABLED=/data/youtube-vanced-detach-disabled

if [ ! -e $DETACHENABLED ] && [ ! -e $DETACHDISABLED ]; then
    exit 0
fi

if [ -e $DETACHDISABLED ]; then
    (while [ 1 ]; do
    if [ `getprop sys.boot_completed` = 1 ]; then sleep 60
	pm enable 'com.android.vending/com.google.android.finsky.dailyhygiene.DailyHygiene'$'DailyHygieneService\'
	pm enable 'com.android.vending/com.google.android.finsky.hygiene.DailyHygiene'$'DailyHygieneService\'
	am startservice 'com.android.vending/com.google.android.finsky.dailyhygiene.DailyHygiene'$'DailyHygieneService\'
	am startservice 'com.android.vending/com.google.android.finsky.hygiene.DailyHygiene'$'DailyHygieneService\'
	rm -f $DETACHENABLED
	rm -f $DETACHDISABLED
	exit; fi
    done &)
fi

if [ -e $DETACHENABLED ]; then
    (while [ 1 ]; do
	if [ `getprop sys.boot_completed` = 1 ]; then sleep 60
	pm disable 'com.android.vending/com.google.android.finsky.hygiene.DailyHygiene$DailyHygieneService'
	am force-stop com.android.vending
	cd $MODDIR
	./sqlite $PLAY_DB_DIR/library.db "DELETE from ownership where doc_id = 'com.google.android.youtube'";
	./sqlite $PLAY_DB_DIR/localappstate.db "DELETE from appstate where package_name = 'com.google.android.youtube'";
	exit; fi
    done &)
fi