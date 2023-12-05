#!/usr/bin/bash

# This rather clunky script is used by Anton to produce
# summaries of OpenLane runs, to help quickly compare
# what has changed, so as to speed up iterating config.json.
# 
# Usage: ./ammsum.sh [design_tag [upw_tag]]
# where:
#   design_tag  = the openlane/$design/runs/* tag of the main design run to summarise.
#   upw_tag     = the openlane/user_project_wrapper/runs/* tag to summarise.
# If both arguments are omitted, the script will attempt to
# summarise the pair of most recent runs.

design=top_raybox_zero_fsm
upw=user_project_wrapper

upw_dir=openlane/user_project_wrapper
tempdir=$(mktemp -d)

# Shortcut for summary.py.
# Usage: olsum SUMMARY_TYPE [DESIGN [EXTRA_ARGS]]
# SUMMARY_TYPE is e.g. full-summary.
# DESIGN defaults to user_project_wrapper.
# EXTRA_ARGS is appended if supplied after DESIGN.
function olsum() {
    stype=$1; shift
    design=${1:-user_project_wrapper}; shift
    echo summary.py --caravel --design "$design" --$stype $@
    summary.py --caravel --design "$design" --$stype $@
}


for step in DESIGN UPW; do

    echo "Step: $step"

    case $step in
    DESIGN)
        design_name=$design
        design_dir=openlane/$design_name
        if [ ! -z "$1" ]; then
            # Run is specified.
            run=$1
        else
            run='*'
        fi
        # Get the latest design run:
        drun=$(ls -1td $design_dir/runs/$run | head -1)
        drunid=$(basename $drun)
        design_metrics_date=$(stat -c%Z $drun/reports/metrics.csv)
        echo
        if [ ! -z "$1" ]; then
            echo "SELECTED design run:  >>>  $drunid  <<<  ($drun)"
        else
            echo "Latest design run:  >>>  $drunid  <<<  ($drun)"
        fi
        echo
        design_antenna_report=$drun/reports/signoff/46-antenna_violators.rpt
        design_checks_report=$drun/reports/signoff/37-sta-rcx_nom/multi_corner_sta.checks.rpt
        design_holds_report=$drun/reports/signoff/37-sta-rcx_nom/multi_corner_sta.min.rpt
        dgds=$drun/results/final/gds/$design_name.gds
        ;;
    UPW)
        design_name=$upw
        design_dir=openlane/$design_name
        if [ ! -z "$2" ]; then
            # Run is specified.
            run=$2
        else
            run='*'
        fi
        # Get the latest design run:
        drun=$(ls -1td $upw_dir/runs/$run | head -1)
        drunid=$(basename $drun)
        upw_metrics_date=$(stat -c%Z $drun/reports/metrics.csv)
        echo
        if [ ! -z "$2" ]; then
            echo "SELECTED UPW run:  >>>  $drunid  <<<  ($drun)"
        else
            echo "Latest UPW run:  >>>  $drunid  <<<  ($drun)"
        fi
        echo
        design_antenna_report=$drun/reports/signoff/30-antenna_violators.rpt
        design_checks_report=$drun/reports/signoff/20-sta-rcx_nom/multi_corner_sta.checks.rpt
        design_holds_report=$drun/reports/signoff/20-sta-rcx_nom/multi_corner_sta.min.rpt
        dgds=$drun/results/final/gds/$design_name.gds
        if [ -z "$2" ]; then
            if [ "$design_metrics_date" -ge "$upw_metrics_date" ]; then
                echo "ERROR: UPW's reports/metrics.csv is OLDER. Either the flow is running now, or it crashed."
                exit 1
            fi
        fi
        ;;
    esac

    # Make sure it is finished:
    if [ ! -f $drun/reports/metrics.csv ]; then
        echo "ERROR: reports/metrics.csv missing. Either the flow is running now, or it crashed."
        exit 1
    fi

    # Get GDS size:
    design_filesize=$(
        echo $(du -h $dgds; du -b $dgds) |
        awk '{print $1, "("$3")"}'
    )
    printf "| %30s | %20s |\n" 'Design final GDS size' "$design_filesize"

    # Get design dimensions:
    design_dims=$(printf '%.0fx%.0f' $(
        fgrep 'Floorplanned with width' $drun/openlane.log |
        awk '{print $5, $8}' |
        egrep -o '[0-9]+(\.[0-9]+)?'
    ))

    printf "| %30s | %20s |\n" 'Design macro dimensions' $design_dims

    # Get stuff out of summary.py
    # Ugly hack to get run NUMBER from summary.py:
    runnum=$(
        echo $(
            echo x | olsum summary $design_name --run 2>/dev/null |
            egrep ": $drunid\b"
        ) |
        awk -F'[: ]' '{print $1}'
    )
    printf "| %30s | %20s |\n" '(summary.py temp run num)' $runnum

    olsumfields="
        total_runtime
        FP_CORE_UTIL
        PL_TARGET_DENSITY
        OpenDP_Util
        synth_cell_count
        net_antenna_violations
        wns
        tns
        cells_pre_abc
        CoreArea_um
        NonPhysCells
        CLOCK_PERIOD
    "

    olsumdata=$(
        olsum full-summary $design_name --run $runnum
    )

    dsuccess=$(echo "$olsumdata" | fgrep 'flow_status :' | fgrep 'flow completed' >/dev/null && echo Yes || echo NO)
    printf "| %30s | %20s |\n" 'Flow success' $dsuccess

    # Interpret/print each field that we want:
    for f in $olsumfields; do
        printf "| %30s | " $f
        # echo -n "| $f | "
        v=$(egrep "^\s+$f" <<< "$olsumdata" | awk -F' :[ ]+' '{ print $2 }')
        case $f in
        total_runtime)
            printf "%20s" "$(awk -F'[hms]' '{print $1":"$2":"$3}' <<< "$v")"
            ;;
        OpenDP_Util)
            printf "%20s" "$v%"
            ;;
        *)
            printf "%20s" "$v"
            ;;
        esac
        echo " |"
    done

    echo "Setup, slews, caps:   $design_checks_report"
    echo "Unconstrained:"
    fgrep 'report_checks -unconstrained' -A 123456789 $design_checks_report |
        fgrep 'report_checks --slack_max' -B 123456789 |
        fgrep '= Typical Corner =' -A 123456789 |
        egrep '^Path Type:|\(VIOLAT|\(MET|No paths found.' |
        sed -e 's/^/    /'
    echo
    echo "slack_max:"
    fgrep 'report_checks --slack_max -0.01' -A 123456789 $design_checks_report |
        fgrep 'report_check_types -max_slew -max_cap -max_fanout -violators' -B 123456789 |
        fgrep '= Typical Corner =' -A 123456789 |
        egrep '^Path Type:|\(VIOLAT|\(MET|No paths found.' |
        sed -e 's/^/    /'
    echo
    echo "Slew, caps, fanout:"

    # This one is more involved. Dump the whole section to a temp file:
    tf=$tempdir/slewcapfan
    fgrep 'report_check_types -max_slew -max_cap -max_fanout -violators' -A 123456789 $design_checks_report |
        fgrep 'report_parasitic_annotation -report_unannotated' -B 123456789 |
        fgrep '= Typical Corner =' -A 123456789 > $tf
    # Print summary:
    egrep '^max.*violations count Typical' $tf |
        sed -e 's/^/    /'
    # Print max slew:
    echo
    echo "Max slew:"
    (
        capture="$(
        egrep '^max slew\s*$' $tf -A 123456 |
            egrep '^max fanout\s*$' -B 123456 |
            egrep 'Pin|---|VIOLATED'
        )"
        egrep 'Pin|---' <<< "$capture"
        capture="$(
            egrep 'VIOLATED' <<< "$capture"
        )"
        count=$(wc -l <<< "$capture")
        echo "$capture" | head -10
        echo
        if [ "$count" -gt 10 ]; then
            echo "Showing worst 10 out of $count"
        else
            echo "Showing all $count"
        fi
        echo
    ) | sed -e 's/^/    /'
    # Print fanout:
    echo
    echo "Fanout:"
    (
        capture="$(
        egrep '^max fanout\s*$' $tf -A 123456 |
            egrep '^max slew violations count' -B 123456 |
            egrep 'Pin|---|VIOLATED'
        )"
        egrep 'Pin|---' <<< "$capture"
        capture="$(
            egrep 'VIOLATED' <<< "$capture"
        )"
        count=$(wc -l <<< "$capture")
        echo "$capture" | head -10
        echo
        if [ "$count" -gt 10 ]; then
            echo "Showing worst 10 out of $count"
        else
            echo "Showing all $count"
        fi
        echo
    ) | sed -e 's/^/    /'
    # Print caps:
    echo
    echo "Max caps:"
    (
        capture="$(
        egrep '^max capacitance\s*$' $tf -A 123456 |
            egrep '^max slew violations count' -B 123456 |
            egrep 'Pin|---|VIOLATED'
        )"
        egrep 'Pin|---' <<< "$capture"
        capture="$(
            egrep 'VIOLATED' <<< "$capture"
        )"
        count=$(wc -l <<< "$capture")
        echo "$capture" | head -10
        echo
        if [ -z "$capture" ]; then
            echo "None"
        elif [ "$count" -gt 10 ]; then
            echo "Showing worst 10 out of $count"
        else
            echo "Showing all $count"
        fi
        echo
    ) | sed -e 's/^/    /'
    # Hold slack:
    echo
    echo "Hold slack:   $design_holds_report"
    tf=$design_holds_report
    (
        egrep 'worst slack corner Typical:' $tf
        egrep '= Typical Corner =' -A 123456789 $tf |
            egrep 'Startpoint:|VIOLATED' |
            egrep 'VIOLATED' -B1 |
            awk 'BEGIN {RS="Startpoint:"; FS="[\n]+"} {print $1, $2, $3, $4}' | sed -E 's/\s\s\s\s+/    /'
    ) | sed -e 's/^/    /'
    echo

    echo "Antennas:             $design_antenna_report"
    (
        capture="$(cat $design_antenna_report)"
        count=$(cat $design_antenna_report | wc -l)
        echo "$capture" | head -10
        echo
        if [ "$count" -eq 0 ]; then
            echo "None"
        elif [ "$count" -gt 10 ]; then
            echo "Showing worst 10 out of $count"
        else
            echo "Showing all $count"
        fi
        echo
    ) | sed -e 's/^/    /'

    echo

done
