# Module 08 Completion Report

## Tracked Files
```text
.gitignore
README.md
calculator.py
main.py
project_spec.md
```

## Spec Commit History
```text
e7e7678 (HEAD -> master) Add project specification
```

## project_spec.md Contents
```markdown
# Retirement Readiness Planner: Technical Specification

## 1. Purpose

Build a responsive internal web tool that lets each member of a six-person team privately estimate whether their retirement plan may cover their expected expenses through a chosen lifespan. The tool is for personal planning and education, not for managing or comparing team members.

The initial audience is an internal Scrum team working on a fixed-bid project. The project contract and end date are not part of the initial financial model. Employment income is assumed to continue until the user's selected retirement age.

## 2. Goals

- Collect a user's financial assets, salaried work status and income, net rental income, household expenses, liabilities, planned contributions, and a separate awareness-only list of possessions.
- Project asset accumulation before retirement and drawdown after retirement under conservative, base, and optimistic scenarios.
- Show whether modeled resources cover estimated expenses through a user-selected planning age, along with the assumptions and any projected gap or depletion age.
- Keep each person's financial data private and local to their browser.
- Use India-specific locale and Indian Rupees (INR) for the initial release.

## 3. Non-Goals

- Providing personalized financial, tax, legal, or investment advice.
- Recommending specific investments or financial products.
- Giving administrators access to individual financial profiles.
- Ranking, comparing, or reporting retirement readiness across the six team members.
- Modeling job loss, contract end dates, or other employment-income interruption in the initial release.
- Providing India-specific EPF, PPF, NPS, gratuity, or pension calculators in the initial release; users can represent assets and recurring income using generic fields.

## 4. Users and Privacy

- Each of the six team members uses the tool for their own planning.
- One user's inputs and results must not be visible to another user through the application.
- The MVP has no application accounts, shared profiles, team dashboard, or server-side financial-data storage.
- Inputs may be saved in browser-local storage on the user's device. The interface must explain this behavior and provide a clear action to erase locally stored data.
- Do not send financial inputs to analytics, external APIs, or third-party services.
- The hosting layer should use organization-approved access controls if the app must be restricted to the internal team. The specific hosting and access-control mechanism remains to be confirmed.

## 5. Platform and Locale

- Responsive browser application, usable on desktop and mobile.
- Initial locale: India; currency: INR, formatted using Indian digit grouping.
- Use accessible labels, keyboard-operable controls, readable contrast, and validation messages that do not rely on color alone.

## 6. Functional Requirements

### 6.1 Financial Profile

The user can enter and edit:

- Current age, target retirement age, and planning age through which expenses should be modeled.
- Current financial assets using generic asset labels and INR values.
- Employment status: employed/salaried for the MVP.
- Monthly salary and other recurring income.
- Monthly net rental income after property costs, vacancy, and tax as estimated by the user.
- Monthly household expenses.
- Outstanding loans or liabilities and their relevant recurring payments.
- Planned monthly savings or investment contributions up to retirement.
- A separate list of possessions for awareness. Possessions are excluded from available assets and all calculations.

The form must validate positive ages and a target retirement age greater than the current age. It must validate numeric values, identify missing required inputs, and explain invalid entries inline.

### 6.2 Assumptions and Scenarios

- Present conservative, base, and optimistic projections.
- Show the assumptions used by each scenario, including annual inflation and investment returns.
- Allow users to inspect and edit the assumptions; recalculation must update the displayed projections.
- Clearly distinguish user-entered values from default assumptions.
- State that results are estimates and sensitive to the assumptions. Do not imply that any scenario is guaranteed.
- Exact default rates, rental-income escalation, treatment of taxes, and the detailed calculation method are open decisions that must be finalized before implementation.

### 6.3 Calculation and Results

- Project financial assets through the accumulation period using the user's current assets, planned monthly contributions, and the selected scenario's return assumption.
- At the target retirement age, stop modeled salary income and project expenses and recurring non-salary income through the selected planning age.
- Include net rental income and other user-entered recurring income in the retirement cash-flow projection.
- Project whether available resources cover the modeled expense gap through the planning age. Show a clear result for each scenario, not a single unsupported guarantee.
- Display estimated monthly income versus expenses, projected asset balance over time, and any modeled shortfall or approximate depletion age.
- Provide possible next-step prompts such as reviewing assumptions, expenses, contributions, or target retirement age. Do not tell users which financial product to buy or make a personalized investment recommendation.
- Include a concise disclaimer that the results are educational estimates, not individualized financial, tax, or investment advice.

## 7. User Experience

- The primary flow is: enter profile and financial information, review assumptions, then view scenario results.
- Users can return to edit inputs and recalculate without losing their current browser-local profile.
- Provide a reset/clear-data action with confirmation.
- Use plain-language explanations for financial terms and show the inputs and assumptions behind each result.
- Do not expose financial information in URLs, browser analytics, shared team views, or exported telemetry.

## 8. Recommended Technical Approach

- Build a client-side single-page application using React, TypeScript, and Vite.
- Keep the calculation engine in a pure TypeScript module, separate from UI components, so formulas can be unit-tested independently.
- Render projection charts with an established charting library, such as Chart.js, and provide equivalent accessible tabular values.
- Store user data only in browser-local storage; do not create a backend API or database for the MVP.
- Deploy as a static site using an organization-approved internal hosting option. Enforce any required internal access restriction at the hosting layer.
- This is a recommendation; the team has not selected a hosting provider or finalized a stack mandate.

## 9. Acceptance Criteria

- A user can enter the required financial profile and receive conservative, base, and optimistic estimates.
- The result view shows the user's monthly income and expense comparison, projected asset balance over time, and any estimated gap or depletion age.
- Editing an assumption or input causes the scenarios to recalculate and makes the changed assumption visible.
- Possessions appear separately and do not increase projected resources.
- No financial profile is sent to a server, analytics service, or third-party API.
- A user can erase locally stored data, and the application confirms the action.
- The interface works at desktop and mobile sizes and remains usable with keyboard navigation and screen readers.
- The disclaimer and scenario assumptions are visible alongside results.

## 10. Open Decisions Before Implementation

- Select and document the exact projection formulas, including compounding frequency and how assets are drawn down in retirement.
- Set initial conservative, base, and optimistic return and inflation assumptions, and define whether assumptions are nominal or inflation-adjusted.
- Decide how rental-income growth, taxes, liabilities, and recurring loan payments enter the model without double-counting.
- Decide whether salary and other income are entered as gross or take-home amounts.
- Confirm whether the initial release needs an export/print feature or remains browser-only.
- Select the internal static hosting provider and required access controls.
```
