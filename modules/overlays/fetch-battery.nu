# Provides information about the laptop's battery
def main []: nothing -> record {
    cd /sys/class/power_supply/BAT0

    # TODO: function for milli watt hour conversion
    # also maybe look at the documentation from linux

    let current = open energy_now | into int | $in / 1_000_000;
    let full = open energy_full | into int | $in / 1_000_000;
    let full_design = open energy_full_design | into int | $in / 1_000_000;

    let cycles = open cycle_count | into int;
    let charge = open capacity | into int;

    {
        status: (open status),
        charge: $charge,
        health: ($full / $full_design * 100),

        cycles: $cycles,

        current: $current,
        full: $full,
        full_design: $full_design,
    }
}
