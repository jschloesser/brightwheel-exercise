select
    /* Primary Key */
    {{ dbt_utils.generate_surrogate_key(['phone', 'loaded_at']) }} as lead_id,

    /* Foreign Keys */
    cast(regexp_replace(phone, r"([^0-9])",'') as numeric) as phone,

    /* Address */
    upper(Address) as street,
    upper(City) as city,
    upper(State) as state,
    Zip as zip,
    upper(concat(Address,' ',City,' ',State,' ',zip)) as 
    
    /* Status and Properties */
    capacity as capacity,
    Operation_Name as company_name,
    Email_Address as email,
    'source3' as lead_source,
    
    /* Metadata */
    current_timestamp() as loaded_at

from {{ source('third_party_leads', 'source3') }}
