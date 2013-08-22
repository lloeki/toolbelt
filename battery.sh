#!/bin/bash

legacyinfo=$(ioreg -l -w 2048 | grep 'LegacyBatteryInfo')

get_attribute()
{
    echo $legacyinfo | sed "s/.*\"$@\"=\([^,}][^,}]*\)[,}].*/\1/" 
}

is_negative()
{
    [ $(echo "$@ > (2^63-1)" | bc) == "1" ]
}

two_complement()
{
    echo "2^64 - $@" | bc
}

fix_negative()
{
    # is the value negative?
    if is_negative "$@"; then
        # compute two's complement
        echo "-$(two_complement "$@")"
    else
        echo "$@"
    fi
}

get_integer_attribute()
{
    fix_negative "$(get_attribute "$@")"
}

amperage()
{
    get_integer_attribute 'Amperage'
}

full_capacity()
{
    get_integer_attribute 'Capacity'
}

current_capacity()
{
    get_integer_attribute 'Current'
}

voltage()
{
    get_integer_attribute 'Voltage'
}

cycle_count()
{
    get_integer_attribute 'Cycle Count'
}

discharge_time()
{
    hours=$(echo "-$(current_capacity) / $(amperage)" | bc)
    minutes=$(echo "-( $(current_capacity) % $(amperage) ) * 60 / $(amperage)" | bc)
    echo "$hours:$minutes"
}

full_discharge_time()
{
    hours=$(echo "-$(full_capacity) / $(amperage)" | bc)
    minutes=$(echo "-( $(full_capacity) % $(amperage) ) * 60 / $(amperage)" | bc)
    echo "$hours:$minutes"
}

charge_time()
{
    hours=$(echo "( $(full_capacity) - $(current_capacity) ) / $(amperage)" | bc)
    minutes=$(echo "( ( $(full_capacity) - $(current_capacity) ) % $(amperage) ) * 60 / $(amperage)" | bc)
    echo "$hours:$minutes"
}

full_charge_time()
{
    hours=$(echo "$(full_capacity) / $(amperage)" | bc)
    minutes=$(echo "( $(full_capacity) % $(amperage) ) * 60 / $(amperage)" | bc)
    echo "$hours:$minutes"
}

remaining_time()
{
    if [ $(echo "$(amperage) < 0" | bc) == "1" ]; then
        discharge_time
    elif [ $(echo "$(amperage) > 0" | bc) == "1" ]; then
        charge_time
    else
        echo "0:00"
    fi
}

full_time()
{
    if [ $(echo "$(amperage) < 0" | bc) == "1" ]; then
        full_discharge_time
    elif [ $(echo "$(amperage) > 0" | bc) == "1" ]; then
        full_charge_time
    else
        echo "0:00"
    fi
}

charge_ratio()
{
    echo "$(echo "(  $(current_capacity) * 100 / $(full_capacity) )" | bc)%"
}

attributes=('amperage' 'full_capacity' 'current_capacity' 'voltage' 'cycle_count' 'remaining_time' 'charge_ratio' 'full_time')

for ((i=0;i<${#attributes[*]};i++)); do
    data=$(${attributes[$i]})
    echo "${attributes[$i]}: $data"
done

