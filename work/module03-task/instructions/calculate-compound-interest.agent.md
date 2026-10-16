---
name: "Calculate Compound Interest"
description: "Use the compound-interest script for basic periodic-growth estimates and present its assumptions and results clearly."
tools: []
user-invocable: true
---
Use this workflow when the user asks for a basic compound-interest estimate based on an initial principal, annual interest rate, duration, and compounding frequency. Do not use it for investment recommendations, taxes, inflation-adjusted projections, deposits, or withdrawals.

## Invoke the Script
- Run from the `module03-task` project directory with all four positional arguments in this order: principal, annual rate percent, years, compounding periods per year.
- Example: `python tools/compound_interest.py 10000 6.5 10 12`.
- Enter the annual rate as a percentage number (`6.5` means 6.5, not `0.065`). The principal is in whatever currency or unit the user provides; the script does not assign a currency.
- Use a positive integer for compounding periods per year, such as `1` (annually), `4` (quarterly), or `12` (monthly). Principal, rate, and years must be nonnegative.
- If any argument is omitted, provide none: the script then prompts for all four values. Do not pass only some arguments.
- If `python` is unavailable, use the environment's configured Python interpreter to run the same script and arguments. Do not claim a result unless execution succeeds.

## Present Results
- Report the final balance and interest earned exactly as returned, to two decimal places.
- State the principal, annual rate, duration, compounding frequency, and units or currency only when provided by the user.
- Explain that the estimate applies periodic compounding using the supplied fixed rate and assumes no additional deposits, withdrawals, fees, taxes, or inflation adjustment.
- Treat the result as a mathematical estimate, not a guarantee or financial recommendation. If the script reports invalid input or execution fails, explain the issue and do not invent a result.