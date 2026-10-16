---
name: "Calculate Asset Total"
description: "Use when totaling named financial assets with the calculate_assets.py command-line tool."
tools: []
user-invocable: true
---
Use this workflow when the user provides financial asset names and values and asks for their combined total. Do not include awareness-only possessions in the calculation.

## Invoke the Script
- From the `module03-task` project directory, run `python tools/calculate_assets.py` with one or more `--asset NAME VALUE` pairs.
- Example: `python tools/calculate_assets.py --asset "Savings account" 125000.50 --asset "Fixed deposit" 80000`.
- Quote asset names containing spaces. Enter each value as a non-negative number; the script accepts decimal values.
- Provide at least one complete pair. Do not omit a name or value, and do not include possessions that are not financial assets.
- If `python` is unavailable, use the environment's configured Python interpreter to run the same script. Do not claim a calculated total unless execution succeeds.

## Present Results
- Report the total exactly as printed by the script, including the `₹` symbol, Indian digit grouping, and two decimal places.
- State which assets were included when that helps distinguish financial assets from excluded possessions.
- Do not infer additional asset values, assign a currency other than INR, or imply the total accounts for liabilities unless the user asks for a separate calculation.
- If an input is rejected or execution fails, explain the issue and do not invent a total.