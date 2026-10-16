import argparse


def compound_interest(
    principal: float,
    annual_rate_percent: float,
    years: float,
    compounds_per_year: int,
) -> float:
    """Return the balance after periodic compounding."""
    if principal < 0:
        raise ValueError("Principal cannot be negative.")
    if annual_rate_percent < 0:
        raise ValueError("Annual rate cannot be negative.")
    if years < 0:
        raise ValueError("Years cannot be negative.")
    if compounds_per_year <= 0:
        raise ValueError("Compounding frequency must be positive.")

    periodic_rate = annual_rate_percent / 100 / compounds_per_year
    periods = compounds_per_year * years
    return principal * (1 + periodic_rate) ** periods


def main() -> None:
    """Read values from arguments or prompts and display the result."""
    parser = argparse.ArgumentParser(
        description="Calculate a balance with periodic compound interest."
    )
    parser.add_argument("principal", nargs="?", type=float, help="initial amount")
    parser.add_argument(
        "annual_rate_percent",
        nargs="?",
        type=float,
        help="annual interest rate as a percent, such as 5 for 5%",
    )
    parser.add_argument("years", nargs="?", type=float, help="investment period")
    parser.add_argument(
        "compounds_per_year",
        nargs="?",
        type=int,
        help="number of compounding periods per year",
    )
    arguments = parser.parse_args()
    values = (
        arguments.principal,
        arguments.annual_rate_percent,
        arguments.years,
        arguments.compounds_per_year,
    )

    if all(value is None for value in values):
        try:
            principal = float(input("Initial principal: "))
            annual_rate_percent = float(input("Annual interest rate (%): "))
            years = float(input("Investment period (years): "))
            compounds_per_year = int(input("Compounding periods per year: "))
        except ValueError as error:
            print(f"Invalid input: {error}")
            return
    elif any(value is None for value in values):
        parser.error("provide all four positional arguments, or provide none")
    else:
        principal, annual_rate_percent, years, compounds_per_year = values

    try:
        balance = compound_interest(
            principal,
            annual_rate_percent,
            years,
            compounds_per_year,
        )
    except ValueError as error:
        print(f"Invalid input: {error}")
        return

    print(f"Final balance: {balance:.2f}")
    print(f"Interest earned: {balance - principal:.2f}")


if __name__ == "__main__":
    main()