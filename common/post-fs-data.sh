#!/system/bin/sh

MODDIR=${0%/*}

# Detach/Attach Apps from playstore by hinxnz modified for the Youtube Vanced project
# Later modified by MCMotherEffin' for proper Magisk / detach compatibility

PLAY_DB_DIR=/data/data/com.android.vending/databases
DETACHENABLED=$MODDIR/enable_detach;
DETACHDISABLED=$MODDIR/disable_detach;

if [ ! -e $DETACHENABLED ] && [ ! -e $DETACHDISABLED ]; then
    exit 1;
fi;

(
while [ 1 ]; do
    if [ `getprop sys.boot_completed` = 1 ]; then
        sleep 60;
        if [ -e $DETACHDISABLED ]; then
            pm enable 'com.android.vending/com.google.android.finsky.dailyhygiene.DailyHygiene'$'DailyHygieneService\'
	    pm enable 'com.android.vending/com.google.android.finsky.hygiene.DailyHygiene'$'DailyHygieneService\'
	    am startservice 'com.android.vending/com.google.android.finsky.dailyhygiene.DailyHygiene'$'DailyHygieneService\'
	    am startservice 'com.android.vending/com.google.android.finsky.hygiene.DailyHygiene'$'DailyHygieneService\'
	    rm -f $DETACHENABLED
	    rm -f $DETACHDISABLED
        elif [ -e $DETACHENABLED ]; then
	    pm disable 'com.android.vending/com.google.android.finsky.hygiene.DailyHygiene$DailyHygieneService'
	    am force-stop com.android.vending
	    cd $MODDIR
	    ./sqlite $PLAY_DB_DIR/library.db "DELETE from ownership where doc_id = 'com.google.android.youtube'";
	    ./sqlite $PLAY_DB_DIR/localappstate.db "DELETE from appstate where package_name = 'com.google.android.youtube'";
	fi;
	break;
    else
        sleep 1;
    fi;
done &)
