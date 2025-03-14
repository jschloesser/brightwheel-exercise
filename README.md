# brightwheel-exercise

## Exploring the Data
- Checked through for identifiers and primary/foreign keys in each table
- Staged Salesforce first. Most data, updated daily, assumed as the more reliable source of truth.
- Staged the other sources subsequently. Tried to focus on the key columns likely most important for the team to follow up on leads: phone, then address, then contact info.

## Testing/QA
- Generic dbt tests for primary key uniqueness at staging level
- Generic null tests for phone numbers as the key primary identifier for leads (also important for flagging potential duplicates)
- If schemas are subject to change and more models are added to the mix, some referential integrity tests might help with catching issues. 

## Tradeoff/Left for Time
- Did not include all columns from sources or explore their values (e.g. booleans for “Infant” or values in “AA2”)
- Additional tests and descriptions of columns in .yml files
- Fleshing out `lead_status` values (i.e. do the Salesforce lead statuses align with the company's definition?)
- Custom test logic for phone format (i.e. is Salesforce phone number a string? numeric?)
- Including mobile phones in the check for duplicate leads based on phone identifier

## Longer Term ETL Strategies
- Since future file uploads are subject to schema changes at any time, I went with the approach of using dbt’s union relations macro here. Long term, there is also the option of using some Jinja conditions and for loops to query for the information schema of new tables and potentially take dynamic actions based on those results... but that could be unnecessarily complex and resource intensive.
- Since third party file loads require full refreshes of existing records and there are “many more rows” than in the sample, I wanted to materialize staging and intermediate models as views and leave the final core leads model materialized as a table.
- If these third party sources are uploaded monthly, we could add tags to those models so the orchestrator of choice runs them monthly and not with the daily Saleforce model. 
