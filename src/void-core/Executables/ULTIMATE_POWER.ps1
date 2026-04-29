# Ultimate Power Plan Injection
# Unhides Core Parking and sets it to 0% for maximum consistent CPU frequency.

# Unhide Core Parking features in Power Options
$powerSettings = @(
    "0cc5b647-c1df-4637-891a-dec35c318583", # Processor performance core parking min cores
    "3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb", # Allow Throttle States
    "5d76a2ca-e8c0-402f-a133-2158492d58ad", # Processor idle disable
    "ea062031-0e34-4ff1-9b6d-eb1059334028", # Processor performance core parking max cores
    "8f7b45e3-c393-480a-878c-f4f58c139f5f"  # Processor performance core parking utility
)

foreach ($setting in $powerSettings) {
    # Unhide
    powercfg -attributes SUB_PROCESSOR $setting -ATTRIB_HIDE
}

# Duplicate High Performance Plan and rename to Void OS Ultimate
$highPerf = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
$guid = [guid]::NewGuid().ToString()

powercfg -duplicatescheme $highPerf $guid
powercfg -changename $guid "Void OS Ultimate Performance" "Engineered by Remo for zero latency and absolute maximum FPS."

# Set Parking to 0%
powercfg -setacvalueindex $guid SUB_PROCESSOR 0cc5b647-c1df-4637-891a-dec35c318583 100
powercfg -setdcvalueindex $guid SUB_PROCESSOR 0cc5b647-c1df-4637-891a-dec35c318583 100

powercfg -setacvalueindex $guid SUB_PROCESSOR 5d76a2ca-e8c0-402f-a133-2158492d58ad 1
powercfg -setdcvalueindex $guid SUB_PROCESSOR 5d76a2ca-e8c0-402f-a133-2158492d58ad 1

# Activate the plan
powercfg -setactive $guid
Write-Output "Void OS Ultimate Power Plan injected and activated."
