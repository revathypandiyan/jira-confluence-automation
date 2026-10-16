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