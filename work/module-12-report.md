# Module 12 Completion Report

## Instruction File
- Filename: `use-calculate-assets.agent.md`

```markdown
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
```

## Script File
- Filename: `calculate_assets.py`
- Language: Python

```python
import argparse
from decimal import Decimal, InvalidOperation


def calculate_asset_total(assets: list[tuple[str, Decimal]]) -> Decimal:
    """Return the sum of the supplied asset values."""
    return sum((value for _, value in assets), start=Decimal("0"))


def format_inr(amount: Decimal) -> str:
    """Format an amount with Indian digit grouping and two decimal places."""
    whole, fraction = f"{amount:.2f}".split(".")
    if len(whole) > 3:
        groups = [whole[-3:]]
        whole = whole[:-3]
        while whole:
            groups.append(whole[-2:])
            whole = whole[:-2]
        whole = ",".join(reversed(groups))
    return f"₹{whole}.{fraction}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Calculate the total value of assets in Indian Rupees."
    )
    parser.add_argument(
        "--asset",
        action="append",
        nargs=2,
        metavar=("NAME", "VALUE"),
        required=True,
        help="asset name and non-negative value; repeat for each asset",
    )
    arguments = parser.parse_args()

    assets: list[tuple[str, Decimal]] = []
    for name, raw_value in arguments.asset:
        if not name.strip():
            parser.error("asset names cannot be empty")
        try:
            value = Decimal(raw_value)
        except InvalidOperation:
            parser.error(f"asset value must be a valid number: {raw_value!r}")
        if not value.is_finite() or value < 0:
            parser.error("asset values must be finite and non-negative")
        assets.append((name, value))

    print(f"Total assets: {format_inr(calculate_asset_total(assets))}")


if __name__ == "__main__":
    main()
```

## Script Execution Output
```text
Python was not found; run without arguments to install from the Microsoft Store,
 or disable this shortcut from Settings > Apps > Advanced app settings > App exe
cution aliases.
```